#!/bin/bash

RESULTS_DIR="../results-validation-array"

mkdir -p "../gnuplot"
####################################################################################################################################################

declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")
declare -a gray_pallet=("696969" "808080" "A9A9A9" "C0C0C0" "D3D3D3" "DCDCDC" "696969")
declare -a all_pallet=("33ccff" "ccccff" "009933" "ff9900" "ff6666" "0033cc" "cc0000" "999966")

FILE1="../gnuplot/simple-array-validation-co-op-heatmap-random-walk.gnuplot"
FILE2="../gnuplot/simple-array-validation-co-op-heatmap-sequential-walk.gnuplot"

echo > $FILE1
echo > $FILE2

echo "set terminal wxt size 1440,1080" | tee -a $FILE1 $FILE2
echo "set decimal locale \"en_US.UTF-8\"; show locale" | tee -a $FILE1 $FILE2
#echo "set size 1,1" >> $FILE
#echo "set origin 0,0" >> $FILE



#echo "set datafile missing '0'" >> $FILE
#echo "unset ytics" >> $FILE
#echo "set tics scale 0"  >> $FILE
#echo "set xtics nomirror rotate by 45 right scale 0 font \",8\"" >> $FILE
#echo "unset ytics" >> $FILE
#echo "set ytics" >> $FILE
#echo "set grid ytics lc rgb \"#606060\"" >> $FILE
#echo "set format y2 \"%0.4f\"" >> $FILE

#echo "set logscale x" >> $FILE
echo "set key inside top right font \"Computer Modern, 15\""| tee -a $FILE1 $FILE2
#echo "set key left Left left Left inside top" | tee -a $FILE1 $FILE2

#echo "set format x \"%d\"" >> $FILE

echo "set datafile separator whitespace" | tee -a $FILE1 $FILE2

echo "set border lc rgb \"black\"" | tee -a $FILE1 $FILE2
#echo "unset border" >> $FILE

CO_OP_RAND_PATH="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk"
HEAT_FILE_RAND="../results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/heat-file"
HEAT_FILE_CPU_RAND="../results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/heat-file"

CO_OP_SEQ_PATH="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-sequential-walk"
HEAT_FILE_SEQ="../results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-sequential-walk/heat-file"
HEAT_FILE_CPU_SEQ="../results-validation-array/TinySTM-wbetl/1/array-r99-w1-sequential-walk/heat-file"

echo "set xtics font \"Computer Modern,18\" offset 1,-1,0" | tee -a $FILE1 $FILE2
echo "set ytics font \"Computer Modern,24\" " | tee -a $FILE1 $FILE2
echo "set ztics font \"Computer Modern,28\" " | tee -a $FILE1 $FILE2

echo "set xlabel \"READ-SET SIZE\" font \"Computer Modern, 22\" offset graph 0,0,-0.04"  | tee -a $FILE1 $FILE2
echo "set ylabel \"CPU %\" font \"Computer Modern, 25\" offset graph 0.1,0,0"  | tee -a $FILE1 $FILE2
echo "set zlabel \"READS VALIDATED / s\" font \"Computer Modern, 18\" offset graph 0,0,0.66"  | tee -a $FILE1 $FILE2


echo -n > $HEAT_FILE_RAND
echo -n > $HEAT_FILE_SEQ
echo -n > $HEAT_FILE_CPU_RAND
echo -n > $HEAT_FILE_CPU_SEQ

for((i=55;i<=75;i++));do
  #from each file extract column 1 and 2
  #add to column 2 3 in newfile

  #was NR>1 to skip header but we focused on best place

  awk -vi=$i 'NR>10{print i, $1, $12/$2}' "$CO_OP_RAND_PATH/1-random-cpu-$(($i))-gpu-$((100-$i))" >> $HEAT_FILE_RAND
  echo >> $HEAT_FILE_RAND

  awk -vi=$i 'NR>10{print i, $1, $12/$2}' "$CO_OP_SEQ_PATH/1-sequential-cpu-$(($i))-gpu-$((100-$i))" >> $HEAT_FILE_SEQ
  echo >> $HEAT_FILE_SEQ

  #draw TINYSTM UNTOUCHED plane accross
  awk -vi=$i 'NR>10{print i, $1, $8/$2}' "$RESULTS_DIR/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation" >> $HEAT_FILE_CPU_RAND
  echo >> $HEAT_FILE_CPU_RAND

  awk -vi=$i 'NR>10{print i, $1, $8/$2}' "$RESULTS_DIR/TinySTM-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation" >> $HEAT_FILE_CPU_SEQ
  echo >> $HEAT_FILE_CPU_SEQ
done


echo | tee -a $FILE1 $FILE2

echo "col_24=\"#c724d6\"" | tee -a $FILE1 $FILE2
echo "col_48=\"#44cd1\"" | tee -a $FILE1 $FILE2
echo "col_gold=\"#8f8800\"" | tee -a $FILE1 $FILE2



#echo "set view map" >> $FILE
#echo "set pm3d interpolate 100, 10" >> $FILE
#echo "set dgrid3d" >> $FILE

#FILE 1
echo "set cbrange [0:600000000]" | tee -a $FILE1 $FILE2




echo "set logscale x" >> $FILE1
echo "set title \"Array walk - RANDOM elements - CPUGPU cooperative validation - STATIC assignment in %\" font \"Computer Modern,22\"" >> $FILE1
echo "set style fill transparent solid 1 " >> $FILE1
echo "unset colorbox" >> $FILE1
echo "set pm3d depthorder" >> $FILE1
#echo "set view 45, 45" >> $FILE
echo "splot '$HEAT_FILE_RAND' u 2:1:3:xtic(1) t \"TinySTM-wbetl CPUGPU cooperative validation\" with pm3d, \\" >> $FILE1
echo "      '$HEAT_FILE_CPU_RAND' u 2:1:3:xtic(2) t \"TinySTM-wbetl untouched\" w surface lt 13 lc \"#000000\"  " >> $FILE1
echo >> $FILE1

#FILE 2
#logscale on read-set-size
echo "set logscale x" >> $FILE2
echo "set title \"Array walk - SEQUENTIAL elements - CPUGPU cooperative validation - STATIC assignment in %\" font \"Computer Modern,22\"" >> $FILE2

echo "set cbtics font \"Computer Modern, 16\" " >> $FILE2
#echo "set style fill transparent solid 1" >> $FILE2
#echo "set view 45, 45" >> $FILE
echo "splot '$HEAT_FILE_SEQ' u 2:1:3:xtic(1) t \"TinySTM-wbetl CPUGPU cooperative validation\" with pm3d, \\" >> $FILE2
echo "      '$HEAT_FILE_CPU_SEQ' u 2:1:3:xtic(2) t \"TinySTM-wbetl untouched\" w surface lc \"#000000\"" >> $FILE2
echo >> $FILE2

gnuplot -p $FILE1 #RANDOM
#gnuplot -p $FILE2 #SEQUENTIAL





