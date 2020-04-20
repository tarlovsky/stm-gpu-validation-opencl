#!/bin/bash

RESULTS_DIR="results-validation-array"

mkdir -p "gnuplot"

declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")
declare -a gray_pallet=("696969" "808080" "A9A9A9" "C0C0C0" "D3D3D3" "DCDCDC" "696969")
declare -a all_pallet=("33ccff" "ccccff" "009933" "ff9900" "ff6666" "0033cc" "cc0000" "999966")

#HEATMAP############################################################

####################################################################
# Table the times where gpu-cpu co-op is best and show speedup     #
####################################################################
FILE1="gnuplot/simple-array-validation-dynamic-co-op.gnuplot"

#echo "set term postscript eps color solid" >> $FILE1
#echo "set output '1.eps'" >> $FILE1

echo "set terminal wxt size 3300,1100" > $FILE1

echo "set multiplot layout 4,2 title \"Transactional array traversal application - Intel 6700k CPU + Intel HD530 iGPU co-operative validation with dynamic workload assignment vs. TinySTM-WBETL unmodified\" font \"Computer Modern,16\"" >> $FILE1
echo "set decimal locale \"en_US.UTF-8\"; show locale" >> $FILE1
#echo "set datafile missing \" \"" >> $FILE1
#echo "unset border" >> $FILE1
echo "set view map" >> $FILE1
echo "set grid front lc rgb \"#999966\"" >> $FILE1
echo "set datafile separator \" \"" >> $FILE1
echo "set palette rgb -21,-22,-23" >> $FILE1
echo "set key autotitle columnhead" >> $FILE1
echo "set ytics nomirror" >> $FILE1
echo "set xlabel \"READ-SET SIZE\"" >> $FILE1
echo "set ylabel \"PROGRAM\"" >> $FILE1
echo "unset colorbox" >> $FILE1
#echo "unset xtics" >> $FILE1
#echo "set style line 102 lc rgb'#101010' lt 0 lw 4" >> $FILE1

echo "set xtics rotate by 45 right scale 0 font \"Computer Modern,8\" offset 0,0,-0.04" >> $FILE1
echo "set cbrange [0.78:3.8]" >> $FILE1
echo "set palette rgb -21,-22,-23" >> $FILE1

#read-set-sizes
header=$(awk 'NR>1{print $1}' "$RESULTS_DIR/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation")
rset_sizes=
empty_line=
for word in ${header[@]}; do
  rset_sizes+="\"${word}\" "
  empty_line+="- "
done

#repeat for multithreaded
for i in 1 2 4 8; do
  for mode in "random" "sequential";
    do
    #folder of config we are comparing agains baseline tinystm
    #store all intermedeiate files here because they belong to them
    TARGET_FOLDER="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-BEST/$i/array-r99-w1-$mode-walk"

    #get cpu-only val_time
    cpu_val_time=$(awk 'NR>1{print $2}' "$RESULTS_DIR/TinySTM-wbetl/$i/array-r99-w1-$mode-walk/1-$mode-cpu-validation")
    #get current config valtime
    co_op_val_time=$(awk 'NR>1{print $2}' "$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-BEST/$i/array-r99-w1-$mode-walk/1-$mode-cpu-validation")
    #parse speedup between them
    SPEEDUP=$(paste <(echo "$co_op_val_time") <(echo "$cpu_val_time") | awk '{if($1<$2){printf "%.2f ", $2/$1;}else{print "-"}}')

    RESUL_FILE="$TARGET_FOLDER/tabled-data"
    RESUL_FILE_SPEEDUP="$TARGET_FOLDER/tabled-data-speedup"

    #such a fucking hack. create two files in order to FORMAT plots them differently, lol
    #one with speedups %.2f, and one with time in seconds.
    echo "\"NAME\"" $rset_sizes > $RESUL_FILE_SPEEDUP
    echo $SPEEDUP
    echo "\"SPEED-UP\"" $SPEEDUP >> $RESUL_FILE_SPEEDUP
    echo "\"TINYSTM-COOPERATIVE-VALIDATION\"" $empty_line >> $RESUL_FILE_SPEEDUP
    echo "\"TINYSTM-BASELINE\"" $empty_line >> $RESUL_FILE_SPEEDUP

    echo "\"NAME\"" $rset_sizes > $RESUL_FILE
    echo "\"Speed-up\"" $empty_line >> $RESUL_FILE
    echo "\"Cooperative-validation\"" $co_op_val_time >> $RESUL_FILE
    echo "\"Unaltered\"" $cpu_val_time >> $RESUL_FILE
    #plot
    # RSET SIZE
    #
    echo "set title \"$i STM threads ($mode array walk) - time in seconds\" font \",16\"" >> $FILE1
    echo "plot '$RESUL_FILE_SPEEDUP' matrix rowheaders columnheaders w image,\\" >> $FILE1
    echo "     '$RESUL_FILE_SPEEDUP' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"x%.2f\",\$3)) : (sprintf(\"-\")))) with labels font \",11.5\",\\" >> $FILE1
    echo "     '$RESUL_FILE' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"%f\",\$3)) : (sprintf(\" \")))):xtic(1) with labels,\\" >> $FILE1
    echo >> $FILE1

  done #done with seq, rand.
  break; #NO DATA FOR MULTITHREADED YET
done

echo "unset multiplot" >> $FILE1
gnuplot -p $FILE1

