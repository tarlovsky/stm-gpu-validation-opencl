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

echo "set multiplot layout 2,2 title \"Random array walk: READS VALIDATED PER SECOND (THROUGHPUT) - using CPU thread pool to validate (higher is better)\" font \",14\"" >> $FILE
echo "set decimal locale \"en_US.UTF-8\"; show locale" >> $FILE
#echo "set datafile missing \"x\"" >> $FILE
#echo "unset ytics" >> $FILE
echo "set tics scale 0"  >> $FILE
#echo "set xtics nomirror rotate by 45 right scale 0 font \",8\"" >> $FILE
#echo "unset ytics" >> $FILE
echo "set ytics" >> $FILE
echo "set grid ytics lc rgb \"#606060\"" >> $FILE
#echo "set format y2 \"%0.4f\"" >> $FILE
echo "set logscale y" >> $FILE

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

echo "set key font \",8\"" >> $FILE
#echo "set key left Left left Left inside top" >> $FILE
echo "set key inside bottom right" >> $FILE

echo "set yrange [100000:10000000000]" >> $FILE
echo "set ylabel \"READS VALIDATED / VALIDATION CALL / SECOND\""  >> $FILE
#echo "unset key" >> $FILE
#l1
echo  "set arrow from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb \"#efefef\"" >> $FILE
echo  "set label \"\$L1: 128KB\" at 5.9, 10000000 " >> $FILE
#l2
echo  "set arrow from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb \"#bebebe\"" >> $FILE
echo  "set label \"\$L2: 1.024MB\" at 8.9, 10000000+10000000*0.50 " >> $FILE
#l3
echo  "set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb \"#afafaf\"" >> $FILE
echo  "set label \"\$L3: 8MB\" at 11.9, 10000000+10000000*2 " >> $FILE
echo  "set title \"Only CPU, threaded validation, sequential walk\" font \",12\"" >> $FILE

##############################################################################################################################################################################
# out of all the data inside TinySTM-igpu-cpu-persistend (CO-OP) validation
# find the fastest percentage. it is somewhere between 55-85% CPU validation assignment
# plot the fastest CO-OP over the first graph

#get baseline TinySTM-wbetl seinglethreaded
BASELINE_FILE="$RESULTS_DIR/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation"

val_time_col=$(awk 'NR>1{printf "%f ", $2}' $BASELINE_FILE) #skip NR>4: header, 64,128,256. start at 512
val_time_col_ref=($val_time_col)
N_RSET_SIZES=${#val_time_col_ref[@]} #get number of rows in file

####### RANDOM #######
BEST_FILE="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-gpu-best"
if [[ ! -f "$BEST_FILE" ]]; then
  #create file
  echo -n > $BEST_FILE
fi

#find them all
declare -a BEST_CO_OP_somewhere=()
BEST_CO_OP=
BEST_COUNT=0

val_time_col_co_op=

echo
echo "The following co-op assignments are better than TinySTM-wbetl on at least one READ-SET SIZE:"
echo "OCCASION | FILENAME"
for((j=0;j<=100;j++));do
  SEARCH_FILE="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-$j-gpu-$((100-$j))"
  val_time_col_co_op=$(awk 'NR>1{printf "%f ", $2}' $SEARCH_FILE)
  val_time_col_co_op_ref=($val_time_col_co_op)
  not_added_yet=1
  COUNT=0
  #get those who have better time in $2 than BASE
  #bash doesn't deal with floats, use something else to compare like awk
  for((i=0;i < $N_RSET_SIZES;i++));do
    if [[ 1 -eq "$(echo "${val_time_col_co_op_ref[$i]} < ${val_time_col_ref[$i]}" | bc)" ]];then
      ((COUNT++))
      if [[ not_added_yet -eq 1 ]]; then
        BEST_CO_OP_somewhere+=($SEARCH_FILE)
        not_added_yet=0 #added to BEST_CO_OP_somewhere
      fi
      if [[ $COUNT -gt $BEST_COUNT ]];then
        BEST_COUNT=$COUNT
        BEST_CO_OP=$SEARCH_FILE
      fi
    fi
    #continue searching for best overall
  done
  if [[ $COUNT -gt 0 ]];then
    echo "$COUNT | $SEARCH_FILE"
  fi
done
echo
echo "$BEST_CO_OP best on $BEST_COUNT occasions"
echo
##############################################################################################################################################################################
t_col_best_co_op="GLOBAL MINUMUM "
t_col_best_co_op+=$(echo $BEST_CO_OP | sed 's/.*\///')

#  $i STM-threads
for i in 1 2 4 8;do
  echo "set title \"$i STM threads\" font \",12\"" >> $FILE
  echo  "plot \\"  >> $FILE
  # \$2 = valtime
  #  $i STM-threads
  if [[ $i -eq 1 ]];then
    # 12 valreads
    # 14+16=val enters
    echo  " '$BEST_CO_OP' u (\$0):(((\$14+\$16)>0)?(((\$12/(ceil(\$14+\$16)))/\$2)/$i):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"$i STM THREADS $t_col_best_co_op\" lw 2 lc rgb \"#b01313\",\\"  >> $FILE
    #  12 valreads
    #  14 CPU VAL READS
    #  16 GPU VAL READS
    #  18 WASTED VAL READS
    #  20 GPU employment times
    #  22 Val success
    #  24 Val fail
    echo  " '$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-k-1/$i/array-r99-w1-random-walk/$i-random-cpu-validation' \\" >> $FILE
    echo  "u (\$0):(((\$22+\$24)>0)?(((\$12/(ceil(\$22+\$24)))/\$2)/$i):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"$i STM CPU+GPU DYNAMIC CO-OP - BLOCKS\" lw 2 lc rgb \"#${blue_palette[$i]}\" ,\\"  >> $FILE
    echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-blocks-wbetl/$i/array-r99-w1-random-walk/$i-random-igpu' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"Intel iGPU HD530 PERSISTENT KERNEL - BLOCKS\" dt new lw 2 lc rgb \"#${blue_palette[$i]}\" ,\\"  >> $FILE
  fi

  #  8 valreads
  #  10+12 = val enters
  #(((\$10+\$12)>0)?(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):(NaN))
  #                                     (\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)
  # (/$i) can be simplified out but the formula is harder to explain
  #AUTO-SCHED MULTI-THREADED
  echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-8-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 8 validation worker / STM thread\" lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE
  echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-4-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 4 validation worker / STM thread\" dt new1 lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE
  echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-2-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 2 validation worker / STM thread\" dt new lc rgb \"#${gray_palette[$i]}\",\\"  >> $FILE
  #CUSTOM THREAD PINNING
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl-CUSTOM-PINNING/$i/array-r99-w1-random-walk/$i-random-cpu-validation-8-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):3:xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) w yerrorlines t \"CUSTOM PINNING CPU -02 8 validation worker / STM thread\" lc rgb \"#${blue_palette[$i]}\",\\"  >> $FILE
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl-CUSTOM-PINNING/$i/array-r99-w1-random-walk/$i-random-cpu-validation-4-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):3:xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) w yerrorlines t \"CUSTOM PINNING CPU -02 4 validation worker / STM thread\" dt new1 lc rgb \"#${blue_palette[$i]}\",\\"  >> $FILE
  #echo  " '$RESULTS_DIR/TinySTM-threads-wbetl-CUSTOM-PINNING/$i/array-r99-w1-random-walk/$i-random-cpu-validation-2-workers' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):3:xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) w yerrorlines t \"CUSTOM PINNING CPU -02 2 validation worker / STM thread\" dt new lc rgb \"#${blue_palette[$i]}\",\\"  >> $FILE
  #random execution
  echo  " '$RESULTS_DIR/TinySTM-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation' u (\$0):(((\$10+\$12)>0)?( ((\$8/(ceil(\$10+\$12)))/$i) /  (\$2/$i) ):(NaN)):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t \"CPU -02 1 validation worker / STM thread\" lw 2 lc rgb \"#${gold_palette[$i]}\",\\"  >> $FILE
  echo >> $FILE
done
echo >> $FILE
echo  "unset multiplot" >> $FILE



gnuplot -p $FILE


