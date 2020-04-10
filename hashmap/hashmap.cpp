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

#define XSTR(s)                         STR(s)
#define STR(s)                          #s

/* ################################################################### *
 * GLOBALS
 * ################################################################### */

#include "tm.h"

typedef struct Node_HM_t
{
	long m_val;
	struct Node_HM_t* m_next;
} Node_HM;

typedef struct List_t
{
	Node_HM* sentinel;
} List;

static volatile int stop;

static int N_BUCKETS = 512;

List** bucket;

TM_CALLABLE
long hm_insert_htm(TM_ARGDECL List* set, long val)
{
        // traverse the list to find the insertion point
        Node_HM* prev = set->sentinel;
        Node_HM* curr = TM_SHARED_READ_P(prev->m_next);

        while (curr != NULL) {
                if (TM_SHARED_READ(curr->m_val) >= val)
                        break;
                prev = curr;
                curr = TM_SHARED_READ_P(prev->m_next);
        }

        if (!curr || (TM_SHARED_READ(curr->m_val) > val)) {
                Node_HM* insert_point = (Node_HM*)(prev);

                // create the new node
                Node_HM* i = (Node_HM*)TM_MALLOC(sizeof(Node_HM));
                i->m_val = val;
                i->m_next = (Node_HM*)(curr);
                TM_SHARED_WRITE_P(insert_point->m_next, i);
		return 1;
        }
	return 0;
}

void hm_insert_seq(List* set, long val)
{
        Node_HM* prev = set->sentinel;
        Node_HM* curr = prev->m_next;

        while (curr != NULL) {
                if (curr->m_val >= val)
                        break;
                prev = curr;
                curr = prev->m_next;
        }

        // now insert new_node between prev and curr
        if (!curr || (curr->m_val > val)) {
                Node_HM* insert_point = (Node_HM*)(prev);

                // create the new node
                Node_HM* i = (Node_HM*)malloc(sizeof(Node_HM));
                i->m_val = val;
                i->m_next = (Node_HM*)(curr);
                insert_point->m_next = i;
        }
}

TM_CALLABLE
long hm_lookup_htm(TM_ARGDECL List* set, long val)
{
	int found = 0;
	const Node_HM* curr = set->sentinel;
	curr = TM_SHARED_READ_P(curr->m_next);

	while (curr != NULL) {
		if (TM_SHARED_READ(curr->m_val) >= val)
			break;
		curr = TM_SHARED_READ_P(curr->m_next);
	}

	found = ((curr != NULL) && (TM_SHARED_READ(curr->m_val) == val));
	return found;
}

TM_CALLABLE
int hm_remove_htm(TM_ARGDECL List* set, long val)
{
	Node_HM* prev = set->sentinel;
	Node_HM* curr = TM_SHARED_READ_P(prev->m_next);
	while (curr != NULL) {

		if (TM_SHARED_READ(curr->m_val) == val) {
			Node_HM* mod_point = (Node_HM*)(prev);
			TM_SHARED_WRITE_P(mod_point->m_next, TM_SHARED_READ_P(curr->m_next));

			TM_FREE((Node_HM*)(curr));
			return 1;
		}
		else if (TM_SHARED_READ(curr->m_val) > val) {
			return 0;
		}
		prev = curr;
		curr = TM_SHARED_READ_P(prev->m_next);
	}
	return 0;
}

TM_CALLABLE
long hm_insert_stm(TM_ARGDECL List* set, long val)
{
        // traverse the list to find the insertion point
        Node_HM* prev = set->sentinel;
        Node_HM* curr = TM_SHARED_READ_P(prev->m_next);

        while (curr != NULL) {
                if (TM_SHARED_READ(curr->m_val) >= val)
                        break;
                prev = curr;
                curr = TM_SHARED_READ_P(prev->m_next);
        }

        if (!curr || (TM_SHARED_READ(curr->m_val) > val)) {
                Node_HM* insert_point = (Node_HM*)(prev);

                // create the new node
                Node_HM* i = (Node_HM*)TM_MALLOC(sizeof(Node_HM));
                i->m_val = val;
                i->m_next = (Node_HM*)(curr);
                TM_SHARED_WRITE_P(insert_point->m_next, i);
		return 1;
        }
	return 0;
}

TM_CALLABLE
long hm_lookup_stm(TM_ARGDECL List* set, long val)
{
	int found = 0;
	const Node_HM* curr = set->sentinel;
	curr = TM_SHARED_READ_P(curr->m_next);

	while (curr != NULL) {
		if (TM_SHARED_READ(curr->m_val) >= val)
			break;
		curr = TM_SHARED_READ_P(curr->m_next);
	}

	found = ((curr != NULL) && (TM_SHARED_READ(curr->m_val) == val));
	return found;
}

TM_CALLABLE
int hm_remove_stm(TM_ARGDECL List* set, long val)
{
	Node_HM* prev = set->sentinel;
	Node_HM* curr = TM_SHARED_READ_P(prev->m_next);
	while (curr != NULL) {

		if (TM_SHARED_READ(curr->m_val) == val) {
			Node_HM* mod_point = (Node_HM*)(prev);
			TM_SHARED_WRITE_P(mod_point->m_next, TM_SHARED_READ_P(curr->m_next));

			TM_FREE((Node_HM*)(curr));
			return 1;
		}
		else if (TM_SHARED_READ(curr->m_val) > val) {
			return 0;
		}
		prev = curr;
		curr = TM_SHARED_READ_P(prev->m_next);
	}
	return 0;
}


TM_CALLABLE
long priv_insert_htm(TM_ARGDECL long val)
{
    return hm_insert_htm(TM_ARG (bucket[val % N_BUCKETS]), val);
}

void priv_insert_seq(long val)
{
	hm_insert_seq( (bucket[val % N_BUCKETS]), val);
}

TM_CALLABLE
long priv_lookup_htm(TM_ARGDECL long val)
{
    return hm_lookup_htm(TM_ARG (bucket[val % N_BUCKETS]), val);
}

TM_CALLABLE
int priv_remove_item_htm(TM_ARGDECL long val)
{
    return hm_remove_htm(TM_ARG (bucket[val % N_BUCKETS]), val);
}

TM_CALLABLE
long priv_insert_stm(TM_ARGDECL long val)
{
    return hm_insert_stm(TM_ARG (bucket[val % N_BUCKETS]), val);
}

TM_CALLABLE
long priv_lookup_stm(TM_ARGDECL long val)
{
    return hm_lookup_stm(TM_ARG (bucket[val % N_BUCKETS]), val);
}

TM_CALLABLE
int priv_remove_item_stm(TM_ARGDECL long val)
{
    return hm_remove_stm(TM_ARG (bucket[val % N_BUCKETS]), val);
}

long set_add_seq(long val) {
	priv_insert_seq(val);
 return 1;
}

long set_add(TM_ARGDECL long val)
{
    int res = 0;

    TM_BEGIN();
    res = priv_insert_stm(TM_ARG val);
    TM_END();

    return res;
}

int set_remove(TM_ARGDECL long val)
{
    int res = 0;

    TM_BEGIN();
    res = priv_remove_item_stm(TM_ARG val);
    TM_END();

    return res;
}

long set_contains(TM_ARGDECL long  val)
{
    long res = 0;

    int mode = 0;
    TM_BEGIN_EXT(2, mode, 1);
    res = priv_lookup_stm(TM_ARG val);
    TM_END();

    return res;
}

#include <sched.h>
  long range;
  int update;
  unsigned long nb_add;
  unsigned long nb_remove;
  unsigned long nb_contains;
  unsigned long nb_found;
  unsigned long nb_aborts;
  unsigned int nb_threads;
  unsigned int seed;
  long operations;

void *test(void *data)
{

  TM_THREAD_ENTER();

  unsigned int mySeed = seed + sched_getcpu();

  long myOps = operations / nb_threads;
  long val = -1;
  int op;

  while (myOps > 0) {
    op = rand_r(&mySeed) % 100;
    if (op < update) {
      if (val == -1) {
        /* Add random value */
        val = (rand_r(&mySeed) % range) + 1;
        if(set_add(TM_ARG val) == 0) {
          val = -1;
        }
      } else {
        /* Remove random value */
        set_remove(TM_ARG  val);
        val = -1;
      }
    } else {
      /* Look for random value */
      long tmp = (rand_r(&mySeed) % range) + 1;
      set_contains(TM_ARG tmp);
    }

    myOps--;
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
    {"help",                      no_argument,       NULL, 'h'},
    {"duration",                  required_argument, NULL, 'd'},
    {"initial-size",              required_argument, NULL, 'i'},
    {"num-threads",               required_argument, NULL, 'n'},
    {"range",                     required_argument, NULL, 'r'},
    {"seed",                      required_argument, NULL, 's'},
    {"buckets",                   required_argument, NULL, 'b'},
    {"update-rate",               required_argument, NULL, 'u'},
    {NULL, 0, NULL, 0}
  };

  int i, c;
  long val;
  operations = DEFAULT_DURATION;
  unsigned int initial = DEFAULT_INITIAL;
  nb_threads = DEFAULT_NB_THREADS;
  range = DEFAULT_RANGE;
  update = DEFAULT_UPDATE;
  N_BUCKETS = 512;

  while(1) {
    i = 0;
    c = getopt_long(argc, argv, "hd:i:n:b:r:s:u:", long_options, &i);

    if(c == -1)
      break;

    if(c == 0 && long_options[i].flag == 0)
      c = long_options[i].val;

    switch(c) {
     case 0:
       /* Flag is automatically set */
       break;
     case 'h':
       printf("intset -- STM stress test "
              "(hash map)\n"
              "\n"
              "Usage:\n"
              "  intset [options...]\n"
              "\n"
              "Options:\n"
              "  -h, --help\n"
              "        Print this message\n"
              "  -d, --duration <int>\n"
              "        Test duration in milliseconds (0=infinite, default=" XSTR(DEFAULT_DURATION) ")\n"
              "  -i, --initial-size <int>\n"
              "        Number of elements to insert before test (default=" XSTR(DEFAULT_INITIAL) ")\n"
              "  -n, --num-threads <int>\n"
              "        Number of threads (default=" XSTR(DEFAULT_NB_THREADS) ")\n"
              "  -r, --range <int>\n"
              "        Range of integer values inserted in set (default=" XSTR(DEFAULT_RANGE) ")\n"
              "  -s, --seed <int>\n"
              "        RNG seed (0=time-based, default=" XSTR(DEFAULT_SEED) ")\n"
              "  -u, --update-rate <int>\n"
              "        Percentage of update transactions (default=" XSTR(DEFAULT_UPDATE) ")\n"
         );
       exit(0);
     case 'd':
       operations = atoi(optarg);
       break;
     case 'b':
       N_BUCKETS = atoi(optarg);
       break;
     case 'i':
       initial = atoi(optarg);
       break;
     case 'n':
       nb_threads = atoi(optarg);
       break;
     case 'r':
       range = atoi(optarg);
       break;
     case 's':
       seed = atoi(optarg);
       break;
     case 'u':
       update = atoi(optarg);
       break;
     case '?':
       printf("Use -h or --help for help\n");
       exit(0);
     default:
       exit(1);
    }
  }

  if (seed == 0)
    srand((int)time(0));
  else
    srand(seed);

  SIM_GET_NUM_CPU(nb_threads);
  TM_STARTUP(nb_threads);
  P_MEMORY_STARTUP(nb_threads);
  thread_startup(nb_threads);

  bucket = (List**) malloc(N_BUCKETS*sizeof(List*));

  for (i = 0; i < N_BUCKETS; i++) {
    bucket[i] = (List*) malloc (sizeof(List));
    bucket[i]->sentinel = (Node_HM*) malloc(sizeof(Node_HM));
    bucket[i]->sentinel->m_val = LONG_MIN;
    bucket[i]->sentinel->m_next = NULL;
  }

  /* Populate set */
  //printf("Adding %d entries to set\n", initial);
  for (i = 0; i < initial; i++) {
    val = (rand() % range) + 1;
    set_add_seq(val);
  }

  seed = rand();
  TIMER_READ(start);
  GOTO_SIM();


  thread_start(test, NULL);

  GOTO_REAL();
  TIMER_READ(stop);

  printf("%.9f\n", TIMER_DIFF_SECONDS(start, stop));

  fflush(stdout);

  TM_SHUTDOWN();
  P_MEMORY_SHUTDOWN();
  GOTO_SIM();
  thread_shutdown();
  MAIN_RETURN(0);
}
