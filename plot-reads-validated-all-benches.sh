#!/bin/bash

# sudo bash plot-rset-size.sh cpu cache

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
    echo "bash plot-detaild.sh cpu|gpu [cache]"
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
#declare -a thread_count=(1a)

declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")
declare -a gray_pallet=("696969" "808080" "A9A9A9" "C0C0C0" "D3D3D3" "DCDCDC" "696969")
declare -a all_pallet=("33ccff" "ccccff" "009933" "ff9900" "ff6666" "0033cc" "cc0000" "999966")


if [[ -z $CACHE ]];
then
    cd $RESULTS_DIR
    for stm in ${STMS[@]};
        do


        fileout=
        fileout_3d="\"Bench\" ${thread_count[@]} average"
        fileout_3d+=$'\n'

        for program in ${full_benchmark_names[@]};do
            linesum_readsvalidated=0
            linesum_readsvalidated_per_th=0
            lineavg_readsvalidated=0
            lineavg_readsvalidated_per_th=0

            fileout+=$program
            line_3d_1="$program"
            line_3d_2="C+A"
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

                    #($10+$12) is zero when norec and tl2 can't run tpcc and sb7
                    # 10+12 is val fail+success=total val function calls. Reads validated / function calls gives avg reads validated.
                    # now do this per thread;
                    readsvalidated=$(awk '{
                        denum=($10+$12);
                        if(denum>0){
                            readsvalidated = $8/(denum);
                        }else{
                            readsvalidated=0
                        }
                    } END { printf "%.0f", readsvalidated }' <<< "$my_line")

                    #3d plot has only aborts,readsvalidated,threads
                    C_A=$(awk '{ A=($6) } END { printf "%d", A }' <<< "$my_line")

                    if [[ ! $readsvalidated == 0 ]];then
                        #eliminate zeroes when doing average
                        ((N_TH_AVG++))
                    fi

                    #echo "          $source_file: $readsvalidated"
                    #this represents total reads-validated for all $th threads.
                    # 1 2 4 8 16 32
                    fileout+=" $readsvalidated"

                    #use this later to sort
                    #this is the bulk done on all $th threads
                    linesum_readsvalidated=$(bc <<< "scale=10; $linesum_readsvalidated+($readsvalidated)";)

                    #this is how much is done in each validation function vall
                    if [[ $th != "1a" ]]; then
                      linesum_readsvalidated_per_th=$(bc <<< "scale=10; $linesum_readsvalidated_per_th+($readsvalidated/$th)";)
                    else
                      linesum_readsvalidated_per_th=$(bc <<< "scale=10; $linesum_readsvalidated_per_th+($readsvalidated)";)
                    fi

                    line_3d_1+=" $readsvalidated"
                    line_3d_2+=" $C_A"

                fi
            done #thread count for a single program

            # "Total"->column only used for sorting
            fileout+=" $linesum_readsvalidated"

            if [[ $N_TH_AVG -eq 0 ]]; then
                lineavg_readsvalidated=0
                lineavg_readsvalidated_per_th=0
            else
                lineavg_readsvalidated=$(bc <<< "scale=0; $linesum_readsvalidated/$N_TH_AVG";)
                lineavg_readsvalidated_per_th=$(bc <<< "scale=0; $linesum_readsvalidated_per_th/$N_TH_AVG";)
            fi

            # "Average"
            fileout+=" $lineavg_readsvalidated"
            # "Reads validated per function call / thread"
            fileout+=" $lineavg_readsvalidated_per_th"
            fileout+=$'\n'
            #########
            line_3d_1+=" $lineavg_readsvalidated"
            line_3d_1+=$'\n'
            line_3d_2+=" $lineavg_readsvalidated"
            line_3d_2+=$'\n'

            fileout_3d+=$line_3d_1
            fileout_3d+=$line_3d_2

        done #all programs for this stm

        dest_file="RSET-SIZE-${stm}"
        echo -e "$fileout" > $dest_file

        # sort on second to last column
        echo -e "$(sort -s -nk$((${#thread_count[@]}+2)) $dest_file)" > "RSET-SIZE-sorted-${stm}"

        dest_file_3d="3D-RSET-SIZE-ABORTS-${stm}"
        echo -e "$fileout_3d" > $dest_file_3d

    done #all stms

    cd .. #crawl out of RESULTS_DIR

    #add header with gnuplot key
    for stm in ${STMS[@]}; do
        header_str=
        for i in ${thread_count[@]}; do
            header_str="$header_str \"$i\""
        done
        sed -i "1i\\\"Bench\"$header_str \"Total\" \"Average\" \"Reads validated per function call\"" "$RESULTS_DIR/RSET-SIZE-${stm}"
        sed -i "1i\\\"Bench\"$header_str \"Total\" \"Average\" \"Reads validated per function call\"" "$RESULTS_DIR/RSET-SIZE-sorted-${stm}"
    done
fi


FILE="gnuplot/AVG-READS-VALIDATED.gnuplot"

echo "set terminal wxt size 1440,1200" > $FILE
echo "set decimal locale \"en_US.UTF-8\"; show locale" >> $FILE
#echo "set output 'png/... .png'" >> $FILE

echo "set multiplot layout ${#STMS[@]},1 rowsfirst title \"Average reads validated in STM benchmarks\" font \"Computer Modern,16\"" >> $FILE
echo "set title \"Average reads validated for all benchmark programs\" font \"Computer Modern,16\"" >> $FILE
echo "set datafile missing '0'" >> $FILE

echo "set border 0" >> $FILE
#echo "xlabeloffsety=1.75" >> $FILE
echo "set tics scale 0"  >> $FILE


#echo "set offset -0.3,-0.3,0,0" >> $FILE
echo "set bmargin 8" >> $FILE
echo "set style fill solid 1.00" >> $FILE
#echo "set style fill pattern border lt -1" >> $FILE
echo "set grid ytics lc rgb \"#606060\"" >> $FILE
echo "unset border" >> $FILE
echo "set yrange [0:*]" >> $FILE
#echo "set format y \"%d\""  >> $FILE

echo "set ytics right font \"Computer Modern,11\" " >> $FILE
echo "set xtics nomirror rotate by 45 right scale 0 font \"Computer Moder,9.5\"" >> $FILE
#echo "set ytics (10,50,100)"  >> $FIL1E
echo "set datafile separator whitespace" >> $FILE
echo "set boxwidth 0.95" >> $FILE
echo "set style data histogram" >> $FILE
#echo "set style histogram rowstacked gap 1" >> $FILE
echo "set style histogram rowstacked" >> $FILE

#TODO: cant show legend (keys) only once. they repeat foe each thread count/newhistogram
#echo "unset key"  >> $FILE
#echo "unset grid" >> $FILE

echo "set key outside right vertical" >> $FILE
echo "set key invert" >> $FILE
echo "set key title \"Threads\"" >> $FILE
echo "set key font \"Computer Modern,10.75\"" >> $FILE

echo >> $FILE

COUNT=0
for stm in ${STMS[@]};
do
    ((COUNT++))
    echo "set title \"${stm}\" font \"Computer Modern,12\" tc rgb \"#8f8800\"" >> $FILE

    #get trend average for red ine
    avg_rset_size=$(awk 'NR>1{if($NF>0){total+=$(NF);n++}} END{printf "%f",total/n}' <<< cat $RESULTS_DIR/RSET-SIZE-${stm};)
    avg_rset_size_pos=$(awk -v col=$((${#thread_count[@]}+2)) 'NR>1{total+=$col;n++} END{printf "%f",total/n}' <<< cat $RESULTS_DIR/RSET-SIZE-${stm};)

    ########################################### Validation success rate #####################################################
    echo  "plot newhistogram, \\"  >> $FILE
    echo  "      '$RESULTS_DIR/RSET-SIZE-${stm}' u 2:xtic(1) t col lc rgbcolor \"#${gray_pallet[0]}\" lt 1 fs pattern 3, \\"  >> $FILE
    for ((i=3;i<${#thread_count[@]}+2;i++)) do
        echo  "      '' u (\$${i}) t col lc rgbcolor \"#${gray_pallet[(($i-3 % ${#gray_pallet[@]}))]}\" lt 1 fs pattern 3, \\"  >> $FILE
    done

    avg_per_validation_function_call=$((${#thread_count[@]}+4)) #last field is average value
    line_sum_idx=$((${#thread_count[@]}+2))   #next to last is sum
    echo  "      '' u (\$0-1):(\$$line_sum_idx):(sprintf(\"%'d\", \$$avg_per_validation_function_call)) notitle w labels rotate by 90 left font \"Computer Modern,12.5\",\\"  >> $FILE
    echo  "      $avg_rset_size_pos t sprintf('%d', $avg_rset_size) lc rgb \"#c9413e\" "  >> $FILE

    echo >> $FILE
done #for each stm
echo  "unset multiplot" >> $FILE

##################################################################################################################################################
##################################################################################################################################################
######################################################## ZOOM INTO TOP LARGEST RSET SIZES ########################################################
FILE_sorted="gnuplot/RSET-SIZES-sorted-top.gnuplot"
echo "set terminal wxt size 800,1200" > $FILE_sorted
#echo "set output 'png/... .png'" >> $FILE_sorted

echo "set multiplot layout ${#STMS[@]},1 rowsfirst title \"Average reads validated in lengthiest STM benchmarks\" font \"Computer Modern,16\"" >> $FILE_sorted
echo "set title \"Average reads validated for all benchmark programs\" font \"Computer Modern,16\"" >> $FILE
echo "set datafile missing '0'" >> $FILE_sorted

echo "set datafile separator whitespace" >> $FILE_sorted

#echo "set border 3" >> $FILE_sorted
echo "unset border" >> $FILE_sorted
#echo "xlabeloffsety=1.75" >> $FILE_sorted

echo "set tics scale 0"  >> $FILE_sorted
#echo "set xtics nomirror rotate by 45 right scale 0 font \"Computer Modern,8\"" >> $FILE_sorted
#echo "set offset -0.3,-0.3,0,0" >> $FILE_sorted

echo "set style fill solid 1.00" >> $FILE_sorted
#echo "set style fill pattern border lt -1" >> $FILE_sorted
echo "set grid ytics lc rgb \"#606060\"" >> $FILE_sorted

echo "set yrange [0:*]" >> $FILE_sorted
#echo "set format y \"%d\""  >> $FILE_sorted

echo "set style data linespoints" >> $FILE_sorted
#echo "unset key"  >> $FILE_sorted
#echo "unset grid" >> $FILE_sorted

echo "set key autotitle columnhead" >> $FILE_sorted
echo "set key outside right vertical" >> $FILE_sorted
echo "set key invert" >> $FILE_sorted
echo "set key title \"Benchmark\"" >> $FILE_sorted
echo "set key font \"Computer Modern,9\"" >> $FILE_sorted

COUNT=0
for stm in ${STMS[@]};
do
    ((COUNT++))
    echo "set title \"${stm}\" font \"Computer Modern,12\" tc rgb \"#8f8800\"" >> $FILE_sorted
    #get trend average for red ine
    SORTED_FILE="$RESULTS_DIR/RSET-SIZE-sorted-${stm}"
    SORTED_FILE_TOP="$RESULTS_DIR/RSET-SIZE-sorted-top-${stm}"

    avg_rset_size=$(awk 'NR>1{if($(NF)>0){total+=$NF;n++}} END{printf "%f",total/n}' <<< cat $SORTED_FILE;)

    #enter file and delete entries with smaller than avg_rset_size
    head -n 1 $SORTED_FILE > $SORTED_FILE_TOP
    awk -v avg=$avg_rset_size '(NR>1){if($NF>=(avg)) print $0}' $SORTED_FILE >> $SORTED_FILE_TOP

    #transpose the file
    SORTED_FILE_TOP_TRANSPOSED="$RESULTS_DIR/RSET-SIZE-sorted-top-transposed-${stm}"
    echo -n > $SORTED_FILE_TOP_TRANSPOSED
    numc=$((${#thread_count[@]}+1))
    for ((i=1; i<="$numc"; i++)); do
        row=$(cut -d' ' -f"$i" $SORTED_FILE_TOP | paste -d' ' -s)
        echo "$row" >> $SORTED_FILE_TOP_TRANSPOSED
    done

    ########################################### Validation success rate #####################################################
    echo  "plot \\"  >> $FILE_sorted
    echo  "      '$SORTED_FILE_TOP_TRANSPOSED' u 2:xtic(1) t col lt 1, \\"  >> $FILE_sorted
    LINES_TO_PLOT=$(wc -l < $SORTED_FILE_TOP)-1
    for ((i=3;i<$LINES_TO_PLOT+1;i++)) do
        echo  "      '' u (\$${i}) t col lt $i, \\"  >> $FILE_sorted
    done
    echo  "      '' u (\$$(($LINES_TO_PLOT+1))) t col lt $((LINES_TO_PLOT+1))"  >> $FILE_sorted

    #last_field_idx=$((${#thread_count[@]}+3))
    #line_sum_idx=$((${#thread_count[@]}+2))
    #echo  "       3 notitle w labels rotate by 90 left font \",8\",\\"  >> $FILE_sorted
    echo >> $FILE_sorted

done #for each stm
echo  "unset multiplot" >> $FILE_sorted


######################################################## 3D RSET SIZES  ########################################################
######################################################## 3D RSET SIZES  ########################################################
######################################################## 3D RSET SIZES  ########################################################
FILE_3D="gnuplot/3D-RSET-SIZES-ABORTS.gnuplot"
echo -n > $FILE_3D
echo "set terminal wxt size 2440,1200" > $FILE_3D
#echo "set terminal postscript eps enhanced color font 'Times-Bold' 25" >> $FILE_3D
##echo "set term pdfcairo color dashed font 'FreeSans,9'" >> $FILE_3D
echo "set multiplot layout 2,2 title \"Avg reads validated, aborts (programs with reads validated > avg)\" font \"Computer Modern,16\"" >> $FILE_3D
#echo "set output \"3D-RSET-SIZE-ALL-STMS.pdf\" " >> $FILE_3D

#echo "set logscale x;" >> $FILE_3D
#echo "set logscale y;" >> $FILE_3D
#echo "set logscale z;" >> $FILE_3D

echo "set xtics center offset -2,-0.6,-14" >> $FILE_3D
echo "set ytics center offset -3,-0.65,0" >> $FILE_3D
echo "set ztics center offset 1,1,0" >> $FILE_3D

echo "set datafile missing '0'" >> $FILE_3D
echo "set xlabel \"threads\" offset 6, -2,3" >> $FILE_3D
echo "set ylabel \"Aborts\" offset -9,-2,-6" >> $FILE_3D
echo "set zlabel \"Rset size\" offset 5,50,0" >> $FILE_3D
echo "set grid back" >> $FILE_3D
echo "set border ls 2 lc rgb \"black\"" >> $FILE_3D

#perfect angle do not touch
#echo "set view 69, 119, 1.2, 1.1" >> $FILE_3D
echo "set view 45, 45, 1, 1.1" >> $FILE_3D
echo "set key outside top right" >> $FILE_3D

COUNT=0
for stm in ${STMS[@]};
do

    ((COUNT++))

    #create all thread 3D chunks for this STM
    F_3D_RSET_SIZES="$RESULTS_DIR/3D-RSET-SIZE-ABORTS-${stm}"
    avg_rset_size=$(awk 'NR>1{if($NF>0){total+=$NF;n++}} END{printf "%f",total/n}' <<< cat $F_3D_RSET_SIZES;)

    F_3D_RSET_SIZES_TOP="$RESULTS_DIR/3D-RSET-SIZE-ABORTS-TOP-${stm}"

    head -n 1 $F_3D_RSET_SIZES > $F_3D_RSET_SIZES_TOP

    #production
    awk -v avg=$avg_rset_size 'NR>1{if($NF>=(avg)) print $0}' $F_3D_RSET_SIZES >> $F_3D_RSET_SIZES_TOP

    #plot all not just >= avg
    #awk -v avg=$avg_rset_size 'NR>1{print $0}' $F_3D_RSET_SIZES >> $F_3D_RSET_SIZES_TOP

    #transpose for 3d splot
    F_3D_RSET_SIZES_TOP_TRANSPOSED="$RESULTS_DIR/3D-RSET-SIZE-ABORTS-TOP-TRANSPOSED-${stm}"
    echo -n > $F_3D_RSET_SIZES_TOP_TRANSPOSED

    numc=$((${#thread_count[@]}+1))
    for ((i=1; i<="$numc"; i++)); do
        row=$(cut -d' ' -f"$i" $F_3D_RSET_SIZES_TOP | paste -d' ' -s)
        echo "$row" >> $F_3D_RSET_SIZES_TOP_TRANSPOSED
    done

    NCOLS=$(awk 'NR==1{print NF}' $F_3D_RSET_SIZES_TOP_TRANSPOSED)
    NCOLS=$(($NCOLS-1)) #remove thread count xtic col

    echo "set title \"${stm}\" font \"Computer Modern,16\" tc rgb \"#8f8800\"" >> $FILE_3D
    echo "splot \\" >> $FILE_3D

    #COLOR_IDX=0
    #prev_benchmark=""
    for ((i=1;i<$NCOLS-1;i+=2));
    do
        #t_col=$(head -n 1 $F_3D_RSET_SIZES_TOP_TRANSPOSED | awk -v col=$(($i+1)) 'NR==1{print $col}' $F_3D_RSET_SIZES_TOP_TRANSPOSED | grep -E -o '^[[:alnum:]]*')
        #echo $t_col $prev_benchmark

        #if [[ ! "$prev_benchmark" == "$t_col" ]] || [[ $i -eq 1 ]]; then
        #    prev_benchmark=$t_col
        #    ((COLOR_IDX++))
        #fi
        echo " '${F_3D_RSET_SIZES_TOP_TRANSPOSED}' using (int(\$0)):$i:$(($i+1)):xtic(1) t col with linespoints ,\\" >> $FILE_3D
    done
    echo " '${F_3D_RSET_SIZES_TOP_TRANSPOSED}' using (int(\$0)):$((NCOLS-1)):$(($NCOLS)):xtic(1) t col with linespoints" >> $FILE_3D
    #echo "set output" >> $FILE_3D
    echo >> $FILE_3D

done
#echo "unset output" >> $FILE_3D
echo "unset multiplot" >> $FILE_3D

gnuplot -p $FILE
#gnuplot -p $FILE_3D
#gnuplot -p $FILE_sorted





