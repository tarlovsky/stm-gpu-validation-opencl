#!/bin/bash
# 100 rounds each transaction kicks its neighbour once every round
# disjoint array sets
#



#!/bin/bash

RESULTS_DIR="results-validation-array"

mkdir -p "gnuplot"

declare -a blue_palette=(" " "69a2ff" "7dafff" " " "94bdff" " " " " " " "9cc2ff" " " "adcdff" " " "b5d2ff" " " "bdd7ff")
declare -a gray_palette=(" " "000000" "696969" " " "808080" " " " " " " "A9A9A9" " " "C0C0C0" " " "D3D3D3" " " "DCDCDC" " " "696969")
declare -a all_palette=( " " "1D4599" "11AD34" " " "E69F17" " " " " " " "E62B17" " " "ff6666" " " "0033cc" " " "cc0000" " " "999966")
declare -a red_palette=( " " "F9B7B0" "E62B17" " " "8F463F" " " " " " " "6D0D03")
declare -a gold_palette=(" " "8f8d08" "a77f0e" " " "916a09" " " " " " " "914a09" " " "adcdff" " " "b5d2ff" " " "bdd7ff")
declare -a red_palette=( " " "b01313")


FILE1="gnuplot/simple-disjoint-array-lsa-utility-validation-proportion.gnuplot"
FILE2="gnuplot/simple-disjoint-array-lsa-utility-aborts.gnuplot"
FILE3="gnuplot/simple-disjoint-array-lsa-utility-tx-throughput.gnuplot"


FILES="$FILE1 $FILE2 $FILE3"

echo "set terminal wxt size 1600,550" > $FILE1
echo "set terminal wxt size 1600,550" > $FILE2
echo "set terminal wxt size 1600,550" > $FILE3
#echo "set size 1,1" >> $FILE
#echo "set origin 0,0" >> $FILE
echo "unset bmargin" | tee -a $FILES
echo "unset tmargin" | tee -a $FILES
echo "unset rmargin" | tee -a $FILES
echo "unset lmargin" | tee -a $FILES

echo "set multiplot layout 1,3 title \"array DISJOINT sets, 100 rounds, Round-Robin neighbour write / per round: TIME % SPENT IN VALIDATION\" font \",24\"" >> $FILE1
echo "set multiplot layout 1,3 title \"array DISJOINT sets, 100 rounds, Round-Robin neighbour write / per round: ABORTS/thread \" font \",24\"" >> $FILE2
echo "set multiplot layout 1,3 title \"array DISJOINT sets, 100 rounds, Round-Robin neighbour write / per round: TRANSACTIONS/s \" font \",24\"" >> $FILE3

#vars
echo "col_24=\"#c724d6\"" | tee -a $FILES
echo "col_48=\"#44cd1\"" | tee -a $FILES
echo "col_gold=\"#8f8800\"" | tee -a $FILES
echo "col_red=\"#b01313\"" | tee -a $FILES


echo "set decimal locale \"en_US.UTF-8\"; show locale" | tee -a $FILES
#echo "set datafile missing \"x\"" >> $FILE
#echo "unset ytics" >> $FILE
echo "set tics scale 0"  | tee -a $FILES

#echo "unset ytics" >> $FILE
echo "set ytics" | tee -a $FILES
echo "set grid ytics lc rgb \"#606060\"" | tee -a $FILES
echo "set grid xtics lc rgb \"#bbbbbb\"" | tee -a $FILES
echo "set ytics nomirror font \"Computer Modern, 17\" " | tee -a $FILES
#echo "set format y2 \"%0.4f\"" >> $FILE
#echo "set logscale y" | tee -a $FILES

echo "set logscale y" | tee -a $FILE2
echo "set yrange [0:0.03]" | tee -a $FILE1
echo "set yrange [1000:10000000000]" >> $FILE2
#echo "set ytics" >> $FILE2
echo "set yrange [0:2.5]" | tee -a $FILE3

echo "set format x \"%d\"" | tee -a $FILES
echo "set xtics nomirror rotate by 45 right font \"Computer Modern, 13\" " | tee -a $FILES
echo "set datafile separator whitespace" | tee -a $FILES

echo "set border lc rgb \"black\"" | tee -a $FILES
#echo "unset border" >> $FILE

echo "set style data lines" | tee -a $FILES

#echo "set xlabel \"Read-set size\""  >> $FILE
echo "set xlabel offset 0,-0.25 \"Read-set size\" font \"Computer Modern, 17\""  | tee -a $FILES

echo | tee -a $FILES
echo "new = \"-\"" | tee -a $FILES
echo "new1 = \"..\"" | tee -a $FILES
echo "new2 = \"_-_\"" | tee -a $FILES


echo "set key font \",9\"" | tee -a $FILES
#echo "set key left Left left Left inside top" | tee -a $FILES
echo "set key inside top right" | tee -a $FILES

echo "set ylabel \"TIME PROPORTION SPENT IN VALIDATION\"" | tee -a $FILE1
echo "set ylabel \"#ABORTS\" offset -1.4,0 font \"Computer Modern, 14\"" | tee -a $FILE2
echo "set ylabel \"\"" | tee -a $FILE3

echo  "set arrow 1 from 0, 1 to 12, 1 front nohead lc rgb \"#000000\" lw 1" | tee -a $FILE3

echo "unset key" | tee -a $FILES
#l1
echo  "set arrow from 1.8, graph 0 to 1.8, graph 1 nohead lc rgb \"#efefef\"" | tee -a $FILES
echo  "set label \"\$L1: 128KB\" at 1.9, 0.55 " | tee -a $FILES
#intelhd l3
echo  "set arrow 2 from 3.8, graph 0 to 3.8, graph 1 nohead lc rgb \"#dadada\"" | tee -a $FILES
echo  "set label 2 \"\$L3 GPU: 512KB\" at 3.9, 0.69 " | tee -a $FILES
#l2
echo  "set arrow from 4.8, graph 0 to 4.8, graph 1 nohead lc rgb \"#bebebe\"" | tee -a $FILES
echo  "set label \"\$L2: 1.024MB\" at 4.9, 0.60 " | tee -a $FILES
#l3
echo  "set arrow from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb \"#afafaf\"" | tee -a $FILES
echo  "set label \"\$L3: 8MB\" at 7.9, 0.69 " | tee -a $FILES
echo  "set title \"Only CPU, threaded validation, sequential walk\" font \",12\"" | tee -a $FILES

#  $i STM-threads
for i in 2 4 8; do

  echo "set title \"$i STM threads\" offset 0, -1.15 font \"Computer Modern,23\"" | tee -a $FILES

  if [[ $i -eq 8 ]]; then
    echo "set key right right right right inside top font \"Computer modern, 15\"" | tee -a $FILES
  fi

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

  # array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk
  # STM versions:
  # co-op-wbetl:     TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl
  # co-op-wbetl-lsa: TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa
  # tiny wbetl:      TinySTM-wbetl
  # tinySTM-wbetl-lsa:  TinySTM-wbetl-lsa
  # tinySTM-threads-wbetl:  TinySTM-threads-wbetl
  # tinySTM-threads-wbetl-lsa:  TinySTM-threads-wbetl-lsa

  #co-op multithreaded
  coop="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/$i/array-strongly-scaled-all-large-tx-shared-gpu-r99-w1-d1-RR-kick-random-walk/$i-random"
  coop_lsa="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa/$i/array-strongly-scaled-all-large-tx-shared-gpu-r99-w1-d1-RR-kick-random-walk/$i-random"

  #untouched tiny
  tiny="$RESULTS_DIR/TinySTM-wbetl/$i/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/$i-random"
  tiny_lsa="$RESULTS_DIR/TinySTM-wbetl-lsa/$i/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/$i-random"

  #cpu worker threads validating
  tiny_threads="$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/$i-random-4-workers"
  tiny_threads_lsa="$RESULTS_DIR/TinySTM-threads-wbetl-lsa/$i/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/$i-random-4-workers"


  CHOICE_VAL_PROP=$FILE1
  CHOICE_ABORTS=$FILE2
  CHOICE_TXPS=$FILE3


  # aborts/s
  echo  " '$tiny' u (\$0):(\$6/$i):( sprintf( '%.2fx', (\$6/$i) ) ):xtic(sprintf(\"%'d \", \$1, (\$1*8)/1000000)) t \"TinySTM-wbetl\" with linespoints pt 1 lw 2 lc rgb col_gold,\\"  >> $CHOICE_ABORTS
  echo  " '$tiny_lsa' u (\$0):(\$6/$i):( sprintf( '%.2fx', (\$6/$i) ) ):xtic(sprintf(\"%'d \", \$1, (\$1*8)/1000000)) t \"TinySTM-wbetl-lsa\" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\\"  >> $CHOICE_ABORTS
  # "RSET" "Validation time (s)" "stddev" "Validation time (s) CPU" "stddev" "Validation time (s) GPU" "stddev" "Commits" "stddev" "Aborts" "stddev" "Val Reads" "stddev" "CPU Val Reads" "stddev" "GPU Val Reads" "stddev" "Wasted Val Reads" "stddev" "GPU employment times" "stddev" "Val success" "stddev" "Val fail" "stddev" 26"Snapshot ext. calls" "stddev" "Energy (J)" "stddev" #30:"Total time (s)" "stddev"
  echo  " '$coop' u (\$0):(\$10/$i):( sprintf( '%.2fx',(\$10/$i) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t     \"Intel cooperative\" pt 2 lw 2 lc rgb \"#b5d2ff\" with linespoints,\\"  >> $CHOICE_ABORTS
  echo  " '$coop_lsa' u (\$0):(\$10/$i):( sprintf( '%.2fx',(\$10/$i) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative - LSA\" pt 2 lw 2 lc rgb \"#b5d2ff\" dt new with linespoints,\\"  >> $CHOICE_ABORTS

  # "RSET" "Validation time (s)" "stddev" "Commits" "stddev" "Aborts" "stddev" "Val Reads" "stddev" "Val success" "stddev" "Val fail" "stddev" "Energy (J)" "stddev" "Total time (s)" "stddev"
  echo  " '$tiny_threads' u (\$0):(\$6/$i):( sprintf( '%.2fx',(\$6/$i) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000))t \"TinySTM-wbetl 4 validators\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" with linespoints,\\"  >> $CHOICE_ABORTS
  echo  " '$tiny_threads_lsa' u (\$0):(\$6/$i):( sprintf( '%.2fx',(\$6/$i) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000))  t \"TinySTM-wbetl-lsa 4 validators\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" dt new1 with linespoints,\\"  >> $CHOICE_ABORTS
  ##########################

  # time proportion spent in validation: valtime/total_time:
  # "RSET" "Validation time (s)" "stddev" "Commits" "stddev" "Aborts" "stddev" "Val Reads" "stddev" "Val success" "stddev" "Val fail" "stddev" "Energy (J)" "stddev" "Total time (s)" "stddev"
  echo  " '$tiny' u (\$0):(\$2/(\$16*$i)):( sprintf( '%.2fx', (\$2/(\$16*$i)) ) ):xtic(sprintf(\"%'d \", \$1, (\$1*8)/1000000)) t \"TinySTM-wbetl\" with linespoints lc rgb col_gold,\\"  >> $CHOICE_VAL_PROP
  echo  " '$tiny_lsa' u (\$0):(\$2/(\$16*$i)):( sprintf( '%.2fx', (\$2/(\$16*$i)) ) ):xtic(sprintf(\"%'d \", \$1, (\$1*8)/1000000)) t \"TinySTM-wbetl-lsa\" with linespoints lc rgb col_gold dt new,\\"  >> $CHOICE_VAL_PROP
  # "RSET" "Validation time (s)" "stddev" "Validation time (s) CPU" "stddev" "Validation time (s) GPU" "stddev" "Commits" "stddev" "Aborts" "stddev" "Val Reads" "stddev" "CPU Val Reads" "stddev" "GPU Val Reads" "stddev" "Wasted Val Reads" "stddev" "GPU employment times" "stddev" "Val success" "stddev" "Val fail" "stddev" 26"Snapshot ext. calls" "stddev" "Energy (J)" "stddev" #30:"Total time (s)" "stddev"
  echo  " '$coop' u (\$0):(\$2/(\$30*$i)):( sprintf( '%.2fx',(\$2/(\$30*$i)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t     \"CPU-GPU co-op; iGPU shared (CAS compete); Blocks of 5736 on iGPU; sync on block\" lc rgb col_red        with linespoints,\\"  >> $CHOICE_VAL_PROP
  echo  " '$coop_lsa' u (\$0):(\$2/(\$30*$i)):( sprintf( '%.2fx',(\$2/(\$30*$i)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"LSA CPU-GPU co-op; iGPU shared (CAS compete); Blocks of 5736 on iGPU; sync on block\" lc rgb col_red dt new with linespoints,\\"  >> $CHOICE_VAL_PROP
  # "RSET" "Validation time (s)" "stddev" "Commits" "stddev" "Aborts" "stddev" "Val Reads" "stddev" "Val success" "stddev" "Val fail" "stddev" "Energy (J)" "stddev" "Total time (s)" "stddev"
  echo  " '$tiny_threads' u (\$0):(\$2/(\$16*$i)):( sprintf( '%.2fx',(\$2/(\$16*$i)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validation worker threads\" lc rgb \"#${gray_palette[2]}\" with linespoints,\\"  >> $CHOICE_VAL_PROP
  echo  " '$tiny_threads_lsa' u (\$0):(\$2/(\$16*$i)):( sprintf( '%.2fx',(\$2/(\$16*$i)) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"LSA; TinySTM-wbetl 4 validation worker threads\" lc rgb \"#${gray_palette[2]}\" dt new1 with linespoints,\\"  >> $CHOICE_VAL_PROP
  ##########################


  #tx/s: commits/totaltime relative to tinystm-untouched
  echo  " '< join $tiny $tiny_lsa' u (\$0):((\$20/(\$32*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$20/(\$32*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl-lsa\" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\\"  >> $CHOICE_TXPS

  echo  " '< join $tiny $coop' u (\$0):((\$24/(\$46*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$24/(\$46*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative\" pt 2 lw 2 lc rgb \"#b5d2ff\" with linespoints,\\"    >> $CHOICE_TXPS
  echo  " '< join $tiny $coop_lsa' u (\$0):((\$24/(\$46*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$24/(\$46*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"Intel cooperative - LSA\" pt 2 lw 2 lc rgb \"#b5d2ff\" dt new with linespoints,\\"    >> $CHOICE_TXPS
  echo  " '< join $tiny $coop_amd' u (\$0):((\$24/(\$46*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$24/(\$46*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"AMD cooperative\" pt 2 lw 2 lc rgb col_red with linespoints,\\"   >> $CHOICE_TXPS

  echo  " '< join $tiny $tiny_threads' u (\$0):((\$20/(\$32*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$20/(\$32*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validators\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" with linespoints,\\"   >> $CHOICE_TXPS
  echo  " '< join $tiny $tiny_threads_lsa' u (\$0):((\$20/(\$32*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$20/(\$32*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4  validators - LSA\" pt 1 lw 2 lc rgb \"#${gray_palette[2]}\" dt new1 with linespoints,\\"  >> $CHOICE_TXPS
  ###################################################################################################################################################################################################################################################################################


  echo | tee -a $FILES
done
echo | tee -a $FILES

echo  "unset multiplot" | tee -a $FILES

#gnuplot -p $FILE1
#gnuplot -p $FILE2
gnuplot -p $FILE3




