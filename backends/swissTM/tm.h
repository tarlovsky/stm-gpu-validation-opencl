#ifndef TM_H
#define TM_H 1


#include <stdio.h>

#define MAIN(argc, argv)              int main (int argc, char** argv)
#define MAIN_RETURN(val)              return val
#define GOTO_SIM()                    /* nothing */
#define GOTO_REAL()                   /* nothing */
#define IS_IN_SIM()                   (0)
#define SIM_GET_NUM_CPU(var)          /* nothing */
#define TM_PRINTF                     printf
#define TM_PRINT0                     printf
#define TM_PRINT1                     printf
#define TM_PRINT2                     printf
#define TM_PRINT3                     printf

#define P_MEMORY_STARTUP(numThread)   /* nothing */
#define P_MEMORY_SHUTDOWN()           /* nothing */

#include <string.h>
#include "stm.h"


#ifndef REDUCED_TM_API
    #include "thread.h"
#endif

#ifdef REDUCED_TM_API
    #define SPECIAL_THREAD_ID()         get_tid()
#else
    #define SPECIAL_THREAD_ID()         thread_getId()
#endif

#define TM_ARGDECL_ALONE                tx_desc* tx
#define TM_ARGDECL                      tx_desc* tx,
#define TM_ARG                          tx,
#define TM_ARG_ALONE                    tx

#define TM_STARTUP(numThread)     wlpdstm_global_init()
#define TM_SHUTDOWN()             wlpdstm_global_shutdown()

/*in stmbench 7 enable reduced tm api. cannot access tx_desc* tx anywhere in stmbench7*/
#ifdef REDUCED_TM_API
    #define TM_THREAD_ENTER()         wlpdstm_thread_init();
    #define TM_THREAD_EXIT()          wlpdstm_thread_shutdown();
#else
    #define TM_THREAD_ENTER()         wlpdstm_thread_init(); \
                                      tx_desc *tx = wlpdstm_get_tx_desc(); \
                                      wlpdstm_start_thread_profiling_desc(tx)
    #define TM_THREAD_EXIT()          wlpdstm_end_thread_profiling_desc(tx); \
                                      wlpdstm_thread_shutdown()
#endif

#define P_MALLOC(size)            wlpdstm_s_malloc(size)
#define P_FREE(ptr)               wlpdstm_s_free(ptr)
#define TM_MALLOC(size)           malloc(size)/*wlpdstm_tx_malloc_desc(tx, size)*/
#define TM_FREE(ptr)              wlpdstm_tx_free_desc(tx, ptr, sizeof(*ptr))

/*this because _DESC stores local variable and references TX which cannot bereferenced in STMBENCH7*/
#ifdef REDUCED_TM_API
    #define TM_BEGIN()                BEGIN_TRANSACTION
    #define TM_END()                  END_TRANSACTION
    #define FAST_PATH_RESTART()       wlpdstm_restart_tx()
    #define SLOW_PATH_RESTART()       FAST_PATH_RESTART()
#else
    #define TM_BEGIN()                BEGIN_TRANSACTION_DESC
    #define TM_BEGIN_ID(ID)           BEGIN_TRANSACTION_DESC_ID(ID)
    #define FAST_PATH_RESTART()       wlpdstm_restart_tx_desc(tx)
    #define SLOW_PATH_RESTART()       FAST_PATH_RESTART()
#endif

#define TM_BEGIN_RO()             STM_BEGIN()
#define TM_END()                  END_TRANSACTION
#define TM_RESTART()              wlpdstm_restart_tx_desc(tx)

#define TM_BEGIN_EXT(b,mode,ro)   TM_BEGIN()
#define TM_EARLY_RELEASE(var)       /* nothing */

#ifdef REDUCED_TM_API
    #define TM_SHARED_READ(var)           wlpdstm_read_word((Word *)(&var))
    #define TM_SHARED_WRITE(var, val)     wlpdstm_write_word((Word *)(&var), (Word)(val))
#else
    #define TM_SHARED_READ(var)           wlpdstm_read_word_desc(tx, (Word *)(&var))
    #define TM_SHARED_READ_P(var)         (void *)wlpdstm_read_word_desc(tx, (Word *)(&var))
    #define TM_SHARED_READ_D(var)         wlpdstm_read_double_desc(tx, (&var))
    #define TM_SHARED_READ_F(var)         wlpdstm_read_float_desc(tx, (&var))

    #define TM_SHARED_WRITE(var, val)     wlpdstm_write_word_desc(tx, (Word *)(&var), (Word)(val))
    #define TM_SHARED_WRITE_P(var, val)   wlpdstm_write_word_desc(tx, (Word *)(&var), (Word)(val))
    #define TM_SHARED_WRITE_D(var, val)   wlpdstm_write_double_desc(tx, (&var), (val))
    #define TM_SHARED_WRITE_F(var, val)   wlpdstm_write_float_desc(tx, (&var), (val))
#endif


#define TM_LOCAL_WRITE(var, val)      ({var = val; var;})
#define TM_LOCAL_WRITE_P(var, val)    ({var = val; var;})
#define TM_LOCAL_WRITE_D(var, val)    ({var = val; var;})

#define TM_CALLABLE                     /* nothing */
#define TM_PURE                         /* nothing */


#endif /* TM_H */
