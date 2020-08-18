#!/bin/bash

RESULTS_DIR="results-validation-array"

mkdir -p "gnuplot"

declare -a blue_palette=(" " "69a2ff" "7dafff" " " "94bdff" " " " " " " "9cc2ff" " " "adcdff" " " "b5d2ff" " " "bdd7ff")
declare -a gray_palette=(" " "000000" "696969" " " "808080" " " " " " " "A9A9A9" " " "C0C0C0" " " "D3D3D3" " " "DCDCDC" " " "696969")
declare -a all_palette=( " " "1D4599" "11AD34" " " "E69F17" " " " " " " "E62B17" " " "ff6666" " " "0033cc" " " "cc0000" " " "999966")
declare -a red_palette=( " " "F9B7B0" "E62B17" " " "8F463F" " " " " " " "6D0D03")
declare -a gold_palette=(" " "8f8d08" "a77f0e" " " "916a09" " " " " " " "914a09" " " "adcdff" " " "b5d2ff" " " "bdd7ff")
declare -a red_palette=( " " "b01313")

FILE="gnuplot/simple-conjoint-array-lsa-validation-reads-validated.gnuplot"  #d=0
FILE1="gnuplot/simple-disjoint-array-lsa-validation-reads-validated.gnuplot" #d=1
FILE2="gnuplot/simple-conjoint-array-lsa-tx-throughput.gnuplot"              #d=0
FILE3="gnuplot/simple-disjoint-array-lsa-tx-throughput.gnuplot"              #d=1

FILES="$FILE $FILE1 $FILE2 $FILE3"

echo "set terminal wxt size 1400,1100" > $FILE
echo "set terminal wxt size 1400,1100" > $FILE1
echo "set terminal wxt size 1400,1100" > $FILE2
echo "set terminal wxt size 1400,1100" > $FILE3
#echo "set size 1,1" >> $FILE
#echo "set origin 0,0" >> $FILE
echo "unset bmargin" | tee -a $FILES
echo "unset tmargin" | tee -a $FILES
echo "unset rmargin" | tee -a $FILES
echo "unset lmargin" | tee -a $FILES

#no sequential executions
echo "set multiplot layout 2,2 title \"CONJOINT array walk STRONGLY scaled: ABORTS / THREAD / SECOND\" font \",14\"" >> $FILE #d=0
echo "set multiplot layout 2,2 title \"DISJOINT array walk STRONGLY scaled: ABORTS / THREAD / SECOND\" font \",14\"" >> $FILE1 #d=1
echo "set multiplot layout 2,2 title \"CONJOINT array walk STRONGLY scaled: TRANSACTIONAL THROUGHPUT NORMALIZED TO TINYSTM-UNTOUCHED; MULTITHREADED STM - CAS COMPETE FOR IGPU\" font \",13\"" >> $FILE2
echo "set multiplot layout 2,2 title \"DISJOINT array walk STRONGLY scaled: TRANSACTIONAL THROUGHPUT NORMALIZED TO TINYSTM-UNTOUCHED; MULTITHREADED STM - CAS COMPETE FOR IGPU\" font \",13\"" >> $FILE3

#vars
echo "col_24=\"#c724d6\"" | tee -a $FILES
echo "col_48=\"#44cd1\"" | tee -a $FILES
echo "col_gold=\"#8f8800\"" | tee -a $FILES
echo "col_red=\"#b01313\"" | tee -a $FILES
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
#echo "set logscale y" | tee -a $FILES

#THESE FILES CONTAIN ABORTS/SECOND
echo "set yrange [0:4000000]" | tee -a $FILE $FILE1

#THESE FILES CONTAIN ONLY MULTIPLIERS NORMALIZED TO TINY-UNTOUCHED
echo "set yrange [0:1.5]" | tee -a $FILE2 $FILE3


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

echo "set ylabel \"ABORTS / SECOND / THREAD\"" | tee -a $FILE $FILE1
echo "set ylabel \"TRANSACTIONS / SECOND / THREAD\"" | tee -a $FILE2 $FILE3


#echo "unset key" >> $FILE
#l1
echo  "set arrow from 1.8, graph 0 to 1.8, graph 1 nohead lc rgb \"#efefef\"" | tee -a $FILES
echo  "set label \"\$L1: 128KB\" at 1.9, 0.05 " | tee -a $FILES
#intelhd l3
echo  "set arrow 2 from 3.8, graph 0 to 3.8, graph 1 nohead lc rgb \"#dadada\"" | tee -a $FILES
echo  "set label 2 \"\$L3 GPU: 512KB\" at 3.9, 0.19 " | tee -a $FILES
#l2
echo  "set arrow from 4.8, graph 0 to 4.8, graph 1 nohead lc rgb \"#bebebe\"" | tee -a $FILES
echo  "set label \"\$L2: 1.024MB\" at 4.9, 0.10 " | tee -a $FILES
#l3
echo  "set arrow from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb \"#afafaf\"" | tee -a $FILES
echo  "set label \"\$L3: 8MB\" at 7.9, 0.19 " | tee -a $FILES
echo  "set title \"Only CPU, threaded validation, sequential walk\" font \",12\"" | tee -a $FILES

#  $i STM-threads
for i in 1 2 4 8; do
  echo "set title \"$i STM threads\" font \",12\"" | tee -a $FILES
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

    #f1 shared gpu
    coop="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/$i/array-strongly-scaled-shared-gpu-r99-w1-d$D-random-walk/$i-random"
    coop_lsa="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa/$i/array-strongly-scaled-shared-gpu-r99-w1-d$D-random-walk/$i-random"

    #untouched tiny
    tiny="$RESULTS_DIR/TinySTM-wbetl/$i/array-strongly-scaled-r99-w1-d$D-random-walk/$i-random"
    tiny_lsa="$RESULTS_DIR/TinySTM-wbetl-lsa/$i/array-strongly-scaled-r99-w1-d$D-random-walk/$i-random"

    #cpu worker threads validating
    tiny_threads="$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-strongly-scaled-r99-w1-d$D-random-walk/$i-random-4-workers"
    tiny_threads_lsa="$RESULTS_DIR/TinySTM-threads-wbetl-lsa/$i/array-strongly-scaled-r99-w1-d$D-random-walk/$i-random-4-workers"


    if [[ $D -eq 0 ]]; then
      #conjoint array walk
      CHOICE_ABORTS=$FILE
      CHOICE_TXPS=$FILE2
    else
      CHOICE_ABORTS=$FILE1
      CHOICE_TXPS=$FILE3
    fi


    # aborts/s
    echo  " '$tiny' u (\$0):(\$6/(\$16*$i)):( sprintf( '%.2fx', (\$6/(\$16*$i)) ) ):xtic(sprintf(\"%'d (%.2fMB)\", \$1, (\$1*8)/1000000)) t \"TinySTM-wbetl\" with linespoints lc rgb col_gold,\\"  >> $CHOICE_ABORTS
    echo  " '$tiny_lsa' u (\$0):(\$6/(\$16*$i)):( sprintf( '%.2fx', (\$6/(\$16*$i)) ) ):xtic(sprintf(\"%'d (%.2fMB)\", \$1, (\$1*8)/1000000)) t \"TinySTM-wbetl-lsa\" with linespoints lc rgb col_gold dt new,\\"  >> $CHOICE_ABORTS

    # "RSET" "Validation time (s)" "stddev" "Validation time (s) CPU" "stddev" "Validation time (s) GPU" "stddev" "Commits" "stddev" "Aborts" "stddev" "Val Reads" "stddev" "CPU Val Reads" "stddev" "GPU Val Reads" "stddev" "Wasted Val Reads" "stddev" "GPU employment times" "stddev" "Val success" "stddev" "Val fail" "stddev" 26"Snapshot ext. calls" "stddev" "Energy (J)" "stddev" #30:"Total time (s)" "stddev"
    echo  " '$coop' u (\$0):(\$10/(\$30*$i)):( sprintf( '%.2fx',(\$10/(\$30*$i)) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t     \"CPU-GPU co-op; iGPU shared (CAS compete); Blocks of 5736 on iGPU; sync on block\" lc rgb col_red        with linespoints,\\"  >> $CHOICE_ABORTS
    echo  " '$coop_lsa' u (\$0):(\$10/(\$30*$i)):( sprintf( '%.2fx',(\$10/(\$30*$i)) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"LSA CPU-GPU co-op; iGPU shared (CAS compete); Blocks of 5736 on iGPU; sync on block\" lc rgb col_red dt new with linespoints,\\"  >> $CHOICE_ABORTS

    # "RSET" "Validation time (s)" "stddev" "Commits" "stddev" "Aborts" "stddev" "Val Reads" "stddev" "Val success" "stddev" "Val fail" "stddev" "Energy (J)" "stddev" "Total time (s)" "stddev"
    echo  " '$tiny_threads' u (\$0):(\$6/(\$16*$i)):( sprintf( '%.2fx',(\$6/(\$16*$i)) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validation worker threads\" lc rgb \"#${gray_palette[2]}\" with linespoints,\\"  >> $CHOICE_ABORTS
    echo  " '$tiny_threads_lsa' u (\$0):(\$6/(\$16*$i)):( sprintf( '%.2fx',(\$6/(\$16*$i)) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"LSA; TinySTM-wbetl 4 validation worker threads\" lc rgb \"#${gray_palette[2]}\" dt new1 with linespoints,\\"  >> $CHOICE_ABORTS
    ##########################

    #tx/s: commits/totaltime relative to tinystm-untouched
    echo  " '< join $tiny $tiny_lsa' u (\$0):((\$20/(\$32*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$20/(\$32*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl-lsa\" with linespoints lc rgb col_gold dt new,\\"  >> $CHOICE_TXPS

    #echo  " '< join $tiny $f' u (\$0):((\$24/(\$46*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$24/(\$46*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU-GPU co-op; iGPU sticky thread (thread 0); Blocks of 5736 on iGPU; sync on block\" with linespoints,\\"  >> $CHOICE_TXPS

    echo  " '< join $tiny $coop' u (\$0):((\$24/(\$46*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$24/(\$46*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU-GPU co-op; iGPU shared GPU (iGPU CAS); Blocks of 5736 on iGPU; sync on block\" lc rgb col_red with linespoints,\\"  >> $CHOICE_TXPS
    echo  " '< join $tiny $tiny_lsa' u (\$0):((\$24/(\$46*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$24/(\$46*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU-GPU co-op; iGPU shared GPU (iGPU CAS); Blocks of 5736 on iGPU; sync on block; LSA\" lc rgb col_red dt new with linespoints,\\"  >> $CHOICE_TXPS

    echo  " '< join $tiny $tiny_threads' u (\$0):((\$20/(\$32*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$20/(\$32*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validation worker threads\" lc rgb \"#${gray_palette[2]}\" with linespoints,\\"  >> $CHOICE_TXPS
    echo  " '< join $tiny $tiny_threads_lsa' u (\$0):((\$20/(\$32*$i)) / (\$4/(\$16*$i))):( sprintf( '%.2fx',((\$20/(\$32*$i)) / (\$4/(\$16*$i))) ) ):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"TinySTM-wbetl 4 validation worker threads LSA\" lc rgb \"#${gray_palette[2]}\" dt new1 with linespoints,\\"  >> $CHOICE_TXPS


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
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-4-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 4 validation worker / STM thread\" dt new1 lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE1
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
gnuplot -p $FILE
gnuplot -p $FILE1
# tx/s
gnuplot -p $FILE2
gnuplot -p $FILE3


