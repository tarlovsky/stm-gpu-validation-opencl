#!/bin/bash

RESULTS_DIR="../results-cpu"
RESULTS_DIR_CPUGPU="../results-cpu-gpu"
TMP="../tmp"
mkdir -p "../gnuplot"

BENCHMARK=sb7




########################################################################################################################
benchmarks=("tpcc" "sb7" "synth" "redblacktree" "linkedlist" "hashmap" "skiplist" "genome" "intruder" "kmeans" "labyrinth" "ssca2" "vacation" "yada")
full_benchmark_names=(\
                    "tpcc-s96-d1-o1-p1-r1" "tpcc-s1-d96-o1-p1-r1" "tpcc-s1-d1-o96-p1-r1" "tpcc-s1-d1-o1-p96-r1" "tpcc-s1-d1-o1-p1-r96" "tpcc-s20-d20-o20-p20-r20" "tpcc-s4-d4-o4-p43-r45"\
                    #"sb7-r-f-f"\
                    #"sb7-rw-f-f"\
                    #"sb7-w-f-f"\
                    "sb7-r-t-f"\
                    "sb7-rw-t-f"\
                    "sb7-w-t-f"\
                    #"sb7-r-f-t"\
                    #"sb7-rw-f-t"\
                    #"sb7-w-f-t"\
                    "sb7-r-t-t"\
                    "sb7-rw-t-t"\
                    "sb7-w-t-t"\
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

declare -a thread_count=(2 4 8 16)

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
    if [[ ${b} =~ $BENCHMARK ]]; then
        benchmark_arr+=($b)
    fi
done
########################################################################################################################


declare -a blue_palette=(" " "69a2ff" "7dafff" " " "94bdff" " " " " " " "9cc2ff" " " "adcdff" " " "b5d2ff" " " "bdd7ff")
declare -a gray_palette=(" " "000000" "696969" " " "808080" " " " " " " "A9A9A9" " " "C0C0C0" " " "D3D3D3" " " "DCDCDC" " " "696969")
declare -a all_palette=( " " "1D4599" "11AD34" " " "E69F17" " " " " " " "E62B17" " " "ff6666" " " "0033cc" " " "cc0000" " " "999966")
declare -a red_palette=( " " "F9B7B0" "E62B17" " " "8F463F" " " " " " " "6D0D03")
declare -a gold_palette=(" " "8f8d08" "a77f0e" " " "916a09" " " " " " " "914a09" " " "adcdff" " " "b5d2ff" " " "bdd7ff")
declare -a red_palette=( " " "b01313")

FILE="../gnuplot/sb7-tx-throughput.gnuplot"              #d=0
FILE1="../gnuplot/sb7-validation-reads-validated.gnuplot"  #d=0
FILE1="../gnuplot/sb7-aborts.gnuplot"              #d=0
FILE3="../gnuplot/sb7-val-proportion.gnuplot"
FILE4="../gnuplot/sb7-performance-energy.gnuplot"

FILES="$FILE $FILE1 $FILE2 $FILE3 $FILE4"

echo "set terminal wxt size 1200,1100" > $FILE
echo "set terminal wxt size 1400,1100" > $FILE1
echo "set terminal wxt size 880,2600;" > $FILE2
echo "set terminal wxt size 880,2600; " > $FILE3
echo "set terminal wxt size 1400,1100" > $FILE4
#echo "set size 1,1" >> $FILE
#echo "set origin 0,0" >> $FILE
#echo "unset bmargin" | tee -a $FILES
#echo "set tmargin -3" | tee -a $FILES
echo "set bmargin 8" | tee -a $FILES
echo "set lmargin -2" | tee -a $FILES
#echo "set lmargin 10" >> $FILE5

#no sequential executions
echo "set multiplot layout 2,3 title \"TX/S\" font \"Computer Modern,20\"" >> $FILE #txps
echo "set multiplot layout 2,3 title \"Reads validated/s normalized to TinySTM-untouched-Intel\" font \"Computer Modern,20\"" >> $FILE1 # readsval
echo "set multiplot layout 4,1 title \"#Aborts normalized to TinySTM-untouched\" font \"Computer Modern,23\"" >> $FILE2 #aborts
echo "set multiplot layout 4,1 title \"Validation time / Total time\" font \"Computer Modern,23\"" >> $FILE3 #valtime proportion
echo "set multiplot layout 2,2 title \"Performance/J, normalized to TinySTM-untouched-Intel; INTEL-COOP - CAS COMPETE FOR IGPU\" font \",12\"" >> $FILE4

#vars
echo "col_24=\"#c724d6\"" | tee -a $FILES
echo "col_48=\"#44cd1\"" | tee -a $FILES
echo "col_gold=\"#8f8800\"" | tee -a $FILES
echo "col_red=\"#b01313\"" | tee -a $FILES
echo "xlabeloffsety=0.15" | tee -a $FILES

echo "set decimal locale \"en_US.UTF-8\"; show locale" | tee -a $FILES
#echo "set datafile missing \"x\"" >> $FILE
#echo "unset ytics" >> $FILE
echo "set tics scale 0"  | tee -a $FILES

echo "set ytics nomirror font \"Computer Modern, 21\" " | tee -a $FILES
#echo "set ytics (0,0.5,1.0,1.5,2.0,2.5) " | tee -a $FILES

#echo "set ytics 0.1" | tee -a $FILE $FILE1 $FILE2 $FILE4

#echo  "set arrow 1 from 0, 1 to 12, 1 front nohead lc rgb \"#000000\" lw 2" | tee -a $FILES
#echo  "unset arrow 1" >> $FILE5

echo "set grid ytics lc rgb \"#606060\"" | tee -a $FILES
echo "set grid xtics lc rgb \"#bbbbbb\"" | tee -a $FILES
#echo "set format y2 \"%0.4f\"" >> $FILE
echo "set logscale y" | tee -a $FILES

#THESE FILES CONTAIN #RV/s NORMALIZED TO TINY-UNTOUCHED
#echo "set yrange [0:2.5]" | tee -a $FILE $FILE1 $FILE2 $FILE4

#THESE FILES CONTAIN #TX/s NORMALIZED TO TINY-UNTOUCHED
#echo "set yrange [0.2:1.4]" | tee -a $FILE2 $FILE3

echo "set yrange [0.1:5]" >> $FILE

echo "set format x \"%d\"" | tee -a $FILES
echo "set xtics font \"Computer Modern, 19\" " | tee -a $FILES
echo "set xtics offset 0, xlabeloffsety" | tee -a $FILES
echo "set datafile separator whitespace" | tee -a $FILES

echo "set border lc rgb \"black\"" | tee -a $FILES
#echo "unset border" >> $FILE

echo "set style data lines" | tee -a $FILES

echo "set xlabel offset 0,-0.3 \"threads\" font \"Computer Modern, 20\""  | tee -a $FILES

echo | tee -a $FILES
echo "new = \"-\"" | tee -a $FILES
echo "new1 = \"..\"" | tee -a $FILES
echo "new2 = \"_-_\"" | tee -a $FILES

echo "unset key" | tee -a $FILES

echo "set ylabel offset -1, 0 \"TX / SECOND / THREAD\" font \"Computer Modern, 16\"" | tee -a $FILE $FILE1
#echo "set ylabel \"TRANSACTIONS / SECOND / THREAD\"" | tee -a $FILE2 $FILE3
#echo "set ylabel \"Validation time proportion\" offset -1.4,0 font \"Computer Modern, 14\"" | tee -a $FILE5


#echo  "set title \"Only CPU, threaded validation, sequential walk\" font \"Computer Modern, 25\"" | tee -a $FILES

#  $i STM-threads
for i in ${!benchmark_arr[@]}; do

  COUNT=0
  PROGRAM="$TMP/gnuplot-${benchmark_arr[$i]}-txps"
  echo "#THREADS TinySTM-wbetl AMD Intel Intel-LSA" > $PROGRAM
  #cluster files that house avg data from multiple benchmarks

  for j in ${!thread_count[@]}; do
    n=${thread_count[$j]}

    #######################################
    # extract from each cluster file:
    # cpu:    tx/s from line with first col value with TinySTM-wbetl;
    # cpu-gpu tx/s from all lines.
    # insert these lines into new column of new file:

    #have these files for each becnhmark_arr i

    ##### Tiny ##### TinyCoopIntel ##### TinyCoopAMD ##### TinyCoopIntelLsa
    # 1   tx/s        tx/s                  tx/s                tx/s
    # 2   tx/s        tx/s                  tx/s                tx/s
    # 4   tx/s        tx/s                  tx/s                tx/s
    # 8   tx/s        tx/s                  tx/s                tx/s
    # 16
    # regular plot with linespoints!

    cpu=$RESULTS_DIR/$n-${benchmark_arr[$i]}-cluster
    cpugpu=$RESULTS_DIR_CPUGPU/$n-${benchmark_arr[$i]}-cluster

    tinystm_txps=$(awk -v th=$n 'NR>1{if ($1 == "TinySTM-wbetl") {printf "%.17g\n", $4/($16*th)} }' <<< cat "$cpu")
    cpugpu_txps=$(awk -v th=$n 'NR>1{printf "%.17g\n", $8/($30*th)}' <<< cat "$cpugpu")

    echo $n $tinystm_txps $cpugpu_txps >> $PROGRAM

    #echo $tinystm_txps $cpugpu_txps
    #exit;

    # u (\$0):((\$20/(\$32*$i)) / (\$4/(\$16*$i))) : ( sprintf( '%.2fx',((\$20/(\$32*$i)) / (\$4/(\$16*$i))) ) ) : xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000))
    #echo  " '$cpu' u 4:xtic(1) t col pt 1 lw 2 lc rgbcolor \"#${blue_pallet[((COUNT))]} dt new w linespoints,\\"  >> $FILE
    #echo  " '$cpu' u 4:xtic(1) t col pt 1 lw 2 lc rgbcolor \"#${blue_pallet[((COUNT))]} dt new w linespoints,\\"  >> $FILE
    #((COUNT++))

    #tx/s: commits/totaltime relative to tinystm-untouched
    #echo  " '< join $tiny $tiny_lsa' u (\$0):((\$20/(\$32*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$20/(\$32*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl-lsa\" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\\"  >> $CHOICE_TXPS

    #echo  " '< join $tiny $coop' u (\$0):((\$24/(\$46*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$24/(\$46*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative\" pt 2 lw 2 lc rgb \"#b5d2ff\" with linespoints,\\"    >> $CHOICE_TXPS
    #echo  " '< join $tiny $coop_lsa' u (\$0):((\$24/(\$46*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$24/(\$46*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative - LSA\" pt 2 lw 2 lc rgb \"#b5d2ff\" dt new with linespoints,\\"    >> $CHOICE_TXPS
    #echo  " '< join $tiny $coop_amd' u (\$0):((\$24/(\$46*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$24/(\$46*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"AMD cooperative\" pt 2 lw 2 lc rgb col_red with linespoints,\\"   >> $CHOICE_TXPS

    #echo  " '< join $tiny $tiny_threads' u (\$0):((\$20/(\$32*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$20/(\$32*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validators\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" with linespoints,\\"   >> $CHOICE_TXPS
    #echo  " '< join $tiny $tiny_threads_lsa' u (\$0):((\$20/(\$32*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$20/(\$32*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4  validators - LSA\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" dt new1 with linespoints,\\"  >> $CHOICE_TXPS
    ###################################################################################################################################################################################################################################################################################


    # readsval/s relative to tinystm-untouched
    # divide what you want over TINYSTM fields
    # tiny comes to the left; what you want to the right
    # Because this is normalized, the per thread (*$i) is redundant. keep it for future formulas.
    #echo  " '< join $tiny $tiny_lsa' u (\$0):((\$24/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$24/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl-lsa\" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\\"  >> $CHOICE_VALREADS

    #echo  " '< join $tiny $coop' u (\$0):((\$28/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$28/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"Intel CPU-GPU co-op; GPU CAS; Blocks of 5736; sync on block\" pt 2 lw 2 lc rgb \"#b5d2ff\" with linespoints,\\"  >> $CHOICE_VALREADS
    #echo  " '< join $tiny $coop_lsa' u (\$0):((\$28/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$28/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"Intel CPU-GPU co-op; GPU CAS; Blocks of 5736; sync on block; LSA\" pt 2 lw 2 lc rgb \"#b5d2ff\" dt new with linespoints,\\"  >> $CHOICE_VALREADS
    #echo  " '< join $tiny $coop_amd' u (\$0):((\$28/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$28/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"AMD CPU-GPU co-op; GPU CAS; Blocks of 11264; sync on block\" pt 2 lw 2 lc rgb col_red with linespoints,\\"  >> $CHOICE_VALREADS

    #echo  " '< join $tiny $tiny_threads' u (\$0):((\$24/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$24/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validation worker threads\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" with linespoints,\\"  >> $CHOICE_VALREADS
    #echo  " '< join $tiny $tiny_threads_lsa' u (\$0):((\$24/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$24/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validation worker threads LSA\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" dt new1 with linespoints,\\"  >> $CHOICE_VALREADS
    ###################################################################################################################################################################################################################################################################################


    #TOTAL ABORTS relative to tinystm-untouched
    #echo  " '< join $tiny $tiny_lsa' u (\$0):((\$20) / (\$4)):( sprintf( '%.2fx',((\$20) / (\$6)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl-lsa\" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\\"  >> $CHOICE_ABORTS

    #echo  " '< join $tiny $coop' u (\$0):((\$26) / (\$6)):( sprintf( '%.2fx',((\$26) / (\$6)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative\" pt 2 lw 2 lc rgb \"#b5d2ff\" with linespoints,\\"    >> $CHOICE_ABORTS
    #echo  " '< join $tiny $coop_lsa' u (\$0):((\$26) / (\$6)):( sprintf( '%.2fx',((\$26) / (\$6)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative - LSA\" pt 2 lw 2 lc rgb \"#b5d2ff\" dt new with linespoints,\\"    >> $CHOICE_ABORTS
    #echo  " '< join $tiny $coop_amd' u (\$0):((\$26) / (\$6)):( sprintf( '%.2fx',((\$26) / (\$6)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"AMD cooperative\" pt 2 lw 2 lc rgb col_red with linespoints,\\"   >> $CHOICE_ABORTS

    #echo  " '< join $tiny $tiny_threads' u (\$0):((\$20) / (\$4)):( sprintf( '%.2fx',((\$20) / (\$4)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validators\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" with linespoints,\\"   >> $CHOICE_ABORTS
    #echo  " '< join $tiny $tiny_threads_lsa' u (\$0):((\$20) / (\$4)):( sprintf( '%.2fx',((\$20) / (\$4)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4  validators - LSA\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" dt new1 with linespoints,\\"  >> $CHOICE_ABORTS
    ###################################################################################################################################################################################################################################################################################


    # Extract time in validation proportion
    #validation time proportion
    #echo  " '$tiny' u (\$0):(\$2/(\$16)):( sprintf( '%.2fx', (\$2/(\$16)) ) ):xtic(sprintf(\"%'d\",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl\" with linespoints pt 1 lw 3 lc rgb col_gold,\\"  >> $FILE5
    #echo  " '$tiny_lsa' u (\$0):(\$2/(\$16)):( sprintf( '%.2fx',(\$2/(\$16)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl-lsa\" with linespoints pt 1 lw 3 lc rgb col_gold dt new,\\"  >> $FILE5
    #echo  " '$coop' u (\$0):(\$2/\$30):( sprintf( '%.2fx', (\$2/\$30) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative\" pt 2 lw 3 lc rgb \"#b5d2ff\" with linespoints,\\"  >> $FILE5
    #echo  " '$coop_lsa' u (\$0):(\$2/\$30):( sprintf( '%.2fx',(\$2/\$30) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative - LSA\" pt 2 lw 3 lc rgb \"#b5d2ff\" dt new with linespoints,\\"  >> $FILE5
    #echo  " '$coop_amd' u (\$0):(\$2/\$30):( sprintf( '%.2fx',(\$2/\$30) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"AMD cooperative\" pt 2 lw 3 lc rgb col_red with linespoints,\\"  >> $FILE5
    #echo  " '$tiny_threads' u (\$0):((\$2/(\$16))):( sprintf( '%.2fx',(\$2/(\$16)) )):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validators\" pt 1 lw 3 lc rgb \"#${gray_palette[2]}\" with linespoints,\\"  >> $FILE5
    #echo  " '$tiny_threads_lsa' u (\$0):((\$2/(\$16))):( sprintf( '%.2fx',(\$2/(\$16)) )):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validators - LSA\" pt 1 lw 3 lc rgb \"#${gray_palette[2]}\" dt new1 with linespoints,\\"  >> $FILE5
    ################################################################################################################################

  done

  if [[ $i -eq 5 ]];then
    echo "set key left right left Left reverse inside bottom font\"Computer modern, 18\"" >> $FILE
  fi

  #echo "set title \"${benchmark_arr[$i]}\" font \",12\" tc rgb \"#8f8800\"" | tee -a $FILES
  echo "set title \"${benchmark_arr[$i]}\" offset 0, -1.15 font \"Computer Modern,23\"" | tee -a $FILES
  echo "plot\\"  | tee -a $FILES

  echo "'$PROGRAM' u 2:xtic(1) t \"TinySTM-wbetl\" lw 3 lc rgb col_gold with linespoints, \\" >> $FILE
  echo "'$PROGRAM' u 3:xtic(1) t \"AMD cooperative\" lw 3 lc rgb col_red with linespoints, \\" >> $FILE
  echo "'$PROGRAM' u 4:xtic(1) t \"Intel cooperative\" lw 3 lc rgb \"#1f84ff\" with linespoints, \\" >> $FILE
  echo "'$PROGRAM' u 5:xtic(1) t \"Intel coop LSA\" lw 3 dt new lc rgb \"#1f84ff\" with linespoints, \\" >> $FILE

  echo | tee -a $FILES

done

echo | tee -a $FILES

echo  "unset multiplot" | tee -a $FILES


gnuplot -p $FILE


# valreads/s
#gnuplot -p $FILE
#gnuplot -p $FILE1

# tx/s
#gnuplot -p $FILE2
#gnuplot -p $FILE3

# valreads/s intel coop disjoint vs conjoint. effects of contention on GPU help
#gnuplot -p $FILE4

#validation time proportion
#gnuplot -p $FILE5

# total aborts
#gnuplot -p $FILE6
#gnuplot -p $FILE7
