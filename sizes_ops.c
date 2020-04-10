/* ############################## tinystm wbetl with ############################## */


typedef uintptr_t stm_word_t;             /*8 byte*/

typedef struct r_entry {
    stm_word_t version;
    volatile stm_word_t *lock;
} r_entry_t;                              /*16 byte */

typedef struct r_set {
    r_entry_t *entries;
    unsigned int nb_entries;
    unsigned int size;
} r_set_t;                                /* 16 byte */

/* including my own vars for validation benchmarks */
typedef struct stm_tx {
    ...
    r_set_t r_set;                        /* 16 byte */
    ...
} stm_tx_t;                               /* 344 byte, my overhead 32 */

// 4092 * 16 byte = 65536 byte
stm_tx_t->r_set.entries = (r_entry_t*) xmalloc_aligned(tx->r_set.size * sizeof(r_entry_t));

/* This structure should be ordered by hot and cold variables */
typedef struct {
    volatile stm_word_t locks[LOCK_ARRAY_SIZE] ALIGNED; // 8388608 byte
    ...
} ALIGNED global_t;                       /* size with lock array 8390080 byte*/



/* Operations and space when validating */
/*
 space: 4 8 N(8 8 8 4)
 opers: N(p++ > & & ~ ! <= && < p++)
 */

static INLINE int
stm_wbetl_validate(stm_tx_t *tx)    //8
{
    r_entry_t *r;
    int i;
    stm_word_t l;

    r = tx->r_set.entries;          //8 (one because entries is +0 offset)

    // count only space and ops inside loop for every read:
    // 4b loaded: (*tx).r_set.nb_entries into int i
    for (i = tx->r_set.nb_entries; i > 0; i--, r++) {// N(p++ >)
        l = *(r->lock);// N(8 8)
        if( l & 0x01 ){ // N &
            w_entry_t *w = (w_entry_t *) (l & ~(stm_word_t) 1); // N(& ~)
            if (!(tx->w_set.entries <= w && w < tx->w_set.entries + tx->w_set.nb_entries)){
                // N (8 4)
                // N(! <= && < p++)
                return 0;
            }
        }else{
            if( (l >> 4) != r->version){ // >> !=
                return 0;
            }
        }
    }
    return 1;
}


/* ############################## TL 2 ############################## */
typedef uintptr_t      vwLock;  /* (Version,LOCKBIT) */

/* Read set and write-set log entry */
typedef struct _AVPair {
    struct _AVPair* Next;
    struct _AVPair* Prev;
    volatile intptr_t* Addr;
    intptr_t Valu;
    volatile vwLock* LockFor; /* points to the vwLock covering Addr */
    vwLock rdv;               /* read-version @ time of 1st read - observed */
    struct _Thread* Owner;
    long Ordinal;
} AVPair;//72

typedef struct _Log {
    AVPair* List;
    AVPair* put;        /* Insert position - cursor */
    AVPair* tail;       /* CCM: Pointer to last valid entry */
    AVPair* end;        /* CCM: Pointer to last entry */
    long ovf;           /* Overflow - request to grow */
    BitMap BloomFilter; /* Address exclusion fast-path test */
} Log;//48

struct _Thread {
    ...
    Log rdSet;
    Log wrSet;
    ...
};//440, my overhead 32

// operations

#define LDLOCK(a)                       *(a)     /* for PS */
#define UNS(a)                          ((uintptr_t)(a))

#  define _TABSZ  (1<< 20)              // 1048576
static volatile vwLock LockTab[_TABSZ];

static volatile vwLock GClock[TL2_CACHE_LINE_SIZE]; //TL2_CACHE_LINE_SIZE 64
#define _GCLOCK  GClock[32]

__INLINE__ longReadSetCoherent (Thread* Self)   // 8
{
    intptr_t dx = 0;
    vwLock rv = Self->rv;                       // 8
    Log* const rd = &Self->rdSet;               // 8
    AVPair* const EndOfList = rd->put;          // 8
    AVPair* e;
    ASSERT((rv & LOCKBIT) == 0);                // & ==

    // 8 for first e=rd->List
    for (e = rd->List; e != EndOfList; e = e->Next) { //N(!= 8)
        ASSERT(e->LockFor != NULL);// N( 8 !=)
        vwLock v = *(e->LockFor);// N(8)
        if (v & LOCKBIT) {// N &
            dx |= (uintptr_t) (((AVPair*)((uintptr_t)v & ~LOCKBIT))->Owner) ^ (uintptr_t)Self); // N(& ~ 8 ^ |)
        } else {
            dx |= (v > rv);
        }
    }
    return (dx == 0);// ==
}

/*
 space: 40+N(32)
 opers: 2ops+N(8ops)
 */


/* ############################## NOREC ############################## */
typedef struct _AVPair {
    struct _AVPair* Next;
    struct _AVPair* Prev;
    volatile intptr_t* Addr;
    intptr_t Valu;
    long Ordinal;
} AVPair;

typedef struct _Log {
    AVPair* List;
    AVPair* put;        /* Insert position - cursor */
    AVPair* tail;       /* CCM: Pointer to last valid entry */
    AVPair* end;        /* CCM: Pointer to last entry */
    long ovf;           /* Overflow - request to grow */
    BitMap BloomFilter; /* Address exclusion fast-path test */
} Log;

struct _Thread {
    long UniqID;
    volatile long Retries;
    long Starts;
    long Aborts; /* Tally of # of aborts */
    /*tarlovsky*/
    unsigned long long val_reads;
    long val_succ;
    long val_fail;
    double val_time;
    long snapshot;
    unsigned long long rng;
    unsigned long long xorrng [1];
    Log rdSet;
    Log wrSet;
    sigjmp_buf* envPtr;
    long stats[12];
    long TxST;
    long TxLD;
};
typedef struct
{
    long value;
    long padding1;
    long padding2;
    long padding3;
    long padding4;
    long padding5;
    long padding6;
    long padding7;
} aligned_type_t ;
__attribute__((aligned(64))) volatile aligned_type_t* LOCK;

__INLINE__ long
ReadSetCoherent (Thread* Self)          //8
{
    long time;

    while (1) {
        MEMBARSTLD();//mem fence
        time = LOCK->value;             // 8
        // spin while locked
        if ((time & 1) != 0) {          // (& !=)
            continue;
        }

        Log* const rd = &Self->rdSet;       // (8)
        AVPair* const EndOfList = rd->put;  // (8)
        AVPair* e;

        //8
        for (e = rd->List; e != EndOfList; e = e->Next) { // N(!= 8)
            if (e->Valu != LDNF(e->Addr)) { //N(8 != 8)
                return -1;//invalid
            }
        }
        if (LOCK->value == time) // 8
            break;
    }

    return time;
}

// space: 48+N(24)
// ops:   & != N(2)

/* ############################## SWISSTM ############################## */
#define LSB 1u

// default is 2
// how many successive locations (segment size)
#define LOG_DEFAULT_LOCK_EXTENT_SIZE_WORDS 2
#define DEFAULT_LOCK_EXTENT_SIZE (LOG_DEFAULT_LOCK_EXTENT_SIZE_WORDS + LOG_BYTES_IN_WORD)
#define MIN_LOCK_EXTENT_SIZE LOG_BYTES_IN_WORD
#define MAX_LOCK_EXTENT_SIZE 10

#define VERSION_LOCK_TABLE_SIZE (1 << 22)
// two locks are used - write/write and read/write
#define FULL_VERSION_LOCK_TABLE_SIZE (VERSION_LOCK_TABLE_SIZE << 1)

typedef uintptr_t Word;
typedef Word VersionLock;//8

wlpdstm::VersionLock wlpdstm::TxMixinv::version_lock_table[FULL_VERSION_LOCK_TABLE_SIZE]; //67108864

template<typename T, int CHUNK_LENGTH = 2048, bool INIT = false> class Log : public WlpdstmAlloced {
        LogChunk *head;
        // logically last chunk
        LogChunk *lastChunk;
        unsigned nextElement;
};


class TxMixinv : public CacheAlignedAlloc { // 3520
    ...
    struct ReadLogEntry {
        VersionLock *read_lock;
        VersionLock version;
    };//16

    struct WriteLogEntry {
        VersionLock *read_lock;
        WriteLock *write_lock;
        VersionLock old_version;
        TxMixinv *owner;
        WriteWordLogEntry *head;
        ...
    };//40

    typedef Log<ReadLogEntry> ReadLog; // 24
    protected:
        ReadLog read_log;
        /*tarlovsky*/
        double val_time;
        long stat_commits;
        long stat_aborts;
        unsigned long long stat_val_reads;
        long stat_val_succ;
        long stat_val_fail;
    ...
}


inline bool wlpdstm::TxMixinv::ValidateWithReadLocks() {

    ReadLog::iterator iter;


    for(iter = read_log.begin();iter.hasNext();iter.next()) {

        ReadLogEntry &entry = *iter;// N (32)
        VersionLock currentVersion = (VersionLock)atomic_load_no_barrier(entry.read_lock); // N 8

        if(currentVersion != entry.version) {// N !=
            if( currentVersion & 1u ) {// N &
                WriteLock *write_lock = map_read_lock_to_write_lock(entry.read_lock); // N 8 p++
                WriteLogEntry *log_entry = (WriteLogEntry *)atomic_load_no_barrier(write_lock); // N 8
                if(log_entry != NULL && log_entry->owner == this/*this:"TxMixinv *owner"*/) { // N(!= && == 8 8)
                    continue;
                }
            }
            return false;
        }
    }
    return true;
}

/*
 * size: N (72)
 * ops: N(!= & p++ != && ==)
 * */


/* ############################## TinySTM-igpu-persistent ############################## */
int signal_gpu(unsigned int grabbed_r_entry_slot, unsigned int r_set_entires_n, w_entry_t* w_set_base, w_entry_t* w_set_end, unsigned int* rcount){

    // CPU: 4 4 4 4 4 8 8 4 4 24(4 4) 8 4

    int retval = 1;
    int idx = grabbed_r_entry_slot; // 4

    threadComm[idx].n_per_wi = (r_set_entires_n + global_dim[0] - 1) / global_dim[0];// 4 4 4
    threadComm[idx].nb_entries = r_set_entires_n; // 4
    threadComm[idx].w_set_base = (uintptr_t) w_set_base; // 8
    threadComm[idx].w_set_end = (uintptr_t) w_set_end; // 8
    threadComm[idx].reads_count = 0;
    threadComm[idx].r_pool_idx = idx; // 4
    //threadComm[idx].wkgp_comp_count = 0;
    threadComm[idx].valid = 1;
    threadComm[idx].complete = 0;
    threadComm[idx].Phase = 0;
    //atomic_fetch_add_explicit(&threadComm[idx].Phase, ++cl_global_phase, memory_order_seq_cst); //go!
    pCommBuffer[PHASE] = ++cl_global_phase; // TODO will overflow on gpu and cpu, watch out //4

    while(pCommBuffer[COMPLETE] < g_numWorkgroups); // 24 * (4 4)

    pCommBuffer[COMPLETE] = 0;

    return atomic_load(&threadComm[idx].valid); // 8 4 (address is 8, value is 4)
}


__kernel void InstantKernel(__global unsigned int* pCommBuffer, __global r_entry_wrapper_t* r_entry_wrapper_pool, __global thread_control_t* thread_comm){

    __global volatile atomic_int* SVMComm = (__global volatile atomic_int*) pCommBuffer; // P: 5376*8

    //each hw thread notifies that its is ready
    if( get_sub_group_local_id() == 0 ){ // P: 5376 * 4
        atomic_fetch_add_explicit(&SVMComm[SPIN],1,memory_order_release,memory_scope_all_svm_devices); // P: 168 * 8
    }

    __global thread_control_t* threadComm = (__global thread_control_t*) &thread_comm[0];// P: 5376 * 8

  	__local int Finish;
	__local long ReqPhase;
    __local uint n;
    __local uint n_per_wi;

	Finish = 0;
	ReqPhase = 0;

	barrier(CLK_LOCAL_MEM_FENCE);

	__private uint Phase = 0;
    __private uint i = get_global_id(0);// P:5376*4

	while(1){

		if ( get_local_id(0) == 0 ) { //P: 5376*4
			Finish = atomic_load_explicit(&SVMComm[FINISH], memory_order_acquire, memory_scope_all_svm_devices);//L: 24*4, P: 8
            ReqPhase = atomic_load_explicit(&SVMComm[PHASE], memory_order_acquire, memory_scope_all_svm_devices);//L: 24*4, P: 8
            n = threadComm->nb_entries;//L: 24*4
            n_per_wi = threadComm->n_per_wi;//24*4
		}

		barrier( CLK_LOCAL_MEM_FENCE );

		if(Finish != 0) return; // P:5376*4

        if( Phase < ReqPhase ){ //P:5376*(4 4)
            for( int j = i * n_per_wi; j < (i * n_per_wi) + n_per_wi; j++ ){ //P: 5376*(4 N*( 4 4 4 4 4 ))
                if(j < n && atomic_load_explicit(&threadComm->valid, memory_order_acquire, memory_scope_all_svm_devices) == 1){ //P 5376*(N*(4 4 8 4))
                    r_entry_t r = r_entry_wrapper_pool[0].entries[j];//P: 5376*(N*(16))
                    atomic_fetch_add(&threadComm->reads_count, 1);// P: 5376*(N*(16))
                    stm_word_t l = (*((volatile size_t *)(r.lock)));//P: 5376*(N*8)
                    if( LOCK_GET_OWNED(l) ) { //5376*(N*8)
                        uintptr_t w = (uintptr_t) LOCK_GET_ADDR(l);// P: 5376*N*(8)
                        if( !(threadComm->w_set_base <= w && w < threadComm->w_set_end) ){ // P: 5376*N*(8 8 8 8)
                            atomic_store_explicit(&threadComm->valid, 0, memory_order_release, memory_scope_all_svm_devices);// P: 5376*N*(8)
                        }
                    } else {
                        if (LOCK_GET_TIMESTAMP(l) != r.version) { //P: 5376*N*(8 8)
                            atomic_store_explicit(&threadComm->valid, 0, memory_order_release, memory_scope_all_svm_devices);//P: 5376*N*(8)
                        }
                    }
                }
            }
            Phase++; //P: 5376*(4)
            barrier( CLK_GLOBAL_MEM_FENCE );
            if( get_local_id(0) == 0 ){ //P: 5376*(4)
                atomic_fetch_add_explicit(&SVMComm[COMPLETE], 1, memory_order_release, memory_scope_all_svm_devices); //P: 24*(8)
            }
		}
	}
}