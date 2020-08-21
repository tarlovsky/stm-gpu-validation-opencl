/*
 * File:
 *   stm_wbetl.h
 * Author(s):
 *   Pascal Felber <pascal.felber@unine.ch>
 *   Patrick Marlier <patrick.marlier@unine.ch>
 * Description:
 *   STM internal functions for Write-back ETL.
 *
 * Copyright (c) 2007-2014.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, version 2
 * of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * This program has a dual license and can also be distributed
 * under the terms of the MIT license.
 */

#ifndef _STM_WBETL_H_
#define _STM_WBETL_H_

#include "stm_internal.h"

#include "atomic.h"

//need to print uintptr
#include "inttypes.h"
/*to time validation*/
#include "timer.h"

#if CM == CM_MODULAR
/* Function declaration */
static NOINLINE void stm_drop(stm_tx_t *tx);
static NOINLINE int stm_kill(stm_tx_t *tx, stm_tx_t *other, stm_word_t status);
#endif /* CM == CM_MODULAR */

#define STATES 5
#define PHASE 0
#define SPIN 1
#define COMPLETE 2
#define FINISH 3
#define STM_SUBSCRIBER_THREAD 4

#define STICKY_THREAD 0

static INLINE int
stm_wbetl_validate(stm_tx_t *tx)
{
    PRINT_DEBUG("==> stm_wbetl_validate(%p[%lu-%lu])...tx->r_set.nb_entires: %d\n", tx, (unsigned long)tx->start, (unsigned long)tx->end, tx->r_set.nb_entries);
    //printf("EXT R_SET_SLOT/THREAD %d ==> stm_wbetl_validate(%p[%lu-%lu])...tx->r_set.nb_entires: %d tx->w_set.nb_entires: %d\n",tx->rset_slot, tx, (unsigned long)tx->start, (unsigned long)tx->end, tx->r_set.nb_entries, tx->w_set.nb_entries);

    TIMER_T start;
    TIMER_T stop;
    TIMER_READ(start);
    double gpu_time;
    int idx = tx->rset_slot;
    unsigned long long N = tx->r_set.nb_entries;
    threadComm[idx].valid = 1;
    /*some known chunk where it is known that the GPU is never fast enough to reech*/
    //long THRESHOLD = N - N / 3;
    int gpu_mine = 0;
    r_entry_t *r;
    stm_word_t l;
    r = ((r_entry_t*) (rset_pool[tx->rset_slot])) + N - 1; // wind r to len-1 element

    /* don't even bother bothering GPU if read set <= 8192 */
    if(
#if STICKY_THREAD /*only use gpu for STM THREAD 1. Sticky gpu thread.*/
        idx == 1 &&
#endif
#if SB7_BENCHMARK
        idx > 0 && /*thread 0 is data holder, ignore gpu for it. only use gpu for worker threads with id _> 0*/
#endif
        N >= RSET_MIN_GPU_VAL){/*set index to 1 because thread 0 always has less aborts*/
        /* compete for gpu employment */
        /* Try once if not taken - else move one */

#if STICKY_THREAD
        /*only use gpu for STM THREAD idx. Sticky gpu thread*/
        atomic_store_explicit(&gpu_employed, idx, memory_order_release);
#else
        /*CAS compete for iGPU*/

        /*If you would have to introduce a loop only because of spurious failure, don't do it; use strong.
        * If you have a loop anyway, then use weak.*/
        if(atomic_compare_exchange_strong(&gpu_employed, &minus_one, idx)) {
#endif /*! sticky thread*/

           //printf("%d WON GPU!\n", atomic_load_explicit(&gpu_employed, memory_order_seq_cst));
           //if(atomic_load_explicit(&gpu_employed, memory_order_acquire) == idx) {/*was someone was faster than us?*/

                gpu_mine = 1;/*turn on to collect counters after finish*/

                /*register your index/rset_slot with the gpu*/
                pCommBuffer[STM_SUBSCRIBER_THREAD] = idx;

                /* halted when invalidation encountered on the CPU*/
                //halt_gpu = 0;
                atomic_store(&halt_gpu, 0);

                atomic_store(&gpu_exit_validity,1);

                atomic_store_explicit(&GPU_POS, 0, memory_order_relaxed);
                //GPU_POS = 0;

                threadComm[idx].nb_entries = N;

                /*this overshoots rset size but gets everything*/
                //threadComm[idx].submersions = (N + global_dim[0] - 1) / global_dim[0];

                /*this does not overshoot. cpu will be fast enough to take care of gap.*/
                threadComm[idx].submersions = N / global_dim[0];

                threadComm[idx].w_set_base = (uintptr_t) tx->w_set.entries;
                threadComm[idx].w_set_end = (uintptr_t)(tx->w_set.entries + tx->w_set.nb_entries);

                pthread_mutex_lock(&validate_mutex);
                //printf("SIGNALING GPU SIGNALER THREAD..\n");
                    atomic_store_explicit(&delegate_validate, 1, memory_order_release);
                    pthread_cond_signal(&validate_cond);
                pthread_mutex_unlock(&validate_mutex);
           //}
#if !STICKY_THREAD
        } /*atomic cas*/
#endif
    }

    unsigned long long CPU_POS;

    TIMER_READ(T1C);
    /* validate a chunk then increment global counter of how many chunks you have validated */

    for (CPU_POS = N; CPU_POS > 0; r--) {
        CPU_POS--;
        //printf("INDEX ACCESSED %d\n", CPU_POS);
        /* optimization: start checking two inter-threaded variables only past some percentage X
         * because we know cpu is at least X faster than gpu */

        /* this is useful because loads to GPU_POS are evaded by checking on a constant THRESHOLD */
        /* if(gpu_mine && CPU_POS < THRESHOLD){ */

        if(gpu_mine){
            //printf("GPU_POS%d\n", GPU_POS);
            /* CPU_POS starts from 0      |    <- N-1
             * GPU_POS starts from 0 ->      |    N-1
             *
             * gpu_exit_validity set when gpu re-emerges from validation */
            if( CPU_POS <= atomic_load_explicit(&GPU_POS, memory_order_relaxed)
                || !gpu_exit_validity ){
                    //printf("CPU:%d, GPU:%d WASTE:%d\n", N-1-CPU_POS, GPU_POS, MAX(GPU_POS-CPU_POS, CPU_POS-GPU_POS));
                    /*signal gpu to stop*/
                    atomic_store(&halt_gpu, 1);
                    goto ret;
            }
        }

        /*gone from threadComm[idx].valid check to gpu_exit_validity check; cost wend down half from 1.463684 to 0.7 on cpu validation (130M rset).*/
        /*this reduces cpu-gpu contention*/

        //printf("CPU VALIDATED %d ENTRIES\n", tx->val_reads);
        //printf("%d [%016" PRIXPTR "]\n", i, r);
        /* Read lock */
        l = ATOMIC_LOAD(r->lock);
        if (LOCK_GET_OWNED(l)) {
            w_entry_t *w = (w_entry_t *)LOCK_GET_ADDR(l);
            if (!(tx->w_set.entries <= w && w < tx->w_set.entries + tx->w_set.nb_entries)){
                if(gpu_mine){halt_gpu = 1;}/*if we employed gpu tell it to stop*/
                threadComm[idx].valid = 0; /*tell gpu to stop in PRIVATE thread-validation-descriptor*/
                goto ret;
            }
        } else {
            if (LOCK_GET_TIMESTAMP(l) != r->version) {
                if(gpu_mine){halt_gpu = 1;}/*if we employed gpu tell it to stop*/
                threadComm[idx].valid = 0; /*tell gpu to stop in PRIVATE thread-validation-descriptor*/
                goto ret;
            }
        }
    }

ret:
    TIMER_READ(T2C);

    //sync & release gpu
    //dont need this because cpu-gpu meet at middle and CPU stops it then
    //if(gpu_employed) {
        //pthread_mutex_lock(&validate_mutex);
            //while(!atomic_load_explicit(&validate_complete, memory_order_acquire)){
                //printf("Waiting for validation to finish\n");
                //pthread_cond_wait(&validate_complete_cond, &validate_mutex);
            //};
            //atomic_store_explicit(&validate_complete, 0, memory_order_release);//for next iteration
        //pthread_mutex_unlock(&validate_mutex);

        //printf("GPU VALIDATED %d\n", threadComm[tx->rset_slot].reads_count);
        //tx->val_reads += threadComm[tx->rset_slot].reads_count;
    //}
    TIMER_READ(stop);

    //printf("GPU VALIDATED %d\n", threadComm[tx->rset_slot].reads_count);
    //tx->val_reads += threadComm[tx->rset_slot].reads_count;

    //printf("APU TIME: %f\n", TIMER_DIFF_SECONDS(start, stop));

    /* get validation start, whoever started earlier, cpu or gpu,
     * and who ever ended latest, cpu, or gpu. this way we have co-op valtime.*/
    //TIMER_T T1 = TIMER_MIN(T1C, T1G);
    //TIMER_T T2 = TIMER_MAX(T2C, T2G);
    //printf("CPU TIME: %f\n", TIMER_DIFF_SECONDS(T1C, T2C));
    //printf("CPU [%lld.%.9ld %lld.%.9ld]\n", (long long) (T1C).tv_sec, (T1C).tv_nsec, (long long) (T2C).tv_sec , (T2C).tv_nsec);
    //printf("GPU [%lld.%.9ld %lld.%.9ld]\n", (long long) (T1G).tv_sec, (T1G).tv_nsec, (long long) (T2G).tv_sec , (T2G).tv_nsec);
    //printf("APU [%lld.%.9ld %lld.%.9ld]\n", (long long) (T1).tv_sec , T1.tv_nsec, (long long) (T2).tv_sec , T2.tv_nsec);
    //printf("APU TIME: %f\n", TIMER_DIFF_SECONDS(T1, T2));

    //tx->val_time += TIMER_DIFF_SECONDS(TIMER_MIN(T1C, T1G), TIMER_MAX(T2C, T2G));

    tx->val_time += TIMER_DIFF_SECONDS(start, stop);
    tx->cpu_val_time += TIMER_DIFF_SECONDS(T1C, T2C);
    tx->cpu_validated += N-CPU_POS;

    /*add cpu_pos always, gpu_pos later if gpu employed*/
    //printf("%d CPU_N %d\n", idx, N-CPU_POS);
    tx->val_reads += N-CPU_POS;

    if(gpu_mine){
        /*gpu is mine but CPU was so fast that gpu didnt meet it at the end*/
        /*stop gpu from going forward*/
        atomic_store(&halt_gpu, 1);

        /*might underflow if cpu is to fast
         * make it 0 if cpu completed faster than T2G was ever read*/
        gpu_time = TIMER_DIFF_SECONDS(T1G, T2G);
        tx->gpu_val_time += (gpu_time < 0 ? 0 : gpu_time);

        /*need to know N to print gpu average validation time per function call per function call*/
        tx->gpu_employed_times += 1;

        /*GPU_POS increments in blocks of MAX_OCCUPANCY*/

        tx->gpu_validated += atomic_load_explicit(&GPU_POS, memory_order_relaxed);

        if(GPU_POS >= 0){
            tx->waste_double_validated += ABS((long long) (GPU_POS-CPU_POS));
        }

        /*total val_reads like in any other benchmark*/
        /*keep it as a standard across all benchmarks*/
        tx->val_reads+=GPU_POS;

        //printf("CPU %d + GPU %d = %d\n", N-1-CPU_POS, GPU_POS, CPU_POS + GPU_POS);

        /*submit counters before release fence*/
        /*relieve gpu of it's duty. Other transactions can now get the gpu*/
        //printf("%d CLEARING gpu_employed\n", idx);
        /*prevent gpu proxy thread from waking up*/
        atomic_store_explicit(&delegate_validate, 0, memory_order_release);
        //atomic_compare_exchange_strong(&gpu_employed, &idx, -1);
        atomic_store_explicit(&gpu_employed, -1, memory_order_release);
    }

    tx->stat_val_succ += threadComm[idx].valid;//faster than a branch i guess, v is either 1 or 0
    tx->stat_val_fail += !threadComm[idx].valid;//

    return threadComm[idx].valid;
}


#define LASTCHUNKELEMENTS 5

static INLINE int
stm_wbetl_validate_unaltered(stm_tx_t *tx)
{
    r_entry_t *r;
    int i;
    stm_word_t l;

    PRINT_DEBUG("==> stm_wbetl_validate(%p[%lu-%lu])...tx->r_set.nb_entires: %d\n", tx, (unsigned long)tx->start, (unsigned long)tx->end, tx->r_set.nb_entries);
    printf("==> stm_wbetl_validate(%p[%lu-%lu])...tx->r_set.nb_entires: %d\n", tx, (unsigned long)tx->start, (unsigned long)tx->end, tx->r_set.nb_entries);
    /* Validate reads */
    r = tx->r_set.entries;
    for (i = tx->r_set.nb_entries; i > 0; i--, r++) {
        /* Read lock */
        l = ATOMIC_LOAD(r->lock);
        /* Unlocked and still the same version? */
        if (LOCK_GET_OWNED(l)) {
            /* Do we own the lock? */
            w_entry_t *w = (w_entry_t *)LOCK_GET_ADDR(l);
            /* Simply check if address falls inside our write set (avoids non-faulting load) */
            if (!(tx->w_set.entries <= w && w < tx->w_set.entries + tx->w_set.nb_entries))
            {
                /* Locked by another transaction: cannot validate */
#ifdef CONFLICT_TRACKING
                if (_tinystm.conflict_cb != NULL) {
# ifdef UNIT_TX
          if (l != LOCK_UNIT) {
# endif /* UNIT_TX */
            /* Call conflict callback */
            stm_tx_t *other = ((w_entry_t *)LOCK_GET_ADDR(l))->tx;
            _tinystm.conflict_cb(tx, other);
# ifdef UNIT_TX
          }
# endif /* UNIT_TX */
        }
#endif /* CONFLICT_TRACKING */
                return 0;
            }
            /* We own the lock: OK */
        } else {
            if (LOCK_GET_TIMESTAMP(l) != r->version) {
                /* Other version: cannot validate */
                return 0;
            }
            /* Same version: OK */
        }
    }
    return 1;
}


/*
 * Extend snapshot range.
 */
static INLINE int
stm_wbetl_extend(stm_tx_t *tx)
{
  stm_word_t now;
  tx->snapshot_extension_calls += 1;
  PRINT_DEBUG("==> stm_wbetl_extend(%p[%lu-%lu])\n", tx, (unsigned long)tx->start, (unsigned long)tx->end);
  //printf("%d SNAPSHOT EXTEND ==> stm_wbetl_validate(%p[%lu-%lu])...tx->r_set.nb_entires: %d tx->w_set.nb_entires: %d\n",tx->rset_slot, tx, (unsigned long)tx->start, (unsigned long)tx->end, tx->r_set.nb_entries, tx->w_set.nb_entries);
#ifdef UNIT_TX
  /* Extension is disabled */
  if (tx->attr.no_extend)
    return 0;
#endif /* UNIT_TX */

  /* Get current time */
  now = GET_CLOCK;
  /* No need to check clock overflow here. The clock can exceed up to MAX_THREADS and it will be reset when the quiescence is reached. */

  /* Try to validate read set */
  if (stm_wbetl_validate(tx)) {
    /* It works: we can extend until now */
    tx->end = now;
    return 1;
  }
  return 0;
}

static INLINE void
stm_wbetl_rollback(stm_tx_t *tx)
{
  w_entry_t *w;
  int i;
#if CM == CM_MODULAR
  stm_word_t t;
#endif /* CM == CM_MODULAR */
#if CM == CM_BACKOFF
  unsigned long wait;
  volatile int j;
#endif /* CM == CM_BACKOFF */

  PRINT_DEBUG("==> stm_wbetl_rollback(%p[%lu-%lu])\n", tx, (unsigned long)tx->start, (unsigned long)tx->end);

  assert(IS_ACTIVE(tx->status));
#if CM == CM_MODULAR
  /* Set status to ABORTING */
  t = tx->status;
  if (GET_STATUS(t) == TX_KILLED || (GET_STATUS(t) == TX_ACTIVE && ATOMIC_CAS_FULL(&tx->status, t, t + (TX_ABORTING - TX_ACTIVE)) == 0)) {
    /* We have been killed */
    assert(GET_STATUS(tx->status) == TX_KILLED);
    /* Release locks */
    stm_drop(tx);
    return;
  }
#endif /* CM == CM_MODULAR */

  /* Drop locks */
  i = tx->w_set.nb_entries;
  if (i > 0) {
    w = tx->w_set.entries;
    for (; i > 0; i--, w++) {
      if (w->next == NULL) {
        /* Only drop lock for last covered address in write set */
        ATOMIC_STORE(w->lock, LOCK_SET_TIMESTAMP(w->version));
      }
    }
    /* Make sure that all lock releases become visible */
    ATOMIC_MB_WRITE;
  }
}

/*
 * Load a word-sized value (invisible read).
 */
static INLINE stm_word_t
stm_wbetl_read_invisible(stm_tx_t *tx, volatile stm_word_t *addr)
{
  volatile stm_word_t *lock;
  stm_word_t l, l2, value, version;
  r_entry_t *r;
  w_entry_t *w;
#if CM == CM_MODULAR
  stm_word_t t;
  int decision;
#endif /* CM == CM_MODULAR */

  PRINT_DEBUG2("==> stm_wbetl_read_invisible(t=%p[%lu-%lu],a=%p)\n", tx, (unsigned long)tx->start, (unsigned long)tx->end, addr);

#if CM != CM_MODULAR
  assert(IS_ACTIVE(tx->status));
#endif /* CM != CM_MODULAR */

  /* Get reference to lock */
  lock = GET_LOCK(addr);

  /* Note: we could check for duplicate reads and get value from read set */

  /* Read lock, value, lock */
 restart:
  l = ATOMIC_LOAD_ACQ(lock);
 restart_no_load:
  if (unlikely(LOCK_GET_WRITE(l))) {
    /* Locked */
    /* Do we own the lock? */
    w = (w_entry_t *)LOCK_GET_ADDR(l);
    /* Simply check if address falls inside our write set (avoids non-faulting load) */
    if (likely(tx->w_set.entries <= w && w < tx->w_set.entries + tx->w_set.nb_entries)) {
      /* Yes: did we previously write the same address? */
      while (1) {
        if (addr == w->addr) {
          /* Yes: get value from write set (or from memory if mask was empty) */
          value = (w->mask == 0 ? ATOMIC_LOAD(addr) : w->value);
          break;
        }
        if (w->next == NULL) {
          /* No: get value from memory */
          value = ATOMIC_LOAD(addr);
# if CM == CM_MODULAR
          if (GET_STATUS(tx->status) == TX_KILLED) {
            stm_rollback(tx, STM_ABORT_KILLED);
            return 0;
          }
# endif /* CM == CM_MODULAR */
          break;
        }
        w = w->next;
      }
      /* No need to add to read set (will remain valid) */
      return value;
    }

# ifdef UNIT_TX
    if (l == LOCK_UNIT) {
      /* Data modified by a unit store: should not last long => retry */
      goto restart;
    }
# endif /* UNIT_TX */

    /* Conflict: CM kicks in (we could also check for duplicate reads and get value from read set) */
# if defined(IRREVOCABLE_ENABLED) && defined(IRREVOCABLE_IMPROVED)
    if (tx->irrevocable && ATOMIC_LOAD(&_tinystm.irrevocable) == 1)
      ATOMIC_STORE(&_tinystm.irrevocable, 2);
# endif /* defined(IRREVOCABLE_ENABLED) && defined(IRREVOCABLE_IMPROVED) */
# if CM != CM_MODULAR && defined(IRREVOCABLE_ENABLED)
    if (unlikely(tx->irrevocable)) {
      /* Spin while locked */
      goto restart;
    }
# endif /* CM != CM_MODULAR && defined(IRREVOCABLE_ENABLED) */
# if CM == CM_MODULAR
    t = w->tx->status;
    l2 = ATOMIC_LOAD_ACQ(lock);
    if (l != l2) {
      l = l2;
      goto restart_no_load;
    }
    if (t != w->tx->status) {
      /* Transaction status has changed: restart the whole procedure */
      goto restart;
    }
#  ifdef READ_LOCKED_DATA
#   ifdef IRREVOCABLE_ENABLED
    if (IS_ACTIVE(t) && !tx->irrevocable)
#   else /* ! IRREVOCABLE_ENABLED */
    if (GET_STATUS(t) == TX_ACTIVE)
#   endif /* ! IRREVOCABLE_ENABLED */
    {
      /* Read old version */
      version = ATOMIC_LOAD(&w->version);
      /* Read data */
      value = ATOMIC_LOAD(addr);
      /* Check that data has not been written */
      if (t != w->tx->status) {
        /* Data concurrently modified: a new version might be available => retry */
        goto restart;
      }
      if (version >= tx->start && (version <= tx->end || (!tx->attr.read_only && stm_wbetl_extend(tx)))) {
      /* Success */
#  ifdef TM_STATISTICS2
        tx->stat_locked_reads_ok++;
#  endif /* TM_STATISTICS2 */
        goto add_to_read_set;
      }
      /* Invalid version: not much we can do => fail */
#  ifdef TM_STATISTICS2
      tx->stat_locked_reads_failed++;
#  endif /* TM_STATISTICS2 */
    }
#  endif /* READ_LOCKED_DATA */
    if (GET_STATUS(t) == TX_KILLED) {
      /* We can safely steal lock */
      decision = KILL_OTHER;
    } else {
      decision =
#  ifdef IRREVOCABLE_ENABLED
        GET_STATUS(tx->status) == TX_IRREVOCABLE ? KILL_OTHER :
        GET_STATUS(t) == TX_IRREVOCABLE ? KILL_SELF :
#  endif /* IRREVOCABLE_ENABLED */
        GET_STATUS(tx->status) == TX_KILLED ? KILL_SELF :
        (_tinystm.contention_manager != NULL ? _tinystm.contention_manager(tx, w->tx, WR_CONFLICT) : KILL_SELF);
      if (decision == KILL_OTHER) {
        /* Kill other */
        if (!stm_kill(tx, w->tx, t)) {
          /* Transaction may have committed or aborted: retry */
          goto restart;
        }
      }
    }
    if (decision == KILL_OTHER) {
      /* Steal lock */
      l2 = LOCK_SET_TIMESTAMP(w->version);
      if (ATOMIC_CAS_FULL(lock, l, l2) == 0)
        goto restart;
      l = l2;
      goto restart_no_load;
    }
    /* Kill self */
    if ((decision & DELAY_RESTART) != 0)
      tx->c_lock = lock;
# elif CM == CM_DELAY
    tx->c_lock = lock;
# endif /* CM == CM_DELAY */
    /* Abort */
# ifdef CONFLICT_TRACKING
    if (_tinystm.conflict_cb != NULL) {
#  ifdef UNIT_TX
      if (l != LOCK_UNIT) {
#  endif /* UNIT_TX */
        /* Call conflict callback */
        stm_tx_t *other = ((w_entry_t *)LOCK_GET_ADDR(l))->tx;
        _tinystm.conflict_cb(tx, other);
#  ifdef UNIT_TX
      }
#  endif /* UNIT_TX */
    }
# endif /* CONFLICT_TRACKING */
    stm_rollback(tx, STM_ABORT_RW_CONFLICT);
    return 0;
  } else {
    /* Not locked */
    value = ATOMIC_LOAD_ACQ(addr);
    l2 = ATOMIC_LOAD_ACQ(lock);
    if (unlikely(l != l2)) {
      l = l2;
      goto restart_no_load;
    }
#ifdef IRREVOCABLE_ENABLED
    /* In irrevocable mode, no need check timestamp nor add entry to read set */
    if (unlikely(tx->irrevocable))
      goto return_value;
#endif /* IRREVOCABLE_ENABLED */
    /* Check timestamp */
#if CM == CM_MODULAR
    if (LOCK_GET_READ(l))
      version = ((w_entry_t *)LOCK_GET_ADDR(l))->version;
    else
      version = LOCK_GET_TIMESTAMP(l);
#else /* CM != CM_MODULAR */
    version = LOCK_GET_TIMESTAMP(l);
#endif /* CM != CM_MODULAR */
    /* Valid version? */
    if (unlikely(version > tx->end)) {
      /* No: try to extend first (except for read-only transactions: no read set) */
      if (tx->attr.read_only || !stm_wbetl_extend(tx)) {
        /* Not much we can do: abort */
#if CM == CM_MODULAR
        /* Abort caused by invisible reads */
        tx->visible_reads++;
#endif /* CM == CM_MODULAR */
        stm_rollback(tx, STM_ABORT_VAL_READ);
        return 0;
      }
      /* Verify that version has not been overwritten (read value has not
       * yet been added to read set and may have not been checked during
       * extend) */
      l2 = ATOMIC_LOAD_ACQ(lock);
      if (l != l2) {
        l = l2;
        goto restart_no_load;
      }
      /* Worked: we now have a good version (version <= tx->end) */
    }
#if CM == CM_MODULAR
    /* Check if killed (necessary to avoid possible race on read-after-write) */
    if (GET_STATUS(tx->status) == TX_KILLED) {
      stm_rollback(tx, STM_ABORT_KILLED);
      return 0;
    }
#endif /* CM == CM_MODULAR */
  }
  /* We have a good version: add to read set (update transactions) and return value */

#ifdef READ_LOCKED_DATA
 add_to_read_set:
#endif /* READ_LOCKED_DATA */
  if (!tx->attr.read_only) {
#ifdef NO_DUPLICATES_IN_RW_SETS
    if (stm_has_read(tx, lock) != NULL)
      goto return_value;
#endif /* NO_DUPLICATES_IN_RW_SETS */
    /* Add address and version to read set */
    if (tx->r_set.nb_entries == tx->r_set.size) {
        stm_allocate_rs_entries(tx, 1);
    }
    r = &tx->r_set.entries[tx->r_set.nb_entries++];
    r->version = version;
    r->lock = lock;
  }
 return_value:
  return value;
}

#if CM == CM_MODULAR
/*
 * Load a word-sized value (visible read).
 */
static INLINE stm_word_t
stm_wbetl_read_visible(stm_tx_t *tx, volatile stm_word_t *addr)
{
  volatile stm_word_t *lock;
  stm_word_t l, l2, t, value, version;
  w_entry_t *w;
  int decision;

  PRINT_DEBUG2("==> stm_wbetl_read_visible(t=%p[%lu-%lu],a=%p)\n", tx, (unsigned long)tx->start, (unsigned long)tx->end, addr);

  if (GET_STATUS(tx->status) == TX_KILLED) {
    stm_rollback(tx, STM_ABORT_KILLED);
    return 0;
  }

  /* Get reference to lock */
  lock = GET_LOCK(addr);

  /* Try to acquire lock */
 restart:
  l = ATOMIC_LOAD_ACQ(lock);
 restart_no_load:
  if (LOCK_GET_OWNED(l)) {
    /* Locked */
#ifdef UNIT_TX
    if (l == LOCK_UNIT) {
      /* Data modified by a unit store: should not last long => retry */
      goto restart;
    }
#endif /* UNIT_TX */
    /* Do we own the lock? */
    w = (w_entry_t *)LOCK_GET_ADDR(l);
    /* Simply check if address falls inside our write set (avoids non-faulting load) */
    if (tx->w_set.entries <= w && w < tx->w_set.entries + tx->w_set.nb_entries) {
      /* Yes: is it only read-locked? */
      if (!LOCK_GET_WRITE(l)) {
        /* Yes: get value from memory */
        value = ATOMIC_LOAD(addr);
      } else {
        /* No: did we previously write the same address? */
        while (1) {
          if (addr == w->addr) {
            /* Yes: get value from write set (or from memory if mask was empty) */
            value = (w->mask == 0 ? ATOMIC_LOAD(addr) : w->value);
            break;
          }
          if (w->next == NULL) {
            /* No: get value from memory */
            value = ATOMIC_LOAD(addr);
            break;
          }
          w = w->next;
        }
      }
      if (GET_STATUS(tx->status) == TX_KILLED) {
        stm_rollback(tx, STM_ABORT_KILLED);
        return 0;
      }
      /* No need to add to read set (will remain valid) */
      return value;
    }
    /* Conflict: CM kicks in */
# if defined(IRREVOCABLE_ENABLED) && defined(IRREVOCABLE_IMPROVED)
    if (tx->irrevocable && ATOMIC_LOAD(&_tinystm.irrevocable) == 1)
      ATOMIC_STORE(&_tinystm.irrevocable, 2);
# endif /* defined(IRREVOCABLE_ENABLED) && defined(IRREVOCABLE_IMPROVED) */
    t = w->tx->status;
    l2 = ATOMIC_LOAD_ACQ(lock);
    if (l != l2) {
      l = l2;
      goto restart_no_load;
    }
    if (t != w->tx->status) {
      /* Transaction status has changed: restart the whole procedure */
      goto restart;
    }
    if (GET_STATUS(t) == TX_KILLED) {
      /* We can safely steal lock */
      decision = KILL_OTHER;
    } else {
      decision =
# ifdef IRREVOCABLE_ENABLED
        GET_STATUS(tx->status) == TX_IRREVOCABLE ? KILL_OTHER :
        GET_STATUS(t) == TX_IRREVOCABLE ? KILL_SELF :
# endif /* IRREVOCABLE_ENABLED */
        GET_STATUS(tx->status) == TX_KILLED ? KILL_SELF :
        (_tinystm.contention_manager != NULL ? _tinystm.contention_manager(tx, w->tx, (LOCK_GET_WRITE(l) ? WR_CONFLICT : RR_CONFLICT)) : KILL_SELF);
      if (decision == KILL_OTHER) {
        /* Kill other */
        if (!stm_kill(tx, w->tx, t)) {
          /* Transaction may have committed or aborted: retry */
          goto restart;
        }
      }
    }
    if (decision == KILL_OTHER) {
      version = w->version;
      goto acquire;
    }
    /* Kill self */
    if ((decision & DELAY_RESTART) != 0)
      tx->c_lock = lock;
    /* Abort */
# ifdef CONFLICT_TRACKING
    if (_tinystm.conflict_cb != NULL) {
#  ifdef UNIT_TX
      if (l != LOCK_UNIT) {
#  endif /* UNIT_TX */
        /* Call conflict callback */
        stm_tx_t *other = ((w_entry_t *)LOCK_GET_ADDR(l))->tx;
        _tinystm.conflict_cb(tx, other);
#  ifdef UNIT_TX
      }
#  endif /* UNIT_TX */
    }
# endif /* CONFLICT_TRACKING */
    stm_rollback(tx, (LOCK_GET_WRITE(l) ? STM_ABORT_WR_CONFLICT : STM_ABORT_RR_CONFLICT));
    return 0;
  }
  /* Not locked */
  version = LOCK_GET_TIMESTAMP(l);
 acquire:
  /* Acquire lock (ETL) */
  if (tx->w_set.nb_entries == tx->w_set.size)
    stm_rollback(tx, STM_ABORT_EXTEND_WS);
  w = &tx->w_set.entries[tx->w_set.nb_entries];
  w->version = version;
  value = ATOMIC_LOAD(addr);
  if (ATOMIC_CAS_FULL(lock, l, LOCK_SET_ADDR_READ((stm_word_t)w)) == 0)
    goto restart;
  /* Add entry to write set */
  w->addr = addr;
  w->mask = 0;
  w->lock = lock;
  w->value = value;
  w->next = NULL;
  tx->w_set.nb_entries++;
  return value;
}
#endif /* CM == CM_MODULAR */

static INLINE stm_word_t
stm_wbetl_read(stm_tx_t *tx, volatile stm_word_t *addr)
{
#if CM == CM_MODULAR
  if (unlikely((tx->attr.visible_reads))) { /*VR_THESH DEFAULT IS 3, after 3 aborts with invisible reads switch to visible*/
    /* Use visible read */
    return stm_wbetl_read_visible(tx, addr);
  }

#endif /* CM == CM_MODULAR */
  return stm_wbetl_read_invisible(tx, addr);
}

static INLINE w_entry_t *
stm_wbetl_write(stm_tx_t *tx, volatile stm_word_t *addr, stm_word_t value, stm_word_t mask)
{
  volatile stm_word_t *lock;
  stm_word_t l, version;
  w_entry_t *w;
  w_entry_t *prev = NULL;
#if CM == CM_MODULAR
  int decision;
  stm_word_t l2, t;
#endif /* CM == CM_MODULAR */

  PRINT_DEBUG2("==> stm_wbetl_write(t=%p[%lu-%lu],a=%p,d=%p-%lu,m=0x%lx)\n",
               tx, (unsigned long)tx->start, (unsigned long)tx->end, addr, (void *)value, (unsigned long)value, (unsigned long)mask);

  /* Get reference to lock */
  lock = GET_LOCK(addr);

  /* Try to acquire lock */
 restart:
  l = ATOMIC_LOAD_ACQ(lock);
 restart_no_load:
  if (unlikely(LOCK_GET_OWNED(l))) {
    /* Locked */

#ifdef UNIT_TX
    if (l == LOCK_UNIT) {
      /* Data modified by a unit store: should not last long => retry */
      goto restart;
    }
#endif /* UNIT_TX */

    /* Do we own the lock? */
    w = (w_entry_t *)LOCK_GET_ADDR(l);
    /* Simply check if address falls inside our write set (avoids non-faulting load) */
    if (likely(tx->w_set.entries <= w && w < tx->w_set.entries + tx->w_set.nb_entries)) {
      /* Yes */
#if CM == CM_MODULAR
      /* If read-locked: upgrade lock */
      if (!LOCK_GET_WRITE(l)) {
        if (ATOMIC_CAS_FULL(lock, l, LOCK_UPGRADE(l)) == 0) {
          /* Lock must have been stolen: abort */
          stm_rollback(tx, STM_ABORT_KILLED);
          return NULL;
        }
        tx->w_set.has_writes++;
      }
#endif /* CM == CM_MODULAR */
      if (mask == 0) {
        /* No need to insert new entry or modify existing one */
        return w;
      }
      prev = w;
      /* Did we previously write the same address? */
      while (1) {
        if (addr == prev->addr) {
          /* No need to add to write set */
          if (mask != ~(stm_word_t)0) {
            if (prev->mask == 0)
              prev->value = ATOMIC_LOAD(addr);
            value = (prev->value & ~mask) | (value & mask);
          }
          prev->value = value;
          prev->mask |= mask;
          return prev;
        }
        if (prev->next == NULL) {
          /* Remember last entry in linked list (for adding new entry) */
          break;
        }
        prev = prev->next;
      }
      /* Get version from previous write set entry (all entries in linked list have same version) */
      version = prev->version;
      /* Must add to write set */
      if (tx->w_set.nb_entries == tx->w_set.size)
        stm_rollback(tx, STM_ABORT_EXTEND_WS);
      w = &tx->w_set.entries[tx->w_set.nb_entries];
#if CM == CM_MODULAR
      w->version = version;
#endif /* CM == CM_MODULAR */
      goto do_write;
    }
    /* Conflict: CM kicks in */
#if defined(IRREVOCABLE_ENABLED) && defined(IRREVOCABLE_IMPROVED)
    if (tx->irrevocable && ATOMIC_LOAD(&_tinystm.irrevocable) == 1)
      ATOMIC_STORE(&_tinystm.irrevocable, 2);
#endif /* defined(IRREVOCABLE_ENABLED) && defined(IRREVOCABLE_IMPROVED) */
#if CM != CM_MODULAR && defined(IRREVOCABLE_ENABLED)
    if (tx->irrevocable) {
      /* Spin while locked */
      goto restart;
    }
#endif /* CM != CM_MODULAR && defined(IRREVOCABLE_ENABLED) */
#if CM == CM_MODULAR
    t = w->tx->status;
    l2 = ATOMIC_LOAD_ACQ(lock);
    if (l != l2) {
      l = l2;
      goto restart_no_load;
    }
    if (t != w->tx->status) {
      /* Transaction status has changed: restart the whole procedure */
      goto restart;
    }
    if (GET_STATUS(t) == TX_KILLED) {
      /* We can safely steal lock */
      decision = KILL_OTHER;
    } else {
      decision =
# ifdef IRREVOCABLE_ENABLED
        GET_STATUS(tx->status) == TX_IRREVOCABLE ? KILL_OTHER :
        GET_STATUS(t) == TX_IRREVOCABLE ? KILL_SELF :
# endif /* IRREVOCABLE_ENABLED */
        GET_STATUS(tx->status) == TX_KILLED ? KILL_SELF :
        (_tinystm.contention_manager != NULL ? _tinystm.contention_manager(tx, w->tx, WW_CONFLICT) : KILL_SELF);
      if (decision == KILL_OTHER) {
        /* Kill other */
        if (!stm_kill(tx, w->tx, t)) {
          /* Transaction may have committed or aborted: retry */
          goto restart;
        }
      }
    }
    if (decision == KILL_OTHER) {
      /* Handle write after reads (before CAS) */
      version = w->version;
      goto acquire;
    }
    /* Kill self */
    if ((decision & DELAY_RESTART) != 0)
      tx->c_lock = lock;
#elif CM == CM_DELAY
    tx->c_lock = lock;
#endif /* CM == CM_DELAY */
    /* Abort */
#ifdef CONFLICT_TRACKING
    if (_tinystm.conflict_cb != NULL) {
# ifdef UNIT_TX
      if (l != LOCK_UNIT) {
# endif /* UNIT_TX */
        /* Call conflict callback */
        stm_tx_t *other = ((w_entry_t *)LOCK_GET_ADDR(l))->tx;
        _tinystm.conflict_cb(tx, other);
# ifdef UNIT_TX
      }
# endif /* UNIT_TX */
    }
#endif /* CONFLICT_TRACKING */
    stm_rollback(tx, STM_ABORT_WW_CONFLICT);
    return NULL;
  }
  /* Not locked */
  /* Handle write after reads (before CAS) */
  version = LOCK_GET_TIMESTAMP(l);
#ifdef IRREVOCABLE_ENABLED
  /* In irrevocable mode, no need to revalidate */
  if (unlikely(tx->irrevocable))
    goto acquire_no_check;
#endif /* IRREVOCABLE_ENABLED */
 acquire:
  if (unlikely(version > tx->end)) {
    /* We might have read an older version previously */
#ifdef UNIT_TX
    if (unlikely(tx->attr.no_extend)) {
      stm_rollback(tx, STM_ABORT_VAL_WRITE);
      return NULL;
    }
#endif /* UNIT_TX */
    if (unlikely(stm_has_read(tx, lock) != NULL)) {
      /* Read version must be older (otherwise, tx->end >= version) */
      /* Not much we can do: abort */
#if CM == CM_MODULAR
      /* Abort caused by invisible reads */
      tx->visible_reads++;
#endif /* CM == CM_MODULAR */
      stm_rollback(tx, STM_ABORT_VAL_WRITE);
      return NULL;
    }
  }
  /* Acquire lock (ETL) */
#ifdef IRREVOCABLE_ENABLED
 acquire_no_check:
#endif /* IRREVOCABLE_ENABLED */
  if (unlikely(tx->w_set.nb_entries == tx->w_set.size))
    stm_rollback(tx, STM_ABORT_EXTEND_WS);
  w = &tx->w_set.entries[tx->w_set.nb_entries];
#if CM == CM_MODULAR
  w->version = version;
#endif /* if CM == CM_MODULAR */
  if (unlikely(ATOMIC_CAS_FULL(lock, l, LOCK_SET_ADDR_WRITE((stm_word_t)w)) == 0))
    goto restart;
  /* We own the lock here (ETL) */
do_write:
  /* Add address to write set */
  w->addr = addr;
  w->mask = mask;
  w->lock = lock;
  if (unlikely(mask == 0)) {
    /* Do not write anything */
#ifndef NDEBUG
    w->value = 0;
#endif /* ! NDEBUG */
  } else {
    /* Remember new value */
    if (mask != ~(stm_word_t)0)
      value = (ATOMIC_LOAD(addr) & ~mask) | (value & mask);
    w->value = value;
  }
#if CM != CM_MODULAR
  w->version = version;
#endif /* CM != CM_MODULAR */
  w->next = NULL;
  if (prev != NULL) {
    /* Link new entry in list */
    prev->next = w;
  }
  tx->w_set.nb_entries++;
  tx->w_set.has_writes++;

  return w;
}

static INLINE stm_word_t
stm_wbetl_RaR(stm_tx_t *tx, volatile stm_word_t *addr)
{
  /* Possible optimization: avoid adding to read set again */
  return stm_wbetl_read(tx, addr);
}

static INLINE stm_word_t
stm_wbetl_RaW(stm_tx_t *tx, volatile stm_word_t *addr)
{
  stm_word_t l;
  w_entry_t *w;

  l = ATOMIC_LOAD_ACQ(GET_LOCK(addr));
  /* Does the lock owned? */
  assert(LOCK_GET_WRITE(l));
  /* Do we own the lock? */
  w = (w_entry_t *)LOCK_GET_ADDR(l);
  assert(tx->w_set.entries <= w && w < tx->w_set.entries + tx->w_set.nb_entries);

  /* Read directly from write set entry. */
  return w->value;
}

static INLINE stm_word_t
stm_wbetl_RfW(stm_tx_t *tx, volatile stm_word_t *addr)
{
  /* Acquire lock as write. */
  stm_wbetl_write(tx, addr, 0, 0);
  /* Now the lock is owned, read directly from memory is safe. */
  /* TODO Unsafe with CM_MODULAR */
  return *addr;
}

static INLINE void
stm_wbetl_WaR(stm_tx_t *tx, volatile stm_word_t *addr, stm_word_t value, stm_word_t mask)
{
  /* Probably no optimization can be done here. */
  stm_wbetl_write(tx, addr, value, mask);
}

static INLINE void
stm_wbetl_WaW(stm_tx_t *tx, volatile stm_word_t *addr, stm_word_t value, stm_word_t mask)
{
  stm_word_t l;
  w_entry_t *w;

  l = ATOMIC_LOAD_ACQ(GET_LOCK(addr));
  /* Does the lock owned? */
  assert(LOCK_GET_WRITE(l));
  /* Do we own the lock? */
  w = (w_entry_t *)LOCK_GET_ADDR(l);
  assert(tx->w_set.entries <= w && w < tx->w_set.entries + tx->w_set.nb_entries);
  /* in WaW, mask can never be 0 */
  assert(mask != 0);
  while (1) {
    if (addr == w->addr) {
      /* No need to add to write set */
      if (mask != ~(stm_word_t)0) {
        if (w->mask == 0)
          w->value = ATOMIC_LOAD(addr);
        value = (w->value & ~mask) | (value & mask);
      }
      w->value = value;
      w->mask |= mask;
      return;
    }
    /* The entry must exist */
    assert (w->next != NULL);
    w = w->next;
  }
}

static INLINE int
stm_wbetl_commit(stm_tx_t *tx)
{
  w_entry_t *w;
  stm_word_t t;
  int i;

  PRINT_DEBUG("==> stm_wbetl_commit(%p[%lu-%lu])\n", tx, (unsigned long)tx->start, (unsigned long)tx->end);

#if CM == CM_MODULAR
  /* A read-only transaction with visible reads must simply drop locks */
  /* FIXME: if killed? */
  if (tx->w_set.has_writes == 0) {
    w = tx->w_set.entries;
    for (i = tx->w_set.nb_entries; i > 0; i--, w++) {
      /* Only drop lock for last covered address in write set */
      if (w->next == NULL)
        ATOMIC_STORE_REL(w->lock, LOCK_SET_TIMESTAMP(w->version));
    }
    /* Update clock so that future transactions get higher timestamp (liveness of timestamp CM) */
    FETCH_INC_CLOCK;
    goto end;
  }
#endif /* CM == CM_MODULAR */

  /* Update transaction */
#ifdef IRREVOCABLE_ENABLED
  /* Verify if there is an irrevocable transaction once all locks have been acquired */
# ifdef IRREVOCABLE_IMPROVED
  /* FIXME: it is bogus. the status should be changed to idle otherwise stm_quiesce will not progress */
  if (unlikely(!tx->irrevocable)) {
    do {
      t = ATOMIC_LOAD(&_tinystm.irrevocable);
      /* If the irrevocable transaction have encountered an acquired lock, abort */
      if (t == 2) {
        stm_rollback(tx, STM_ABORT_IRREVOCABLE);
        return 0;
      }
    } while (t);
  }
# else /* ! IRREVOCABLE_IMPROVED */
  if (!tx->irrevocable && ATOMIC_LOAD(&_tinystm.irrevocable)) {
    stm_rollback(tx, STM_ABORT_IRREVOCABLE);
    return 0;
  }
# endif /* ! IRREVOCABLE_IMPROVED */
#endif /* IRREVOCABLE_ENABLED */

  /* Get commit timestamp (may exceed VERSION_MAX by up to MAX_THREADS) */
  t = FETCH_INC_CLOCK + 1;
#ifdef IRREVOCABLE_ENABLED
  if (unlikely(tx->irrevocable))
    goto release_locks;
#endif /* IRREVOCABLE_ENABLED */

  /* Try to validate (only if a concurrent transaction has committed since tx->start) */
  //if (unlikely(tx->start != t - 1 && !stm_wbetl_validate(tx))) {

    /*if only one STM thread exists*/
    /*sequential always validates despite having one or N stm-threads*/
    /*sequential would not validate otherwise because no stm-thread touches anybodies rset*/
    //if(SEQUENTIAL || _tinystm.global_tid == 1){
    //if(_tinystm.global_tid == 1){
    if(_tinystm.global_tid == 1){
        /* always validate with 1 thread for thesis */
        if (!stm_wbetl_validate(tx)) {
            //if (unlikely(!stm_wbetl_validate(tx))) { /*tarlovskyy*/
            /* Cannot commit */
    #if CM == CM_MODULAR
            /* Abort caused by invisible reads */
    tx->visible_reads++;
    #endif /* CM == CM_MODULAR */
            stm_rollback(tx, STM_ABORT_VALIDATE);
            return 0;
        }
    }else{

        /*UNTOUCHED CASE*/

        /* Try to validate (only if a concurrent transaction has committed since tx->start) */
        if (unlikely(tx->start != t - 1 && !stm_wbetl_validate(tx))) {
            //if (!stm_wbetl_validate(tx)) {
            //if (unlikely(!stm_wbetl_validate(tx))) { /*tarlovskyy*/
            /* Cannot commit */
    #if CM == CM_MODULAR
            /* Abort caused by invisible reads */
    tx->visible_reads++;
    #endif /* CM == CM_MODULAR */
            stm_rollback(tx, STM_ABORT_VALIDATE);
            return 0;
        }
    }

#ifdef IRREVOCABLE_ENABLED
  release_locks:
#endif /* IRREVOCABLE_ENABLED */

  /* Install new versions, drop locks and set new timestamp */
  w = tx->w_set.entries;
  for (i = tx->w_set.nb_entries; i > 0; i--, w++) {
    if (w->mask != 0)
      ATOMIC_STORE(w->addr, w->value);
    /* Only drop lock for last covered address in write set */
    if (w->next == NULL) {
# if CM == CM_MODULAR
      /* In case of visible read, reset lock to its previous timestamp */
      if (w->mask == 0)
        ATOMIC_STORE_REL(w->lock, LOCK_SET_TIMESTAMP(w->version));
      else
# endif /* CM == CM_MODULAR */
        ATOMIC_STORE_REL(w->lock, LOCK_SET_TIMESTAMP(t));
    }
  }

 end:
  return 1;
}

#endif /* _STM_WBETL_H_ */

