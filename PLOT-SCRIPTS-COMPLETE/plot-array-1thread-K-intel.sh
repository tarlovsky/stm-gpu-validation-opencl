#!/bin/bash

RESULTS_DIR="../results-validation-array"

mkdir -p "../gnuplot"

declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")
declare -a gray_pallet=("696969" "808080" "A9A9A9" "C0C0C0" "D3D3D3" "DCDCDC" "696969")
declare -a all_pallet=("33ccff" "ccccff" "009933" "ff9900" "ff6666" "0033cc" "cc0000" "999966")

#HEATMAP############################################################

####################################################################
# Table the times where gpu-cpu co-op is best and show speedup     #
####################################################################
FILE1="../gnuplot/simple-array-validation-K-choice-1.gnuplot"
FILE2="../gnuplot/simple-array-validation-K-choice-2.gnuplot"

echo > $FILE1
echo > $FILE2
#echo "set term postscript eps color solid" >> $FILE1
#echo "set output '1.eps'" >> $FILE1

echo "set terminal wxt size 1230,1100" | tee -a $FILE1 $FILE2

echo "set multiplot layout 2,1 title \"Optimizing number of elements/work-item. RANDOM array walk - Intel HD530\" font \"Computer Modern,16\"" >> $FILE1
echo "set multiplot layout 2,1 title \"Optimizing number of elements/work-item. SEQUENTIAL array walk - Intel HD530\" font \"Computer Modern,16\"" >> $FILE2

echo "set decimal locale \"en_US.UTF-8\"; show locale" | tee -a $FILE1 $FILE2
#echo "set datafile missing \" \"" | tee -a $FILE1 $FILE2
echo "unset border" | tee -a $FILE1 $FILE2
echo "set view map" | tee -a $FILE1 $FILE2
echo "set grid front lc rgb \"#999966\"" | tee -a $FILE1 $FILE2
echo "set datafile separator \" \"" | tee -a $FILE1 $FILE2
echo "set format x \"%d\"" | tee -a $FILE1 $FILE2
echo "set cbrange [0.01:15]" | tee -a $FILE1 $FILE2
echo "set palette model RGB defined (0.0 \"#ffffff\" , 0.05 \"#bdd7ff\" ,0.5 \"#c1ff2a\", 0.75 \"#dcff87\",1 \"#efff4d\",2 \"#fff14c\",3 \"#ffa81b\",4 \"#fe971a\",6 \"#ff4e1d\",7 \"#ff1e1e\")" | tee -a $FILE1 $FILE2

#echo "set cbtics (4096 8192 32768 65536 131072 262144 524288 1048576 2097152 16777216 134217728)" | tee -a $FILE1 $FILE2
echo "set key autotitle columnhead" | tee -a $FILE1 $FILE2
echo "set ytics nomirror font \"Computer Modern, 11\" " | tee -a $FILE1 $FILE2

echo "set xlabel \"READ-SET SIZE\" font \"Computer Modern, 11\" " | tee -a $FILE1 $FILE2
echo "set ylabel offset 2.5,0 \"K = N PER WORK-ITEM\" font \"Computer Modern, 11\" " | tee -a $FILE1 $FILE2
#echo "unset colorbox" | tee -a $FILE1 $FILE2
#echo "unset xtics" | tee -a $FILE1 $FILE2
#echo "set style line 102 lc rgb'#101010' lt 0 lw 4" | tee -a $FILE1 $FILE2
echo "set xtics rotate by 45 right scale 0 font \"Computer Modern,12\" offset 0,0,-0.04" | tee -a $FILE1 $FILE2

#echo "set cbrange [0.001:9]" | tee -a $FILE1 $FILE2
#echo "set palette rgb -21,-22,-23" | tee -a $FILE1 $FILE2
#declare -a KARRAY=(1 2 3 4 5 6 7 8 9 10 20 40 50 100) #ignoring 200. coalesced 200 did not finish and coalesced random was too slow
declare -a KARRAY=(1 2 3 4 5 6 7 8 9 10 20 40 50 100 200 500 1000 10000 24966)
#declare -a RSET=(512 4096 8192 32768 65536 131072 262144 524288 1048576 2097152 16777216 134217728)

#read-set-sizes
header=

for((i=512;i<=134217728;i*=2));do
  header+="\"${i}\" " #build header (first line in file RESULTS_FILE
done

#repeat for multithreaded
i=1
for mode in "random" "sequential";
  do
  echo "$mode"
  #folder of config we are comparing agains baseline tinystm
  #store all intermedeiate files here because they belong to them
  TARGET_FOLDER="$RESULTS_DIR/TinySTM-igpu-persistent-blocks-wbetl/$i/array-r99-w1-$mode-walk"

  RESULS_FILE_STRIDED="$TARGET_FOLDER/tabled-heatmap-data-STRIDED-$mode"
  RESULS_FILE_COALESCED="$TARGET_FOLDER/tabled-heatmap-data-COALESCED-$mode"
  TMP="$TARGET_FOLDER/tmp-best-cpu"
  TMP1="$TARGET_FOLDER/tmp-best-co-op"
  echo -n > $RESULS_FILE_COALESCED
  echo -n > $RESULS_FILE_STRIDED
  echo -n > $TMP
  echo -n > $TMP1
  #get cpu-only val_time

# EXTRACT ONLY DATAPOINTS FROM CPU AND BEST-CO-OP EXISTANT IN VARYING-K STATISTIC #

  #extract only those datapoints/readsets we have with "varying K" files/stats
  for((r=512;r<=134217728;r*=2));do
    ########################### TINY UNTOUCHED ###########################
    echo $(awk -v r=$r 'NR>1{if($1==r){print $0}}' "$RESULTS_DIR/TinySTM-wbetl/$i/array-r99-w1-$mode-walk/1-$mode-cpu-validation") >> $TMP
    #extract only those datapoints/readsets we have with "varying K" files/stats
    ########################### CO-OP ###########################
    echo $(awk -v r=$r 'NR>1{if($1==r){print $0}}' "$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-k-1/$i/array-r99-w1-$mode-walk/1-$mode-cpu-validation") >> $TMP1
  done

  cpu_val_time=$(awk '{printf "%0.2f\n", ($8/$2)/100000000}' $TMP)
  #get PREVIOUS BEST VAL_TIME. CO-OP- DYNAMIC SPLIT K=1, (THE ONE WITH A LOT OF SUBMERSIONS)
  co_op_val_time=$(awk '{printf "%0.2f\n", ($12/$2)/100000000}' $TMP1)

  #i want these comparisons in both STRIDED and COALESCED files
  echo "\"NAME\" $header" | tee -a $RESULS_FILE_COALESCED $RESULS_FILE_STRIDED

  for k in ${KARRAY[@]};
  do
########################## COALESCED MEM ACCESS ##########################
    mem_access="coalesced"
    MEM_CONFIG_NAME="K=$k" #Y label
    CURR_DATA_FILE="$TARGET_FOLDER/$i-$mem_access-mem-K-$k" #SOURCE
    mem_access_line=$(awk -v test=$((5376*$k)) 'NR>1{if($1 > test){print ($8/$2)/100000000 }else{print "-";}}' $CURR_DATA_FILE)
    #extract column 2 with val_times
    #put it into RESULT_FILE with name in $1
    echo \"$MEM_CONFIG_NAME\" $mem_access_line >> $RESULS_FILE_COALESCED
########################## STRIDED MEM ACCESS ##########################
    mem_access="strided"
    MEM_CONFIG_NAME="K=$k" #Y label
    CURR_DATA_FILE="$TARGET_FOLDER/$i-$mem_access-mem-K-$k" #SOURCE
    mem_access_line=$(awk -v test=$((5376*$k)) 'NR>1{if($1 > test){print ($8/$2)/100000000}else{print "-";}}' $CURR_DATA_FILE)
    #extract column 2 with val_times
    #put it into RESULT_FILE with name in $1
    echo \"$MEM_CONFIG_NAME\" $mem_access_line >> $RESULS_FILE_STRIDED
  done
  #plot
  # RSET SIZE
  #

  #echo "set cbrange [0.00000001:10]" | tee -a $FILE1 $FILE2
  #echo "set logscale cb" | tee -a $FILE1 $FILE2

  #line splitting cpu/gpu
  echo  "set arrow 1 from -0.5, 18.5 to 18.5, 18.5 front nohead lc rgb \"#000000\" lw 2" | tee -a $FILE1 $FILE2

  #lines surrounding k=2
  echo  "set arrow 2 from -0.5, 0.5 to 18.5, 0.5 front nohead lc rgb \"#000000\" lw 2" | tee -a $FILE1 $FILE2
  echo  "set arrow 3 from -0.5, 1.5 to 18.5, 1.5 front nohead lc rgb \"#000000\" lw 2" | tee -a $FILE1 $FILE2

  echo "\"INTEL-COOP\"" $co_op_val_time | tee -a $RESULS_FILE_COALESCED $RESULS_FILE_STRIDED
  echo "\"TinySTM-INTEL\"" $cpu_val_time | tee -a $RESULS_FILE_COALESCED $RESULS_FILE_STRIDED


  if [[ $mode == "random" ]];then
    FILE=$FILE1
  else
    FILE=$FILE2
  fi

  #COALESCED
  echo "set title \"COALESCED kernel memory access\" font \"Computer Modern,18\"" >> $FILE
  echo "plot '$RESULS_FILE_COALESCED' matrix rowheaders columnheaders w image,\\" >> $FILE
  # "     '' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"x%.2f\",\$3)) : (sprintf(\"-\")))) with labels font \",11.5\",\\" >> $FILE
  echo "     '' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"%.3f\",\$3)) : (sprintf(\" \")))):xtic((sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000)))):3 with labels font \"Computer Modern,10.7\" palette,\\" >> $FILE
  echo >> $FILE

  echo "unset arrow 2" | tee -a $FILE1 $FILE2
  echo "unset arrow 3" | tee -a $FILE1 $FILE2

  ############################################################################################################################################################################################################################################################################################################
  #lines surrounding k=2
  echo  "set arrow 2 from -0.5, -0.5 to 18.5, -0.5 front nohead lc rgb \"#000000\" lw 2" >> $FILE
  echo  "set arrow 3 from -0.5, 2.5 to 18.5, 2.5 front nohead lc rgb \"#000000\" lw 2" >> $FILE

  #STRIDED
  echo "set title \"STRIDED kernel memory access\" font \"Computer Modern,18\"" >> $FILE
  echo "plot '$RESULS_FILE_STRIDED' matrix rowheaders columnheaders w image,\\" >> $FILE
  # "     '' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"x%.2f\",\$3)) : (sprintf(\"-\")))) with labels font \",11.5\",\\" >> $FILE
  echo "     '' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"%.3f\",\$3)) : (sprintf(\" \")))):xtic(1) with labels font \"Computer Modern ,10.7\" palette,\\" >> $FILE
  echo >> $FILE

done #done with seq, rand.

echo "unset multiplot" >> $FILE1
echo "unset multiplot" >> $FILE2

gnuplot -p $FILE1
gnuplot -p $FILE2

