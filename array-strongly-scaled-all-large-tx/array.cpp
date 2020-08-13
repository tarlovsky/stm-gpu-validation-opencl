#include <assert.h>
#include <getopt.h>
#include <limits.h>
#include <pthread.h>
#include <atomic>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include <time.h>
#include "timer.h"

#include "rapl.h"

#define DEFAULT_DURATION                10000
#define DEFAULT_INITIAL                 256
#define DEFAULT_NB_THREADS              1
#define DEFAULT_RANGE                   0xFFFF
#define DEFAULT_SEED                    0
#define DEFAULT_UPDATE                  20
#define ARRAY_INITIAL_CAPACITY          1ULL << 32 // 4_294_967_296 / nb_threads = chunk
#define XSTR(s)                         STR(s)
#define STR(s)                          #s

/* ################################################################### *
 * GLOBALS
 * ################################################################### */
#define DEFAULT_UPDATE_RATE             20
#define DEFAULT_OPS                     100
#define BIG_NUMBER                      1ULL << 30
#define SMALL_TX_UPDATES                4
#define CACHELINE_SIZE                  64

#define THREADS_MAX                     8
#define LARGE_TX_N                      100
#include "tm.h"

#define VAL_MIN                         INT_MIN
#define VAL_MAX                         INT_MAX

unsigned long long* array;
unsigned int chunk_size;

#include <sched.h>
unsigned int nb_threads;
unsigned long rset_size = 0;
unsigned long array_size = 0;
unsigned int update_rate = DEFAULT_UPDATE_RATE;
unsigned int disjoint = 0;
unsigned int enable_sequential = 0;

unsigned int kicks [CACHELINE_SIZE * sizeof(unsigned int)*THREADS_MAX];
unsigned int round         [CACHELINE_SIZE * sizeof(unsigned int)*THREADS_MAX];
unsigned int intervene_pos;

void do_large(){

    long id = thread_getId();
    unsigned long rand_max;
    unsigned long my_start = id * chunk_size;
    unsigned long my_end = chunk_size + (chunk_size * id);

    unsigned long ops = 0;
    unsigned long update_ops, update_ops_counter;

    unsigned long i, j;
    unsigned short seed[3];
    int seed0, doWaR;
    time_t t;
    int writes=0;
    srand((unsigned) time(&t));
    seed0 = rand();
    unsigned long val = 0;

    /* how many update ops must I do?: update_rate percent from read_set_size==chunk_size*/

    update_ops = (update_rate * chunk_size) / 100;
    update_ops_counter = update_ops;

    /*prepare disjoint sets*/
    if(disjoint == 1){
        my_start = id * chunk_size;
        rand_max = rset_size;
        j = my_start; /* in case disjoint and sequential*/
    } else {
        /* else access entire array anywhere/any thread*/
        my_start = 0;
        rand_max = array_size;
        j = 0;
    }

    //printf("%d: read-set-size %u, update ops %lu, rand[%lu, %lu]:\n",id, chunk_size, update_ops, my_start, my_start+chunk_size);
    /* Initialize seed (use rand48 as rand is poor) */
    seed[0] = (unsigned short)rand_r(&seed0);
    seed[1] = (unsigned short)rand_r(&seed0);
    seed[2] = (unsigned short)rand_r(&seed0);

    TM_BEGIN();/*calls stm prepare and resets tx descriptors. does not realloc*/


        // # kicks which i did to neighbor have to be at least his round.
        int neighbor_round = round[(id+1)%nb_threads];
        if( kicks[id*CACHELINE_SIZE] < LARGE_TX_N && kicks[id*CACHELINE_SIZE] < neighbor_round ){
            // no point of kicking twice when other TX couple of rounds away from us.
            //simply update our kick count.
            kicks[id*CACHELINE_SIZE] = neighbor_round;
            /* number of kicks which I did to neighbor.*/

            //write to neighbour some magic number to kill prefetcher
            TM_SHARED_WRITE_P(array[(id+1)%nb_threads], 1337000);

            //printf("THREAD %d asks for kick at position %d\n", id, i);
        }

        /*everyone has to do r_set_size==chunk_size operations*/
        while (ops < chunk_size) {
            ops++;

            /* read or Write after Rear */
            /*binary choice to update this round*/
            //doWaR = (int)(erand48(seed) * 2);
            doWaR = (int)(erand48(seed) * 2);

            if(enable_sequential == 1){
                i = j++;/*increment outside thread local counter*/
            }else{
                /*chunk limit was established on disjoint startup*/
                i = (unsigned long) my_start + (erand48(seed) * rand_max);
                //assert(i >= my_start);//only in debug mode
            }
            //printf("%d accessing element %d %d\n", id, i, array[i]);

            /*do the read*/
            val = TM_SHARED_READ(array[i]);
            //TM_SHARED_WRITE_P(array[i], 1337000);

            /*if still update_ops left and is a write after read*/
            if((update_ops > 0 && doWaR) || (update_ops_counter >= array_size - ops)) { /*unlucky case of WaR never being true, all last ops are updates*/
                update_ops_counter--;/*optimized by compiler in if clause, moved here*/
                //TM_SHARED_WRITE_P(array[1], val + 1);
            }
        }//while ops < chunk_size

        /* Do only one write to keep read-set large enough:
         * for some reason doing writes reduces the read-set to n_writes/4 */
        TM_SHARED_WRITE_P(array[my_start+4], 1337000); // write my favorite magic number

        /*reset for next tx*/
        ops = 0;

        update_ops_counter = update_ops;

    TM_END();

    //announce own round
    round[id*CACHELINE_SIZE]++;

    /* tinystm will only validate if CONCURRENT transaction incremented global clock */
    /* by writing to your own write set you do not advance global clock before commit*/
    /* when random this works. when sequential you have write to your own chunk*/
    /* so write to someone else's chunk */
    // +4 because lock order covers 4 words and you dont want to write into neighbor tx's read set
    return NULL;
}

/* this is fucking stupid. you cannot have thread enter and tm begin close to eachother.
 * something gets optimized and the fot loops breaks the stm*/
void work(void *data){
    long id = thread_getId();
    int n_small_tx = INT_MAX;

    /*infinite small tx; stop when X large txs finished.*/
    /*make tx_small do a bunch of reads*/

    /*CONJOINT*/
    // large =====|======|=== 512k ====|===========
    // large =====|======|=== 512k ====|===========
    // large =====|======|=== 512k ====|===========
    // large =====|======|=== 512k ====|===========
    // write with prob p 0.2

    /* N read for tx_small, 10 100 1000 <--
     * 256k-1M
     *
     * */

    TM_THREAD_ENTER();/*initializes tx descriptors, allocates memory, and instant kernel once*/

        for(int t = 0 ; t < LARGE_TX_N ; t++){
            do_large();
        }

    TM_THREAD_EXIT();
    return NULL;
}

# define no_argument        0
# define required_argument  1
# define optional_argument  2

MAIN(argc, argv) {
  TIMER_T start;
  TIMER_T stop;


  struct option long_options[] = {
    // These options don't set a flag
    {"num-threads",               required_argument, NULL, 'n'},
    {"read-set-size",               required_argument, NULL, 'r'},
    {NULL, 0, NULL, 0}
  };

  int i, c;
  long val;
  nb_threads = DEFAULT_NB_THREADS;

  while(1) {
    i = 0;
    c = getopt_long(argc, argv, "n:s:r:u:d:", long_options, &i);

    if(c == -1)
      break;

    if(c == 0 && long_options[i].flag == 0)
      c = long_options[i].val;

    switch(c) {
     case 0:
       /* Flag is automatically set */
       break;

     case 'n':
       nb_threads = atoi(optarg);
       break;
     case 's':
       enable_sequential = atoi(optarg);
       break;
     case 'r':
       rset_size = atoi(optarg);
       break;
     case 'u':
       update_rate = atoi(optarg);
       break;
     case 'd':
       disjoint = atoi(optarg);
       break;
     default:
       exit(1);
    }
  }

  SIM_GET_NUM_CPU(nb_threads);
  TM_STARTUP(nb_threads);
  P_MEMORY_STARTUP(nb_threads);
  thread_startup(nb_threads);

  for(int i = 0; i < THREADS_MAX;i++){
      kicks[i * CACHELINE_SIZE] = LARGE_TX_N;
      round[i * CACHELINE_SIZE] = 0;
      //printf("LARGE TX LEFT IN %d: %d\n", i, kicks[i * CACHELINE_SIZE]);
  }

  /*set default */
  if(rset_size == 0){
    rset_size = ARRAY_INITIAL_CAPACITY;}

  /*set to argument*/
  chunk_size = rset_size; /* this IS your ops size*/

  /*define array size*/
  if(disjoint == 1){
    /* strongly scaled array:
     * user asked for read-set-size;
     * with N threads the global array has to be rset_size*nb_threads*/
    array_size = chunk_size * nb_threads;
  } else {
    /*reduce the space at which threads operato to increase validation/contention time*/
    /*without this, conjoint*/
    array_size = chunk_size;
  }

  intervene_pos = (unsigned int) array_size * 90 / 100;

  array = malloc(sizeof(unsigned long) * (array_size));

  if(array == NULL){
      printf("could not allocate memory\n");
  }

  //printf("ULL %d, Array in bytes: %d\n",sizeof(unsigned long long), sizeof(unsigned long long)*rset_size);
  /* max llu / max threads on my machine:
   * 4_294_967_296/8=536_870_912 */

  srand(time(NULL));
  /* Populate set */

  for (i = 0; i < array_size; i++) {
      array[i]=rand() % array_size;/*fill up with really pseduo random numbers*/
  }

  //printf("Initial size: %d, random: %d\n", array_size, !enable_sequential);

  TIMER_READ(start);
  GOTO_SIM();
  thread_start(work, NULL);
  GOTO_REAL();
  TIMER_READ(stop);
  TM_SHUTDOWN();
  printf("%.9f\n", TIMER_DIFF_SECONDS(start, stop));
  fflush(stdout);
  P_MEMORY_SHUTDOWN();
  GOTO_SIM();
  thread_shutdown();
  MAIN_RETURN(0);
}
