#!/bin/bash

RESULTS_DIR="results-validation-array"

mkdir -p "gnuplot"

declare -a blue_palette=(" " "69a2ff" "7dafff" " " "94bdff" " " " " " " "9cc2ff" " " "adcdff" " " "b5d2ff" " " "bdd7ff")
declare -a gray_palette=(" " "000000" "696969" " " "808080" " " " " " " "A9A9A9" " " "C0C0C0" " " "D3D3D3" " " "DCDCDC" " " "696969")
declare -a all_palette=( " " "1D4599" "11AD34" " " "E69F17" " " " " " " "E62B17" " " "ff6666" " " "0033cc" " " "cc0000" " " "999966")
declare -a red_palette=( " " "F9B7B0" "E62B17" " " "8F463F" " " " " " " "6D0D03")
declare -a gold_palette=(" " "8f8d08" "a77f0e" " " "916a09" " " " " " " "914a09" " " "adcdff" " " "b5d2ff" " " "bdd7ff")
declare -a red_palette=( " " "b01313")

FILE="gnuplot/simple-array-multithreaded-validation-reads-validated.gnuplot"
FILE1="gnuplot/simple-array-multithreaded-tx-throughput.gnuplot"
FILES="$FILE $FILE1"

echo "set terminal wxt size 1400,1100" > $FILE
echo "set terminal wxt size 1400,1100" > $FILE1
#echo "set size 1,1" >> $FILE
#echo "set origin 0,0" >> $FILE
echo "unset bmargin" | tee -a $FILES
echo "unset tmargin" | tee -a $FILES
echo "unset rmargin" | tee -a $FILES
echo "unset lmargin" | tee -a $FILES

echo "set multiplot layout 2,2 title \"Disjoint array walk: READS VALIDATED / THREAD / SECOND (THROUGHPUT) \" font \",14\"" >> $FILE
echo "set multiplot layout 2,2 title \"Disjoint array walk: TRANSACTIONAL THROUGHPUT MULTITHREADED STM - SHARED IGPU\" font \",14\"" >> $FILE1

#vars
echo "col_24=\"#c724d6\"" | tee -a $FILES
echo "col_48=\"#44cd1\"" | tee -a $FILES
echo "col_gold=\"#8f8800\"" | tee -a $FILES
echo "xlabeloffsety=-0.75" | tee -a $FILES

echo "set decimal locale \"en_US.UTF-8\"; show locale" | tee -a $FILES
#echo "set datafile missing \"x\"" >> $FILE
#echo "unset ytics" >> $FILE
echo "set tics scale 0"  | tee -a $FILES
#echo "set xtics nomirror rotate by 45 right scale 0 font \",8\"" >> $FILE
#echo "unset ytics" >> $FILE
echo "set ytics" | tee -a $FILES
echo "set grid ytics lc rgb \"#606060\"" | tee -a $FILES
#echo "set format y2 \"%0.4f\"" >> $FILE
echo "set logscale y" | tee -a $FILES

echo "set yrange [100000:10000000000]" >> $FILE

echo "set format x \"%d\"" | tee -a $FILES
echo "set xtics nomirror rotate by 45 right font \"Verdana,10\" " | tee -a $FILES
echo "set xtics offset 0, xlabeloffsety" | tee -a $FILES
echo "set datafile separator whitespace" | tee -a $FILES

echo "set border lc rgb \"black\"" | tee -a $FILES
#echo "unset border" >> $FILE

echo "set style data lines" | tee -a $FILES

#echo "set xlabel \"Read-set size\""  >> $FILE

echo | tee -a $FILES
echo "new = \"-\"" | tee -a $FILES
echo "new1 = \"..\"" | tee -a $FILES
echo "new2 = \"_-_\"" | tee -a $FILES


echo "set key font \",9\"" | tee -a $FILES
#echo "set key left Left left Left inside top" | tee -a $FILES
echo "set key inside top right" | tee -a $FILES


echo "set ylabel \"READS VALIDATED / THREAD / SECOND\"" >> $FILE
echo "set ylabel \"TRANSACTIONS / SECOND\"" >> $FILE1
#echo "unset key" >> $FILE
#l1
echo  "set arrow from 1.8, graph 0 to 1.8, graph 1 nohead lc rgb \"#efefef\"" >> $FILE
echo  "set label \"\$L1: 128KB\" at 1.9, 100000+100000*0.50 " >> $FILE
#intelhd l3
echo  "set arrow 2 from 3.8, graph 0 to 3.8, graph 1 nohead lc rgb \"#dadada\"" >> $FILE
echo  "set label 2 \"\L3 GPU: 512KB\" at 3.9, 100000+100000*2 " >> $FILE
#l2
echo  "set arrow from 4.8, graph 0 to 4.8, graph 1 nohead lc rgb \"#bebebe\"" >> $FILE
echo  "set label \"\$L2: 1.024MB\" at 4.9, 100000+100000*0.75 " >> $FILE
#l3
echo  "set arrow from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb \"#afafaf\"" >> $FILE
echo  "set label \"\$L3: 8MB\" at 7.9, 100000+100000*2 " >> $FILE
echo  "set title \"Only CPU, threaded validation, sequential walk\" font \",12\"" >> $FILE

#  $i STM-threads
for i in 1 2 4 8; do
  echo "set title \"$i STM threads\" font \",12\"" | tee -a $FILES
  echo  "plot \\"  | tee -a $FILES

  #  with GPU FILE LEGEND
  #  $2 = valtime
  #  $i STM-threads
  #  12 valreads
  #  14 CPU VAL READS
  #  16 GPU VAL READS
  #  14+16=val enters
  #  18 WASTED VAL READS
  #  20 GPU employment times
  #  22 Val success
  #  24 Val fail
  #  28 total time

  # dynamic co-op between cpu and igpu
  #f sticky gpu thread
  f="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/$i/array-strongly-scaled-sticky-thread-r99-w1-d1-random-walk/$i-random"
  #f1 shared gpu
  f1="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/$i/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/$i-random"
  #untouched tiny
  ftiny="$RESULTS_DIR/TinySTM-wbetl/$i/array-strongly-scaled-r99-w1-d1-random-walk/$i-random"

  # sticky thread to 0
  echo  " '$f' u (\$0):(((\$2)>0)?(((\$12/((\$2*$i))))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU-GPU co-op; iGPU sticky thread (thread 0); blocks of 5736 on iGPU; sync on block\" lc rgb \"#${all_palette[$i]}\",\\"  >> $FILE
  #test
  #echo  "  '< join $f $f1'  u (\$0+0.0055):((\$12/(\$2*$i))):(sprintf('%d,%d', (\$40/(\$30*$i)), (\$12/((\$2*$i))) )) t \"\" w labels  font \",9\" rotate by 45 right, \\"  >> $FILE

  #shared - gpu
  echo  " '$f1' u (\$0):(((\$2)>0)?(((\$12/((\$2*$i))))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU-GPU co-op; iGPU shared GPU (iGPU CAS pinballing); blocks of 5736 on iGPU; sync on block\" dt new lc rgb \"#${all_palette[$i]}\",\\"  >> $FILE

  #custom xtic labels with how much CAS is better than tinystm untouched
  echo  "  '< join $ftiny $f1' u (\$0):(1+100000):(sprintf('%.2fx', ( (\$28/(\$18*$i))>(\$8/(\$2*$i)) ) ? ( (\$28/(\$18*$i)) / (\$8/(\$2*$i)) ):0 )) t \"\" w labels offset char 0,char -0.66 font \",9\", \\"  >> $FILE
  #echo  "  '< join $ftiny $f'  u (\$0):(1+500000):(sprintf('%.2fx', ( (\$28/(\$18*$i))>(\$8/(\$2*$i)) ) ? ( (\$28/(\$18*$i)) / (\$8/(\$2*$i)) ):0 )) t \"\" w labels offset char 0,char -0.66 font \",9\", \\"  >> $FILE
  #echo  "  '< join $f $f1'  u (\$0):(1+100000):(sprintf('%.2fx', ( (\$40/(\$30*$i))>(\$12/(\$2*$i)) ) ? ( (\$40/(\$30*$i)) / (\$12/(\$2*$i)) ):0 )) t \"\" w labels offset char 0,char -0.66 font \",9\", \\"  >> $FILE

  # NO-GPU FILE LEGEND
  # 8 valreads
  # 10+12 = val enters
  # AUTO-SCHED MULTI-THREADED
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-8-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 8 validation worker / STM thread\" lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-4-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 4 validation worker / STM thread\" dt new1 lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-2-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 2 validation worker / STM thread\" dt new lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE

  #unmodified TINYSTM
  #echo  " '$RESULTS_DIR/TinySTM-wbetl/$i/array-strongly-scaled-r99-w1-d1-random-walk/$i-random' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil((\$10+\$12)*\$2*$i))))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-unaltered\" lw 2 lc rgb \"#${gold_palette[$i]}\",\\"  >> $FILE
  echo  " '$ftiny' u (\$0):(((\$2)>0)?( ((\$8/(\$2*$i)))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-unaltered\" lw 2 lc rgb \"#${gold_palette[$i]}\",\\"  >> $FILE

  ################################################################# FILE 2 #################################################################

  # $8 - commits
  # $28 - total time
  # dynamic co-op between cpu and igpu
  # sticky thread to 0
  echo  " '$f' \\" >> $FILE1
  echo  "  u (\$0):(((\$28)>0)?(((\$8/((\$28*$i))))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU-GPU co-op; iGPU sticky thread (thread 0); blocks of 5736 on iGPU; sync on block\" lc rgb \"#${all_palette[$i]}\",\\"  >> $FILE1

  #shared - gpu
  echo  " '$f1' \\" >> $FILE1
  echo  "  u (\$0):(((\$28)>0)?(((\$8/((\$28*$i))))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU-GPU co-op; iGPU shared GPU (iGPU CAS pinballing); blocks of 5736 on iGPU; sync on block\" dt new lc rgb \"#${all_palette[$i]}\",\\"  >> $FILE1

  # NO GPU FILE LEGEND
  # 8 valreads
  # 10+12 = val enters
  # AUTO-SCHED MULTI-THREADED
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-8-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 8 validation worker / STM thread\" lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE1
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-4-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 4 validation worker / STM thread\" dt new1 lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE1
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-2-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 2 validation worker / STM thread\" dt new lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE1

  #transactional throughput improvement of f1 over untouched
  echo  "  '< join $ftiny $f1' u (\$0+0.0055):(0.1):(sprintf('%.2fx', ( (\$24/(\$44*$i)) / (\$4/(\$16*$i)) ) )) t \"\" w labels offset char 0,char -0.66 font \",9\", \\"  >> $FILE1

  #unmodified TINYSTM
  # $16 - total time
  # $4 - commits
  #echo  " '$RESULTS_DIR/TinySTM-wbetl/$i/array-strongly-scaled-r99-w1-d1-random-walk/$i-random' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil((\$10+\$12)*\$2*$i))))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-unaltered\" lw 2 lc rgb \"#${gold_palette[$i]}\",\\"  >> $FILE1
  echo " '$RESULTS_DIR/TinySTM-wbetl/$i/array-strongly-scaled-r99-w1-d1-random-walk/$i-random' u (\$0):(((\$16)>0)?( ((\$4/(\$16*$i)))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-unaltered\" lw 2 lc rgb \"#${gold_palette[$i]}\",\\"  >> $FILE1
  echo | tee -a $FILES
done
echo | tee -a $FILES

echo  "unset multiplot" | tee -a $FILES

gnuplot -p $FILE
gnuplot -p $FILE1


