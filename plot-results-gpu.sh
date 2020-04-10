#!/bin/bash

# sudo bash plot-naive-speedup.sh sb7|tpcc

BENCHMARK=$1

#num arguments
if [[ "$#" -ne 1 ]];then
    echo "Illegal number of arguments. Correct usage:"
    echo "bash plot-detaild.sh BENCH"
    echo "bash plot-detaild.sh ssca2"
    echo ""
    exit;
fi

#3 i have placed tinystm-cpu inside results-gpu folder
RESULTS_DIR="results-gpu"

mkdir -p "gnuplot"

benchmarks=("tpcc" "sb7" "synth" "redblacktree" "linkedlist" "hashmap" "skiplist" "genome" "intruder" "kmeans" "labyrinth" "ssca2" "vacation" "yada")
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

declare -a thread_count=(1 1a 2 4 8 16 32)

declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")

#get all stm+mods inside results dir
if [[ ! " ${benchmarks[@]} " =~ " ${BENCHMARK} " ]]; then
    echo "Benchmark does not exist. Exiting."
    echo ""
    exit;
fi

declare -a benchmark_arr=()
#check if argument $1 exists in full benchmark names and if does add them
for b in "${full_benchmark_names[@]}"; do
    if [[ ${b} =~ ${1} ]]; then
        benchmark_arr+=($b)
    fi
done

n=${#benchmark_arr[@]}
MAXC=3
C=$MAXC
R=$(echo "a=$n; b=$C; if ( a%b ) a/b+1 else a/b" | bc)
H=1080
#number of benchmark parameter runs less or equal than max columns (3)
#then have only one row and 1-3 columns for programs
if [[ $n -le $MAXC ]]; then
    R=1;
    C=$n;
    H=480
fi


#TIMES
FILE_time="gnuplot/$BENCHMARK.time.gnuplot"
FILE_val_succ="gnuplot/$BENCHMARK.val_succ.gnuplot"
FILE_reads_val="gnuplot/$BENCHMARK.val_through.gnuplot"
FILE_c_a="gnuplot/$BENCHMARK.C_A.gnuplot"
FILE_energy="gnuplot/$BENCHMARK.energy.gnuplot"
FILES="$FILE_time $FILE_val_succ $FILE_reads_val $FILE_c_a $FILE_energy"

echo > $FILE_time
echo > $FILE_val_succ
echo > $FILE_reads_val
echo > $FILE_c_a
echo > $FILE_energy

#echo "set terminal png size 1920,1080" >> $FILE

echo "set terminal wxt size 2560,$H" | tee -a $FILES
#echo "set output '$BENCHMARK-detailed.png'" >> $FILE

echo "set multiplot layout $R,$C rowsfirst title \"$BENCHMARK - Validation time/total execution time (s)\" font \",16\"" | tee -a $FILE_time
echo "set multiplot layout $R,$C rowsfirst title \"$BENCHMARK - Validation success rate\" font \",16\"" | tee -a $FILE_val_succ
echo "set multiplot layout $R,$C rowsfirst title \"$BENCHMARK - Reads validated/s (avg.)\" font \",16\"" | tee -a $FILE_reads_val
echo "set multiplot layout $R,$C rowsfirst title \"$BENCHMARK - Commit/abort rate \" font \",16\"" | tee -a $FILE_c_a
echo "set multiplot layout $R,$C rowsfirst title \"$BENCHMARK - Energy consumption using Intel RAPL (W)\" font \",16\"" | tee -a $FILE_energy

#echo "set border 3" | tee -a $FILES
echo "xlabeloffsety=-2.75" | tee -a $FILES

echo "set tics scale 0"  | tee -a $FILES
echo "set xtics nomirror rotate by 45 right scale 0 font \",8\""  | tee -a $FILES

#echo "set datafile missing '0'" | tee -a $FILES
echo "set xtics offset 0, 0" >> $FILE_reads_val
echo "set style fill solid 1.00"  | tee -a $FILES
echo "set grid ytics lc rgb \"#606060\""  | tee -a $FILES
echo "unset border" | tee -a $FILES
echo "set yrange [0:*]" | tee -a $FILES
echo "set bmargin -10" | tee -a $FILES
#echo "set ytics (10,50,100)"  >> $FIL1E
echo "set datafile separator whitespace" | tee -a $FILES
echo "set boxwidth 0.88"  | tee -a $FILES
echo "set style data histogram"  | tee -a $FILES
echo "set style histogram rowstacked gap 1"  | tee -a $FILES

#TODO: cant show legend (keys) only once. they repeat foe each thread count/newhistogram
echo "unset key" | tee -a $FILES

step=3
echo "leftcolumn_offset_1= $((step*0))" | tee -a $FILES
echo "leftcolumn_offset_1a=$((step*1))" | tee -a $FILES
echo "leftcolumn_offset_2= $((step*2))" | tee -a $FILES
echo "leftcolumn_offset_4= $((step*3))" | tee -a $FILES
echo "leftcolumn_offset_8= $((step*4))" | tee -a $FILES
echo "leftcolumn_offset_16=$((step*5))" | tee -a $FILES
echo "leftcolumn_offset_32=$((step*6))" | tee -a $FILES

########################################### PLOT SPECIFIC ###########################################

########################################### VALIDATION TIME/TOTAL TIME#####################################################
echo "set xtics offset 0, xlabeloffsety" >> $FILE_time
echo "set ylabel \"Time (s)\""  >> $FILE_time
echo "set format y \"%2.2f\""  >> $FILE_time
########################################### Validation success rate #####################################################
echo "set xtics offset 0, xlabeloffsety" >> $FILE_val_succ
echo "set ylabel \"\""  >> $FILE_val_succ
echo "set format y \"\""  >> $FILE_val_succ
echo "unset grid"  >> $FILE_val_succ
########################################### average Read entries validated / ms #####################################################
echo "set xtics offset 0, 0" >> $FILE_reads_val
echo "set ylabel \"\""  >> $FILE_reads_val
echo "set format y \"%2.0t{/Symbol \264}10^{%L}\""  >> $FILE_reads_val
#echo "unset grid"  >> $FILE_reads_val
########################################### COMMITS/ABORTS  #####################################################
echo "set xtics offset 0, xlabeloffsety" >> $FILE_c_a
echo "set ylabel \"\""  >> $FILE_c_a
echo "set format y \"\""  >> $FILE_c_a
echo "unset grid"  >> $FILE_c_a
########################################### ENERGY #####################################################
echo "set xtics offset 0, 0" >> $FILE_energy
echo "unset grid"  >> $FILE_energy
echo "set ylabel \"Power consumption (W)\""  >> $FILE_energy
echo "set format y \"%2.0f\""  >> $FILE_energy
echo "set grid ytics lc rgb \"#606060\""  >> $FILE_energy
echo "unset datafile" >> $FILE_energy


for i in ${!benchmark_arr[@]}; do

    echo "set title \"${benchmark_arr[i]}\" font \",12\" tc rgb \"#8f8800\"" | tee -a $FILES
    echo "plot\\"  | tee -a $FILES

    COUNT=0
    for j in ${!thread_count[@]}; do
        n=${thread_count[$j]}
        ########################################### VALIDATION TIME/TOTAL TIME#####################################################
        echo  "    newhistogram \"{$n threads}\" offset char 0,xlabeloffsety, \\"  >> $FILE_time
        echo  "      '$RESULTS_DIR/$n-${benchmark_arr[$i]}-cluster' u 2:xtic(1) t col lc rgbcolor \"#80b3ff\" lt 1 fs pattern 3, \\"  >> $FILE_time
        echo  "      ''               u (\$16>=\$2 ? \$16-\$2 : NaN) t col lc rgbcolor \"#b3d1ff\" fs pattern 6, \\"  >> $FILE_time
        echo  "      ''               u (\$0-1-0.26):((\$2!=0)?\$2:NaN):(sprintf('%2.6f', \$2)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left textcolor rgb \"#8f8800\" font \",8\", \\"  >> $FILE_time
        echo  "      ''               u (\$0-1+0.26):((\$16!=0)?\$16:NaN):(sprintf('%2.2f', \$16)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left font \",8\", \\"  >> $FILE_time
        echo  "      ''               u (\$0-1):(\$2-\$2):(sprintf('%2.1f%', (\$16!=0)?(\$2/\$16*100):0)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 right font \",8\", \\"  >> $FILE_time
        echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$2):3 w yerr ls 1 lc rgb \"#8f8800\" t \"\", \\"  >> $FILE_time
        if [[ "$n" == "${thread_count[-1]}" ]]; then
            echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$16):17 w yerr ls 1 lc rgb 'black' t \"\""  >> $FILE_time
        else
            echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$16):17 w yerr ls 1 lc rgb 'black' t \"\", \\"  >> $FILE_time
        fi

        ########################################### Validation success rate #####################################################
        echo  "    newhistogram \"{$n threads}\" offset char 0,xlabeloffsety, \\"  >> $FILE_val_succ
        echo  "      '$RESULTS_DIR/$n-${benchmark_arr[$i]}-cluster' using 12:xtic(1) t col lc rgbcolor \"#b3d1ff\" lt 1 fs pattern 6, \\"  >> $FILE_val_succ
        echo  "      ''               u (\$10) t col lc rgbcolor \"#${blue_pallet[((COUNT))]}\" lt 1 fs pattern 3, \\"  >> $FILE_val_succ
        #Lables 10 val succ 12 val fail
        echo  "      ''               u (\$0-1-0.27):((\$12!=0)?\$12:NaN):(sprintf('%d', \$12)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left textcolor rgb \"#8f8800\" font \",8\", \\"  >> $FILE_val_succ
        echo  "      ''               u (\$0-1+0.27):((\$12+\$10!=0)?\$12+\$10:NaN):(sprintf('%d', \$10)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left font \",8\", \\"  >> $FILE_val_succ
        #8-validation calls percentage compared to commits
        echo  "      ''               u (\$0-1):(\$10-\$10):(sprintf('%2.2f%', ((\$10+\$12)!=0)?(\$10/(\$10+\$12)*100):100 )) notitle w labels offset first leftcolumn_offset_$n rotate by 90 right font \",8\", \\"  >> $FILE_val_succ
        #errors
        echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$12):13 w yerr ls 1 lc rgb \"#8f8800\"  t \"\", \\"  >> $FILE_val_succ
        if [[ "$n" == "${thread_count[-1]}" ]]; then
            echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$12+\$10):11 w yerr ls 1 lc rgb 'black' t \"\""  >> $FILE_val_succ
        else
            echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$12+\$10):11 w yerr ls 1 lc rgb 'black' t \"\", \\"  >> $FILE_val_succ
        fi

        ########################################### average Read entries validated / s #####################################################
        n=${thread_count[$j]}
        echo  "    newhistogram \"{$n threads}\" offset char 0,xlabeloffsety, \\"  >> $FILE_reads_val
        echo  "      '$RESULTS_DIR/$n-${benchmark_arr[$i]}-cluster' using (\$2!=0?(\$8/(\$2)):0):xtic(1) t col lc rgbcolor \"#${blue_pallet[((COUNT))]}\" lt 1 fs pattern 10, \\"  >> $FILE_reads_val
        #Lables 2 val time 8 reads validated total
        if [[ "$n" == "${thread_count[-1]}" ]]; then
            echo  "      ''               u (\$0-1):(\$2>0?(\$8/(\$2)):0):( sprintf('%.2g', \$8/(\$2)) ) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left font \",8\""  >> $FILE_reads_val
        else
            echo  "      ''               u (\$0-1):(\$2>0?(\$8/(\$2)):0):( sprintf('%.2g', \$8/(\$2)) ) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left font \",8\", \\"  >> $FILE_reads_val
        fi

        ########################################### COMMITS/ABORTS  #####################################################
        echo  "    newhistogram \"{$n threads}\" offset char 0,xlabeloffsety, \\"  >> $FILE_c_a
        echo  "      '$RESULTS_DIR/$n-${benchmark_arr[$i]}-cluster' using 4:xtic(1) t col lc rgbcolor \"#80b3ff\" lt 1 fs pattern 3, \\"  >> $FILE_c_a
        echo  "      ''               u (\$6) t col lc rgbcolor \"#b3d1ff\" lt 1 fs pattern 6, \\"  >> $FILE_c_a
        #Lables 10 val succ 12 val fail
        echo  "      ''               u (\$0-1-0.27):(\$4):(sprintf('%d', \$4)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left textcolor rgb \"#8f8800\" font \",8\", \\"  >> $FILE_c_a
        echo  "      ''               u (\$0-1+0.27):(\$6+\$4):(sprintf(  (\$6<=149999)?('%d (%d%)'):('%.g (%d%)'), \$6, ((\$6+\$4>0)?((\$6/(\$4+\$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left font \",8\", \\"  >> $FILE_c_a
        #8-validation calls percentage compared to commits
        echo  "      ''               u (\$0-1):(\$6-\$6):(sprintf('%.g tx/s', ((\$16>0)?((\$4+\$6)/\$16):(0)))) notitle w labels offset first leftcolumn_offset_$n rotate by 90 right font \",6\", \\"  >> $FILE_c_a
        #errors
        echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$4):5 w yerr ls 1 lc rgb \"#8f8800\" t \"\", \\"  >> $FILE_c_a
        if [[ "$n" == "${thread_count[-1]}" ]]; then
            echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$6+\$4):7 w yerr ls 1 lc rgb 'black' t \"\""  >> $FILE_c_a
        else
            echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$6+\$4):7 w yerr ls 1 lc rgb 'black' t \"\", \\"  >> $FILE_c_a
        fi

        ########################################### ENERGY #####################################################
        echo  "    newhistogram \"{$n threads}\" offset char 0,xlabeloffsety, \\"  >> $FILE_energy
        echo  "      '$RESULTS_DIR/$n-${benchmark_arr[$i]}-cluster' using ( \$14/\$16 ):xtic(1) t col lc rgbcolor \"#${blue_pallet[((COUNT))]}\" lt 1 fs pattern 6, \\"  >> $FILE_energy
        if [[ "$n" == "${thread_count[-1]}" ]]; then
            echo  "      ''               u (\$0-1):(\$14/\$16):(sprintf('%2.1f', \$14/\$16)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left font \",8\""  >> $FILE_energy
        else
            echo  "      ''               u (\$0-1):(\$14/\$16):(sprintf('%2.1f', \$14/\$16)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left font \",8\", \\"  >> $FILE_energy
        fi


        ((COUNT++)) #for colors and such

    done

    echo | tee -a $FILES

done

#echo "set key outside right top vertical Left" | tee -a $FILE1 $FILE2 $FILE3
#echo "set key samplen 2.5 spacing 0.85" | tee -a $FILE1 $FILE2 $FILE3
#echo "set key font \",11\"" | tee -a $FILE1 $FILE2 $FILE3
echo  "unset multiplot" | tee -a $FILES

gnuplot -p $FILE_time
gnuplot -p $FILE_val_succ
gnuplot -p $FILE_reads_val
gnuplot -p $FILE_c_a
gnuplot -p $FILE_energy