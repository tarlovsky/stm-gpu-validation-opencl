#!/bin/bash

# sudo bash parse-benchmark-results.sh cpu|gpu

DIR="cpu-gpu"

#only argument
if [[ ! $DIR =~ ^(cpu-gpu)$  ]];then
    echo "second argument can only be cpu or gpu."
    exit;
fi

RESULTS_DIR="results-$DIR"

benchmarks=("tpcc" "sb7" "synth" "redblacktree" "linkedlist" "hashmap" "skiplist"  "genome" "intruder" "kmeans" "labyrinth" "ssca2" "vacation" "yada")
full_benchmark_names=(\
              "tpcc-s96-d1-o1-p1-r1" "tpcc-s1-d96-o1-p1-r1" "tpcc-s1-d1-o96-p1-r1" "tpcc-s1-d1-o1-p96-r1" "tpcc-s1-d1-o1-p1-r96" "tpcc-s20-d20-o20-p20-r20" "tpcc-s4-d4-o4-p43-r45"\
              #TODO run these later on CPU Intel at least #no need because we can still get tx/s from 5 seconds and compare. tx/s is relative
              #"sb7_20-r-f-f" "sb7_20-rw-f-f" "sb7_20-w-f-f" "sb7_20-r-t-f" "sb7_20-rw-t-f" "sb7_20-w-t-f" "sb7_20-r-f-t" "sb7_20-rw-f-t" "sb7_20-w-f-t" "sb7_20-r-t-t" "sb7_20-rw-t-t" "sb7_20-w-t-t"\
              "sb7-r-f-f" "sb7-rw-f-f" "sb7-w-f-f" "sb7-r-t-f" "sb7-rw-t-f" "sb7-w-t-f" "sb7-r-f-t" "sb7-rw-f-t" "sb7-w-f-t" "sb7-r-t-t" "sb7-rw-t-t" "sb7-w-t-t"\
              "synth-s-r" "synth-s-w" "synth-l-r" "synth-l-w"\
              "redblacktree-l-w" "redblacktree-l-r" "redblacktree-s-w" "redblacktree-s-r"\
              "hashmap-l-r" "hashmap-l-w" "hashmap-s-r" "hashmap-s-w"\
              "linkedlist-l-w" "linkedlist-l-r" "linkedlist-s-w" "linkedlist-s-r"\
              "skiplist-l-w" "skiplist-l-r" "skiplist-s-w" "skiplist-s-r"\
              "genome" "genome+" "genome++"\
              "intruder" "intruder+" "intruder++"\
              "kmeans-high" "kmeans-high+" "kmeans-high++" "kmeans-low" "kmeans-low+" "kmeans-low++"\
              "labyrinth" "labyrinth+" "labyrinth++"\
              "ssca2" "ssca2+" "ssca2++"\
              "vacation-high" "vacation-high+" "vacation-high++" "vacation-low" "vacation-low+" "vacation-low++"\
              "yada" "yada+" "yada++")
#declare -a thread_count=(1 1a 2 4 8 16 32)
declare -a thread_count=(1 2 4 8 16)

#get all stm+mods inside results dir
STMS=()

cd $RESULTS_DIR

#each directory is an STM
for d in ./*;
do
    #if NOT DIRECTOY then continue
    if [[ ! -d $d ]]; then
        continue;
    fi
    #only look for folders. they are always STMS
    STMS+=(${d##./})
done

#create cluster files and header for geometric cluster inside RESULTS dir
for ((i=0;i<${#thread_count[@]};i++));
do
    for ((j=0;j<${#benchmarks[@]};j++));
    do
        f="geometric-${thread_count[$i]}-${benchmarks[$j]}-cluster"
        echo "\"RSET\" \"Validation time (s)\" \"stddev\" \"Validation time (s) CPU\" \"stddev\" \"Validation time (s) GPU\" \"stddev\" \"Commits\" \"stddev\" \"Aborts\" \"stddev\" \"Val Reads\" \"stddev\" \"CPU Val Reads\" \"stddev\" \"GPU Val Reads\" \"stddev\" \"Wasted Val Reads\" \"stddev\" \"GPU employment times\" \"stddev\" \"Val success\" \"stddev\" \"Val fail\" \"stddev\" \"Snapshot ext. calls\" \"stddev\" \"Energy (J)\" \"stddev\" \"Total time (s)\" \"stddev\"" > $f
    done
done

#create cluster files and header for detailed benchmark inside RESULTS dir
for ((i=0;i<${#thread_count[@]};i++));
do
    for ((j=0;j<${#full_benchmark_names[@]};j++));
    do
        f="${thread_count[$i]}-${full_benchmark_names[$j]}-cluster"
        echo "\"RSET\" \"Validation time (s)\" \"stddev\" \"Validation time (s) CPU\" \"stddev\" \"Validation time (s) GPU\" \"stddev\" \"Commits\" \"stddev\" \"Aborts\" \"stddev\" \"Val Reads\" \"stddev\" \"CPU Val Reads\" \"stddev\" \"GPU Val Reads\" \"stddev\" \"Wasted Val Reads\" \"stddev\" \"GPU employment times\" \"stddev\" \"Val success\" \"stddev\" \"Val fail\" \"stddev\" \"Snapshot ext. calls\" \"stddev\" \"Energy (J)\" \"stddev\" \"Total time (s)\" \"stddev\"" > $f
    done
done

#go over every stm+mode, TinySTM-wbetl/
for stm in ${STMS[@]};
do
    #get into that folder and plot every file
    cd $stm;

    #for each N THREADS execution
    for th in ./*; do

        #loop on next thread FOLDER
        if [[ ! -d $th ]]; then
            continue;
        fi

        th=${th##./}

        cd $th

        for b in ${benchmarks[@]}; do
            #for each benchmark

            N_READ=0
            avg_acc=
            bench_modes_entered=0
            bench_modes_averaged=0
            # f is yada yada+ yada++ etc
            for f in $b*; do
                #echo "----- $stm/$th/$f "
                f=${f%/} #remove / at the end of filename

                # only allow geometric average if all modes completed
                ((bench_modes_entered++)) # means file exists. later check if (entered == averaged)

                CLUSTER_FILE_PATH="../../${th}-${f}-cluster"

                #skip file if it has no data
                #only one line count for columns
                if [[ ! -f "$f" ]] || [[ $(wc -l < $f) -eq 1 ]]; then
                    echo "Skipping $stm/$th/$f, it has no data."
                    echo "$stm 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0" >> "$CLUSTER_FILE_PATH"
                    continue;
                fi

                # every file that is like yada, like any benchmark, lets average their RUN times/commits/energy
                # get ARITHMETIC (REGULAR) AVG and STDDEV of every column after 1 title rows, Skip title row
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
                ' <<< cat $f)


                #echo "$stm $th $b $f corelation between RSETSIZE and ABORTS IS $correlation_r_s_f_a"

                if [[ ! $mean_stddev_col == "" ]];
                then
                    ((bench_modes_averaged++))
                    #this is needed in plot_detailed.sh when creating: for example vacation: 2x3 detailed vacation multiplot with low, low+, low++, high, high+, high++

                    echo "$stm ${mean_stddev_col}" >> "$CLUSTER_FILE_PATH"
                    #echo $stm "${mean_stddev_col}"

                    #debug
                    #echo $stm $th $b $f $mean_stddev_col

                    # accomulate thread input with col averages.
                    # each line will be regular average execution time for 2, 4, 8, 16 threads
                    # do geometric average from avg_acc next.
                    avg_acc+=${mean_stddev_col}

                    ((N_READ++))
                fi
            done #for every benchmark parameters

            #store in file ex.: $TinySTM-igpu-wbetl-lsa/2-vacation-geometric-avg
            #now we have file with thread dump for 2,4,8,16 inside
            CLUSTER_FILE_PATH="../../geometric-${th}-${b}-cluster"

            # calculate geometric average with awk | only enter if there is a non empty average for every: intruder, intruder+, intruder++: 3 == 3
            if [[ $avg_acc ]] && [[ $bench_modes_averaged -eq $bench_modes_entered ]]; then
                # this line collapses N_READ rows into a single GEOMETRIC average that represents these executions like yada, yada++, yada+++ (N_READ=3)
                # geometric mean: sum of natural logarithms of every number, divide over n and to the power of Euler's constant.

                geometric_avg=$(awk -F ' ' -v nn=$N_READ '
                    #dont need to check NR > 1. inoput comes from variable
                    END{
                        #s-stride; nn=rows; NF=cols
                        s=NF/nn;

                        #divide by N[i] later to remove blanks/zoroes
                        for(i=1;i<=s;i++){N[i]=nn}

                        for(i=1;i<=s;i++){
                            for (j=1;j<=nn;j++){
                                val=$(i+((s)*(j-1)))
                                if(val > 0){ #exclude 0 in geometric avg
                                    sum[i]+=log(val);
                                }else{
                                    #its zero dont consider it for avg
                                    NN[i]-=1; #one less number to divide over
                                }
                            }
                        }

                        for(i=1;i<=s;i++){
                            if(sum[i]!=0){
                                printf "%f ", exp(sum[i]/N[i]);
                            }else{
                                printf "0 "
                            }
                        }
                    }
                ' <<< $avg_acc)
                if [[ $geometric_avg ]]
                then


                    #debug
                    echo "geometric avg $stm $th $f" #$geometric_avg"
                    echo "$stm ${geometric_avg}" >> "$CLUSTER_FILE_PATH"
                # if got geometric average and data not empty
                fi
            else
                #don't want gaps in plot.
                echo "$stm 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0" >> "$CLUSTER_FILE_PATH"
            fi # if data from benchmarks not empty

        done # for every benchmark
        cd .. # out of thread 2 4 8 16 folder
    done # for every thread count
    cd ..
done #end iterating over benchmark name + mode

#stay in get out of results









