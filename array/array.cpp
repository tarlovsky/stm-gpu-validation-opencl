#include <assert.h>
#include <getopt.h>
#include <limits.h>
#include <pthread.h>
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
#define ARRAY_INITIAL_CAPACITY          1ULL << 20 // 4_294_967_296 / nb_threads = chunk
#define XSTR(s)                         STR(s)
#define STR(s)                          #s

/* ################################################################### *
 * GLOBALS
 * ################################################################### */

#include "tm.h"

#define VAL_MIN                         INT_MIN
#define VAL_MAX                         INT_MAX

unsigned long long* array;
unsigned int chunk_size;

#include <sched.h>
unsigned int nb_threads;
unsigned int rset_size = 0;

unsigned int enable_sequential = 0;

void *test(void *data)
{
    long id = thread_getId();
    int my_start = id * chunk_size;
    int ops = 1;
    int i,j;
    if(enable_sequential){
        time_t t;
        /* Intializes enable_sequential number generator */
        srand((unsigned) time(&t));
    }

    //printf("MY ID %d\n", id);

    TM_THREAD_ENTER();
    TM_BEGIN();
    while (ops--) {
        for (i = 0; i < chunk_size; i++) {
            if (enable_sequential == 0) {
                j = rand() % rset_size;
                TM_SHARED_READ_P(array[j]);
            } else {
                TM_SHARED_READ_P(array[i]);
            }
        }
    }
    /* tinystm will only validate if CONCURRENT transaction incremented global clock */
    /* by writing to your own write set you do not advance global clock before commit*/
    TM_SHARED_WRITE_P(array[my_start], id);
    TM_END();
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
    c = getopt_long(argc, argv, "n:r:s:", long_options, &i);

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
     default:
       exit(1);
    }
  }
  //printf("STARTING WITH %d THREAD\n", nb_threads);

  SIM_GET_NUM_CPU(nb_threads);
  TM_STARTUP(nb_threads);
  P_MEMORY_STARTUP(nb_threads);
  thread_startup(nb_threads);

  if(rset_size == 0){
    rset_size = ARRAY_INITIAL_CAPACITY;
  }

  array = malloc(sizeof(unsigned long) * (rset_size));
  chunk_size = rset_size / nb_threads;

  if(array == NULL){
      printf("could not allocate memory\n");
  }

  //printf("ULL %d, Array in bytes: %d",sizeof(unsigned long long), sizeof(unsigned long long)*rset_size);
  /* 4_294_967_296/8=536_870_912 */
  //exit(0);
  /* Populate set */
  //printf("Adding %d entries to set\n", initial);
  for (i = 0; i < rset_size; i++) {
      array[i]=i;
  }

  //printf("Initial size: %d, random: %d\n",   rset_size, !enable_sequential);

  TIMER_READ(start);
  GOTO_SIM();

  thread_start(test, NULL);

  GOTO_REAL();
  TIMER_READ(stop);

  printf("%.9f\n", TIMER_DIFF_SECONDS(start, stop));

  fflush(stdout);

//printf("Final size: %d\n",   array_size(set));

  TM_SHUTDOWN();
  P_MEMORY_SHUTDOWN();
  GOTO_SIM();
  thread_shutdown();
  MAIN_RETURN(0);
}
