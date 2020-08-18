#ifndef THREAD_H
#define THREAD_H 1

# define CACHE_LINE_SIZE 64

typedef struct padded_statistics {
    double val_time_local;
    double cpu_val_time_local;
    double gpu_val_time_local;
    unsigned long n_commits;
    unsigned long n_aborts;
    unsigned long long n_val_reads;
    unsigned long long cpu_validated;
    unsigned long long gpu_validated;
    unsigned long long waste_double_validated;
    unsigned long long gpu_employed_times;
    unsigned long n_val_succ;
    unsigned long n_val_fail;
    unsigned long long snapshot_extension_calls;
    char suffixPadding[CACHE_LINE_SIZE];
} __attribute__((aligned(CACHE_LINE_SIZE))) padded_statistics_t;

extern __attribute__((aligned(CACHE_LINE_SIZE))) padded_statistics_t statistics_array[];

extern __thread long threadID;

#include <pthread.h>
#include <stdlib.h>
#include "types.h"

#include "stm.h"

#ifndef REDUCED_TM_API


    #ifdef __cplusplus
    extern "C" {
    #endif

    #define THREAD_T                            pthread_t
    #define THREAD_ATTR_T                       pthread_attr_t

    #define THREAD_ATTR_INIT(attr)              pthread_attr_init(&attr)
    #define THREAD_JOIN(tid)                    pthread_join(tid, (void**)NULL)
    #define THREAD_CREATE(tid, attr, fn, arg)   pthread_create(&(tid), \
                                                               &(attr), \
                                                               (void* (*)(void*))(fn), \
                                                               (void*)(arg))

    #define THREAD_LOCAL_T                      pthread_key_t
    #define THREAD_LOCAL_INIT(key)              pthread_key_create(&key, NULL)
    #define THREAD_LOCAL_SET(key, val)          pthread_setspecific(key, (void*)(val))
    #define THREAD_LOCAL_GET(key)               pthread_getspecific(key)

    #define THREAD_MUTEX_T                      pthread_mutex_t
    #define THREAD_MUTEX_INIT(lock)             pthread_mutex_init(&(lock), NULL)
    #define THREAD_MUTEX_LOCK(lock)             pthread_mutex_lock(&(lock))
    #define THREAD_MUTEX_UNLOCK(lock)           pthread_mutex_unlock(&(lock))

    #define THREAD_COND_T                       pthread_cond_t
    #define THREAD_COND_INIT(cond)              pthread_cond_init(&(cond), NULL)
    #define THREAD_COND_SIGNAL(cond)            pthread_cond_signal(&(cond))
    #define THREAD_COND_BROADCAST(cond)         pthread_cond_broadcast(&(cond))
    #define THREAD_COND_WAIT(cond, lock)        pthread_cond_wait(&(cond), &(lock))

    #  define THREAD_BARRIER_T                  barrier_t
    #  define THREAD_BARRIER_ALLOC(N)           barrier_alloc()
    #  define THREAD_BARRIER_INIT(bar, N)       barrier_init(bar, N)
    #  define THREAD_BARRIER(bar, tid)          barrier_cross(bar)
    #  define THREAD_BARRIER_FREE(bar)          barrier_free(bar)

    typedef struct barrier {
        pthread_cond_t complete;
        pthread_mutex_t mutex;
        int count;
        int crossing;
    } barrier_t;

    barrier_t *barrier_alloc();

    void barrier_free(barrier_t *b);

    void barrier_init(barrier_t *b, int n);

    void barrier_cross(barrier_t *b);

    void thread_startup (long numThread);

    void thread_start (void (*funcPtr)(void*), void* argPtr);

    void thread_shutdown ();

    void thread_barrier_wait();

    long thread_getId();

    long thread_getNumThread();


    #ifdef __cplusplus
    }
    #endif

#endif


#endif /* THREAD_H */
