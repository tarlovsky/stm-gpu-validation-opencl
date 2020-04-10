#!/bin/bash

declare -a thread_count=(2 4 8 16 32)
#declare -a STMS=("swissTM" "norec" "tl2" "TinySTM wbetl")
declare -a STMS=("TinySTM-igpu wbetl")
declare -a benchmarks=("sb7" "tpcc" "vacation" )

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
			      if [[ $b == "sb7" || $b == "tpcc" ]] && [[ ! $stm =~ ^(swissTM|TinySTM wbetl|TinySTM-igpu wbetl)$ ]]; then
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

#bash parse-benchmark-results.sh

#run 1 thread always validate 1a
#cd ../stm-validation-study-always-validate
#bash refine-results.sh
#bash parse-benchmark-results.sh
#cd ..
