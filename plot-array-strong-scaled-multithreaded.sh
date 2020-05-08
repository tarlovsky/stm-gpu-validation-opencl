#!/bin/bash

RESULTS_DIR="results-validation-array"

mkdir -p "gnuplot"
####################################################################################################################################################

declare -a blue_palette=(" " "69a2ff" "7dafff" " " "94bdff" " " " " " " "9cc2ff" " " "adcdff" " " "b5d2ff" " " "bdd7ff")
declare -a gray_palette=(" " "000000" "696969" " " "808080" " " " " " " "A9A9A9" " " "C0C0C0" " " "D3D3D3" " " "DCDCDC" " " "696969")
declare -a all_palette=( " " "1D4599" "11AD34" " " "E69F17" " " " " " " "E62B17" " " "ff6666" " " "0033cc" " " "cc0000" " " "999966")
declare -a red_palette=( " " "F9B7B0" "E62B17" " " "8F463F" " " " " " " "6D0D03")
declare -a gold_palette=(" " "8f8d08" "a77f0e" " " "916a09" " " " " " " "914a09" " " "adcdff" " " "b5d2ff" " " "bdd7ff")
declare -a red_palette=( " " "b01313")
FILE="gnuplot/simple-array-multithreaded-validation-reads-validated.gnuplot"

echo "set terminal wxt size 1400,1100" > $FILE
#echo "set size 1,1" >> $FILE
#echo "set origin 0,0" >> $FILE
echo "unset bmargin" >> $FILE
echo "unset tmargin" >> $FILE
echo "unset rmargin" >> $FILE
echo "unset lmargin" >> $FILE

#echo "set multiplot layout 2,2 title \"Disjoint array walk: READS VALIDATED PER SECOND (THROUGHPUT) - \" font \",14\"" >> $FILE
echo "set decimal locale \"en_US.UTF-8\"; show locale" >> $FILE
#echo "set datafile missing \"x\"" >> $FILE
#echo "unset ytics" >> $FILE
echo "set tics scale 0"  >> $FILE
#echo "set xtics nomirror rotate by 45 right scale 0 font \",8\"" >> $FILE
#echo "unset ytics" >> $FILE
echo "set ytics" >> $FILE
echo "set grid ytics lc rgb \"#606060\"" >> $FILE
#echo "set format y2 \"%0.4f\"" >> $FILE
#echo "set logscale y" >> $FILE
#echo "set yrange [10000000:100000000]" >> $FILE
echo "set yrange [0:0.06]" >> $FILE

echo "set format x \"%d\"" >> $FILE
echo "set xtics nomirror rotate by 45 right font \"Verdana,10\" " >> $FILE
echo "set datafile separator whitespace" >> $FILE

echo "set border lc rgb \"black\"" >> $FILE
#echo "unset border" >> $FILE

echo "set style data lines" >> $FILE

#echo "set xlabel \"Read-set size\""  >> $FILE

echo >> $FILE
echo "new = \"-\"" >> $FILE
echo "new1 = \"..\"" >> $FILE
echo "new2 = \"_-_\"" >> $FILE

echo "col_24=\"#c724d6\"" >> $FILE
echo "col_48=\"#44cd1\"" >> $FILE
echo "col_gold=\"#8f8800\"" >> $FILE

echo "set key font \",9\"" >> $FILE
#echo "set key left Left left Left inside top" >> $FILE
echo "set key inside top right" >> $FILE


echo "set ylabel \"READS VALIDATED / SECOND\""  >> $FILE
#echo "unset key" >> $FILE
#l1
echo  "set arrow from 1.8, graph 0 to 1.8, graph 1 nohead lc rgb \"#efefef\"" >> $FILE
echo  "set label \"\$L1: 128KB\" at 1.9, 10000000 " >> $FILE
#l2
echo  "set arrow from 4.8, graph 0 to 4.8, graph 1 nohead lc rgb \"#bebebe\"" >> $FILE
echo  "set label \"\$L2: 1.024MB\" at 4.9, 10000000+10000000*0.50 " >> $FILE
#l3
echo  "set arrow from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb \"#afafaf\"" >> $FILE
echo  "set label \"\$L3: 8MB\" at 7.9, 10000000+10000000*2 " >> $FILE
echo  "set title \"Only CPU, threaded validation, sequential walk\" font \",12\"" >> $FILE

##############################################################################################################################################################################
echo "set title \"$i STM threads\" font \",12\"" >> $FILE
  echo  "plot \\"  >> $FILE
#  $i STM-threads
for i in 1 2 4 8;do

  # \$2 = valtime
  #  $i STM-threads

  # 12 valreads
  # 14+16=val enters

  #  12 valreads
  #  14 CPU VAL READS
  #  16 GPU VAL READS
  #  18 WASTED VAL READS
  #  20 GPU employment times
  #  22 Val success
  #  24 Val fail
  # dynamic co-op between cpu and igpu
  echo  " '$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/$i/array-strongly-scaled-sticky-thread-r99-w1-d1-random-walk/$i-random' \\" >> $FILE
  #reads validated / validation call / second  (valreads/((valcalls)*valtime)) / threads
  #echo  "  u (\$0):((((\$22+\$24)*\$2)>0)?(((\$12/(ceil(\$22+\$24)*\$2*$i)))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU-GPU co-op; iGPU sticky thread (thread 0); blocks of 5736 on iGPU; sync on block\" lc rgb \"#b01313\",\\"  >> $FILE
  #reads validated / second
  # 28 - total time
  echo  "  u (\$0):(((\$2)>0)?(((\$6/((\$28))))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"$i threads\" lc rgb \"#${all_palette[$i]}\",\\"  >> $FILE

  #time spent in validation per thread
  #echo  "  u (\$0):(((\$2)>0)?(((((\$2))))/$i):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU-GPU co-op; iGPU sticky thread (thread 0); blocks of 5736 on iGPU; sync on block\" lc rgb \"#b01313\",\\"  >> $FILE

  #  8 valreads
  #  10+12 = val enters
  #(((\$10+\$12)>0)?(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):(NaN))
  #                                     (\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)
  # (/$i) can be simplified out but the formula is harder to explain
  #AUTO-SCHED MULTI-THREADED
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-8-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 8 validation worker / STM thread\" lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-4-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 4 validation worker / STM thread\" dt new1 lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-2-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 2 validation worker / STM thread\" dt new lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE

  #unmodified TINYSTM
  #echo  " '$RESULTS_DIR/TinySTM-wbetl/$i/array-strongly-scaled-r99-w1-d1-random-walk/$i-random' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil((\$10+\$12)*\$2*$i))))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-unaltered\" lw 2 lc rgb \"#${gold_palette[$i]}\",\\"  >> $FILE
  #echo  " '$RESULTS_DIR/TinySTM-wbetl/$i/array-strongly-scaled-r99-w1-d1-random-walk/$i-random' u (\$0):(((\$2)>0)?( ((\$8/(\$2*$i)))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-unaltered\" lw 2 lc rgb \"#${gold_palette[$i]}\",\\"  >> $FILE
  #echo >> $FILE
done
echo >> $FILE
#echo  "unset multiplot" >> $FILE



gnuplot -p $FILE


