
#pragma OPENCL EXTENSION cl_khr_int64_base_atomics : enable
#pragma OPENCL EXTENSION cl_khr_int64_extended_atomics : enable

#define SUCCESS 0
#define FAIL -1

#define STATES 8
#define PHASE 0
#define SPIN 1
#define COMPLETE 2
#define FINISH 3
#define VALID 4
#define RCHUNKCOUNTER 5
#define LASTCHUNKELEMENTS 6
#define SHAREDI 7


//from atomic_ops
/* All operations operate on unsigned AO_t, which               */
/* is the natural word size, and usually unsigned long.         */
/* It is possible to check whether a particular operation op    */
/* is available on a particular platform by checking whether    */
/* AO_HAVE_op is defined.  We make heavy use of these macros    */
/* internally.*/
#define ATOMIC_LOAD(a)               (*((volatile size_t *)(a)))

/* only thing that worries me is l = ATOMIC_LOAD(r->lock);
 * that is in the atomic ops lib. But if clSVMAlloc access is atomic then great.
 * */


typedef uintptr_t stm_word_t;
//typedef atomic_uintptr_t atomic_stm_word_t;

#define OWNED_BITS                     1                   /* 1 bit */
#define INCARNATION_BITS               3                   /* 3 bits */
#define WRITE_MASK                     0x01                /* 1 bit */
#define OWNED_MASK                     (WRITE_MASK)
#define LOCK_GET_OWNED(l)               (l & OWNED_MASK)
#define LOCK_GET_ADDR(l)                (l & ~(stm_word_t)OWNED_MASK)
#define LOCK_BITS                       (OWNED_BITS + INCARNATION_BITS)
#define LOCK_GET_TIMESTAMP(l)           (l >> (LOCK_BITS))
#ifndef CACHELINE_SIZE
/* It ensures efficient usage of cache and avoids false sharing.
 * It could be defined in an architecture specific file. */
# define CACHELINE_SIZE                 64
#endif


typedef struct r_entry {                  /* Read set entry */
	stm_word_t version;                   /* Version read */
	volatile stm_word_t *lock;            /* Pointer to lock (for fast access) */
} r_entry_t;

typedef struct w_entry {                /* Write set entry */
    union {                               /* For padding... */
        struct {
            volatile stm_word_t *addr;        /* Address written */
            stm_word_t value;                 /* New (write-back) or old (write-through) value */
            stm_word_t mask;                  /* Write mask */
            stm_word_t version;               /* Version overwritten */
            volatile stm_word_t *lock;        /* Pointer to lock (for fast access) */
            union {
                struct w_entry *next;           /* WRITE_BACK_ETL || WRITE_THROUGH: Next address covered by same lock (if any) */
                stm_word_t no_drop;             /* WRITE_BACK_CTL: Should we drop lock upon abort? */
            };
        };
        char padding[CACHELINE_SIZE];       /* Padding (multiple of a cache line) */
    };
} w_entry_t;

typedef struct thread_control{
    uintptr_t w_set_base;
    uintptr_t w_set_end;
    atomic_int r_pool_idx;  /* index within the r_entry_pool */
    atomic_int reads_count; /* stats */
    atomic_int valid;
    atomic_int Phase;
    unsigned long submersions;
    unsigned int block_offset;
    unsigned int nb_entries;
} thread_control_t;

/* clSetKernelExecInfo(..., CL_KERNEL_EXEC_INFO_SVM_PTRS,...) for each p in clsvmvalidation.c::r_entry_wrapper_t array
 * pass in r_entry_wrapper_pool as clSetKernelArgSVMPointer
 * */

typedef struct r_entry_wrapper{
    r_entry_t* entries;
}r_entry_wrapper_t;

//single define inside
#include "debug_validation.h"

__kernel void InstantKernel(
		__global unsigned int* pCommBuffer,
		//__global stm_word_t* locks_arg,
		__global r_entry_wrapper_t* r_entry_wrapper_pool,
		__global thread_control_t* thread_comm
#ifdef DEBUG_VALIDATION
#if (DEBUG_VALIDATION == 1)
        ,
        __global uintptr_t* debug_buffer,
        __global stm_word_t* debug_buffer1,
        __global stm_word_t* debug_buffer2
#endif
#endif
        )
{

    // declares a pointer p in the __private address space that
    // points to an object in address space __global:

    __global volatile atomic_int* SVMComm =
    (__global volatile atomic_int*) pCommBuffer;

    //each hw thread notifies that its is ready
    if( get_sub_group_local_id() == 0 ){
        /* release fence is inserted right after atomic operation, so write results of the current work-item
         * immediately become visible to others once atomic operation finishes*/
        atomic_fetch_add_explicit(
                &SVMComm[SPIN],
                1,
                memory_order_seq_cst,
                memory_scope_all_svm_devices);
    }

    /* type is pointer to global memory object thread_control_t. threadComm is a private pointer private to each WI. */
    /* __global thread_control_t* __local threadComm[0]; //this is how you store pointer in local memory */
    __global thread_control_t* threadComm =    /* *threadComm is private to each WI. a pointer to its work-group's assigned th_con slot*/
    (__global thread_control_t*) &thread_comm[0]; /* each work item has got a pointer in private memory.*/

    //__global volatile atomic_int* tphase = (__global volatile atomic_int*) threadComm->Phase;

    /* map a work-group into a gpu chunk */
    /* each CPU thread maps to a gpu chunk */
    /* each GPU chunk is made up of wkgps */
    /* map a work-group into a gpu chunk called thread_control_slot */
    /*optimize into
     *
     * int thread_control_slot = (split_gpu_into * get_group_id(0)) / get_num_groups(0);
     * mult is more efficient. try not to do divisions.
     * */

    /* example: id 13, chunk_capacity=1344:2=672 */
    /* example chunk 2: global_id=685, 685%672chunk_capacity = i = 13*/

	/* SLM local to this WKGP */
	/* initialize SLM for work-group communication */
	__local int Finish;
	__local long ReqPhase;
    __local uint block_offset;
    __local uint rset_size;
    __local atomic_int reads_validated;

	Finish = 0;
	ReqPhase = 0;

	barrier(CLK_LOCAL_MEM_FENCE);

	__private uint Phase = 0;
    __private uint i = get_global_id(0);
    __private uint j;

	while(1){

		if ( get_local_id(0) == 0 ) {
		    atomic_store_explicit(&reads_validated, 0, memory_order_release, memory_scope_work_group);
            /* acquire memory fence is inserted right before atomic operation, so all write results of other work-items
             * within operation scope become visible to current work-item before atomic operation starts.*/
            Finish = atomic_load_explicit(&SVMComm[FINISH], memory_order_release, memory_scope_all_svm_devices);
			ReqPhase = atomic_load_explicit(&SVMComm[PHASE], memory_order_release, memory_scope_all_svm_devices);
            block_offset = threadComm->block_offset;
            rset_size = threadComm->nb_entries;
            //n_per_wi = threadComm->n_per_wi;
		}

		barrier( CLK_LOCAL_MEM_FENCE );

		if(Finish != 0) return;

        if( Phase < ReqPhase ){//some thread subscribed to this work-group
                j = (i + block_offset);
            //how many read entries will each WI do: n
            //n = ( meta_p->nb_entries + gpu_chunk_capacity - 1 ) / gpu_chunk_capacity;//ceil, example (673+672-1)/672=2, which means every wi will look twice
            //for( int j = i * n_per_wi; j < (i * n_per_wi) + n_per_wi; j++ ){
                /* absolutely required */
                if(j < rset_size && atomic_load_explicit(&threadComm->valid, memory_order_acq_rel, memory_scope_all_svm_devices) == 1){ /* if not ordered to break. Comment during early benchmarking */

                    r_entry_t r = r_entry_wrapper_pool[0].entries[j];

                    //increment in Shared Local Memory, work leader notifies world later
                    atomic_fetch_add_explicit(&reads_validated, 1, memory_order_relaxed, memory_scope_work_group);

                    stm_word_t l = (*((volatile size_t *)(r.lock)));


                    #ifdef DEBUG_VALIDATION
                    #if (DEBUG_VALIDATION)
                    //debug_buffer[j]=i; // who did element j
                    //debug_buffer1[j]=l;
                    //debug_buffer2[j]=r.version;
                    #endif
                    #endif
                    if( LOCK_GET_OWNED(l) ) {
                        /* Do we own the lock? */
                        uintptr_t w = (uintptr_t) LOCK_GET_ADDR(l);

                        #ifdef DEBUG_VALIDATION
                        #if (DEBUG_VALIDATION == 1)
                        //debug_buffer1[j] = threadComm->w_set_base;
                        //debug_buffer2[j] = threadComm->w_set_end;
                        #endif
                        #endif

                        /* Simply check if address falls inside our write set */
                        if( !(threadComm->w_set_base <= w && w < threadComm->w_set_end) ){
                            /*it does not: locked by another transactions: cannot validate*/
                            atomic_store_explicit(&threadComm->valid, 0, memory_order_acq_rel, memory_scope_all_svm_devices);
                        }
                        /* We own the lock: OK */
                    } else {

                        #ifdef DEBUG_VALIDATION
                        #if (DEBUG_VALIDATION == 1)
                        //debug_buffer1[i] = LOCK_GET_TIMESTAMP(l);
                        //debug_buffer2[i] = r.version;
                        #endif
                        #endif
                        if (LOCK_GET_TIMESTAMP(l) != r.version) {
                            /* Other version: cannot validate */
                            atomic_store_explicit(&threadComm->valid, 0, memory_order_acq_rel, memory_scope_all_svm_devices);
                        }
                        /* Same version: OK */
                    }

                } /*i < threadComm->nb_entries*/

            //}//end for

            Phase++;//private to every WI//prevent each WI from doing more work. This validation is done.

            /* All work-items in a work-group must execute this function before any are allowed to continue execution beyond the barrier. */
            barrier( CLK_GLOBAL_MEM_FENCE );//on global memory containing atomic control

            if( get_local_id(0) == 0 ){
                //atomic_fetch_add_explicit(&comp_wkgps[get_group_id(0)],1,memory_order_seq_cst,memory_scope_all_svm_devices);
                atomic_fetch_add_explicit(&SVMComm[COMPLETE], 1, memory_order_acq_rel, memory_scope_all_svm_devices);
                atomic_fetch_add_explicit(
                        &threadComm->reads_count,
                        atomic_load_explicit(&reads_validated, memory_order_acquire, memory_scope_work_item),
                        memory_order_relaxed,
                        memory_scope_all_svm_devices);
            }

		}//end reqphase


	}//end while 1

}