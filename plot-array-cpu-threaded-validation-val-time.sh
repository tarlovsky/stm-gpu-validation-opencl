#!/bin/bash

RESULTS_DIR="results-validation-array"

mkdir -p "gnuplot"
####################################################################################################################################################

declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")
declare -a grey_pallet=("696969" "808080" "A9A9A9" "C0C0C0" "D3D3D3" "DCDCDC" "696969")
declare -a all_pallet=("33ccff" "ccccff" "009933" "ff9900" "ff6666" "0033cc" "cc0000" "999966")

FILE="gnuplot/simple-array-multithreaded-validation-val-time.gnuplot"

echo "set terminal wxt size 1440,1200" > $FILE
#echo "set size 1,1" >> $FILE
#echo "set origin 0,0" >> $FILE
echo "unset bmargin" >> $FILE
echo "unset tmargin" >> $FILE
echo "unset rmargin" >> $FILE
echo "unset lmargin" >> $FILE


echo "set multiplot layout 2,2 title \"Time to validate random array walk application; multi-threaded CPU validation vs TinySTM-WBETL untouched\" font \",14\"" >> $FILE

echo "set datafile missing \"0\"" >> $FILE
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

echo "set key font \",9\"" >> $FILE
#echo "set key left Left left Left inside top" >> $FILE
echo "set key left" >> $FILE
echo "set yrange [0.00001:10]" >> $FILE
echo "set ylabel \"Time (s)\""  >> $FILE

#l1
echo  "set arrow from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb \"#efefef\"" >> $FILE
echo  "set label \"\$L1: 128KB\" at 5.9,0.000014 " >> $FILE
#l2
echo  "set arrow from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb \"#bebebe\"" >> $FILE
echo  "set label \"\$L2: 1.024MB\" at 8.9,0.000014*1.5 " >> $FILE
#l3
echo  "set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb \"#afafaf\"" >> $FILE
echo  "set label \"\$L3: 8MB\" at 11.9,0.000014*2.5 " >> $FILE
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
for i in 1 2 4 8;do
  echo >> $FILE
  echo "set title \"$i validation worker threads/STM thread\" font \",14\"" >> $FILE
  echo  "plot \\"  >> $FILE
  echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-8-workers' u (\$0):(\$2/$i):xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"CPU -02 8 validation worker / STM thread\" lc rgb \"black\",\\"  >> $FILE
  echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-4-workers' u (\$0):(\$2/$i):xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"CPU -02 4 validation worker / STM thread\" dt new1 lc rgb \"black\" ,\\"  >> $FILE
  echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation-2-workers' u (\$0):(\$2/$i):xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"CPU -02 2 validation worker / STM thread\" dt new lc rgb \"black\" ,\\"  >> $FILE
  if [[ $i -eq 1 ]];then
    echo  " '$RESULTS_DIR/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"CPU -02 1 validation worker / STM thread\" lw 2 lc rgb col_gold ,\\"  >> $FILE
    echo  " '$BEST_CO_OP' u (\$0):(\$2/$i):xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"$t_col_best_co_op\" dt new lc rgb \"#b01313\",\\"  >> $FILE
  else
    echo  " '$RESULTS_DIR/TinySTM-wbetl/$i/array-r99-w1-random-walk/$i-random-cpu-validation' u (\$0):(\$2/$i):xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"CPU -02 1 validation worker / STM thread\" lw 2 lc rgb col_gold ,\\"  >> $FILE
  fi
  echo >> $FILE
done

echo  "unset multiplot" >> $FILE

#echo "set style data lines" >> $FILE
#echo "set yrange [0.0000001:10]" >> $FILE
#echo "set title \"CPU GPU co-op validation VS. TinySTM-wbetl, multiple balance\" font \",12\"" >> $FILE

#echo  "plot \\"  >> $FILE
#for i in ${BEST_CO_OP_somewhere[@]}; do
  #t_col=$(echo $i | sed 's/.*\///')
  #echo  " '$i' u (\$0):(\$2/$i):xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"$t_col\" lc rgb \"#11cacaca\",\\"  >> $FILE
#done
#t_col_best_co_op="GLOBAL MINUMUM "
#t_col_best_co_op+=$(echo $BEST_CO_OP | sed 's/.*\///')
#echo  " '$BEST_CO_OP' u (\$0):(\$2/$i):xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"$t_col_best_co_op\" dt new lc rgb \"#b01313\",\\"  >> $FILE
#echo  " '$RESULTS_DIR/TinySTM-wbetl/1a/array-r99-w1-random-walk/1a-random-cpu-validation' u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"CPU 02 1 THREADS VALIDATING random array traversal\" lc rgb col_gold pt 17"  >> $FILE
#echo >> $FILE



gnuplot -p $FILE


