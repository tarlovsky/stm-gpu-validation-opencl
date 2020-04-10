#!/bin/bash

# $1 is stamp benchmark name

#sudo bash run-benches.sh yada | ssca2 | vacation | kmeans | labirynth | intruder

#original
declare -a benchmarks=("synth" "redblacktree" "linkedlist" "hashmap" "skiplist"  "genome" "intruder" "kmeans" "labyrinth" "ssca2" "vacation" "yada" "tpcc" "sb7")

#removed other options in tinystm because they are super insconsistent with workloads. somewhere they work other places they don't.
#declare -a STMS=("swissTM" "norec" "tl2" "TinySTM wbetl" "TinySTM wbetl-lsa" "TinySTM wbctl" "TinySTM wtetl")

declare -a STMS=("swissTM" "norec" "tl2" "TinySTM wbetl")

declare -a thread_count=(1 2 4 8 16 32)

#remake rapl
cd rapl-power && make clean 2>&1 > /dev/null;
make 2>&1 > /dev/null;
cd ..;

#needed for rapl
if lsmod | grep msr &> /dev/null ; then
  echo "msr is loaded"
else
  echo "loading msr module"
  modprobe msr
fi

for b in "${benchmarks[@]}"; do
    #make everytime because later for opencl program we need to remake it with makefile number threads set.
    for stm in "${STMS[@]}"; do
        for t in ${thread_count[@]}; do
            echo "------------------------ $b $t $stm ------------------------"
            # need to rebuild tiny everytime because i change thread count in makefile 'initial_RS_set_size'

            # only tiny and swiss are capable of running sb7. i have tried with original tiny versions from 2015 and 2018.
            # original sb7 from the paper as well as aleksandar dragojevich' versions from epfl.
			      if [[ $b == "sb7" || $b == "tpcc" ]] && [[ ! $stm =~ ^(swissTM|TinySTM wbetl)$ ]]; then
                continue;
            fi

            bash run-choice.sh $b $t $stm

            
            #stmbench7 will only run on swisstm, norec and tinystm. tl2 has left the game
            #cd stmbench7
            #bash build-stmbench7.sh $t $stm
            #bash run.sh $stm
            #cd ..
            #exit;

        done
        #TODO: Changed stm. Can rebuild everything here as oposed to innermost loop inside run-choice.sh
    done
done


# take all the results run for every thread and every stm crossover and create cluster files in results/ folder
# as well as make geometric averages from every thread count
bash parse-benchmark-results.sh


#bash plot-detailed.sh $1
#bash plot-geometric.sh $1



