//
// Created by oleksiy on 15-02-2019.
//

#define _GNU_SOURCE
#include "clsvmvalidation.h"
#include "inttypes.h"
#include "timer.h"
#include "unistd.h"

unsigned int found_cl_hardware;//0 no 1 yes (HD530 or other)

cl_context g_clContext;
cl_device_id *g_clDevices;
cl_command_queue g_clCommandQueue;
cl_program g_clProgram;
char *g_clProgramString;
cl_kernel cl_kernel_worker;
cl_kernel cl_kernel_worker_temp;

//following vars populated by clGetDeviceInfo:
unsigned int cachelineSize;
unsigned int max_work_group_size;
unsigned int NumberOfExecUnits;
unsigned int NumberOfHwThreads;
unsigned int SimdSize;

/*read-set cursor that tells where the gpu currently is */
/*set by delegation thread in increments of MAX_OCCUPANCY (5376 on hd530)*/
/*when cpu passes half of read-set it starts checking this variable every on read-set iteration*/
atomic_ulong GPU_POS;


/* tell the gpu to stop submersing into validation blocks.
 * can be set only by transaction currently owning the gpu*/
atomic_int halt_gpu;

/* transaction threads compete for gpu at start of validation. TODO implement a try_lock_for(time) */
/* at the moment it tries once and quits */
atomic_int gpu_employed;

size_t global_dim[1];
size_t lws[1];

_Atomic unsigned int *pCommBuffer;
volatile stm_word_t** locks;
thread_control_t* threadComm;
r_entry_t **rset_pool;

//_Atomic unsigned int *shared_i; // was replaced by GPU_POS

unsigned int kernel_init;/*instant kernel initialized*/
unsigned int cl_global_phase;/* global phase used to control igpu persistentkernel */


/* This is a workaround fix for problem in ocl compiler: "kernel parameter cannot be declared as a pointer to a pointer". Create an array of structs and pass those as svmpointers*/
/* typedef struct r_entry_wrapper{
        r_entry_t* entries; <-- these is the actual pointer to read sets memory start
    }r_entry_wrapper_t;*/
r_entry_wrapper_t* rset_pool_cl_wrapper;

unsigned int initial_rs_svm_buffers_ocl_global;

struct timespec T1C;
struct timespec T2C;
struct timespec T1G;
struct timespec T2G;

long *debug_buffer_arg;
uintptr_t *debug_buffer_arg1;
uintptr_t *debug_buffer_arg2;

/* glogal number of workgroups occupied by instant kernel */
unsigned int g_numWorkgroups;

/* thread that waits on a condition to signal gpu validation */
pthread_t gpu_delegate_thread;

/*used in validation to signal delegation thread to start working*/
pthread_mutex_t validate_mutex;


pthread_cond_t validate_cond,/*gpu_delegate thread sleeps on this condition when there is no work*/
               validate_complete_cond;/*cpu was sleeping on this condition while waiting for gpu to complete TODO unused */

atomic_int delegate_validate, /*transaction doing validation signals gpu_delegation_thread*/
           validate_complete, /*unnecessary when gpu-cpu work dynamically in opposite directions of the readset.*/
           shutdown_gpu,
           minus_one; /* set in --> cleanupCL() */

/* trick that helps cpu-gpu co-op. reduces sharing threadComm[idx].valid. if gpu invalidates,
* after gpu completes it sets gpu_exit_validity to 0|1.*/
atomic_int gpu_exit_validity;

/* <====================== Begin function definitions ======================> */
int initializeCL(volatile stm_word_t **locks_pointer){

    /* copy pointer; this works; Allocation checked outside in tinystm and inside kernel*/
    locks = locks_pointer; //initializeDeviceData initializes this _tinystm.locks as clSVMAlloc Fine grained buffer with atomics

    if (pthread_mutex_init(&validate_mutex, NULL) != 0) {
        fprintf(stderr, "Error creating validation mutex.\n");
        exit(1);
    }

    if (pthread_cond_init(&validate_cond, NULL) != 0) {
        fprintf(stderr, "Error creating validation condition variable.\n");
        exit(1);
    }

    if (pthread_cond_init(&validate_complete_cond, NULL) != 0) {
        fprintf(stderr, "Error creating validation condition variable.\n");
        exit(1);
    }

    /*initialize atomic flag */
    atomic_store_explicit(&delegate_validate,0, memory_order_relaxed);
    atomic_store_explicit(&validate_complete,0,memory_order_relaxed);
    atomic_store_explicit(&shutdown_gpu,0,memory_order_relaxed);
    atomic_store_explicit(&gpu_exit_validity, 1,memory_order_relaxed); /*use this variable to reduce contention on threadComm[idx].valid. set it after gpu exits with invalid state*/
    atomic_store_explicit(&gpu_employed, -1, memory_order_relaxed);
    atomic_store_explicit(&minus_one, -1, memory_order_relaxed);

    cl_int status = 0;
    cl_uint platformCount = 0;
    found_cl_hardware = 0;
    kernel_init = 0;

    //PLATFORMS
    size_t infoSize;
    char* info;//to print Platform attribute
    const char* attributeNames[5] = { "Name", "Vendor", "Version", "Profile", "Extensions" };
    const cl_platform_info attributeTypes[5] = { CL_PLATFORM_NAME, CL_PLATFORM_VENDOR, CL_PLATFORM_VERSION, CL_PLATFORM_PROFILE, CL_PLATFORM_EXTENSIONS };
    const int attributeCount = sizeof(attributeNames) / sizeof(char*);

    //DEVICES
    cl_uint deviceCount;
    cl_device_id* devices;
    cl_uint maxComputeUnits;

    //device name
    size_t valueSize;
    char* value;

    //[1] get the platform
    cl_platform_id platformToUse = NULL;

    //get platform count at most 5
    //TIMER_T start_1;
    //TIMER_T stop_1;
    //TIMER_READ(start_1);
        status = clGetPlatformIDs(1, NULL, &platformCount);
        testStatus(status, "clGetPlatformIDs error");
    //TIMER_READ(stop_1);
    //printf("clGetPlatformIDs %f\n", TIMER_DIFF_SECONDS(start_1, stop_1));

    //get all platforms
    cl_platform_id *platforms = (cl_platform_id *)malloc(sizeof(cl_platform_id) * platformCount);
    status = clGetPlatformIDs(platformCount, platforms, NULL);
    testStatus(status, "clGetPlatformIDs error");

    cl_uint num_devices = -1;
    cl_device_info devTypeToUse = CL_DEVICE_CPU_OR_GPU;  //set as CPU or GPU from clsvmvalidation.h, default is GPU


    // on my setup the paltform is 1
    // this is done for speedup. removed iteration
    platformToUse = platforms[1];

    // UNCOMMENT TO SEE PLATFORMS
    /*for (unsigned int i = 0; i < platformCount; i++)
    {

        char pbuf[100];
        char nbuf[100];
        status = clGetPlatformInfo(platforms[i], CL_PLATFORM_VENDOR, sizeof(pbuf), pbuf, NULL);
        testStatus(status, "clGetPlatformInfo error");
        status = clGetPlatformInfo(platforms[i], CL_PLATFORM_NAME, sizeof(nbuf), nbuf, NULL);
        testStatus(status, "clGetPlatformInfo error");

        //cant be experimental
        if (strcmp(nbuf, "Experimental")
            && !strcmp(pbuf, "Intel(R) Corporation")
            && !strcmp(nbuf, "Intel(R) OpenCL"))
        {
            printf("\n %d. Platform \n", i);
            platformToUse = platforms[i];


            for (unsigned int j = 0; j < attributeCount; j++) {
                clGetPlatformInfo(platforms[i], attributeTypes[j], 0, NULL, &infoSize);
                //info = (char*)malloc(infoSize);

                //get platform attribute value
                //clGetPlatformInfo(platforms[i], attributeTypes[j], infoSize, info, NULL);
                //printf("  %d.%d %-11s: %s\n", i + 1, j + 1, attributeNames[j], info);
                //free(info);

            }
            //printf("\n");


        }
    }*/

    if (platformToUse == NULL) {
        printf("NO Intel(R) Corporation, Intel(R) OpenCL, Non experimental platform found.");
    }

    //TIMER_READ(start_1);
    // get deviceTypeToUse device types: CPU or GPU
    clGetDeviceIDs(platformToUse, devTypeToUse, 0, NULL, &deviceCount);
    devices = (cl_device_id*)malloc(sizeof(cl_device_id) * deviceCount);//all platfomtouse's devices.
    g_clDevices = (cl_device_id*)malloc(sizeof(cl_device_id) * deviceCount);//actually chosen devices according to some criteria inside the for loop.
    clGetDeviceIDs(platformToUse, devTypeToUse, deviceCount, devices, NULL);

    // for each device print critical attributes
    for (int j = 0; j < deviceCount; j++) {

        // print device name
        clGetDeviceInfo(devices[j], CL_DEVICE_NAME, 0, NULL, &valueSize);
        value = (char*)malloc(valueSize);
        clGetDeviceInfo(devices[j], CL_DEVICE_NAME, valueSize, value, NULL);
        //printf("%d. Device: %s\n", j + 1, value);

        if (!strcmp(value, "Intel(R) HD Graphics")) {
            //printf("Found and using Intel(R) HD Graphics\n");
            found_cl_hardware = 1;//found dfevice flag for read_set_malloc
            //printf("Found and using Intel(R) HD Graphics %d\n", j);
            g_clDevices[0] = devices[j];
            free(value);

            // print hardware device version
            //clGetDeviceInfo(devices[j], CL_DEVICE_VERSION, 0, NULL, &valueSize);
            //value = (char*)malloc(valueSize);
            //clGetDeviceInfo(devices[j], CL_DEVICE_VERSION, valueSize, value, NULL);
            //printf(" %d.%d Hardware version: %s\n", j + 1, 1, value);
            //free(value);

            // print software driver version
            //clGetDeviceInfo(devices[j], CL_DRIVER_VERSION, 0, NULL, &valueSize);
            //value = (char*)malloc(valueSize);
            //clGetDeviceInfo(devices[j], CL_DRIVER_VERSION, valueSize, value, NULL);
            //printf(" %d.%d Software version: %s\n", j + 1, 2, value);
            //free(value);

            // print c version supported by compiler for device
            //clGetDeviceInfo(devices[j], CL_DEVICE_OPENCL_C_VERSION, 0, NULL, &valueSize);
            //value = (char*)malloc(valueSize);
            //clGetDeviceInfo(devices[j], CL_DEVICE_OPENCL_C_VERSION, valueSize, value, NULL);
            //printf(" %d.%d OpenCL C version: %s\n", j + 1, 3, value);
            //free(value);

            // print parallel compute units
            clGetDeviceInfo(devices[j], CL_DEVICE_MAX_COMPUTE_UNITS, sizeof(maxComputeUnits), &maxComputeUnits, NULL);
            //printf(" %d.%d Parallel compute units: %d\n", j + 1, 4, maxComputeUnits);

            NumberOfExecUnits = maxComputeUnits;//will be 8 EUs per sublice * 3 slices = 24 on my 6700k's hd530
            NumberOfHwThreads = NumberOfExecUnits * HW_THREADS_PER_EU;//24*7=168

            //clGetDeviceInfo(devices[j], CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE, sizeof(cachelineSize), &cachelineSize, NULL);
            //printf(" %d.%d Global memory cacheline size: %d\n", j + 1, 5, cachelineSize);

            //clGetDeviceInfo(devices[j], CL_DEVICE_MAX_WORK_GROUP_SIZE, sizeof(max_work_group_size), &max_work_group_size, NULL);
            //printf(" %d.%d Max work group size: %d\n", j + 1, 6, max_work_group_size);


            break;
        }
        free(value);
        // print hardware device version
        //clGetDeviceInfo(devices[j], CL_DEVICE_VERSION, 0, NULL, &valueSize);
        //value = (char*)malloc(valueSize);
        //clGetDeviceInfo(devices[j], CL_DEVICE_VERSION, valueSize, value, NULL);
        //printf(" %d.%d Hardware version: %s\n", j + 1, 1, value);
        //free(value);

        // print software driver version
        //clGetDeviceInfo(devices[j], CL_DRIVER_VERSION, 0, NULL, &valueSize);
        //value = (char*)malloc(valueSize);
        //clGetDeviceInfo(devices[j], CL_DRIVER_VERSION, valueSize, value, NULL);
        //printf(" %d.%d Software version: %s\n", j + 1, 2, value);
        //free(value);

        // print c version supported by compiler for device
        //clGetDeviceInfo(devices[j], CL_DEVICE_OPENCL_C_VERSION, 0, NULL, &valueSize);
        //value = (char*)malloc(valueSize);
        //clGetDeviceInfo(devices[j], CL_DEVICE_OPENCL_C_VERSION, valueSize, value, NULL);
        //printf(" %d.%d OpenCL C version: %s\n", j + 1, 3, value);
        //free(value);

        // print parallel compute units
        //clGetDeviceInfo(devices[j], CL_DEVICE_MAX_COMPUTE_UNITS, sizeof(maxComputeUnits), &maxComputeUnits, NULL);
        //printf(" %d.%d Parallel compute units: %d\n", j + 1, 4, maxComputeUnits);

        //clGetDeviceInfo(devices[j], CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE, sizeof(cachelineSize), &cachelineSize, NULL);
        //printf(" %d.%d Global memory cacheline size: %d\n", j + 1, 5, cachelineSize);

        //clGetDeviceInfo(devices[j], CL_DEVICE_MAX_WORK_GROUP_SIZE, sizeof(max_work_group_size), &max_work_group_size, NULL);
        //printf(" %d.%d Max work group size: %d\n", j + 1, 6, max_work_group_size);

    }

    //TIMER_READ(stop_1);
    //printf("clGetPlatformIDs %f\n", TIMER_DIFF_SECONDS(start_1, stop_1));

    free(devices);

    if (g_clDevices[0] == NULL) {
        printf("No iGPU selected.\n");
    }

    //slows down, comment out for prformance, we know it supports so comment this out to check your hardware
    //checkSVMAvailability(g_clDevices[0]);

    cl_context_properties cps[3] = { CL_CONTEXT_PLATFORM, (cl_context_properties) platformToUse, 0 };

    //create an OCL contexts for each thread
    //someone on nvidia ocl forum suggested best way to do this is context per host thread
    //TIMER_T start;
    //TIMER_T stop;
    //TIMER_READ(start);

    g_clContext = clCreateContext(cps, 1, g_clDevices, NULL, NULL, &status);


    //TIMER_READ(stop);
    //printf("clCreateContext %f\n", TIMER_DIFF_SECONDS(start, stop));

    //create an openCL commandqueue
    //TIMER_READ(start);
    g_clCommandQueue = clCreateCommandQueue(g_clContext, g_clDevices[0], NULL, &status); //change null with CL_QUEUE_PROFILING_ENABLE
    testStatus(status, "clCreateCommandQueue error");


    //TIMER_READ(stop);
    //printf("clCreateCommandQueue %f\n", TIMER_DIFF_SECONDS(start, stop));
    //g_clCommandQueue = clCreateCommandQueue(g_clContext, g_clDevices[0], NULL, &status);

    //create device side program, compile and create program objects

    //TIMER_READ(start);
    //status = initializeDeviceCode();
    initializeDeviceCode(CL_KERNEL_INSTANT, CL_KERNEL_INSTANT_NAME, BIN_KERNEL_INSTANT);
    //initializeDeviceCode(CL_KERNEL_REGULAR, CL_KERNEL_REGULAR_NAME, BIN_KERNEL_REGULAR);
    //TIMER_READ(stop);
    //printf("initializeDeviceCode %f\n", TIMER_DIFF_SECONDS(start, stop));
    testStatus(status, "error in initializeDevice()");

    //create ReadSet buffers in SVM

    //TIMER_READ(start);
    status = initializeDeviceData();
    //TIMER_READ(stop);
    //printf("initializeDeviceData %f\n", TIMER_DIFF_SECONDS(start, stop));
    testStatus(status, "error in initializeDeviceData()");

    //The number of occupied SIMD lanes is a function of the compiled SIMD width and your local work size.
    //so long as local work size is a multiple of SIMDSize, you'll be using the full width of the SIMD unit.

    //Check how the kernel was compiled: did it use simd size 8,16, or 32? (InstantKernel will be SIMD32).
    // if the total number of work-items is a multiple of this number, then you’ll get good results.
    // In practice the only compilers that do automatic vectorization (that I know of) are Intel's proprietary ICD,
    // and the open source pocl. Everything else always just returns 1 (if on CPU) or the wavefront/warp width (on GPU).
    //performance hint; the work-group size should be a multiple of CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE.
    int err = clGetKernelWorkGroupInfo(cl_kernel_worker, g_clDevices[0], CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE, sizeof(size_t), (void*)&SimdSize, NULL);

    if (err) {
        printf("ERR getting CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE code %d\n", err);
    }
    else {
        //printf("SIMD SIZE - CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE: %d\n", SimdSize);
    }

    if (platformCount > 0){
        free(platforms);
    }

    if (g_clDevices != NULL){
        free(g_clDevices);
    }

    return SUCCESS;
}

//compile program and create kernels to be used on device side
int initializeDeviceCode(const char* kernel_src_path, const char* kernel_name, const char* bin_name){

    cl_int status, binary_status, errcode_ret;
    FILE *f;
    //load CL file, build CL program object, create CL kernel object
    const char *filename;
    //printf("Opening hardcoded kernel source path %s\n", filename);

    int length;
    size_t binary_size;

    // if binary kernel file does not exist compile program
    if( access( bin_name, F_OK ) != -1 ){
        /*load binary from file*/
        filename = bin_name;
        //printf("binary file path %s\n", filename);
        bin_to_str(filename, &length); // bin_to_str populates g_clProgramString with binary from .bin
        binary_size = length;
    } else {

        /*binary does not exist InstantKernel.bin. Create binary from InstantKernel.cl file*/
        filename = kernel_src_path;

        convertToStringBuf(filename, &length);//populates g_clProgramString with program string from .cl

        size_t sourceSize = strlen(g_clProgramString);

        g_clProgram = clCreateProgramWithSource(g_clContext, 1, (const char **)&g_clProgramString, &sourceSize, &status);
        testStatus(status, "clCreateProgramWithSource error\n");

        /* -device=GPU was set in Visual Studio Intel OpenCL Code Bulder plugin. Not needed in CL_KERNEL_PROGRAM_OPTIONS. */
        status = clBuildProgram(g_clProgram, 1, g_clDevices, CL_KERNEL_PROGRAM_OPTIONS, NULL, NULL);
        testStatus(status, "clBuildProgram\n");

        if (status != CL_SUCCESS) {
            printf("ERROR BUILD PROGRAM FROM BIN STATUS:%d\n", status);
            //if (status == CL_BUILD_PROGRAM_FAILURE) {
            HandleCompileError();
            //}
        }

        cl_kernel_worker_temp = clCreateKernel(g_clProgram, kernel_name, &status);
        testStatus(status, "clCreateKernel error");
        clGetProgramInfo(g_clProgram, CL_PROGRAM_BINARY_SIZES, sizeof(size_t), &binary_size, NULL);

        g_clProgramString = malloc(binary_size);

        clGetProgramInfo(g_clProgram, CL_PROGRAM_BINARIES, binary_size, &g_clProgramString, NULL);

        f = fopen(bin_name, "w");
        fwrite(g_clProgramString, binary_size, 1, f);
        fclose(f);
        status = clReleaseKernel(cl_kernel_worker_temp);
        testStatus(status, "Error releasing cl_kernel_worker_temp kernel\n");
    }

    /* create program with the binary we either loaded or just created. */
    g_clProgram = clCreateProgramWithBinary(
            g_clContext, 1, &g_clDevices[0], &binary_size,
            (const unsigned char **)&g_clProgramString, &binary_status, &errcode_ret);

    free(g_clProgramString);


    status = clBuildProgram(g_clProgram, 1, &g_clDevices[0], CL_KERNEL_PROGRAM_OPTIONS, NULL, NULL);
    testStatus(status, "clBuildProgram\n");
    if (status != CL_SUCCESS) {
        printf("ERROR BUILD PROGRAM FROM BIN STATUS:%d\n", status);
        //if (status == CL_BUILD_PROGRAM_FAILURE) {
        HandleCompileError();
        //}
    }
    /* and finally */
    cl_kernel_worker = clCreateKernel(g_clProgram, kernel_name, &errcode_ret);

    return SUCCESS;

}

//initialzes Device Data
int initializeDeviceData(){
    //initiate device side data objects (buffers and values)
    cl_int status = 0;
    cl_global_phase = 0;

    /*=======================================*/
    /* this clSVMAlloc can be moved to initializeCL. Here is cleaner.     */
    /* this was static allocation in stm_internal.h global_t declaration. */
    *locks = (stm_word_t*) clSVMAlloc(
            g_clContext,
            CL_MEM_READ_WRITE | CL_MEM_SVM_FINE_GRAIN_BUFFER,
            LOCK_ARRAY_SIZE * sizeof(stm_word_t),
            CACHELINE_SIZE
            );
    /*=======================================*/
    /* singled global metadata for serialized validation */

    /*backup*/
    /* Mapping of thread validation requests/subscriptions into gpu work-groups. */
    threadComm = (thread_control_t*) clSVMAlloc(
            g_clContext,
            CL_MEM_READ_WRITE | CL_MEM_SVM_FINE_GRAIN_BUFFER | CL_MEM_SVM_ATOMICS,
            sizeof(thread_control_t) * initial_rs_svm_buffers_ocl_global, /* for now use only 1. max 168 which is hardware threads */
            CACHELINE_SIZE
    );

    /*=======================================*/
    /* The svm communication buffer for commands. */
    pCommBuffer = clSVMAlloc(
            g_clContext,
            CL_MEM_READ_WRITE | CL_MEM_SVM_FINE_GRAIN_BUFFER | CL_MEM_SVM_ATOMICS,
            STATES * sizeof(_Atomic unsigned int),//4 states : 0-PHASE 1-SPIN 2-COMPLETE 3-FINISH
            CACHELINE_SIZE
    );
    memset(pCommBuffer, 0, sizeof(_Atomic unsigned int) * STATES);

    /* replaced by GPU_POS */
    //shared_i = clSVMAlloc(g_clContext, CL_MEM_READ_WRITE | CL_MEM_SVM_FINE_GRAIN_BUFFER | CL_MEM_SVM_ATOMICS,sizeof(_Atomic unsigned int),CACHELINE_SIZE);

    /*=======================================*/
    /* Pre-allocating a large chunk of read_entry arrays for transactions to use.          */
    /* Rule of instant-kernel svm arguments is they have to be passed in at kernel launch. */
    /* Can pass new location as pointer but the area pointed to will not be SVM            */
    /* initial_rs_svm_buffers_ocl_global is set in stm.c::stm_init, now in the makefile    */
    rset_pool = (r_entry_t**) clSVMAlloc(
            g_clContext,
            CL_MEM_READ_WRITE | CL_MEM_SVM_FINE_GRAIN_BUFFER | CL_MEM_SVM_ATOMICS,
            initial_rs_svm_buffers_ocl_global * sizeof(r_entry_t*),
            CACHELINE_SIZE
            );

    for(int i = 0; i < initial_rs_svm_buffers_ocl_global; i++) {
        /* for each STM thread pre_allocate RW_SET_SIZE entries. this number is alsow known in out tests
         * or just make it max alligned alloc 134217728=2^27 */
        rset_pool[i] = (r_entry_t*) clSVMAlloc(
            g_clContext,
            CL_MEM_READ_WRITE | CL_MEM_SVM_FINE_GRAIN_BUFFER | CL_MEM_SVM_ATOMICS,
            RW_SET_SIZE * sizeof(r_entry_t), //4096 is the default size in tinystm
            CACHELINE_SIZE
        );
    }

    /* fix for error: "kernel parameter cannot be declared as a pointer to a pointer" */
    /* probably a bug in r5.0 opencl implementation */
    /* solution pass in a struct with a pointer field */
    rset_pool_cl_wrapper = (r_entry_wrapper_t*) clSVMAlloc(
            g_clContext,
            CL_MEM_READ_WRITE | CL_MEM_SVM_FINE_GRAIN_BUFFER | CL_MEM_SVM_ATOMICS,
            initial_rs_svm_buffers_ocl_global * sizeof(r_entry_wrapper_t),
            CACHELINE_SIZE
    );
    /* pass in an array of structs pointing to svm memory chunks (read set allocations)*/

    //printf("initing device shared data done.\n");
    /*=======================================*/
    /*result = (unsigned int*) clSVMAlloc(
            g_clContext,
            CL_MEM_READ_WRITE | CL_MEM_SVM_FINE_GRAIN_BUFFER | CL_MEM_SVM_ATOMICS,
            initial_rs_svm_buffers_ocl_global * sizeof(_Atomic unsigned int),//4 states : 0-PHASE 1-SPIN 2-COMPLETE 3-FINISH
            0
    );*/
    /*=======================================*/


#ifdef DEBUG_VALIDATION
#if (DEBUG_VALIDATION == 1)
    debug_buffer_arg = (uintptr_t*) clSVMAlloc(
            g_clContext,
            CL_MEM_READ_WRITE | CL_MEM_SVM_FINE_GRAIN_BUFFER,
            RW_SET_SIZE * sizeof(long),
            CACHELINE_SIZE
    );
    if(debug_buffer_arg == NULL){
        printf("could not allocate debug_buffer_arg \n");
    }
    memset(debug_buffer_arg, 0, sizeof(long) * RW_SET_SIZE);

    debug_buffer_arg1 = (stm_word_t *) clSVMAlloc(
            g_clContext,
            CL_MEM_READ_WRITE | CL_MEM_SVM_FINE_GRAIN_BUFFER,
            RW_SET_SIZE * sizeof(stm_word_t),
            CACHELINE_SIZE
    );
    if(debug_buffer_arg1 == NULL){
        printf("could not allocate debug_buffer_arg1 \n");
    }
    memset(debug_buffer_arg1, 0, sizeof(stm_word_t) * RW_SET_SIZE);

    debug_buffer_arg2 = (uintptr_t*) clSVMAlloc(
            g_clContext,
            CL_MEM_READ_WRITE | CL_MEM_SVM_FINE_GRAIN_BUFFER,
            RW_SET_SIZE * sizeof(uintptr_t),
            CACHELINE_SIZE
    );
    if(debug_buffer_arg2 == NULL){
        printf("could not allocate debug_buffer_arg2 \n");
    }
    memset(debug_buffer_arg2, 0, sizeof(uintptr_t) * RW_SET_SIZE);

#endif /*DEBUG_VALIDATION == 1*/
#endif /*DEBUG_VALIDATION*/


    return status;
} /*end initializeDeviceData*/

int launchInstantKernel(void){

    cl_int status;
    cl_event kernel_finish_event;
    cl_event readEvent;
    /*=================== Required ====================*/
    /*  Pass in rset_pool as array of pointers to r_entry_t arrays          */
    /*  Reference each transaction's read_entries through clSetKernelExecInfo  */
    int extra_svm_ptr_size = (initial_rs_svm_buffers_ocl_global + 1) * sizeof(void*); /* + 1 for locks */
    void **extra_svm_ptr_list = malloc(extra_svm_ptr_size);
    /* It works! if comment clSetKernelExecInfo stops working. */
    for(int i = 0; i < initial_rs_svm_buffers_ocl_global; i++){
        /* make wrapper's only field point to all rset_pools */
        rset_pool_cl_wrapper[i].entries = (void*) rset_pool[i];
        extra_svm_ptr_list[i] = rset_pool_cl_wrapper[i].entries;/*mark rset_pools as svm pointer extra */
    }

    /*  set kernel svm arguments */
    int arg_set_status = 0;
    arg_set_status += clSetKernelArgSVMPointer(cl_kernel_worker, 0, pCommBuffer);
    //arg_set_status += clSetKernelArgSVMPointer(cl_kernel_worker, 1, *locks);/* no need to pass as arg, nodirect access to it, works, because its pre-shared */
    arg_set_status += clSetKernelArgSVMPointer(cl_kernel_worker, 1, rset_pool_cl_wrapper);   /* Accessed in kernel. Needs to be arg. */
    //arg_set_status += clSetKernelArg(cl_kernel_worker, 2, sizeof(unsigned int), &initial_rs_svm_buffers_ocl_global);/* visible in kernel - PASS */
    arg_set_status += clSetKernelArgSVMPointer(cl_kernel_worker, 2, threadComm);
    //arg_set_status += clSetKernelArgSVMPointer(cl_kernel_worker, 4, comp_wkgps);

#ifdef DEBUG_VALIDATION
#if (DEBUG_VALIDATION == 1)
    arg_set_status += clSetKernelArgSVMPointer(cl_kernel_worker, 3, debug_buffer_arg);
    arg_set_status += clSetKernelArgSVMPointer(cl_kernel_worker, 4, debug_buffer_arg1);
    arg_set_status += clSetKernelArgSVMPointer(cl_kernel_worker, 5, debug_buffer_arg2);
#endif
#endif
    assert(arg_set_status == 0);

    extra_svm_ptr_list[initial_rs_svm_buffers_ocl_global] = (void*) *locks;/* PASS - can be referenced within kernel this way*/
    /* necessary */
    clSetKernelExecInfo(cl_kernel_worker, CL_KERNEL_EXEC_INFO_SVM_PTRS, extra_svm_ptr_size, extra_svm_ptr_list);
    /*=================== End Kernel ARGS ====================*/

    /*printf("Number of HW threads %d\n", NumberOfHwThreads);*/
    /*printf("Number of EU %d\n", NumberOfExecUnits);*/
    /* CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE is essentially a performance hint,
     * mentioning that to get full utilization of the hardware, the wg size should be
     * a multiple of the given amount, otherwise some of the lanes might remain idle.
     * If the total number of work-items is a multiple of this number, then you’ll get good results. */
    global_dim[0] = SimdSize * NumberOfHwThreads;//we want to fully load the gpu. 32*168=5376, 8*168=1344

    //there is 64KB of SLM per subslice(8 EUs) for all Workgroups.
    //so if each uses 16KB then only 4 may be spawned concurrently
    //GPU may not spawn threads because of lack of free resources.
    //On every cycle, an EU can co-issue up to four different instructions
    //use 4hw Threads per workgroup to minimize traffic.
    size_t HWThreadsPerWKGP = 7;

    //Make sure Local Workgroup Size is a multiple of SIMDsize
    lws[0] = SimdSize * HWThreadsPerWKGP;
    //32*4=128, 32*7=224
    //5376/128=42 5376/224=24
    g_numWorkgroups = global_dim[0] / lws[0];//5376/128=42, 1344//TODO Make check/sure GWS is a multiple of LWS.

    /*printf("+--------------------+\n"
           "| Enqueue NDRange:   |\n"
           "| hw threads:  %5d |\n"
           "| simd size     %4d |\n"
           "| GWS          %5d |\n"
           "| HWth per WKGP %4d |\n"
           "| WKGP SIZE    %5d |\n"
           "| N WKGPs        %3d |\n"
           "+--------------------+\n",
           NumberOfHwThreads, SimdSize, global_dim[0], HWThreadsPerWKGP, lws[0], g_numWorkgroups);*/

    //cl_event event;
    //TIMER_T start1;
    //TIMER_T stop1;
    //TIMER_READ(start1);
    pCommBuffer[FINISH] = 0;
    pCommBuffer[COMPLETE] = 0;
    pCommBuffer[SPIN] = 0;

    status = clEnqueueNDRangeKernel(g_clCommandQueue, cl_kernel_worker, 1, NULL, global_dim, lws, 0, NULL, NULL);
    //testStatus(status, "clEnqueueNDRangeKernel error");
    clFlush(g_clCommandQueue);

    //wait before GPU is ready , each thread will signal
    while (pCommBuffer[SPIN] < NumberOfHwThreads){
        //printf("%d\n",atomic_load(&pCommBuffer[SPIN])); //debug
    };

    //TIMER_READ(stop1);
    //printf("kernel exec time %f\n", TIMER_DIFF_SECONDS(start1, stop1));
    //clFlush(g_clCommandQueue);

    //printf("GPU READY FOR SUBMISSION ON ALL HW THREADS: %d (expected: %d) \n", pCommBuffer[SPIN], NumberOfHwThreads);
    /* if we are here it means that GPU is ready for submissions on all HW threads */
    //cl_ulong time_start;
    //cl_ulong time_end;

    //clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_START, sizeof(time_start), &time_start, NULL);
    //clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_END, sizeof(time_end), &time_end, NULL);
    //pCommBuffer[PHASE] = ++cl_global_phase;
    //double nanoSeconds = time_end - time_start;
    //printf("OpenCl Execution time is: %0.9f seconds \n", nanoSeconds / 1000000000.0);//to seconds


    /*initialize thread that will wait for co-op validation signal*/

    //int *i = malloc(sizeof(*i));
    //*i = 0; /*dynamically set this as global later, for single threaded validation it is set here.*/
    pthread_attr_t attr;
    pthread_attr_init(&attr); // sets default values
    /*STM threads are pinned down to cores in round robin 0,1,2,3,4,5,6,7*/
    /*if we want gpu proxy thread to run in parallel we must alter it's shed policy otherwise it will be also pinned down to this core*/

    /*do not confuse scheduling policy with thread/core pinning/binding*/
    /*I WANTED TO KEEP CORE PINNING ON STM THREADS AND LET THIS ONE RUNE ON OTHER CORE*/
    /*COULD NOT BE DONE. SETTING SCHED ONTO OTHER CPU WILL INCURR A THREAD STACK COPY COST */
    //pthread_attr_setinheritsched(&attr, PTHREAD_EXPLICIT_SCHED);
    //pthread_attr_setschedpolicy(&attr, SCHED_OTHER);
    //pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);

    /*create gpu signaler thread*/
    /* i tried moving this pthread_create that calls launchInstantKernel into stm_init but gpu get's killed
     * because of too fast accesses to gpu. this kind of slows down the interval of calls to the gpu*/
    pthread_create(&gpu_delegate_thread, &attr, signal_gpu, NULL);

    return 0;
}

void* signal_gpu(void){

    pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, NULL);
    /* set affinity because STM threads are pinned and
     * this one will inherit from launchInstantKernel caller */
    cpu_set_t cpuset;
    CPU_ZERO(&cpuset);
    /*sched on any cpus*/
    for (int j = 0; j < 8; j++){
        CPU_SET(j, &cpuset);}
    /*set affinity to any cpu*/
    int s = pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
    if (s != 0){
        printf("pthread_setaffinity_np error %d\n", s);}

    int submersions;    /*number of blocks in which to call persistent kernel*/
    int i;              /*block counter*/
    int idx;            /*stm_thread_employer*/

    while (!atomic_load_explicit(&shutdown_gpu, memory_order_acquire)) {
        /*wait on condition to launch validation from co-op routine*/
        pthread_mutex_lock(&validate_mutex);
            /* if no work we sleep on condition */
            while (!atomic_load_explicit(&delegate_validate, memory_order_acquire)) {
                pthread_cond_wait(&validate_cond, &validate_mutex);
            }
            /*who is the current employer*/
            idx = atomic_load_explicit(&gpu_employed, memory_order_acquire); /*threadComm will be same as grabbedSlot*/
            //if(idx == -1){
                //printf("WORKING FOR %d\n", idx);
            //}
        pthread_mutex_unlock(&validate_mutex);

        /*do work*/

        threadComm[idx].reads_count = 0;
        threadComm[idx].r_pool_idx = idx; /* should put index in global comm: pcommbuffer */

        submersions = threadComm[idx].submersions;
        i = 0;
        //printf("SUBMERSIONS: %d\n", submersions);
        TIMER_READ(T1G);
        /*halted gpu is set on the cpu when it invalidates the tx*/
        /*submersions is derived from block size*/

        while(!atomic_load(&halt_gpu) && i < submersions){

            /*TODO counters will overflow in long runnning tx.
             * Up to 3 million read set safe.
             * Up to 60 seconds tpcc tested*/
            pCommBuffer[PHASE] = ++cl_global_phase;

            threadComm[idx].block_offset = i * global_dim[0];

            while (pCommBuffer[COMPLETE] < g_numWorkgroups){/*wait for workgroups to finish*/};

            #ifdef DEBUG_VALIDATION
            #if (DEBUG_VALIDATION == 1)
                /*for(int i = 0; i < global_dim[0]; i++){
                    r_entry_t r = rset_pool_cl_wrapper[0].entries[i];
                    stm_word_t l = *((volatile stm_word_t*)(r.lock));
                    //if(debug_buffer_arg1[i] != l || debug_buffer_arg2[i] != r.version){
                        printf("work item i %4d KERNEL LOCK: %d [is %016" PRIXPTR ",should %016" PRIXPTR "] [is %016" PRIXPTR ", should %016" PRIXPTR "]\n", i, debug_buffer_arg[i], debug_buffer_arg1[i], l, debug_buffer_arg2[i], r.version);
                    //}
                }*/

                //printf("VALIDATION RESULT: %d\n", threadComm[idx].valid);

                for(int j = 0; j < global_dim[0]; j++){
                    //verified work inside
                    printf("work item i %4d debug0: %ld, [%016" PRIXPTR " %016" PRIXPTR "] [%016" PRIXPTR ",  %016" PRIXPTR "] \n", j, debug_buffer_arg[j], debug_buffer_arg1[j], debug_buffer_arg2[j], threadComm[idx].w_set_base, threadComm[idx].w_set_end);
                }

                /* TDD */
                /* PASS - LOCKS APPEAR AS OUTSIDE. */
                /* PASS - LOCKS ARE PASSING OUT OF KERNEL AS LONG AS DEBUG_BUFFER IS STM_WORD_T */

                /* reset kernel debug array on every iteration */
                memset(debug_buffer_arg, 0, sizeof(long) * RW_SET_SIZE);
                memset(debug_buffer_arg1, 0, sizeof(stm_word_t) * RW_SET_SIZE);
                memset(debug_buffer_arg2, 0, sizeof(stm_word_t) * RW_SET_SIZE);
            #endif /*DEBUG_VALIDATION == 1*/
            #endif /*DEBUG_VALIDATION*/

            /*store to cpu hot variable, avoid cache ping-ponging*/
            /*bad  alternative is to make cpu check threadComm[idx].valid all the time*/
            /*gpu writes to threadComm[idx].valid in kernel when invalid*/
            gpu_exit_validity = threadComm[idx].valid;

            /*same information in GPU_POS*/
            //atomic_fetch_add_explicit(&threadComm->reads_count, global_dim[0], memory_order_relaxed);

            /*this triggers cpu to stop, make all counter submit before*/
            atomic_fetch_add_explicit(&GPU_POS, global_dim[0], memory_order_release);

            pCommBuffer[COMPLETE] = 0;
            /* while gpu was vaidating, cpu might have invalidated tx. Break */
            /* otherwise submerge into another round */
            TIMER_READ(T2G); /* always read timer. never know when it is going to be our last :'-( */

            /*BLOCK-level synchronisation
             * if cpu invalidated while we were working
             * or one of work-items just invalidated: exit
             * removes expensive check in every work item */
            if(!threadComm[idx].valid){break;}else{i++;}
        }

        /*gpu finished parsing read set in blocks*/

        //printf("GPU TIME: %f\n", TIMER_DIFF_SECONDS(T1G, T2G));

        //commented out blocking in cpu code -> commented out signaling here.
        //pthread_mutex_lock(&validate_mutex);
            //atomic_store_explicit(&validate_complete, 1, memory_order_release);
            //pthread_cond_signal(&validate_complete_cond);
            /*set in case some thread sets it to 1, and then we overwrite it with a 0 and no work is done*/
            atomic_store_explicit(&delegate_validate, 0, memory_order_release);/*so that i dont start again*/

        //pthread_mutex_unlock(&validate_mutex);

    }

    pCommBuffer[FINISH]=1;

    return "SOMESTRING";
}

int initializeHost(void){
    g_clDevices = NULL;
    g_clProgramString = NULL;

    return SUCCESS;
}


int xfree_svmalloc(void *mem){
    /* printf("xfree_svmalloc...FEEING MEMORY FOR PRIVATE READ SET\n"); */
    if(mem != NULL) {
        clSVMFree(g_clContext, mem);
    }
}

/* First cleanupCL then host. */
int cleanupCL(void){

    //cleanup all CL queues, contexts, programs, mem_objs
    cl_int status;

    /* Fallback in case forget stop InstantKernel */
    //pCommBuffer[FINISH] = 1;

    atomic_store(&pCommBuffer[FINISH], 1);
    atomic_store(&shutdown_gpu, 1);
    //pthread_join(gpu_delegate_thread, NULL);
    //pthread_kill(gpu_delegate_thread, 0);
    pthread_cancel(&gpu_delegate_thread);

    clFlush(g_clCommandQueue);

    status = clFinish(g_clCommandQueue);
    testStatus(status, "Error CommandQueue finish\n");

    /* ====================== GC SVM BUFFERS ======================== */
    //int gc_num_pointers = 4;

#ifdef DEBUG_VALIDATION
#if (DEBUG_VALIDATION)
    //gc_num_pointers += 3;
#endif /*DEBUG_VALIDATION == 1*/
#endif /*DEBUG_VALIDATION*/

    //void **gc_svm_pointers = malloc(sizeof(void*) * gc_num_pointers);

    //gc_svm_pointers [0] = (void*) *locks;

    //gc_svm_pointers [1] = (void*) threadComm;

    //gc_svm_pointers [2] = (void*) pCommBuffer;

    for(int i = 0; i < initial_rs_svm_buffers_ocl_global; i++){
        //gc_svm_pointers[3+i] = (void*) rset_pool[i];
        if(rset_pool[i]!=NULL){
            clSVMFree(g_clContext, rset_pool[i]);
        }
    }

    //gc_svm_pointers [2] = (void*) rset_pool_cl_wrapper;
    //gc_svm_pointers [3] = (void*) rset_pool;

    clSVMFree(g_clContext, *locks);
    clSVMFree(g_clContext, threadComm);
    //clSVMFree(g_clContext, pCommBuffer);
    clSVMFree(g_clContext, rset_pool_cl_wrapper);
    clSVMFree(g_clContext, rset_pool);

#ifdef DEBUG_VALIDATION
#if (DEBUG_VALIDATION)
    clSVMFree(g_clContext, debug_buffer_arg);
    clSVMFree(g_clContext, debug_buffer_arg1);
    clSVMFree(g_clContext, debug_buffer_arg2);
#endif /*DEBUG_VALIDATION == 1*/
#endif /*DEBUG_VALIDATION*/

    //int err = clEnqueueSVMFree(g_clCommandQueue, gc_num_pointers, gc_svm_pointers, NULL, NULL, 0, NULL, NULL);
    //free(gc_svm_pointers);
    /*int err = 0;
    if(err){
        printf("clEnqueueSVMFree ERR CODE: %d\n", err);
    }*/


    /* ===================== end GC SVM BUFFERS ======================= */

    status = clReleaseKernel(cl_kernel_worker);
    testStatus(status, "Error releasing cl_kernel_worker kernel\n");

    status = clReleaseProgram(g_clProgram);
    testStatus(status, "Error releasing program\n");

    //status = clReleaseCommandQueue(g_clCommandQueue);
    //testStatus(status, "Error releasing mem object g_clCommandQueue\n");

    status = clReleaseContext(g_clContext);
    testStatus(status, "Error releasing mem object\n");

    return status;
}

int cleanupHost(){
    //cleanup the mallocd buffers

    return SUCCESS;
}

/* <============================== helpers ==============================> */

char* bin_to_str(const char *fileName, long *length_out){
    FILE *fp = NULL;
    int status;

    fp = fopen(fileName, "r");
    if (fp == NULL)
    {
        printf("Error opening %s, check path\n", fileName);
        exit(EXIT_FAILURE);
    }

    status = fseek(fp, 0, SEEK_END);
    if (status != 0)
    {
        printf("Error finding end of file\n");
        exit(EXIT_FAILURE);
    }

    int len = ftell(fp);
    if (len == -1L)
    {
        printf("Error reporting position of file pointer\n");
        exit(EXIT_FAILURE);
    }
    rewind(fp);
    g_clProgramString = malloc(len);
    if (g_clProgramString == NULL)
    {
        printf("Error in allocation when converting CL source file to a string\n");
        exit(EXIT_FAILURE);
    }
    fread(g_clProgramString, 1, len, fp);
    status = ferror(fp);
    if (status != 0)
    {
        printf("Error reading into the program string from file\n");
        exit(EXIT_FAILURE);
    }
    fclose(fp);

    if ( length_out != NULL ){
        *length_out = len;
    }

    return SUCCESS;
}

int convertToStringBuf(const char *fileName, long *length_out){
    FILE *fp = NULL;
    int status;

    fp = fopen(fileName, "r");
    if (fp == NULL)
    {
        printf("Error opening %s, check path\n", fileName);
        exit(EXIT_FAILURE);
    }

    status = fseek(fp, 0, SEEK_END);
    if (status != 0)
    {
        printf("Error finding end of file\n");
        exit(EXIT_FAILURE);
    }

    int len = ftell(fp);
    if (len == -1L)
    {
        printf("Error reporting position of file pointer\n");
        exit(EXIT_FAILURE);
    }
    rewind(fp);

    g_clProgramString = (char *)malloc((len * sizeof(char)) + 1);

    if (g_clProgramString == NULL)
    {
        printf("Error in allocation when converting CL source file to a string\n");
        exit(EXIT_FAILURE);
    }

    memset(g_clProgramString, '\0', len + 1);
    fread(g_clProgramString, sizeof(char), len, fp);
    status = ferror(fp);
    if (status != 0)
    {
        printf("Error reading into the program string from file\n");
        exit(EXIT_FAILURE);
    }
    fclose(fp);
    //printf("%s", g_clProgramString, len * sizeof(char) + 1);

    if ( length_out != NULL ){
        *length_out = len;
    }

    return SUCCESS;
}

void testStatus(int status, char *errorMsg){

    if (status != SUCCESS)
    {
        if (errorMsg == NULL)
        {
            printf("Error. Status: %d\n", status);
        }
        else
        {
            printf("Error: %s. Status: %d\n", errorMsg, status);
        }
        //exit(EXIT_FAILURE);
    }
}

bool checkSVMAvailability(cl_device_id device){

    cl_device_svm_capabilities caps;

    int ret = -1;

    cl_int err = clGetDeviceInfo(
            device,
            CL_DEVICE_SVM_CAPABILITIES,
            sizeof(cl_device_svm_capabilities),
            &caps,
            0
    );

    //go best to worst support

    ret = CL_SUCCESS && (caps & CL_DEVICE_SVM_FINE_GRAIN_SYSTEM) && (caps & CL_DEVICE_SVM_ATOMICS);
    //printf("Fine-grained system SVM with device atomics: %d\n", err == ret);

    ret = (CL_SUCCESS && (caps & CL_DEVICE_SVM_FINE_GRAIN_SYSTEM));
    //printf("Fine-grained system SVM: %d\n", err == ret);

    ret = (CL_SUCCESS && (caps & (CL_DEVICE_SVM_FINE_GRAIN_BUFFER | CL_DEVICE_SVM_ATOMICS)));
    //printf("Fine-grained buffer with atomics: %d\n", err == ret);

    ret = (CL_SUCCESS && (caps & CL_DEVICE_SVM_FINE_GRAIN_BUFFER));
    //printf("Fine-grained buffer: %d\n", err == ret);

}

int HandleCompileError(void){
    cl_int logStatus;
    char *buildLog = NULL;
    size_t buildLogSize = 0;
    //in this tutorial i only have one device
    logStatus = clGetProgramBuildInfo(g_clProgram, g_clDevices[0], CL_PROGRAM_BUILD_LOG, buildLogSize, buildLog, &buildLogSize);
    if (logStatus != CL_SUCCESS) {
        printf("logging error\n");
        //exit(EXIT_FAILURE);
    }

    buildLog = (char *)malloc(buildLogSize);
    if (buildLog == NULL) {
        printf("ERROR TO ALLOCATE MEM FOR BUILDLOG\n");
        //exit(EXIT_FAILURE);
    }

    memset(buildLog, 0, buildLogSize);

    logStatus = clGetProgramBuildInfo(g_clProgram, g_clDevices[0], CL_PROGRAM_BUILD_LOG, buildLogSize, buildLog, NULL);
    if (logStatus != CL_SUCCESS) {
        free(buildLog);
        return FAIL;
    }

    printf("\nBUILD LOG\n");
    printf("************************************************************************\n");
    printf("%s END \n", buildLog);
    printf("************************************************************************\n");
    free(buildLog);
    return SUCCESS;
}

