/*
 *  performance costs:
    time (s) => 4ns
    ftime (ms) => 39ns
    gettimeofday (us) => 30ns
    clock_gettime (ns) => 26ns (CLOCK_REALTIME)
    clock_gettime (ns) => 8ns (CLOCK_REALTIME_COARSE)
    clock_gettime (ns) => 26ns (CLOCK_MONOTONIC)
    clock_gettime (ns) => 9ns (CLOCK_MONOTONIC_COARSE)
    clock_gettime (ns) => 170ns (CLOCK_PROCESS_CPUTIME_ID)
    clock_gettime (ns) => 154ns (CLOCK_THREAD_CPUTIME_ID)
 */

#ifndef TIMER_H
#define TIMER_H 1


/*    #include <sys/time.h>


    #define TIMER_T                         struct timeval

    #define TIMER_READ(time)                gettimeofday(&(time), NULL)

    #define TIMER_DIFF_SECONDS(start, stop) \
        (((double)(stop.tv_sec)  + (double)(stop.tv_usec / 1000000.0)) - \
         ((double)(start.tv_sec) + (double)(start.tv_usec / 1000000.0)))
*/


    static double timespec_sub(const struct timespec start, const struct timespec end){

        long s = end.tv_sec - start.tv_sec;
        long ns = end.tv_nsec - start.tv_nsec;

        if (start.tv_nsec > end.tv_nsec) {
            --s;
            ns +=  1000000000L;
        }

        return (double)s + (double)ns / (double)1000000000L;
    }

    #include <time.h>

    #define TIMER_T                         struct timespec

    #define TIMER_READ(tp)                  clock_gettime(CLOCK_MONOTONIC, &tp)

    #define TIMER_DIFF_SECONDS(start, end)  timespec_sub(start, end)


#endif /* TIMER_H */
/* =============================================================================
 *
 * End of timer.h
 *
 * =============================================================================
 */
