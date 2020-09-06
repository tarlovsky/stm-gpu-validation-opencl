#!/bin/bash

RESULTS_DIR="../results-validation-array"

mkdir -p "../gnuplot"

declare -a blue_palette=(" " "69a2ff" "7dafff" " " "94bdff" " " " " " " "9cc2ff" " " "adcdff" " " "b5d2ff" " " "bdd7ff")
declare -a gray_palette=(" " "000000" "696969" " " "808080" " " " " " " "A9A9A9" " " "C0C0C0" " " "D3D3D3" " " "DCDCDC" " " "696969")
declare -a all_palette=( " " "1D4599" "11AD34" " " "E69F17" " " " " " " "E62B17" " " "ff6666" " " "0033cc" " " "cc0000" " " "999966")
declare -a red_palette=( " " "F9B7B0" "E62B17" " " "8F463F" " " " " " " "6D0D03")
declare -a gold_palette=(" " "8f8d08" "a77f0e" " " "916a09" " " " " " " "914a09" " " "adcdff" " " "b5d2ff" " " "bdd7ff")
declare -a red_palette=( " " "b01313")

FILE="../gnuplot/simple-conjoint-array-lsa-validation-reads-validated.gnuplot"  #d=0
FILE1="../gnuplot/simple-disjoint-array-lsa-validation-reads-validated.gnuplot" #d=1
FILE2="../gnuplot/simple-conjoint-array-lsa-tx-throughput.gnuplot"              #d=0
FILE3="../gnuplot/simple-disjoint-array-lsa-tx-throughput.gnuplot"              #d=1
FILE4="../gnuplot/simple-array-intel-coop-contention.gnuplot"
FILE5="../gnuplot/simple-array-val-proportion.gnuplot"
FILE6="../gnuplot/simple-conjoint-array-validators.gnuplot"
FILE7="../gnuplot/simple-disjoint-array-validators.gnuplot"

FILES="$FILE $FILE1 $FILE2 $FILE3 $FILE4 $FILE5 $FILE6 $FILE7"

echo "set terminal wxt size 1400,1100" > $FILE
echo "set terminal wxt size 1400,1100" > $FILE1
echo "set terminal wxt size 1200,1250" > $FILE2
echo "set terminal wxt size 1200,1250" > $FILE3
echo "set terminal wxt size 1400,1100" > $FILE4
echo "set terminal wxt size 1400,1100" > $FILE5
echo "set terminal wxt size 1200,1250" > $FILE6
echo "set terminal wxt size 1200,1250" > $FILE7
#echo "set size 1,1" >> $FILE
#echo "set origin 0,0" >> $FILE
#echo "unset bmargin" | tee -a $FILES
#echo "set tmargin -3" | tee -a $FILES
echo "set bmargin 9" | tee -a $FILES
echo "set lmargin 7" | tee -a $FILES
#echo "set lmargin 10" >> $FILE5

#no sequential executions
echo "set multiplot layout 2,2 title \"CONJOINT set READS VALIDATED/S normalized to TinySTM-untouched-Intel\" font \"Computer Modern,20\"" >> $FILE #d=0
echo "set multiplot layout 2,2 title \"DISJOINT set READS VALIDATED/S normalized to TinySTM-untouched-Intel\" font \"Computer Modern,20\"" >> $FILE1 #d=1
echo "set multiplot layout 2,2 title \"CONJOINT set TX/S THROUGHPUT normalized to TinySTM-untouched-Intel\" font \"Computer Modern,23\"" >> $FILE2
echo "set multiplot layout 2,2 title \"DISJOINT sets TX/S THROUGHPUT normalized to TinySTM-untouched-Intel\" font \"Computer Modern,23\"" >> $FILE3
echo "set multiplot layout 2,2 title \"Contention on READS VALIDATED/S, normalized to TinySTM-untouched-Intel; INTEL-COOP - CAS COMPETE FOR IGPU\" font \",20\"" >> $FILE4
echo "set multiplot layout 2,2 title \"TIME spent in validation / Total program execution time (CONJOINT array sets)\" font \"Computer Modern,26\"" >> $FILE5
echo "set multiplot layout 2,2 title \"CONJOINT set TOTAL ABORTS normalized to TinySTM-untouched-Intel\" font \"Computer Modern,23\"" >> $FILE6 #d=0
echo "set multiplot layout 2,2 title \"DISJOINT set TOTAL ABORTS normalized to TinySTM-untouched-Intel\" font \"Computer Modern,23\"" >> $FILE7 #d=1

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

#echo "unset ytics" >> $FILE
echo "set ytics nomirror font \"Computer Modern, 22\" " | tee -a $FILES
echo "set ytics (0,0.5,1.0,1.5,2.0,2.5) " | tee -a $FILES

echo "set ytics 0.1" | tee -a $FILE2 $FILE3 $FILE5
echo "set ytics 0.2" | tee -a $FILE6 $FILE7

echo  "set arrow 1 from 0, 1 to 12, 1 front nohead lc rgb \"#000000\" lw 1" | tee -a $FILES
echo  "unset arrow 1" >> $FILE5

echo "set grid ytics lc rgb \"#606060\"" | tee -a $FILES
echo "set grid xtics lc rgb \"#bbbbbb\"" | tee -a $FILES
#echo "set format y2 \"%0.4f\"" >> $FILE
#echo "set logscale y" | tee -a $FILES

#THESE FILES CONTAIN #RV/s NORMALIZED TO TINY-UNTOUCHED
echo "set yrange [0:2.5]" | tee -a $FILE $FILE1 $FILE4 $FILE6 $FILE7

#THESE FILES CONTAIN #TX/s NORMALIZED TO TINY-UNTOUCHED
echo "set yrange [0.2:1.4]" | tee -a $FILE2 $FILE3

echo "set yrange [0:1]" >> $FILE5

echo "set format x \"%d\"" | tee -a $FILES
echo "set xtics nomirror rotate by 45 right font \"Computer Modern, 18\" " | tee -a $FILES
echo "set xtics offset 0, xlabeloffsety" | tee -a $FILES
echo "set datafile separator whitespace" | tee -a $FILES

echo "set border lc rgb \"black\"" | tee -a $FILES
#echo "unset border" >> $FILE

echo "set style data lines" | tee -a $FILES

echo "set xlabel offset 0,-2 \"Read-set size\" font \"Computer Modern, 17\""  | tee -a $FILES

echo | tee -a $FILES
echo "new = \"-\"" | tee -a $FILES
echo "new1 = \"..\"" | tee -a $FILES
echo "new2 = \"_-_\"" | tee -a $FILES

echo "unset key" | tee -a $FILES

#echo "set ylabel \"READ VALIDATED / SECOND / THREAD\"" | tee -a $FILE $FILE1
#echo "set ylabel \"TRANSACTIONS / SECOND / THREAD\"" | tee -a $FILE2 $FILE3
#echo "set ylabel \"Validation time proportion\" offset -1.4,0 font \"Computer Modern, 14\"" | tee -a $FILE5

#l1
echo  "set arrow 2 from 1.8, graph 0 to 1.8, graph 1 nohead lc rgb \"#efefef\"" | tee -a $FILES
echo  "set label 2\"\$L1: 128KB\" at 1.9, 0.24 font \"Computer Modern, 12\"" | tee -a $FILES
#intelhd l3
echo  "set arrow 3 from 3.8, graph 0 to 3.8, graph 1 nohead lc rgb \"#dadada\"" | tee -a $FILES
echo  "set label 3 \"\$L3 GPU: 512KB\" at 3.9, 0.34 font \"Computer Modern, 12\"" | tee -a $FILES
#l2
echo  "set arrow 4 from 4.8, graph 0 to 4.8, graph 1 nohead lc rgb \"#bebebe\"" | tee -a $FILES
echo  "set label 4\"\$L2: 1.024MB\" at 4.9, 0.26 font \"Computer Modern, 12\"" | tee -a $FILES
#l3
echo  "set arrow 5 from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb \"#afafaf\"" | tee -a $FILES
echo  "set label 5\"\$L3: 8MB\" at 7.9, 0.34 font \"Computer Modern, 12\"" | tee -a $FILES



echo  "set title \"Only CPU, threaded validation, sequential walk\" font \"Computer Modern, 25\"" | tee -a $FILES

#  $i STM-threads
for i in 1 2 4 8; do

  if [[ $i -eq 8 ]]; then
    echo "set key left Left left Left reverse inside top font\"Computer modern, 14\"" | tee -a $FILE $FILE1 $FILE2 $FILE3
    echo "set key left Left left Left reverse inside top font\"Computer modern, 16\"" | tee -a $FILE4
  fi

  ###### file 5 only ######
  if [[ $i -eq 2 ]]; then
    echo "set key left Left left Left reverse inside top font\"Computer modern, 12\"" | tee -a $FILE5
    echo "unset label 2" >> $FILE5
    echo "unset label 3" >> $FILE5
    echo "unset label 4" >> $FILE5
    echo "unset label 5" >> $FILE5
  else
    echo "unset key" >> $FILE5
    ####################################################################################################
    #FILE5
    echo  "set arrow 2 from 1.8, graph 0 to 1.8, graph 1 nohead lc rgb \"#efefef\"" >> $FILE5
    echo  "set label 2\"\$L1: 128KB\" at 1.9, 0.88 font \"Computer Modern, 14\"" >> $FILE5
    #intelhd l3
    echo  "set arrow 3 from 3.8, graph 0 to 3.8, graph 1 nohead lc rgb \"#dadada\"" >> $FILE5
    echo  "set label 3 \"\$L3 GPU: 512KB\" at 3.9, 0.96 font \"Computer Modern, 14\"" >> $FILE5
    #l2
    echo  "set arrow 4 from 4.8, graph 0 to 4.8, graph 1 nohead lc rgb \"#bebebe\"" >> $FILE5
    echo  "set label 4\"\$L2: 1.024MB\" at 4.9, 0.90 font \"Computer Modern, 14\"" >> $FILE5
    #l3
    echo  "set arrow 5 from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb \"#afafaf\"" >> $FILE5
    echo  "set label 5\"\$L3: 8MB\" at 7.9, 0.96 font \"Computer Modern, 14\"" >> $FILE5
    ####################################################################################################
  fi

  if [[ $i -eq 1 ]]; then
    echo "set key left Left left Left reverse inside top font\"Computer modern, 16\"" | tee -a $FILE6 $FILE7
  else
    echo "unset key" | tee -a $FILE6 $FILE7
  fi

  echo "set title \"$i STM threads\" offset 0, -1.15 font \"Computer Modern,23\"" | tee -a $FILES
  echo  "plot \\"  | tee -a $FILES
  ################################################################# FILE 0 #################################################################
  #  READS VALIDATED

  #  in tinystm untouched file
  #  $2 = valtime
  #  $8 = valreads tiny

  #  in co-op file
  #  12 valreads
  #  14 CPU VAL READS
  #  16 GPU VAL READS
  #  14+16=val enters
  #  18 WASTED VAL READS
  #  20 GPU employment times
  #  22 Val success
  #  24 Val fail
  #  28 total time

  # ONLY WORK WITH RANDOM ACCESS, SEQUENTIAL CPU WINS ALL THE TIME
  # D=1 disjoint array r/w sets
  # D=1 conjoint array r/w sets; all threads write into the same RSET size array with 100 tx in array-strongly-scaled
  for D in 0 1; do
    # D=1
    # dynamic co-op cpu, igpu
    #f sticky gpu thread to stm thread 0
    #f="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/$i/array-strongly-scaled-sticky-thread-r99-w1-d$D-random-walk/$i-random"

    #intel shared gpu
    coop="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/$i/array-strongly-scaled-shared-gpu-r99-w1-d$D-random-walk/$i-random"
    coop_lsa="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa/$i/array-strongly-scaled-shared-gpu-r99-w1-d$D-random-walk/$i-random"

    #amd shared gpu
    coop_amd="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-amd-wbetl/$i/array-strongly-scaled-shared-gpu-r99-w1-d$D-random-walk/$i-random"

    #untouched tiny
    tiny="$RESULTS_DIR/TinySTM-wbetl/$i/array-strongly-scaled-r99-w1-d$D-random-walk/$i-random"
    tiny_lsa="$RESULTS_DIR/TinySTM-wbetl-lsa/$i/array-strongly-scaled-r99-w1-d$D-random-walk/$i-random"

    #4 worker threads validating
    tiny_threads="$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-strongly-scaled-r99-w1-d$D-random-walk/$i-random-4-workers"
    tiny_threads_lsa="$RESULTS_DIR/TinySTM-threads-wbetl-lsa/$i/array-strongly-scaled-r99-w1-d$D-random-walk/$i-random-4-workers"

    ################################################################################################################################
    # Extract time in validation proportion

    ################################################################################################################################

    # junction between disjoint and conjoint files
    if [[ $D -eq 0 ]]; then
      #conjoint array walk
      CHOICE_VALREADS=$FILE
      CHOICE_TXPS=$FILE2
      CHOICE_ABORTS=$FILE6
    else
      #disjoint array walk
      CHOICE_VALREADS=$FILE1
      CHOICE_TXPS=$FILE3
      CHOICE_ABORTS=$FILE7
    fi


    # readsval/s relative to tinystm-untouched
    # divide what you want over TINYSTM fields
    # tiny comes to the left; what you want to the right
    # Because this is normalized, the per thread (*$i) is redundant. keep it for future formulas.
    echo  " '< join $tiny $tiny_lsa' u (\$0):((\$24/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$24/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl-lsa\" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\\"  >> $CHOICE_VALREADS

    echo  " '< join $tiny $coop' u (\$0):((\$28/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$28/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"Intel CPU-GPU co-op; GPU CAS; Blocks of 5736; sync on block\" pt 2 lw 2 lc rgb \"#b5d2ff\" with linespoints,\\"  >> $CHOICE_VALREADS
    echo  " '< join $tiny $coop_lsa' u (\$0):((\$28/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$28/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"Intel CPU-GPU co-op; GPU CAS; Blocks of 5736; sync on block; LSA\" pt 2 lw 2 lc rgb \"#b5d2ff\" dt new with linespoints,\\"  >> $CHOICE_VALREADS
    echo  " '< join $tiny $coop_amd' u (\$0):((\$28/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$28/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"AMD CPU-GPU co-op; GPU CAS; Blocks of 11264; sync on block\" pt 2 lw 2 lc rgb col_red with linespoints,\\"  >> $CHOICE_VALREADS

    echo  " '< join $tiny $tiny_threads' u (\$0):((\$24/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$24/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validation worker threads\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" with linespoints,\\"  >> $CHOICE_VALREADS
    echo  " '< join $tiny $tiny_threads_lsa' u (\$0):((\$24/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$24/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validation worker threads LSA\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" dt new1 with linespoints,\\"  >> $CHOICE_VALREADS
    ###################################################################################################################################################################################################################################################################################

    #tx/s: commits/totaltime relative to tinystm-untouched
    echo  " '< join $tiny $tiny_lsa' u (\$0):((\$20/(\$32*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$20/(\$32*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl-lsa\" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\\"  >> $CHOICE_TXPS

    echo  " '< join $tiny $coop' u (\$0):((\$24/(\$46*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$24/(\$46*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative\" pt 2 lw 2 lc rgb \"#b5d2ff\" with linespoints,\\"    >> $CHOICE_TXPS
    echo  " '< join $tiny $coop_lsa' u (\$0):((\$24/(\$46*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$24/(\$46*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative - LSA\" pt 2 lw 2 lc rgb \"#b5d2ff\" dt new with linespoints,\\"    >> $CHOICE_TXPS
    echo  " '< join $tiny $coop_amd' u (\$0):((\$24/(\$46*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$24/(\$46*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"AMD cooperative\" pt 2 lw 2 lc rgb col_red with linespoints,\\"   >> $CHOICE_TXPS

    echo  " '< join $tiny $tiny_threads' u (\$0):((\$20/(\$32*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$20/(\$32*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validators\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" with linespoints,\\"   >> $CHOICE_TXPS
    echo  " '< join $tiny $tiny_threads_lsa' u (\$0):((\$20/(\$32*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$20/(\$32*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4  validators - LSA\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" dt new1 with linespoints,\\"  >> $CHOICE_TXPS
    ###################################################################################################################################################################################################################################################################################

    #TOTAL ABORTS relative to tinystm-untouched
    echo  " '< join $tiny $tiny_lsa' u (\$0):((\$20) / (\$4)):( sprintf( '%.2fx',((\$20) / (\$6)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl-lsa\" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\\"  >> $CHOICE_ABORTS

    echo  " '< join $tiny $coop' u (\$0):((\$26) / (\$6)):( sprintf( '%.2fx',((\$26) / (\$6)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative\" pt 2 lw 2 lc rgb \"#b5d2ff\" with linespoints,\\"    >> $CHOICE_ABORTS
    echo  " '< join $tiny $coop_lsa' u (\$0):((\$26) / (\$6)):( sprintf( '%.2fx',((\$26) / (\$6)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative - LSA\" pt 2 lw 2 lc rgb \"#b5d2ff\" dt new with linespoints,\\"    >> $CHOICE_ABORTS
    echo  " '< join $tiny $coop_amd' u (\$0):((\$26) / (\$6)):( sprintf( '%.2fx',((\$26) / (\$6)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"AMD cooperative\" pt 2 lw 2 lc rgb col_red with linespoints,\\"   >> $CHOICE_ABORTS

    echo  " '< join $tiny $tiny_threads' u (\$0):((\$20) / (\$4)):( sprintf( '%.2fx',((\$20) / (\$4)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validators\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" with linespoints,\\"   >> $CHOICE_ABORTS
    echo  " '< join $tiny $tiny_threads_lsa' u (\$0):((\$20) / (\$4)):( sprintf( '%.2fx',((\$20) / (\$4)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4  validators - LSA\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" dt new1 with linespoints,\\"  >> $CHOICE_ABORTS
    ###################################################################################################################################################################################################################################################################################

    if [[ $D -eq 1 ]];then #do this once
      #validation time proportion
      echo  " '$tiny' u (\$0):(\$2/(\$16)):( sprintf( '%.2fx', (\$2/(\$16)) ) ):xtic(sprintf(\"%'d\",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl\" with linespoints pt 1 lw 3 lc rgb col_gold,\\"  >> $FILE5
      echo  " '$tiny_lsa' u (\$0):(\$2/(\$16)):( sprintf( '%.2fx',(\$2/(\$16)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl-lsa\" with linespoints pt 1 lw 3 lc rgb col_gold dt new,\\"  >> $FILE5
      echo  " '$coop' u (\$0):(\$2/\$30):( sprintf( '%.2fx', (\$2/\$30) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative\" pt 2 lw 3 lc rgb \"#b5d2ff\" with linespoints,\\"  >> $FILE5
      echo  " '$coop_lsa' u (\$0):(\$2/\$30):( sprintf( '%.2fx',(\$2/\$30) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative - LSA\" pt 2 lw 3 lc rgb \"#b5d2ff\" dt new with linespoints,\\"  >> $FILE5
      echo  " '$coop_amd' u (\$0):(\$2/\$30):( sprintf( '%.2fx',(\$2/\$30) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"AMD cooperative\" pt 2 lw 3 lc rgb col_red with linespoints,\\"  >> $FILE5
      echo  " '$tiny_threads' u (\$0):((\$2/(\$16))):( sprintf( '%.2fx',(\$2/(\$16)) )):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validators\" pt 1 lw 3 lc rgb \"#${gray_palette[2]}\" with linespoints,\\"  >> $FILE5
      echo  " '$tiny_threads_lsa' u (\$0):((\$2/(\$16))):( sprintf( '%.2fx',(\$2/(\$16)) )):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validators - LSA\" pt 1 lw 3 lc rgb \"#${gray_palette[2]}\" dt new1 with linespoints,\\"  >> $FILE5

      ######## FILE 4 - contention compare for d vs c ########
      # tx/s #
      ########
      coop_d="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/$i/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/$i-random"
      coop_c="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/$i/array-strongly-scaled-shared-gpu-r99-w1-d0-random-walk/$i-random"
      echo  " '< join $tiny $coop_d' u (\$0):((\$28/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$28/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"No contention (disjoint arrays)\" pt 2 lw 2 lc rgb \"#94bdff\" dt new with linespoints,\\"  >> $FILE4
      echo  " '< join $tiny $coop_c' u (\$0):((\$28/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$28/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"Medium contention (conjoint array)\" pt 2 lw 2 lc rgb \"#94bdff\" with linespoints,\\"  >> $FILE4
    fi

    #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-4-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 4 validation worker / STM thread\" dt new1 lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE
  done

  #unmodified TINYSTM
  #echo  " '$tiny' u (\$0):(((\$2)>0)?( ((\$8/(\$2*$i)))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-unaltered\" lw 2 lc rgb \"#${gold_palette[$i]}\",\\"  >> $FILE

  ################################################################# FILE 1 #################################################################
  # TX / S

  # dynamic co-op between cpu and igpu
  # sticky thread to 0
  #echo  " '$f' \\" >> $FILE2
  #echo  "  u (\$0):(((\$28)>0)?(((\$8/((\$28*$i))))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU-GPU co-op; iGPU sticky thread (thread 0); blocks of 5736 on iGPU; sync on block\" lc rgb \"#${all_palette[$i]}\",\\"  >> $FILE2

  #shared - gpu
  #echo  " '$coop' \\" >> $FILE2
  #echo  "  u (\$0):(((\$28)>0)?(((\$8/((\$28*$i))))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU-GPU co-op; iGPU shared GPU (iGPU CAS pinballing); blocks of 5736 on iGPU; sync on block\" dt new lc rgb \"#${all_palette[$i]}\",\\"  >> $FILE2

  # NO GPU FILE LEGEND
  # 8 valreads
  # 10+12 = val enters
  # AUTO-SCHED MULTI-THREADED
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-8-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 8 validation worker / STM thread\" lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE1
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validatCHOICE_ABORTSion-4-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 4 validation worker / STM thread\" dt new1 lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE1
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-2-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 2 validation worker / STM thread\" dt new lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE1

  #transactional throughput improvement of f1 over untouched
  #echo  "  '< join $tiny $coop' u (\$0+0.0055):(0.1):(sprintf('%.2fx', ( (\$24/(\$44*$i)) / (\$4/(\$16*$i)) ) )) t \"\" w labels offset char 0,char -0.66 font \",9\", \\"  >> $FILE2

  #unmodified TINYSTM
  # $16 - total time
  # $4 - commits
  #echo  " '$RESULTS_DIR/TinySTM-wbetl/$i/array-strongly-scaled-r99-w1-d1-random-walk/$i-random' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil((\$10+\$12)*\$2*$i))))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-unaltered\" lw 2 lc rgb \"#${gold_palette[$i]}\",\\"  >> $FILE1
  #echo " '$RESULTS_DIR/TinySTM-wbetl/$i/array-strongly-scaled-r99-w1-d1-random-walk/$i-random' u (\$0):(((\$16)>0)?( ((\$4/(\$16*$i)))):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-unaltered\" lw 2 lc rgb \"#${gold_palette[$i]}\",\\"  >> $FILE2


  echo | tee -a $FILES
done
echo | tee -a $FILES

echo  "unset multiplot" | tee -a $FILES

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
gnuplot -p $FILE6
gnuplot -p $FILE7
