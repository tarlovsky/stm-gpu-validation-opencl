#ifndef TM_H
#define TM_H 1

#  include <stdio.h>

#  define MAIN(argc, argv)              int main (int argc, char** argv)
#  define MAIN_RETURN(val)              return val

#  define GOTO_SIM()                    /* nothing */
#  define GOTO_REAL()                   /* nothing */
#  define IS_IN_SIM()                   (0)

#  define SIM_GET_NUM_CPU(var)          /* nothing */

#  define TM_PRINTF                     printf
#  define TM_PRINT0                     printf
#  define TM_PRINT1                     printf
#  define TM_PRINT2                     printf
#  define TM_PRINT3                     printf

#  define P_MEMORY_STARTUP(numThread)   /* nothing */
#  define P_MEMORY_SHUTDOWN()           /* nothing */

#  include <string.h>
#  include <stm.h>
#ifndef REDUCED_TM_API
#  include "thread.h"
#endif

#ifdef REDUCED_TM_API
    #define TM_ARG_ALONE                get_thread()
    #define Self                        TM_ARG_ALONE
    #define SPECIAL_THREAD_ID()         get_tid()
    #define SPECIAL_INIT_THREAD(id)     thread_desc[id] = (void*)TM_ARG_ALONE;
    #define TM_THREAD_ENTER()           Thread* inited_thread = STM_NEW_THREAD(); \
                                        STM_INIT_THREAD(inited_thread, SPECIAL_THREAD_ID()); \
                                        thread_desc[SPECIAL_THREAD_ID()] = (void*)inited_thread;
#else
    #define TM_ARG_ALONE                STM_SELF
    #define SPECIAL_THREAD_ID()         thread_getId()
    #define TM_ARGDECL                  STM_THREAD_T* TM_ARG
    #define TM_ARGDECL_ALONE            STM_THREAD_T* TM_ARG_ALONE
    #define TM_THREAD_ENTER()           TM_ARGDECL_ALONE = STM_NEW_THREAD(); \
                                        STM_INIT_THREAD(TM_ARG_ALONE, SPECIAL_THREAD_ID());
#endif

#define TM_CALLABLE                     /* nothing */
#define TM_ARG                          TM_ARG_ALONE,
#define TM_THREAD_EXIT()                STM_FREE_THREAD(TM_ARG_ALONE)


#include "tl2.h"

#define TM_STARTUP(numThread)           STM_STARTUP()
#define TM_SHUTDOWN()                   STM_SHUTDOWN()

#define P_MALLOC(size)                  malloc(size)
#define P_FREE(ptr)                     free(ptr)
#define TM_MALLOC(size)                 malloc(size)

/*tarlovskyy This works but might cause memory leak later*/
#define TM_FREE(ptr)

#define FAST_PATH_FREE(ptr)
#define SLOW_PATH_FREE(ptr)


#define TM_BEGIN_RO()                   STM_BEGIN_RD()
#define TM_BEGIN_EXT(b,m,ro)            STM_BEGIN(ro);
#define TM_BEGIN()                      TM_BEGIN_EXT(0,0,0)
#define TM_EARLY_RELEASE(var)           /* nothing */

#define TM_END()                        STM_END()
#define TM_RESTART()                    STM_RESTART()
#define FAST_PATH_RESTART()             STM_RESTART()
#define SLOW_PATH_RESTART()             FAST_PATH_RESTART()


#define TM_SHARED_READ(var)             STM_READ(var)
#define TM_SHARED_READ_P(var)           STM_READ_P(var)
#define TM_SHARED_READ_D(var)           STM_READ_D(var)
#define TM_SHARED_READ_F(var)           STM_READ_F(var)

#define TM_SHARED_WRITE(var, val)       STM_WRITE((var), val)
#define TM_SHARED_WRITE_P(var, val)     STM_WRITE_P((var), val)
#define TM_SHARED_WRITE_D(var, val)     STM_WRITE_D((var), val)
#define TM_SHARED_WRITE_F(var, val)     STM_WRITE_F((var), val)

#define TM_LOCAL_WRITE(var, val)        STM_LOCAL_WRITE(var, val)
#define TM_LOCAL_WRITE_P(var, val)      STM_LOCAL_WRITE_P(var, val)
#define TM_LOCAL_WRITE_D(var, val)      STM_LOCAL_WRITE_D(var, val)

#endif /* TM_H */
