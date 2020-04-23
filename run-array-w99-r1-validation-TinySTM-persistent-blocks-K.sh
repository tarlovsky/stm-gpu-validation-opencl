#!/bin/bash

#run withought arguments

STAMP_DS_FOLDERS="array"
RESULTS_DIR="results"
MAKEFILE="Makefile"
retries=0
MAX_RETRY=4

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
#######################################################################################

global_stm="TinySTM-igpu-persistent-blocks"
threads=1

# THREADS
#######################################################################################
# ST
if [[ -z "$global_stm" ]]
then
    echo "Third argument must be an STM (case sensitive): TinySTM, TinySTM-igpu"
fi

mode="wbetl"
#if STM-MODE set add it to results dir and Makefile to lookup when compiling with that specific makefile
if [[ ! -z "$mode" ]]
then
    #add stm mode to end of it's specific makefile name
    MAKEFILE+="-$mode"
    echo "Stm makefile is $MAKEFILE."
fi

#######################################################################################
#change makefile of the selected STM + mode only for OpenCL igpu validation
#check if results dir is cpu or gpu

if [[ "$global_stm" == *"TinySTM-igpu"* ]];
then
    # sets compiler define that is read within stm_init() in TinySTM.
    sed -i "s/INITIAL_RS_SVM_BUFFERS_OCL=.*/INITIAL_RS_SVM_BUFFERS_OCL=$threads/g" "./$global_stm/$MAKEFILE"
    # this can be moved to run-benches to run only once
    rm ./$global_stm/src/validation_tool/instant_kernel.bin #remove it on first run then it gets built again
    rm ./$global_stm/src/validation_tool/regular_kernel.bin #remove it on first run then it gets built again
fi

RESULTS_DIR+='-validation-array'
RESULTS_DIR+="/$global_stm" #every backend has their own results sub-dir

# example: results/ $global_stm:TinySTM - $4:wbetl
#######################################################################################
#if STM-MODE set add it to results dir and Makefile to lookup when compiling with that specific makefile

if [[ ! -z "$mode" ]]
then
    echo $mode
    #add stm mode to end of dirname
    RESULTS_DIR+="-$mode"
fi

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

progout=

#always validate at 1 thread
if [[ $threads -eq 1 ]]; then
  RESULTS_DIR+="/${threads}"
else
  RESULTS_DIR+="/${threads}"
fi

#################### RESULTS FILE #############################
for APP_DIR in "$RESULTS_DIR/array-r99-w1-random-walk" "$RESULTS_DIR/array-r99-w1-sequential-walk";
do
  if [[ ! -d "$APP_DIR" ]]; then
      echo "Results dir \"$APP_DIR\" does not exist, creating."
      mkdir -p "$APP_DIR"
  fi
done

# thread number is dir
# example results/TinySTM-wbetl/2/intruder++
TEMP_FILE="$RESULTS_DIR/temp"

# 200 is where things get really slow. around 70 seconds validating at N=16777216
# 2 seems to be the best performance
# TODO investigate why
#declare -a KARRAY=(1 2 3 4 5 6 7 8 9 10 20 40 50 100 200)
declare -a KARRAY=(200)
declare -a RSET=(4096 8192 32768 65536 131072 262144 524288 1048576 2097152 16777216 134217728)
N_SAMPLES=10
SEQ_ENABLED=1 #do both seq and rand

#debug
DEBUG=0
if [[ DEBUG -eq 1 ]]; then
  declare -a KARRAY=(1)
  declare -a RSET=(8192)
  SEQ_ENABLED=0
  N_SAMPLES=1
fi


for K in ${KARRAY[@]}; do #co-op blind search
  echo "===================== $K ====================="

  for((sequential=1; sequential<=$SEQ_ENABLED;sequential++)); do
      #vary cpu validation percentage

      if [[ $sequential -eq 1 ]]; then
        FILE="$RESULTS_DIR/array-r99-w1-sequential-walk/$threads-strided-mem-K-$K"
      else
        FILE="$RESULTS_DIR/array-r99-w1-random-walk/$threads-strided-mem-K-$K"
      fi

      # this is the number of elements every work-item will do
      # in a loop in the persistent kernel as percentage of WORK-SET/5376
      sed -i "s/CONSTANTK=.*/CONSTANTK=$K/g" "./$global_stm/$MAKEFILE"

      build_stm_and_benchmark

      if [[ DEBUG -eq 0 ]]; then
        echo "\"RSET\" \"Validation time (s)\" \"stddev\" \"Commits\" \"stddev\" \"Aborts\" \"stddev\" \"Val Reads\" \"stddev\" \"Val success\" \"stddev\" \"Val fail\" \"stddev\" \"Energy (J)\" \"stddev\" \"Total time (s)\" \"stddev\"" > $FILE
      fi

      # VARY READ SET
      for i in ${RSET[@]};do

          #if [[ $((K + i)) > 5376 ]]
          #   continue;
          #

          if [[ DEBUG -eq 0 ]]; then
            echo "\"Validation time(S)\" \"Commits\" \"Aborts\" \"Val Reads\" \"Val success\" \"Val fail\" \"Energy (J)\" \"Time(S)\"" > $TEMP_FILE
          fi
          sum=0
          avg=0

          # do a nice average
          for ((k=0;k < N_SAMPLES;k++)) do

              #echo out what wer are doing
              if [[ $sequential -eq 1 ]]; then
                  echo "SAMPLE:$((k+1)), $threads threads, sequential array walk, $global_stm rset:$i N_PER_WI/K=$K"
              else
                  echo "SAMPLE:$((k+1)), $threads threads, random array walk, $global_stm rset:$i N_PER_WI/K=$K"
              fi

              if [[ DEBUG -eq 0 ]]; then
                  progout=$(./array/array -n$threads -r$i -s$sequential) #run the program $( parameters etc )
                  echo "$progout"
                  threads_out=$(head -n "$threads" <<< "$progout")
                  exec_time_power=($(tail -n 2 <<< "$progout"))

                  # ADD validation times from individual threads = total validation time
                  val_time=$(awk '{ total += $1 } END { printf "%f", total }' <<< "$threads_out")
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
              else
                  #in debug just print values
                  ./array/array -n$threads -r$i -s$sequential
              fi

          done

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
                                  sumsq[j]+=((array[i,j]-(sum[j]/NR))**2);
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
done