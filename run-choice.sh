#!/bin/bash

#######################################################################
# usage example                                                       #
#                          bench              stm name | mode         #
# bash run-choice.sh tpcc  thread_count TinySTM-igpu-persistent wbetl #
#######################################################################

STAMP_DS_FOLDERS="array synth redblacktree hashmap skiplist linkedlist genome intruder kmeans labyrinth ssca2 vacation yada"
RESULTS_DIR="results"
MAKEFILE="Makefile"
retries=0
MAX_RETRY=4

containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

make_benches(){
    # $1-tl2 TinySTM norec swissTM. $2 is wbetl, wbctl, wtetl, wbetl-lsa
    #make only stamp

    #clean
    rm lib/*.o || true

    rm common/Defines.common.mk
    rm common/Makefile
    rm lib/tm.h
    rm lib/thread.h
    rm lib/thread.c

    for F in $STAMP_DS_FOLDERS
    do
        cd $F
        rm *.o || true
        rm $F
        cd ..
    done

    #make
    echo "Making Synthetic benchmark, Data Structures, STAMP suite with backend: $1"

    cp backends/$1/Defines.common.mk common/Defines.common.mk
    cp backends/$1/Makefile common/Makefile
    cp backends/$1/tm.h lib/tm.h
    cp backends/$1/thread.h lib/thread.h
    cp backends/$1/thread.c lib/thread.c

    for F in $STAMP_DS_FOLDERS
    do
        cd $F
        # remove redirect 2 to whatever 1 is point to for debug
        make -f Makefile 2>&1 > /dev/null
        rc=$?
        if [[ $rc != 0 ]] ; then
            echo ""
            echo "BASH: =================================== ERROR making $F ==================================="
            echo ""
            exit 1
        fi
        cd ..
    done
}

make_sb7(){
    cd sb7
    # $1 is backend name: tl2 TinySTM norec swissTM.
    make -f Makefile STM_NAME=$1 clean

    rm ../common/Defines.common.mk
    rm ../common/Makefile
    rm src/thread/tm.h
    rm src/thread/thread.h
    rm src/thread/thread_backend.cc

    cp ../backends/$1/Defines.common.mk  ../common/Defines.common.mk
    cp ../backends/$1/Makefile           ../common/Makefile
    cp ../backends/$1/tm.h               src/thread/tm.h
    cp ../backends/$1/thread.h           src/thread/thread.h
    cp ../backends/$1/thread.c           src/thread/thread_backend.cc

    echo "Running stmbench7 make with backend: $1"

    make -f Makefile STM_NAME=$1

    rc=$?
    if [[ $rc != 0 ]] ; then
        echo ""
        echo "=================================== ERROR making sb7  ==================================="
        echo ""
        exit 1
    fi
    cd ..
}

make_tpcc(){
    # $1-tl2 TinySTM norec swissTM. $2 is wbetl, wbctl, wtetl, wbetl-lsa
    #make only stamp

    #clean
    rm lib/*.o || true

    rm common/Defines.common.mk
    rm common/Makefile
    rm lib/tm.h
    rm lib/thread.h
    rm lib/thread.c

    cd tpcc
    rm *.o || true
    cd ..

    echo "Making tpc-c with backend: $1"

    cp backends/$1/Defines.common.mk common/Defines.common.mk
    cp backends/$1/Makefile common/Makefile
    cp backends/$1/tm.h lib/tm.h
    cp backends/$1/thread.h lib/thread.h
    cp backends/$1/thread.c lib/thread.c

    cd tpcc
    # remove redirect 2 to whatever 1 is point to for debug
    make -f Makefile 2>&1 > /dev/null
    rc=$?
    if [[ $rc != 0 ]] ; then
        echo ""
        echo "BASH: =================================== ERROR making tpcc ==================================="
        echo ""
        exit 1
    fi
    cd ..
}

create_gnuplot_data_file(){ # in ./results dir
    # parameter $1 is full bench name: "vacation-low++"

    # check results dir exists
    # create results dir: swissTM, TinySTM-wbetl, tl2, ...
    if [[ ! -d "$RESULTS_DIR/$threads" ]]
    then
        echo "$RESULTS_DIR does not exist, creating."
        mkdir -p "$RESULTS_DIR/$threads"
    fi

    # thread number is dir
    # example results/TinySTM-wbetl/2/intruder++
    FILE="$RESULTS_DIR/$threads/$1"

    if [[ ! -f "$FILE" ]]; then
        echo "$FILE does not exist..creating"
        #touch $FILE
        echo "\"Validation time(S)\" \"Commits\" \"Aborts\" \"Val Reads\" \"Val success\" \"Val fail\" \"Energy (J)\" \"Time(S)\"" > $FILE
    fi
}

#ran for every program parameter set
run_sub(){
    # $1 is the bench name, needed for a single if statement check
    # $2 is the full program name with parameters
    # $3 is the name of the db_file

    echo "$global_stm $2" #echo program name/command

    progout=$($2) #run the program $( parameters etc )
    #DEBUG, see what programs are outputting, first come thread output, then comes total program exec time and power

    ######################### debu/print manual #########################
    # column headerstitles
    #echo 'valtime #commits #aborts val valsucc valfail'

    #$2 #run prog

    #get stm_init time (first line being printed)
    #echo $(head -n +1 <<< "$progout") >> ${RESULTS_DIR}/scratch
    echo "$progout"

    #dont polute db while debugging
    #return
    #exit;

    ################################################################################
    #first line in sb7 sets up with 1 tx and just commits all zeroes
    if [[ $1 == "sb7" ]]; then
        #echo "stmbench7 being ran. remove first line"
        #echo "$progout"
        progout=$(tail -n +2 <<< "$progout")
    fi

    ######################### sum column data from threads #########################

    #get top results
    threads_out=$(head -n "$threads" <<< "$progout")

    #EXTRACT ONLY VALIDATION TIME DEBUG
    #Echo $(echo $threads_out | awk '{print $1}') >> "$RESULTS_DIR/$threads/val_time_tmp"


    exec_time_power=($(tail -n 2 <<< "$progout"))
    # ADD validation times from individual threads = total validation time
    total_val_time=$(awk '{ total += $1 } END { printf "%f", total }' <<< "$threads_out")
    # ADD commits from individual threads
    commits=$(awk '{ total += $2 } END { print total }' <<< "$threads_out")
    # ADD aborts  from individual threads
    aborts=$(awk '{ total += $3 } END { print total }' <<< "$threads_out")

    val_reads=$(awk '{ total += $4 } END { print total }' <<< "$threads_out")
    validation_succ=$(awk '{ total += $5 } END { print total }' <<< "$threads_out")
    validation_fail=$(awk '{ total += $6 } END { print total }' <<< "$threads_out")

    ################################################################################

    # retry logic, retry 4 times
    # there can be 0 aborts, there can be 0 validation time, total time and power cannot be zero
    if [[ "$commits" == "0" || -z "${exec_time_power[0]}" || -z "${exec_time_power[1]}" ]]; then
        #restartm might be some temp error
        if [[ $retries -lt $MAX_RETRY ]]; then
            ((retries++))
            echo "restarting:$retries"
            run_sub $1 "$2" $3
        fi
    else
        #all good echo val in
        #echo "results going into: $RESULTS_DIR/$threads/${bench_name[$COUNT]}"
        echo "${total_val_time} ${commits} ${aborts} ${val_reads} ${validation_succ} ${validation_fail} ${exec_time_power[0]} ${exec_time_power[1]}" >> "$RESULTS_DIR/$threads/$3"
    fi
}

declare -a benchmarks=("array" "tpcc" "sb7" "synth" "redblacktree" "linkedlist" "hashmap" "skiplist" "genome" "intruder" "kmeans" "labyrinth" "ssca2" "vacation" "yada")

declare -a array_names=("array-r99-w1")
declare -a tpcc_names=("tpcc-s96-d1-o1-p1-r1" "tpcc-s1-d96-o1-p1-r1" "tpcc-s1-d1-o96-p1-r1" "tpcc-s1-d1-o1-p96-r1" "tpcc-s1-d1-o1-p1-r96" "tpcc-s20-d20-o20-p20-r20" "tpcc-s4-d4-o4-p43-r45")
declare -a sb7_names=("sb7-r-f-f" "sb7-rw-f-f" "sb7-w-f-f" "sb7-r-t-f" "sb7-rw-t-f" "sb7-w-t-f" "sb7-r-f-t" "sb7-rw-f-t" "sb7-w-f-t" "sb7-r-t-t" "sb7-rw-t-t" "sb7-w-t-t")
declare -a synth_names=("synth-s-r" "synth-s-w" "synth-l-r" "synth-l-w")
declare -a redblacktree_names=("redblacktree-l-w" "redblacktree-l-r" "redblacktree-s-w" "redblacktree-s-r")
declare -a hashmap_names=("hashmap-l-r" "hashmap-l-w" "hashmap-s-r" "hashmap-s-w")
declare -a linkedlist_names=("linkedlist-l-w" "linkedlist-l-r" "linkedlist-s-w" "linkedlist-s-r")
declare -a skiplist_names=("skiplist-l-w" "skiplist-l-r" "skiplist-s-w" "skiplist-s-r")
declare -a genome_names=("genome" "genome+" "genome++")
declare -a intruder_names=("intruder" "intruder+" "intruder++")
declare -a kmeans_names=("kmeans-high" "kmeans-high+" "kmeans-high++" "kmeans-low" "kmeans-low+" "kmeans-low++")
declare -a labyrinth_names=("labyrinth" "labyrinth+" "labyrinth++")
declare -a ssca2_names=("ssca2" "ssca2+" "ssca2++")
declare -a vacation_names=("vacation-high" "vacation-high+" "vacation-high++" "vacation-low" "vacation-low+" "vacation-low++")
declare -a yada_names=("yada" "yada+" "yada++")


################################### needed for rapl ###################################
if lsmod | grep msr &> /dev/null ; then
  echo "msr is loaded"
else
  echo "loading msr module"
  modprobe msr
fi
#######################################################################################

bench_choice=$1
global_stm=$3

#bench choice
if [[ -z "$bench_choice" ]]
then
    echo "First argument must be: genome, intruder, kmeans, labyrinthm, ssca2, vacation, yada"
    exit;
fi
#######################################################################################
# THREADS
if [[ -z "$2" ]]
then
    threads=8
    echo "Setting threads to 8"
else
    threads=$2
    echo "Setting threads to $2"
fi
#######################################################################################
# STM
if [[ -z "$global_stm" ]]
then
    echo "Third argument must be an STM (case sensitive): TinySTM, TinySTM-igpu"
fi

#if STM-MODE set add it to results dir and Makefile to lookup when compiling with that specific makefile
if [[ ! -z "$4" ]]
then
    #add stm mode to end of it's specific makefile name
    MAKEFILE+="-$4"
    echo "Stm makefile is $MAKEFILE."
fi

#######################################################################################
#change makefile of the selected STM + mode only for OpenCL igpu validation
#check if results dir is cpu or gpu
if [[ "$global_stm" == *"TinySTM-igpu"* ]] || [[ "$global_stm" == "TinySTM-threads" ]];
then
    # sets compiler define that is read within stm_init() in TinySTM.
    sed -i "s/INITIAL_RS_SVM_BUFFERS_OCL=.*/INITIAL_RS_SVM_BUFFERS_OCL=$threads/g" "./$global_stm/$MAKEFILE"

    # this can be moved to run-benches to run only once
    rm ./$global_stm/src/validation_tool/instant_kernel.bin #remove it on first run then it gets built again
    rm ./$global_stm/src/validation_tool/regular_kernel.bin #remove it on first run then it gets built again

    RESULTS_DIR+='-gpu'
else
    RESULTS_DIR+='-cpu'
fi

RESULTS_DIR+="/$global_stm" #every backend has their own results sub-dir

# example: results/ $global_stm:TinySTM - $4:wbetl
#######################################################################################
#if STM-MODE set add it to results dir and Makefile to lookup when compiling with that specific makefile
if [[ ! -z "$4" ]]
then
    #add stm mode to end of dirname
    RESULTS_DIR+="-$4"
fi

# example, here: results-cpu/TinySTM-igpu-wbetl

#######################################################################################

#######################################################################################
#                      all STAMP inputs taken from STAMP paper                        #
#                    tpcc, sb7, datastructures, synth taken from                      #
#                            GSD DMT, Shady and Diegues                               #
#                     tpcc made to run in 60secs, down from 150                       #
#######################################################################################
declare -a array=( "./array/array -r$5 -n"$threads )

declare -a tpcc=(\
        #s stock level operations
        "./tpcc/tpcc -t 60 -s 96 -d 1 -o 1 -p 1 -r 1 -n $threads"\
        #d delivery operations
        "./tpcc/tpcc -t 60 -s 1 -d 96 -o 1 -p 1 -r 1 -n $threads"\
        #o order status operations
        "./tpcc/tpcc -t 60 -s 1 -d 1 -o 96 -p 1 -r 1 -n $threads"\
        # payment operations
        "./tpcc/tpcc -t 60 -s 1 -d 1 -o 1 -p 96 -r 1 -n $threads"\
        # new order operations - 99% TIME SPEND IN VALIDATION
        "./tpcc/tpcc -t 60 -s 1 -d 1 -o 1 -p 1 -r 96 -n $threads"\
        # everything equal
        "./tpcc/tpcc -t 60 -s 20 -d 20 -o 20 -p 20 -r 20 -n $threads"\
        # payment and new order ops
        "./tpcc/tpcc -t 60 -s 4 -d 4 -o 4 -p 43 -r 45 -n $threads")
declare -a sb7=(\
        "./sb7/sb7_tt -r false -s b -d 5000 -w r -t false -m false -n $threads"\
        "./sb7/sb7_tt -r false -s b -d 5000 -w rw -t false -m false -n $threads"\
        "./sb7/sb7_tt -r false -s b -d 5000 -w w -t false -m false -n $threads"\
        "./sb7/sb7_tt -r false -s b -d 5000 -w r -t true -m false -n $threads"\
        "./sb7/sb7_tt -r false -s b -d 5000 -w rw -t true -m false -n $threads"\
        "./sb7/sb7_tt -r false -s b -d 5000 -w w -t true -m false -n $threads"\
        "./sb7/sb7_tt -r false -s b -d 5000 -w r -t false -m true -n $threads"\
        "./sb7/sb7_tt -r false -s b -d 5000 -w rw -t false -m true -n $threads"\
        "./sb7/sb7_tt -r false -s b -d 5000 -w w -t false -m true -n $threads"\
        "./sb7/sb7_tt -r false -s b -d 5000 -w r -t true -m true -n $threads"
        "./sb7/sb7_tt -r false -s b -d 5000 -w rw -t true -m true -n $threads"\
        "./sb7/sb7_tt -r false -s b -d 5000 -w w -t true -m true -n $threads")

declare -a synth=(\
        "./synth/synth -s16384 -i 1000 -u10 -c10  -o10000   -t$threads"\
        "./synth/synth -s16384 -i 1000 -u90 -c90  -o10000   -t$threads"\
        "./synth/synth -s16384 -i 1000 -u10 -c10  -o1000000 -t$threads"\
        "./synth/synth -s16384 -i 1000 -u90 -c90  -o1000000 -t$threads")

declare -a redblacktree=(\
        "./redblacktree/redblacktree -d 15000000 -i 1048576 -r 1000000 -u 90 -n$threads"\
        "./redblacktree/redblacktree -d 25000000 -i 1048576 -r 1000000 -u 10 -n$threads"\
        "./redblacktree/redblacktree -d 15000000 -i 1024    -r 1000000 -u 90 -n$threads"\
        "./redblacktree/redblacktree -d 25000000 -i 1024    -r 1000000 -u 10 -n$threads")
declare -a hashmap=(\
        "./hashmap/hashmap -d 50000000 -b 1048576 -i 1048576 -r 1000000 -u 10 -n$threads"\
        "./hashmap/hashmap -d 35000000 -b 1048576 -i 1048576 -r 1000000 -u 90 -n$threads"\
        "./hashmap/hashmap -d 150000000 -b 64 -i 64 -r 1000000 -u 10 -n$threads"\
        "./hashmap/hashmap -d 100000000 -b 64 -i 64 -r 1000000 -u 90 -n$threads")
declare -a skiplist=(\
        "./skiplist/skiplist -d 750000 -i 104857 -r 1000000 -u 90 -n$threads"\
        "./skiplist/skiplist -d 1000000 -i 104857 -r 1000000 -u 10 -n$threads"\
        "./skiplist/skiplist -d 50000000 -i 512 -r 1000000 -u 90 -n$threads"\
        "./skiplist/skiplist -d 80000000 -i 512 -r 1000000 -u 10 -n$threads")
declare -a linkedlist=(\
        "./linkedlist/linkedlist -d 200000 -i 10485 -r 1000000 -u 90 -n$threads"\
        "./linkedlist/linkedlist -d 400000 -i 10485 -r 1000000 -u 10 -n$threads"\
        "./linkedlist/linkedlist -d 50000000 -i 64 -r 1000000 -u 90 -n$threads"\
        "./linkedlist/linkedlist -d 100000000 -i 64 -r 1000000 -u 10 -n$threads")

declare -a genome=(\
    #genome
    "./genome/genome -g256 -s16 -n16384 -t$threads"\
    #genome+
    "./genome/genome -g512 -s32 -n32768 -t$threads"\
    #genome++
    "./genome/genome -g16384 -s64 -n16777216 -t$threads")
declare -a intruder=(\
    #intruder
    "./intruder/intruder -a10 -l4 -n2048 -s1 -t$threads"\
     #intruder+
    "./intruder/intruder -a10 -l16 -n4096 -s1 -t$threads"\
    #intruder++
    "./intruder/intruder -a10 -l128 -n262144 -s1 -t$threads")
declare -a kmeans=(\
    #kmeans-high
    "./kmeans/kmeans -m15 -n15 -t0.05 -i ./kmeans/inputs/random-n2048-d16-c16        -p$threads"\
    #kmeans-high+
    "./kmeans/kmeans -m15 -n15 -t0.05 -i ./kmeans/inputs/random-n16384-d24-c16       -p$threads"\
    #kmeans-high++
    "./kmeans/kmeans -m15 -n15 -t0.00001 -i ./kmeans/inputs/random-n65536-d32-c16    -p$threads"\
    #kmeans-low
    "./kmeans/kmeans -m40 -n40 -t0.05 -i ./kmeans/inputs/random-n2048-d16-c16        -p$threads"\
    #kmeans-low+
    "./kmeans/kmeans -m40 -n40 -t0.05 -i kmeans/inputs/random-n16384-d24-c16         -p$threads"\
     #kmeans-low++
    "./kmeans/kmeans -m40 -n40 -t0.00001 -i ./kmeans/inputs/random-n65536-d32-c16    -p$threads")
declare -a labyrinth=(\
    #labyrinth
    "./labyrinth/labyrinth -i ./labyrinth/inputs/random-x32-y32-z3-n96      -t$threads"\
    #labyrinth+
    "./labyrinth/labyrinth -i ./labyrinth/inputs/random-x48-y48-z3-n64      -t$threads"\
    #labyrinth++
    "./labyrinth/labyrinth -i ./labyrinth/inputs/random-x512-y512-z7-n512   -t$threads")
declare -a ssca2=(\
     #ssca2
    "./ssca2/ssca2 -s13 -i1.0 -u1.0 -l3 -p3            -t$threads"\
     #ssca2+
    "./ssca2/ssca2 -s14 -i1.0 -u1.0 -l9 -p9            -t$threads"\
    #ssca2++
    "./ssca2/ssca2 -s20 -i1.0 -u1.0s -l3 -p3            -t$threads")
declare -a vacation=(\
   #vacation-high
   "./vacation/vacation -n4 -q60 -u90 -r16384   -t4096    -c$threads"\
   #vacation-high+
   "./vacation/vacation -n4 -q60 -u90 -r1048576 -t4096    -c$threads"\
   #vacation-high++
   "./vacation/vacation -n4 -q60 -u90 -r1048576 -t4194304 -c$threads"\
   #vacation-low
   "./vacation/vacation -n2 -q90 -u98 -r16384   -t4096    -c$threads"\
   #vacation-low+
   "./vacation/vacation -n2 -q90 -u98 -r1048576 -t4096    -c$threads"\
   #vacation-low
   "./vacation/vacation -n2 -q90 -u98 -r1048576 -t4194304 -c$threads")
declare -a yada=(\
    #yada
    "./yada/yada -a20 -i ./yada/inputs/633.2               -t$threads"\
    #yada+
    "./yada/yada -a10 -i ./yada/inputs/ttimeu10000.2       -t$threads"\
     #yada++
    "./yada/yada -a15 -i ./yada/inputs/ttimeu1000000.2     -t$threads")

#######################################################################################
for i in ${benchmarks[@]}; do
    tmp="${i}_names" #name of the array holding different benchmark setups
    arr_ref="$tmp[@]" #need to have ref for variable indirection
    for j in "${!arr_ref}"; do
        create_gnuplot_data_file $j
    done
done

#######################################################################################
# rebuild STM all the time because we change number of threads and I need that to SED the makefile with initial_rs_svm_buffer_size
# now build stm $global_stm TinySTM, tl2, etc
echo $global_stm
cd $global_stm;
echo "Scanning for $MAKEFILE makefile in $(pwd)"
echo "Making STM.."
if [[ -f $MAKEFILE ]]
then
    if [[ $global_stm =~ "tl2" || $global_stm =~ "norec" || $global_stm =~ "swissTM"  ]]; then
        make -f $MAKEFILE clean 2>&1 > /dev/null;
        make -f $MAKEFILE       2>&1 > /dev/null;
    elif [[ $global_stm =~ "TinySTM" ]]; then
        make -f $MAKEFILE clean 2>&1 > /dev/null;
        make -f $MAKEFILE all 2>&1 > /dev/null;
    fi

    rc=$?
    if [[ $rc != 0 ]] ; then
        echo ""
        echo "BASH: =================================== ERROR making $global_stm using $MAKEFILE ==================================="
        echo ""
        exit 1
    fi
else
    echo "BASH: Makefile $MAKEFILE does not exist. Go look into STM folder and use that fname"
    exit;
fi
echo "done."
cd ../
#######################################################################################

if [[ $bench_choice == "sb7" ]]; then
    make_sb7 $global_stm
elif [[ $bench_choice == "tpcc" ]]; then
    #build, compile, and copy tm.h thread.h thread.c from backends to lib to use in Stamp
    #tpcc and stamp
    make_tpcc $global_stm
else
    make_benches $global_stm
fi

progout=0 #initialize to something

#  We excluded the Bayes application given its non-deterministic
#  executions, and used standard parameters for each appli-
#  cation. [nmdiegues]

if containsElement $1 ${benchmarks[@]}; then
    for i in {0..10}; do #TODO do 20 at least.

        echo "Running benchmark $bench_choice with $2 threads, stm: $global_stm $4:"

        bench_params_ref="${bench_choice}[@]" #1 is full program with parameters, ex.: ./tpcc/tpcc -t 1 -s 4 -d 4 -o 4 -p 43 -r 45 -n 8
        bench_names_ref="${bench_choice}_names[@]" #ex tpcc-s96-d1-o1-p1-r1 ..
        bench_prog_db_fname=(${!bench_names_ref}) #names of the places to put


        #to index benchmark name in bench_prog_db_fname: yada, yada+ yada++ .. etc
        COUNT=0

        for i in "${!bench_params_ref}"; do #iter all that is program name with parameters
            #1 is program name like tpcc sb7 redblacktree
            #i is full program name with parameters
            retries=0
            run_sub $bench_choice "$i" ${bench_prog_db_fname[$COUNT]}   #look up by index in bench parameter filename
            ((COUNT++))
        done

    done
fi
