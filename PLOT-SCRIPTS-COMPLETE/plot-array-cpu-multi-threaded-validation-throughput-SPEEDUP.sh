#!/bin/bash

RESULTS_DIR="../results-validation-array"

mkdir -p "../gnuplot"
####################################################################################################################################################

declare -a blue_palette=(" " "69a2ff" "7dafff" " " "94bdff" " " " " " " "9cc2ff" " " "adcdff" " " "b5d2ff" " " "bdd7ff")
declare -a gray_palette=(" " "000000" "505050" " " "616161" " " " " " " "757575" " " "C0C0C0" " " "D3D3D3" " " "DCDCDC" " " "696969")
declare -a all_palette=( " " "1D4599" "11AD34" " " "E69F17" " " " " " " "E62B17" " " "ff6666" " " "0033cc" " " "cc0000" " " "999966")
declare -a red_palette=( " " "F9B7B0" "E62B17" " " "8F463F" " " " " " " "6D0D03")
declare -a gold_palette=(" " "8f8d08" "a77f0e" " " "916a09" " " " " " " "914a09" " " "adcdff" " " "b5d2ff" " " "bdd7ff")
declare -a red_palette=( " " "b01313")

FILE="../gnuplot/simple-array-multithreaded-validation-reads-validated.gnuplot"
FILE1="../gnuplot/simple-array-multithreaded-validation-reads-validated-sequential.gnuplot"

FILES="$FILE $FILE1"

echo "set terminal wxt size 1400,1100" > $FILE
#echo "set terminal wxt size 850,2800" > $FILE
echo "set terminal wxt size 850,2800" > $FILE1

echo "unset bmargin" | tee -a $FILES
echo "unset tmargin" | tee -a $FILES
echo "unset rmargin" | tee -a $FILES
echo "set bmargin 11" | tee -a $FILES

echo >> $FILE
echo >> $FILE1

echo "new = \"-\"" | tee -a $FILES
echo "new1 = \"..\"" | tee -a $FILES
echo "new2 = \"_-_\"" | tee -a $FILES

echo "col_24=\"#c724d6\"" | tee -a $FILES
echo "col_48=\"#44cd1\"" | tee -a $FILES
echo "col_gold=\"#8f8800\"" | tee -a $FILES
echo "xlabeloffsety=0.15" | tee -a $FILES

echo "set grid ytics lc rgb \"#606060\"" | tee -a $FILES
echo "set grid xtics lc rgb \"#bbbbbb\"" | tee -a $FILES

echo "set multiplot layout 2,2 " >> $FILE
echo "set multiplot layout 4,1 " >> $FILE1

echo "set decimal locale \"en_US.UTF-8\"; show locale" | tee -a $FILES
#echo "set datafile missing \"x\"" | tee -a $FILES
#echo "unset ytics" | tee -a $FILES
echo "set tics scale 0"  | tee -a $FILES
#echo "set xtics nomirror rotate by 45 right scale 0 font \",8\"" | tee -a $FILES
#echo "unset ytics" | tee -a $FILES
echo "set ytics nomirror font \"Computer Modern, 22\" " | tee -a $FILES
echo "set ytics 0.2 " | tee -a $FILES
echo "set yrange [0:2.5]" | tee -a $FILES
#echo "set format y2 \"%0.4f\"" | tee -a $FILES
#echo "set logscale y" | tee -a $FILES

echo "set format x \"%d\"" | tee -a $FILES
echo "set xtics nomirror rotate by 45 right font \"Computer Modern, 18\" " | tee -a $FILES
echo "set xtics offset 0, xlabeloffsety" | tee -a $FILES
echo "set datafile separator whitespace" | tee -a $FILES

echo "set border lc rgb \"black\"" | tee -a $FILES
#echo "unset border" | tee -a $FILES

echo "set style data lines" | tee -a $FILES

echo "set xlabel offset 0,-2 \"Read-set size\" font \"Computer Modern, 21\""  | tee -a $FILES

echo  "set arrow 1 from 0, 1 to 19, 1 front nohead lc rgb \"#000000\" lw 1" | tee -a $FILES


#l1
echo  "set arrow 2 from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb \"#efefef\"" | tee -a $FILES
echo  "set label 2\"\$L1: 128KB\" at 5.9, 0.54 font \"Computer Modern, 18\"" | tee -a $FILES
#l2
echo  "set arrow 4 from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb \"#bebebe\"" | tee -a $FILES
echo  "set label 4\"\$L2: 1.024MB\" at 8.9, 0.62 font \"Computer Modern, 18\"" | tee -a $FILES
#l3
echo  "set arrow 5 from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb \"#afafaf\"" | tee -a $FILES
echo  "set label 5\"\$L3: 8MB\" at 11.9, 0.71 font \"Computer Modern, 18\"" | tee -a $FILES



#  $i STM-threads
for i in 1 2 4 8;do

  if [[ $i -eq 1 ]];then
    echo "set key left Left left Left reverse inside top font\"Computer modern, 22\"" | tee -a $FILES
  else
    echo "unset key" | tee -a $FILES
  fi

  tiny="$RESULTS_DIR/TinySTM-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation";
  tiny_threads_2="$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-2-workers"
  tiny_threads_4="$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-4-workers"
  tiny_threads_8="$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-8-workers"

  stiny="$RESULTS_DIR/TinySTM-wbetl/$i/array-r99-w1-sequential-walk/$i-sequential-cpu-validation";
  stiny_threads_2="$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-sequential-walk/$i-sequential-cpu-validation-2-workers"
  stiny_threads_4="$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-sequential-walk/$i-sequential-cpu-validation-4-workers"
  stiny_threads_8="$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-sequential-walk/$i-sequential-cpu-validation-8-workers"


  echo "set title \"$i STM threads\" offset 0, -1.15 font \"Computer modern,23\"" | tee -a $FILES
  echo  "plot \\"  | tee -a $FILES

  #  8 valreads
  #  10+12 = val enters
  #(((\$10+\$12)>0)?(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):(NaN))
  #                                     (\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)
  # (/$i) can be simplified out but the formula is harder to explain


  #AUTO-SCHED MULTI-THREADED
  ##### RND #####
  echo  " '< join $tiny $tiny_threads_8' u (\$0):((\$24/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$24/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"8 validator threads\" lw 3 with linespoints,\\"  >> $FILE
  echo  " '< join $tiny $tiny_threads_4' u (\$0):((\$24/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$24/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"4 validator threads\" lw 3 with linespoints,\\"  >> $FILE
  echo  " '< join $tiny $tiny_threads_2' u (\$0):((\$24/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$24/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"2 validator threads\" dt new1 lw 3  with linespoints,\\"  >> $FILE
  ##### SEQ #####
  echo  " '< join $stiny $stiny_threads_8' u (\$0):((\$24/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$24/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"8 validator threads\" lw 3 with linespoints,\\"  >> $FILE1
  echo  " '< join $stiny $stiny_threads_4' u (\$0):((\$24/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$24/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"4 validator threads\" lw 3 with linespoints,\\"  >> $FILE1
  echo  " '< join $stiny $stiny_threads_2' u (\$0):((\$24/(\$18*$i)) / (\$8/(\$2*$i))):( sprintf( '%.2fx',((\$24/(\$18*$i)) / (\$8/(\$2*$i))) ) ):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"2 validator threads\" dt new1 lw 3  with linespoints,\\"  >> $FILE1


  #CUSTOM THREAD PINNING
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl-CUSTOM-PINNING/$i/array-r99-w1-random-walk/$i-random-cpu-validation-8-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):3:xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) w yerrorlines t \"CUSTOM PINNING CPU -02 8 validation worker / STM thread\" lc rgb \"#${blue_palette[$i]}\",\\"  >> $FILE
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl-CUSTOM-PINNING/$i/array-r99-w1-random-walk/$i-random-cpu-validation-4-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):3:xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) w yerrorlines t \"CUSTOM PINNING CPU -02 4 validation worker / STM thread\" dt new1 lc rgb \"#${blue_palette[$i]}\",\\"  >> $FILE
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl-CUSTOM-PINNING/$i/array-r99-w1-random-walk/$i-random-cpu-validation-2-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):3:xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) w yerrorlines t \"CUSTOM PINNING CPU -02 2 validation worker / STM thread\" dt new lc rgb \"#${blue_palette[$i]}\",\\"  >> $FILE
  #random execution
  #echo  " '$RESULTS_DIR/TinySTM-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d \",\$1, (\$1*8)/1000000)) t \"CPU -02 1 validation worker / STM thread\" lw 2 lc rgb \"#${gold_palette[$i]}\",\\"  >> $FILE
  echo | tee -a $FILES
done

echo | tee -a $FILES
echo  "unset multiplot" | tee -a $FILES



gnuplot -p $FILE  #RAND
#gnuplot -p $FILE1 #SEQ


