#!/bin/bash

# sudo bash plot-speedup.sh cpu cache

if [[ "$#" -eq 2 ]];then
    DIR=$1
    CACHE=$2
    if [[ ! $CACHE == "cache" ]];then
        echo "second argument must be 'cache'"
        exit;
    fi
elif [[ "$#" -eq 1 ]];then
    DIR=$1
else
    echo "Illegal number of arguments. Correct usage:"
    echo "bash plot-speedup.sh cpu|gpu [cache]"
    echo ""
    exit;
fi

if [[ ! $DIR =~ ^(cpu|gpu)$  ]];then
    echo "First argument can only be cpu or gpu."
    exit;
fi

RESULTS_DIR="results-$DIR"

mkdir -p "gnuplot"
####################################################################################################################################################
declare -a STMS=("swissTM" "TinySTM-wbetl" "norec" "tl2")
MAX_STM_COUNT=4

#benchmarks=("tpcc" "sb7" "synth" "redblacktree" "linkedlist" "hashmap" "skiplist" "genome" "intruder" "kmeans" "labyrinth" "ssca2" "vacation" "yada")
full_benchmark_names=(\
                    "tpcc-s96-d1-o1-p1-r1" "tpcc-s1-d96-o1-p1-r1" "tpcc-s1-d1-o96-p1-r1" "tpcc-s1-d1-o1-p96-r1" "tpcc-s1-d1-o1-p1-r96" "tpcc-s20-d20-o20-p20-r20" "tpcc-s4-d4-o4-p43-r45"\
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

declare -a thread_count=(1 2 4 8 16 32)
#declare -a thread_count=(1a) #has to be manual

declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")
declare -a gray_pallet=("696969" "808080" "A9A9A9" "C0C0C0" "D3D3D3" "DCDCDC" "696969")

if [[ -z $CACHE ]];
then
    cd $RESULTS_DIR
    for stm in ${STMS[@]};
        do
        declare -a fileout
        #echo "$stm:"
        fileout=
        for program in ${full_benchmark_names[@]};do
            linesum=0
            lineavg=0
            fileout+=$program
            #echo "      $program:"
            #append newline after every program start
            N_TH_AVG=0
            for th in ${thread_count[@]};do
                source_file="$th-${program}-cluster"
                f_contents=$(cat $source_file) #all content with all(4) stm lines.

                #construct a line

                #get line with stm first column
                my_line=$(sed -n "/^${stm}/p" $source_file)

                if [[ ! -z "$my_line" ]];then
                    #($4+$6) is zero when norec and tl2 can't run tpcc and sb7
                    # percentage of time of the paralellizeable portion of code
                    p=$(awk '{
                        #16 is total time
                        #2 is validation time
                        denum=$16;
                        if(denum>0){
                            p=$2/denum
                        }else{
                            p=0
                        }
                    } END { if(p==0){print p}else{printf "%f", p} }' <<< "$my_line")

                    if [[ "$p" == "0" ]]; then
                        #execution time $16 is zero, did not run
                        S=0
                    else
                        # parallelizeable code S using Amdahl's Law
                        # 5376 simultaneous work items in hd530 gt2
                        # sqrt of x^2 to do ABS. Norec 16 threads for example spends more comulative time in validation than total time elapsed
                        #remove $th when you plot 1a
                        if [[ "$th" == '1a'  ]];then
                            S=$(bc -l <<< "scale=20; (1/(sqrt((1-$p)*(1-$p))+($p/(168))))";)
                        else
                            S=$(bc -l <<< "scale=20; (1/(sqrt((1-$p)*(1-$p))+($p/(168/$th))))";)
                        fi
                        #use this later to sort
                        linesum=$(bc <<< "scale=20; $linesum+$S";)
                        ((N_TH_AVG++)) #dont want zeroes in speedup average
                    fi
                    fileout+=" $S"
                fi
            done
            fileout+=" $linesum"
            if [[ $N_TH_AVG -eq 0 ]]; then
                lineavg=0
            else
                lineavg=$(bc <<< "scale=20; $linesum/${N_TH_AVG}";)
            fi
            fileout+=" $lineavg"
            fileout+=$'\n'
            #essentially, we just averaged all Amdaahl's law speedups for each thread to show one number on top
        done
        dest_file="speedup-theoretical-${stm}"
        echo -e "$fileout" > $dest_file

        # sort on second to last column
        #echo -e "$(sort -s -nk$((${#thread_count[@]}+2)) $dest_file)" > $dest_file

    done
    cd ..

    #add header with gnuplot key
    for stm in ${STMS[@]}; do
        F="$RESULTS_DIR/speedup-theoretical-${stm}"
        header_str=
        for i in ${thread_count[@]}; do
            header_str="$header_str \"$i\""
        done

        sed -i "1i\\\"STM\"$header_str \"Total\" \"Average\"" $F
    done
fi


FILE="gnuplot/speedup-theoretical.gnuplot"

echo "set terminal wxt size 1440,1200" > $FILE
#echo "set output 'png/... .png'" >> $FILE

echo "set multiplot layout ${#STMS[@]},1 rowsfirst title \" Theoretical speedup (validation time) accross all thread counts\" font \",16\"" >> $FILE
#echo "set title \"Read set sizes for all benchmark programs\" font \",16\"" >> $FILE
echo "set datafile missing '0'" >> $FILE
#echo "set bmargin 10" >> $FILE
echo "set lmargin 10" >> $FILE
#echo "set border 3" >> $FILE
#echo "xlabeloffsety=1.75" >> $FILE

echo "set tics scale 0"  >> $FILE
echo "set xtics nomirror rotate by 45 right scale 0 font \",8\"" >> $FILE
#echo "set xtics offset -1, xlabeloffsety" >> $FILE
echo "set bmargin 8" >> $FILE
#echo "set offset -0.3,-0.3,0,0" >> $FILE
#echo "set datafile missing '0'" | tee -a $FILES
echo "set style fill solid 1.00" >> $FILE
#echo "set style fill pattern border lt -1" >> $FILE
#echo "set grid ytics lc rgb \"#404040\"" >> $FILE
echo "unset border" >> $FILE
echo "set format y \"\"" >> $FILE
echo "set ylabel \"\"" >> $FILE

#echo "set ytics (10,50,100)"  >> $FIL1E
echo "set datafile separator whitespace" >> $FILE
echo "set boxwidth 0.96" >> $FILE
echo "set style data histogram" >> $FILE
#echo "set style histogram rowstacked gap 1" >> $FILE
echo "set style histogram rowstacked" >> $FILE

echo "unset grid" >> $FILE

echo "set key outside right vertical" >> $FILE
echo "set key invert" >> $FILE
echo "set key title \"Threads\"" >> $FILE
echo "set key font \",7\"" >> $FILE

echo "" >> $FILE

COUNT=0
for stm in ${STMS[@]};
do
    ((COUNT++))
    #get trend average for red ine
    avg_speedup=$(awk 'NR>1{if($NF>0){total+=$NF;n++}} END{printf "%f",total/n}' <<< cat $RESULTS_DIR/speedup-theoretical-${stm};)
    avg_speedup_pos=$(awk -v col=$((${#thread_count[@]}+2)) 'NR>1{total+=$col;n++} END{printf "%f",total/n}' <<< cat $RESULTS_DIR/speedup-theoretical-${stm};)

    echo "set title \"${stm}\" font \",12\" tc rgb \"#8f8800\" offset 0,0" >> $FILE
    ########################################### Validation success rate #####################################################
    echo  "plot newhistogram, \\"  >> $FILE
    echo  "      '$RESULTS_DIR/speedup-theoretical-${stm}' u 2:xtic(1) t col lc rgbcolor \"#${gray_pallet[0]}\" lt 1 fs pattern 3, \\"  >> $FILE
    for ((i=3;i<${#thread_count[@]}+2;i++)) do
        echo  "      '' u (\$${i}) t col lc rgbcolor \"#${gray_pallet[(($i-3 % ${#gray_pallet[@]}))]}\" lt 1 fs pattern 3, \\"  >> $FILE
    done
    last_field_idx=$((${#thread_count[@]}+3))
    line_sum_idx=$((${#thread_count[@]}+2))
    echo  "      '' u (\$0-1):(\$$line_sum_idx):(sprintf('%.2fx', \$$last_field_idx )) notitle w labels rotate by 90 left font \",8\", \\"  >> $FILE
    echo  "      $avg_speedup_pos t sprintf('%.2fx', $avg_speedup) lc rgb \"#c9413e\" "  >> $FILE
    echo >> $FILE

done #for each stm

echo  "unset multiplot" >> $FILE
gnuplot -p "gnuplot/speedup-theoretical.gnuplot"
