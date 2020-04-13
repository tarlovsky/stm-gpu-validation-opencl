#!/bin/bash

RESULTS_DIR="results-validation-array"

mkdir -p "gnuplot"
####################################################################################################################################################

declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")
declare -a grey_pallet=("696969" "808080" "A9A9A9" "C0C0C0" "D3D3D3" "DCDCDC" "696969")
declare -a all_pallet=("33ccff" "ccccff" "009933" "ff9900" "ff6666" "0033cc" "cc0000" "999966")

FILE="gnuplot/simple-array-validation.gnuplot"

echo "set terminal wxt size 3350,800" > $FILE
#echo "set size 1,1" >> $FILE
#echo "set origin 0,0" >> $FILE
echo "unset bmargin" >> $FILE
echo "unset tmargin" >> $FILE
echo "unset rmargin" >> $FILE
echo "unset lmargin" >> $FILE

echo "set multiplot layout 1,4 title \"Validating random/sequential array traversal single-threaded, Intel 6700k CPU, Intel HD530 iGPU, (TinySTM-WBETL)\" font \",16\"" >> $FILE
echo "set datafile missing '0'" >> $FILE
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

echo "set key font \",7\"" >> $FILE
#echo "set key left Left left Left inside top" >> $FILE
echo "set key left" >> $FILE
echo "set yrange [0.0000001:10]" >> $FILE
echo "set ylabel \"Time (s)\""  >> $FILE

#l1
echo  "set arrow from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb \"#efefef\"" >> $FILE
echo  "set label \"\$L1: 128KB\" at 8.9,0.00000014 " >> $FILE
#intelhd l3
echo  "set arrow from 10.8, graph 0 to 10.8, graph 1 nohead lc rgb \"#dadada\"" >> $FILE
echo  "set label \"\L3 GPU: 512KB\" at 10.9,0.00000014*2.5 " >> $FILE
#l2
echo  "set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb \"#bebebe\"" >> $FILE
echo  "set label \"\$L2: 1.024MB\" at 11.9,0.00000014*1.5 " >> $FILE
#l3
echo  "set arrow from 14.8, graph 0 to 14.8, graph 1 nohead lc rgb \"#afafaf\"" >> $FILE
echo  "set label \"\$L3: 8MB\" at 14.9,0.00000014*2.5 " >> $FILE
echo  "set title \"Only CPU, threaded validation, sequential walk\" font \",12\"" >> $FILE


#######################################################################################
# out of all the data inside TinySTM-igpu-cpu-persistend (CO-OP) validation
# find the fastest percentage. it is somewhere between 55-85% CPU validation assignment
# plot the fastest CO-OP over the first graph

#get baseline TinySTM-wbetl seinglethreaded
BASELINE_FILE="$RESULTS_DIR/TinySTM-wbetl/1a/array-r99-w1-random-walk/1a-random-cpu-validation"

val_time_col=$(awk 'NR>4{printf "%f ", $2}' $BASELINE_FILE) #skip NR>4: header, 64,128,256. start at 512
val_time_col_ref=($val_time_col)
N_RSET_SIZES=${#val_time_col_ref[@]} #get number of rows in file

####### RANDOM #######
BEST_FILE="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-gpu-best"
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
  SEARCH_FILE="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-$j-gpu-$((100-$j))"
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

#we know that there is no place better for sequential so no point in doing it.
#######################################################################################

echo "set title \"CPU with threads + GPU Persistent Kernel threads \" font \",12\"" >> $FILE
echo  "plot \\"  >> $FILE
#tinystm-gpu-persistent threads validation
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-random-GPU-NAIVE-CALL-KERNEL-EVERYTIME'    u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"Persistent Kernel 24WKGPS-224WKGPSIZE-SEQ-CST , random array traversal\" lw 2 lc rgb \"#3cde33\" pt 16,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 3:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"24WKGPs 224WI/WKGP NO VALIDATION LOGIC, JUST POLL\" dt new lc rgb col_24 pt 8,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-SEQ-CST'    u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"Persistent Kernel 24WKGPS-224WKGPSIZE-SEQ-CST , random array traversal\" lw 1 lc rgb col_24 pt 16,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL'    u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"Persistent Kernel 24WKGPS-224WKGPSIZE-ACQ-REL , random array traversal\" dt new lw 1 lc rgb col_24 pt 16,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-RELAXED'    u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"Persistent Kernel 24WKGPS-128WKGPSIZE-RELAXED, random array traversal\" dt new1 lw 1 lc rgb col_24 pt 16,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-random-GPU-48WKGPS-128WKGPSIZE-SEQ-CST'    u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"Persistent Kernel 48WKGPS-128WKGPSIZE-SEQ-CST , random array traversal\" lw 1 lc rgb col_48 pt 16,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-random-GPU-48WKGPS-128WKGPSIZE-ACQ-REL'    u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"Persistent Kernel 48WKGPS-128WKGPSIZE-ACQ-REL , random array traversal\" dt new lw 1 lc rgb col_48 pt 16,\\"  >> $FILE
#tinystm with threads
echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-8-workers' u (\$0 + 3):2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"CPU 02 8 THREADS VALIDATING random array traversal\" lc rgb \"black\" pt 7,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-4-workers' u (\$0 + 3):2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"CPU 02 4 THREADS VALIDATING random array traversal\" dt new1 lc rgb \"black\" pt 7,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-2-workers' u (\$0 + 3):2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"CPU 02 2 THREADS VALIDATING random array traversal\" dt new lc rgb \"black\" pt 7,\\"  >> $FILE
#untouched TINYSTM
echo  " '$RESULTS_DIR/TinySTM-wbetl/1a/array-r99-w1-random-walk/1a-random-cpu-validation' u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"CPU 02 1 THREADS VALIDATING random array traversal\" lc rgb col_gold pt 17,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-wbetl/1a/array-r99-w1-sequential-walk/1a-sequential-cpu-validation'u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"CPU 02 1 THREADS VALIDATING sequential array traversal\" dt new lc rgb col_gold pt 17,\\"  >> $FILE
#ONLY SEQUENTIAL NOW
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-sequential-GPU-48WKGPS-128WKGPSIZE-SEQ-CST'    u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"Persistent Kernel 48WKGPS-128WKGPSIZE-SEQ-CST, sequential array traversal\" lw 2 lc rgb col_48 pt 16,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-sequential-GPU-24WKGPS-224WKGPSIZE-SEQ-CST'    u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"Persistent Kernel 24WKGPS-224WKGPSIZE-SEQ-CST, sequential array traversal\" lw 2 lc rgb col_24 pt 16, \\"  >> $FILE
#these are temporary, for scale, to show difference between having seq_cst, acq_rel, relaxed atomic access inside opencl work-items
#echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) notitle lw 2 lc rgb col_48 pt 1,\\"  >> $FILE
#echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 3:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) notitle dt new lc rgb col_48 pt 1,\\"  >> $FILE
#echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 4:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) notitle dt new1 lc rgb col_48 pt 1,\\"  >> $FILE
#echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) notitle lw 2 lc rgb col_24 pt 1,\\"  >> $FILE
#echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 3:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) notitle dt new lc rgb col_24 pt 1,\\"  >> $FILE
#echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 4:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) notitle dt new1 lc rgb col_24 pt 1"  >> $FILE
echo >> $FILE
#CPU l2 1.02400 megabytes
#CPU l1 128 KB
echo "set title \"CPU with threaded validation \" font \",12\"" >> $FILE
echo  "plot \\"  >> $FILE
#echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-16-workers' u (\$0 + 3):2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"random walk CPU 02 16 THREADS VALIDATING\"  lc rgb \"black\" pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-8-workers' u (\$0 + 3):2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"random walk CPU 02   8 THREADS VALIDATING\" lc rgb \"black\" pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-4-workers' u (\$0 + 3):2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"random walk CPU 02   4 THREADS VALIDATING\" dt new1 lc rgb \"black\" pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-2-workers' u (\$0 + 3):2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"random walk CPU 02   2 THREADS VALIDATING\" dt new lc rgb \"black\" pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-wbetl/1a/array-r99-w1-random-walk/1a-random-cpu-validation' u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"random walk CPU 02   1 THREADS VALIDATING\" lw 2 lc rgb \"black\" pt 1,\\"  >> $FILE
#echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/1a/array-r99-w1-sequential-walk/1-sequential-cpu-validation-16-workers' u (\$0 + 3):2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"sequential walk CPU O2 16 THREADS VALIDATING\" lc rgb col_gold pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation-8-workers' u (\$0 + 3):2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"sequential walk CPU O2   8 THREADS VALIDATING\" lc rgb col_gold pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation-4-workers' u (\$0 + 3):2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"sequential walk CPU O2   4 THREADS VALIDATING\" dt new1 lc rgb col_gold pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-threads-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation-2-workers' u (\$0 + 3):2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"sequential walk CPU 02   2 THREADS VALIDATING\" dt new lc rgb col_gold pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-wbetl/1a/array-r99-w1-sequential-walk/1a-sequential-cpu-validation' u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"sequential walk CPU O2   1 THREADS VALIDATING\" lw 2 dt new lc rgb col_gold pt 1"  >> $FILE

#atomics
echo "set yrange [0.0000001:0.0001]" >> $FILE
echo "set title \"GPU C11 ATOMICS MEMORY ORDER COMPARISON + DIFFERENT GPU OCCUPANCY \" font \",12\"" >> $FILE
echo  "plot \\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t col lw 2 lc rgb col_48 pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 3:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t col dt new lc rgb col_48 pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 4:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t col dt new1 lc rgb col_48 pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t col lw 2 lc rgb col_24 pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 3:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t col dt new lc rgb col_24 pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 4:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t col dt new1 lc rgb col_24 pt 1"  >> $FILE

echo "set style data lines" >> $FILE
echo "set yrange [0.0000001:10]" >> $FILE
echo "set title \"CPU GPU co-op validation VS. TinySTM-wbetl, multiple balance\" font \",12\"" >> $FILE
echo  "plot \\"  >> $FILE
for i in ${BEST_CO_OP_somewhere[@]}; do
  t_col=$(echo $i | sed 's/.*\///')
  echo  " '$i' u (\$0 + 3):2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"$t_col\" lc rgb \"#11cacaca\",\\"  >> $FILE
done
t_col_best_co_op="GLOBAL MINUMUM "
t_col_best_co_op+=$(echo $BEST_CO_OP | sed 's/.*\///')
echo  " '$BEST_CO_OP' u (\$0 + 3):2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"$t_col_best_co_op\" dt new lc rgb \"#b01313\",\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-wbetl/1a/array-r99-w1-random-walk/1a-random-cpu-validation' u 2:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"CPU 02 1 THREADS VALIDATING random array traversal\" lc rgb col_gold pt 17"  >> $FILE
echo >> $FILE

echo  "unset multiplot" >> $FILE

#gnuplot -p $FILE



####################################################################
# Table the times where gpu-cpu co-op is best and show percentages #
####################################################################

FILE1="gnuplot/simple-array-validation-co-op.gnuplot"

#echo "set term postscript eps color solid" >> $FILE1
#echo "set output '1.eps'" >> $FILE1

echo "set terminal wxt size 3300,1080" > $FILE1

echo "set multiplot layout 1,2 title \"Validating random array traversal single-threaded,  Intel 6700k CPU (73%) + Intel HD530 iGPU (27%) CO-OP vs (TinySTM-WBETL)\" font \",16\"" >> $FILE1

echo "set datafile missing \" \"" >> $FILE1
echo "set border linewidth 2" >> $FILE1
echo "set view map" >> $FILE1

echo "set grid front lc rgb \"#1c1c1c\"" >> $FILE1
echo "set datafile separator \" \"" >> $FILE1
echo "set cbrange [0:5]" >> $FILE1
echo "set palette rgb -21,-22,-23" >> $FILE1
echo "set key autotitle columnhead" >> $FILE1
#echo "unset key" >> $FILE1
#echo "unset xtics" >> $FILE1
#echo "set style line 102 lc rgb'#101010' lt 0 lw 4" >> $FILE1
#echo "set grid front ls 102" >> $FILE1
###############################################################
HEAT_CO_OP_BEST_SOMEWHERE_RAND_PATH="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/table-heat-file"
HEAT_CO_OP_BEST_SOMEWHERE_RAND_PATH_SPEEDUP="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/table-heat-file-speedup"
header=$(awk 'NR>4{print $1}' "$RESULTS_DIR/TinySTM-wbetl/1a/array-r99-w1-random-walk/1a-random-cpu-validation")
header1=
for word in ${header[@]}; do
  header1+="\"${word}\" "
done
echo \"Name\" $header1 > $HEAT_CO_OP_BEST_SOMEWHERE_RAND_PATH
echo \"Name\" $header1 > $HEAT_CO_OP_BEST_SOMEWHERE_RAND_PATH_SPEEDUP
cpu=$(awk 'NR>4{print $2}' "$RESULTS_DIR/TinySTM-wbetl/1a/array-r99-w1-random-walk/1a-random-cpu-validation")
for i in ${BEST_CO_OP_somewhere[@]};do
  #from each file extract column 1 and 2
  #draw TINYSTM UNTOUCHED plane accross
  row_name=$(echo $i | sed 's/.*\///')
  row=$(awk 'NR>1{print $2}' $i)

  JOINED=$(paste <(echo "$row") <(echo "$cpu") | awk '{if($1<$2){print $1;}else{print "-"}}')
  JOINED_SPEEDUP=$(paste <(echo "$row") <(echo "$cpu") | awk '{if($1<$2){printf "%.2f ", $2/$1;}else{print "-"}}')
  echo \"${row_name//1-random-/}\" $JOINED >> $HEAT_CO_OP_BEST_SOMEWHERE_RAND_PATH
  echo \"${row_name//1-random-/}\" $JOINED_SPEEDUP >> $HEAT_CO_OP_BEST_SOMEWHERE_RAND_PATH_SPEEDUP
done

echo \"TinySTM-wbetl\" $cpu >> $HEAT_CO_OP_BEST_SOMEWHERE_RAND_PATH
###############################################################

echo "plot '$HEAT_CO_OP_BEST_SOMEWHERE_RAND_PATH' matrix rowheaders columnheaders w image,\\" >> $FILE1
#echo "     '$HEAT_CO_OP_BEST_SOMEWHERE_RAND_PATH' matrix rowheaders columnheaders using 1:2:(sprintf(\"%f\",\$3)) with labels" >> $FILE1
echo "     '$HEAT_CO_OP_BEST_SOMEWHERE_RAND_PATH' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"%f\",\$3)) : (sprintf(\" \")))) with labels" >> $FILE1
echo >> $FILE1
echo "set cbrange [1:1.35]" >> $FILE1
echo "set palette rgb -21,-22,-23" >> $FILE1

echo "plot '$HEAT_CO_OP_BEST_SOMEWHERE_RAND_PATH_SPEEDUP' matrix rowheaders columnheaders w image,\\" >> $FILE1
#echo "     '$HEAT_CO_OP_BEST_SOMEWHERE_RAND_PATH' matrix rowheaders columnheaders using 1:2:(sprintf(\"%f\",\$3)) with labels" >> $FILE1
echo "     '$HEAT_CO_OP_BEST_SOMEWHERE_RAND_PATH_SPEEDUP' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"x%.2f\",\$3)) : (sprintf(\" \")))) with labels" >> $FILE1
echo >> $FILE1

echo "unset multiplot" >> $FILE1
gnuplot -p $FILE1

