#!/bin/bash

RESULTS_DIR="results-validation-array"

mkdir -p "gnuplot"
####################################################################################################################################################

declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")
declare -a grey_pallet=("696969" "808080" "A9A9A9" "C0C0C0" "D3D3D3" "DCDCDC" "696969")
declare -a all_pallet=("33ccff" "ccccff" "009933" "ff9900" "ff6666" "0033cc" "cc0000" "999966")

FILE1="gnuplot/simple-array-validation-co-op-heatmap-random-walk.gnuplot"
FILE2="gnuplot/simple-array-validation-co-op-heatmap-sequential-walk.gnuplot"

echo > $FILE1
echo > $FILE2

echo "set terminal wxt size 1440,1080" | tee -a $FILE1 $FILE2
#echo "set size 1,1" >> $FILE
#echo "set origin 0,0" >> $FILE
#echo "unset bmargin" >> $FILE
#echo "unset tmargin" >> $FILE
#echo "unset rmargin" >> $FILE
#echo "unset lmargin" >> $FILE

echo "set title \"Validation with varied cpu-gpu validation assignment (in %)\" font \",16\"" | tee -a $FILE1 $FILE2
#echo "set datafile missing '0'" >> $FILE
#echo "unset ytics" >> $FILE
#echo "set tics scale 0"  >> $FILE
#echo "set xtics nomirror rotate by 45 right scale 0 font \",8\"" >> $FILE
#echo "unset ytics" >> $FILE
#echo "set ytics" >> $FILE
#echo "set grid ytics lc rgb \"#606060\"" >> $FILE
#echo "set format y2 \"%0.4f\"" >> $FILE

#echo "set logscale x" >> $FILE

#echo "set format x \"%d\"" >> $FILE
#echo "set xtics nomirror rotate by 45 right font \"Verdana,10\" " >> $FILE
echo "set datafile separator whitespace" | tee -a $FILE1 $FILE2

echo "set border lc rgb \"black\"" | tee -a $FILE1 $FILE2
#echo "unset border" >> $FILE

CO_OP_RAND_PATH="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk"
HEAT_FILE_RAND="results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/heat-file"
HEAT_FILE_CPU_RAND="results-validation-array/TinySTM-wbetl/1a/array-r99-w1-random-walk/heat-file"

CO_OP_SEQ_PATH="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-sequential-walk"
HEAT_FILE_SEQ="results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-sequential-walk/heat-file"
HEAT_FILE_CPU_SEQ="results-validation-array/TinySTM-wbetl/1a/array-r99-w1-sequential-walk/heat-file"

echo "set xlabel \"READ-SET SIZE\""  | tee -a $FILE1 $FILE2
echo "set ylabel \"CPU VALIDATION PERCENTAGE\""  | tee -a $FILE1 $FILE2
echo "set zlabel \"Validation execution time only (s)\""  | tee -a $FILE1 $FILE2

echo -n > $HEAT_FILE_RAND
echo -n > $HEAT_FILE_SEQ
echo -n > $HEAT_FILE_CPU_RAND
echo -n > $HEAT_FILE_CPU_SEQ

for((i=0;i<=100;i++));do
  #from each file extract column 1 and 2
  #add to column 2 3 in newfile
  awk -vi=$i 'NR>1{print i, $1, $2}' "$CO_OP_RAND_PATH/1-random-cpu-$(($i))-gpu-$((100-$i))" >> $HEAT_FILE_RAND
  echo >> $HEAT_FILE_RAND

  awk -vi=$i 'NR>1{print i, $1, $2}' "$CO_OP_SEQ_PATH/1-sequential-cpu-$(($i))-gpu-$((100-$i))" >> $HEAT_FILE_SEQ
  echo >> $HEAT_FILE_SEQ

  #draw plane accross
  awk -vi=$i 'NR>4{print i, $1, $2}' "$RESULTS_DIR/TinySTM-wbetl/1a/array-r99-w1-random-walk/1a-random-cpu-validation" >> $HEAT_FILE_CPU_RAND
  echo >> $HEAT_FILE_CPU_RAND

  awk -vi=$i 'NR>4{print i, $1, $2}' "$RESULTS_DIR/TinySTM-wbetl/1a/array-r99-w1-sequential-walk/1a-sequential-cpu-validation" >> $HEAT_FILE_CPU_SEQ
  echo >> $HEAT_FILE_CPU_SEQ
done


echo | tee -a $FILE1 $FILE2

echo "col_24=\"#c724d6\"" | tee -a $FILE1 $FILE2
echo "col_48=\"#44cd1\"" | tee -a $FILE1 $FILE2
echo "col_gold=\"#8f8800\"" | tee -a $FILE1 $FILE2

#echo "set key font \",10\"" >> $FILE
#echo "set key left Left left Left inside top" >> $FILE
#echo "set key left" >> $FILE
#echo "set yrange [0.0000001:10]" >> $FILE

echo "set xtics nomirror rotate by 45 right scale 0 font \",8\"" | tee -a $FILE1 $FILE2

#echo  "plot \\"  >> $FILE
#normal execution

#echo "set view map" >> $FILE
#echo "set pm3d interpolate 100, 10" >> $FILE
#echo "set dgrid3d" >> $FILE

#FILE 1
echo "set title \"Simple array random walk cpu-igpu co-op validation\" font \",12\"" >> $FILE1
echo "set pm3d" >> $FILE1
echo "set style data lines" >> $FILE1
#echo "set view 45, 45" >> $FILE
echo "splot '$HEAT_FILE_RAND' u 2:1:3:xtic(1), \\" >> $FILE1
echo "      '$HEAT_FILE_CPU_RAND' u 2:1:3:xtic(2) w l ls 15 " >> $FILE1
echo >> $FILE1

#FILE 2
#logscale on read-set-size
echo "set logscale x" >> $FILE2
echo "set pm3d" >> $FILE2
echo "set style data lines" >> $FILE2
echo "set title \"Simple array sequential walk cpu-igpu co-op validation\" font \",12\"" >> $FILE2
echo "splot '$HEAT_FILE_SEQ' u 2:1:3:xtic(1), \\" >> $FILE2
echo "      '$HEAT_FILE_CPU_SEQ' u 2:1:3:xtic(2) w l ls 15 " >> $FILE2
echo >> $FILE2

gnuplot -p $FILE1
gnuplot -p $FILE2





