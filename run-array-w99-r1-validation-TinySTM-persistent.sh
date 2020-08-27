#!/bin/bash
#run withought arguments

################################### needed for rapl ###################################
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

PROGRAM=

#######################################################################################
build_stm_and_benchmark(){
    # rebuild STM all the time because we change number of threads and I need that to SED the makefile with initial_rs_svm_buffer_size
    # now build stm $global_stm TinySTM, tl2, etc
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
    cd ..

    rm lib/*.o || true
    rm common/Defines.common.mk
    rm common/Makefile
    rm lib/tm.h
    rm lib/thread.h
    rm lib/thread.c
    cd array
      rm *.o || true
      rm array
    cd ..
    echo "Making array: $global_stm"
    cp backends/$global_stm/Defines.common.mk common/Defines.common.mk
    cp backends/$global_stm/Makefile common/Makefile
    cp backends/$global_stm/tm.h lib/tm.h
    cp backends/$global_stm/thread.h lib/thread.h
    cp backends/$global_stm/thread.c lib/thread.c

    cd array
    # remove redirect 2 to whatever 1 is point to for debug
      make -f Makefile
    cd ..
}
#######################################################################################

RESULTS_DIR="results"
MAKEFILE="Makefile"
retries=0
MAX_RETRY=4

mem_access="strided" # no strided for amd yet. prob wont make it.
#mem_access="coalesced"


#AMD
#global_stm="TinySTM-igpu-persistent-$mem_access-amd" #amd
#instant_kernel_config="-g11264-l256-w44"  #done BEST
#instant_kernel_config="-g11264-l64-w176"   #done
#instant_kernel_config="-g2816-l16-w176"   #done
#instant_kernel_config="-g2816-l256-w11"   #no forward progress
#instant_kernel_config="-g28160-l256-w440" #no forward progress

#INTEL
#global_stm="TinySTM-igpu-persistent-$mem_access" #intel


global_stm="TinySTM-igpu-persistent-$mem_access-amd" #amd
#global_stm="TinySTM-igpu-persistent-$mem_access" #intel
threads=1

mode="wbetl"

#######################################################################################

MAKEFILE+="-$mode"
echo
echo "Stm makefile is $MAKEFILE."
echo

#change makefile of the selected STM + mode only for OpenCL igpu validation
#check if results dir is cpu or gpu

if [[ "$global_stm" == *"TinySTM-igpu"* ]];
then
    # sets compiler define that is read within stm_init() in TinySTM.
    sed -i "s/INITIAL_RS_SVM_BUFFERS_OCL=.*/INITIAL_RS_SVM_BUFFERS_OCL=$threads/g" "./$global_stm/$MAKEFILE"
    # this can be moved to run-benches to run only once
    #comment this on ryzen machine in inesc
    #rm ./$global_stm/src/validation_tool/instant_kernel.bin #remove it on first run then it gets built again
    #rm ./$global_stm/src/validation_tool/regular_kernel.bin #remove it on first run then it gets built again
fi

RESULTS_DIR+='-validation-array'
#add some spice to AMD instant kernel
#need to test differnet configs
RESULTS_DIR+="/${global_stm}" #every backend has their own results sub-dir

# example: results/ $global_stm:TinySTM - $4:wbetl
#######################################################################################
#if STM-MODE set add it to results dir and Makefile to lookup when compiling with that specific makefile

if [[ ! -z "$mode" ]]
then
    echo $mode
    #add stm mode to end of dirname
    RESULTS_DIR+="-$mode"
fi

progout=

#always validate at 1 thread
RESULTS_DIR+="/${threads}"

#################### RESULTS FILE #############################
for APP_DIR in "$RESULTS_DIR/array-r99-w1-random-walk" "$RESULTS_DIR/array-r99-w1-sequential-walk";
do
  if [[ ! -d "$APP_DIR" ]]; then
      echo "Results dir \"$APP_DIR\" does not exist, creating."
      mkdir -p "$APP_DIR"
  fi
done

TEMP_FILE="$RESULTS_DIR/temp"

SEQ_ENABLED=1
SEQ_ONLY=0
N_SAMPLES=20
i_start=512
i_end=134217728

#debug flag
##################################################################
DEBUG=1

if [[ DEBUG -eq 1 ]]; then
  SEQ_ENABLED=0
  N_SAMPLES=1 #stay on one as much as possible
  i_start=512
  i_end=512
fi
##################################################################


#make only once because these versions of the program don't depend on any devines in makefil, etc
build_stm_and_benchmark

  for((sequential=$SEQ_ONLY; sequential<=$SEQ_ENABLED;sequential++)); do
    #vary cpu validation percentage

    if [[ $sequential -eq 1 ]];then
      FILE="$RESULTS_DIR/array-r99-w1-sequential-walk/$threads-$mem_access-mem"
    else
      FILE="$RESULTS_DIR/array-r99-w1-random-walk/$threads-$mem_access-mem"
    fi

    if [[ DEBUG -eq 0 ]]; then
      echo "\"RSET\" \"Validation time (s)\" \"stddev\" \"Commits\" \"stddev\" \"Aborts\" \"stddev\" \"Val Reads\" \"stddev\" \"Val success\" \"stddev\" \"Val fail\" \"stddev\" \"Energy (J)\" \"stddev\" \"Total time (s)\" \"stddev\"" > $FILE
    fi

    for((i=i_start;i<=i_end;i*=2));do
        if [[ DEBUG -eq 0 ]]; then
          echo "\"Validation time(S)\" \"Commits\" \"Aborts\" \"Val Reads\" \"Val success\" \"Val fail\" \"Energy (J)\" \"Time(S)\"" > $TEMP_FILE
        fi
        sum=0
        avg=0

        for ((k=1;k <= N_SAMPLES;k++)) do

            if [[ $sequential -eq 1 ]];then
                echo "RUN:$((k+1)), $threads threads, sequential array walk, $global_stm rset:$i" # VALTHREADS|CPU_PROPORTION:$j"
            else
                echo "RUN:$((k+1)), $threads threads, random array walk, $global_stm rset:$i" # VALTHREADS|CPU_PROPORTION:$j"
            fi

            if [[ DEBUG -eq 0 ]]; then
                #debug=off
                progout=$(./array/array -n$threads -r$i -s$sequential) #run the program $( parameters etc )
                echo "$progout"

                threads_out=$(head -n "$threads" <<< "$progout")
                exec_time_power=($(tail -n 2 <<< "$progout"))

                # if CO-OP then include gpu and cpu specific variables
                # this early version did not have any way of working with multiple stm threads
                if [[ $global_stm == "TinySTM-igpu-cpu-persistent" ]]; then

                    # ADD validation times from individual threads = total validation time
                    val_time=$(awk '{ total += $1 } END { printf "%f", total }' <<< "$threads_out")
                    cpu_val_time=$(awk '{ total += $2 } END { printf "%f", total }' <<< "$threads_out")  #no good for anything except co-op
                    gpu_val_time=$(awk '{ total += $3 } END { printf "%f", total }' <<< "$threads_out")  #no good for anything except co-op
                    commits=$(awk '{ total += $4 } END { print total }' <<< "$threads_out")
                    aborts=$(awk '{ total += $5 } END { print total }' <<< "$threads_out")
                    val_reads=$(awk '{ total += $6 } END { print total }' <<< "$threads_out")
                    validation_succ=$(awk '{ total += $7 } END { print total }' <<< "$threads_out")
                    validation_fail=$(awk '{ total += $8 } END { print total }' <<< "$threads_out")

                    if [[ "$commits" == "0" || -z "${exec_time_power[0]}" || -z "${exec_time_power[1]}" ]]; then
                    #restart
                      echo "PROGRAM DID NOT RETURN CORRECT VALUES"
                    else
                      echo "${val_time} ${cpu_val_time} ${gpu_val_time} ${commits} ${aborts} ${val_reads} ${validation_succ} ${validation_fail} ${exec_time_power[0]} ${exec_time_power[1]}" >> $TEMP_FILE
                    fi
                else
                    # ADD validation times from individual threads = total validation time
                    val_time=$(awk '{ total += $1 } END { printf "%f", total }' <<< "$threads_out")
                    # removed cpu
                    # removed gpu
                    commits=$(awk '{ total += $2 } END { print total }' <<< "$threads_out")
                    aborts=$(awk '{ total += $3 } END { print total }' <<< "$threads_out")
                    val_reads=$(awk '{ total += $4 } END { print total }' <<< "$threads_out")
                    validation_succ=$(awk '{ total += $5 } END { print total }' <<< "$threads_out")
                    validation_fail=$(awk '{ total += $6 } END { print total }' <<< "$threads_out")

                    if [[ "$commits" == "0" || -z "${exec_time_power[0]}" || -z "${exec_time_power[1]}" ]]; then
                    #restart
                      echo "PROGRAM DID NOT RETURN CORRECT VALUES"
                    else
                      echo "${val_time} ${commits} ${aborts} ${val_reads} ${validation_succ} ${validation_fail} ${exec_time_power[0]} ${exec_time_power[1]}" >> $TEMP_FILE
                    fi
                fi
            else
              #debug=1
              gdb --args ./array/array -n$threads -r$i -s$sequential
            fi 
        done
        #throw mean and stdev into file
        if [[ DEBUG -eq 0 ]]; then
            #throw mean and stdev into file
            mean_stddev_col=$(awk '
                NR > 1 {
                    n=NR-1
                    for(i=1;i<=NF;i++){
                        sum[i]+=$i;
                        array[n,i]=$i
                    }
                }
                END {
                    if(NR>1){
                        NR=NR-1
                        for(i=1;i<=NF;i++){
                            avg[i]=sum[i]/NR;
                        }

                        for(i=1;i<=NR;i++){
                            for(j=1;j<=NF;j++){
                                sumsq[j]+=((array[i,j]-(sum[j]/NR))^2);
                            }
                        }

                        for(i=1;i<=NF;i++){
                            p_avg=avg[i]
                            p_sqrt=sqrt(sumsq[i]/NR)

                            f_avg="%f "
                            f_sqrt="%f "

                            if(p_avg==0){
                                f_avg="%d "
                            }
                            if(p_sqrt==0){
                                f_sqrt="%d "
                            }
                            #printf "%f %f ", p_avg, p_sqrt;
                            printf f_avg f_sqrt, p_avg, p_sqrt;
                        }
                    }
              }
            ' <<< cat "$TEMP_FILE")
            echo "$i $mean_stddev_col" >> $FILE
          fi
    done
done
