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
FILE1="gnuplot/simple-array-best-K-amd.gnuplot"

#echo "set term postscript eps color solid" >> $FILE1
#echo "set output '1.eps'" >> $FILE1

echo "set terminal wxt size 1230,1100" > $FILE1

echo "set multiplot layout 2,1 title \"Varying N-ELEMENTS-PER-WORK-ITEM. Transactional array walk - AMD Vega 11 - COALESCED memory access\" font \"Computer Modern,16\"" >> $FILE1
#Transactional array walk - COALESCED memory access; varying K (\'N-ELEMENTS-PER-WORK-ITEM\') , 1 STM thread - READS VALIDATED * 10^8 /s - persistent kernel validation in blocks of 11264*K on Vega 11 Ryzen 2400g APU
echo "set decimal locale \"en_US.UTF-8\"; show locale" >> $FILE1
#echo "set datafile missing \" \"" >> $FILE1
echo "unset border" >> $FILE1
echo "set view map" >> $FILE1
echo "set grid front lc rgb \"#999966\"" >> $FILE1
echo "set datafile separator \" \"" >> $FILE1

echo "set cbrange [0.01:10]" >> $FILE1
echo "set palette model RGB defined (0.0 \"#ffffff\" , 0.05 \"#bdd7ff\" ,0.5 \"#c1ff2a\", 0.75 \"#dcff87\",1 \"#efff4d\",2 \"#fff14c\",3 \"#ffa81b\",4 \"#fe971a\",6 \"#ff4e1d\",7 \"#ff1e1e\")" >> $FILE1
#echo "set cbtics (4096 8192 32768 65536 131072 262144 524288 1048576 2097152 16777216 134217728)" >> $FILE1
echo "set key autotitle columnhead" >> $FILE1
echo "set ytics nomirror font \"Computer Modern, 11\" " >> $FILE1

echo "set xlabel \"READ-SET SIZE\" font \"Computer Modern, 11\" " >> $FILE1
echo "set ylabel \"K = N PER WORK-ITEM\" font \"Computer Modern, 11\" " >> $FILE1

#echo "unset colorbox" >> $FILE1
#echo "unset xtics" >> $FILE1
#echo "set style line 102 lc rgb'#101010' lt 0 lw 4" >> $FILE1
echo "set xtics rotate by 45 right scale 0 font \"Computer Modern,12\" offset 0,0,-0.04" >> $FILE1


#echo "set palette rgb -21,-22,-23" >> $FILE1
declare -a KARRAY=(1 2 3 4 5 6 7 8 9 10 20 40 50 100 200 500 1000 10000 11915)

#read-set-sizes in the header of the final file (transposed)
header=

for((i=512;i<=134217728;i*=2));do
  header+="\"${i}\" " #build header (first line in file RESULTS_FILE
done

#repeat for multithreaded
for i in 1; do #2 4 8; do
  for mode in "random" "sequential";
    do
    #folder of config we are comparing agains baseline tinystm
    #store all intermedeiate files here because they belong to them
    TARGET_FOLDER="$RESULTS_DIR/TinySTM-igpu-persistent-blocks-amd-wbetl/$i/array-r99-w1-$mode-walk"

    RESULS_FILE_COALESCED="$TARGET_FOLDER/tabled-heatmap-data-COALESCED"
    TMP="$TARGET_FOLDER/tmp-best-cpu"
    TMP1="$TARGET_FOLDER/tmp-best-co-op"
    echo -n > $RESULS_FILE_COALESCED
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
      echo $(awk -v r=$r 'NR>1{if($1==r){print $0}}' "$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-amd-wbetl/$i/array-r99-w1-$mode-walk/1-$mode-cpu-validation") >> $TMP1
    done

    cpu_val_time=$(awk '{printf "%0.2f\n", ($8/$2)/100000000}' $TMP)
    #get PREVIOUS BEST VAL_TIME. CO-OP- DYNAMIC SPLIT K=1, (THE ONE WITH A LOT OF SUBMERSIONS)
    co_op_val_time=$(awk '{printf "%0.2f\n", ($12/$2)/100000000}' $TMP1)

    echo "\"NAME\" $header" | tee -a $RESULS_FILE_COALESCED

    for k in ${KARRAY[@]};
    do
      echo $k
########################## COALESCED MEM ACCESS ##########################
      mem_access="coalesced"
      MEM_CONFIG_NAME="K=$k"
      CURR_DATA_FILE="$TARGET_FOLDER/$i-$mem_access-mem-K-$k"
      mem_access_line=$(awk -v test=$((11264*$k)) 'NR>1{if($1 > test){print ($8/$2)/100000000 }else{print "-";}}' $CURR_DATA_FILE)
      #extract column 2 with val_times
      #put it into RESULT_FILE with name in $1
      echo \"$MEM_CONFIG_NAME\" $mem_access_line >> $RESULS_FILE_COALESCED
    done
    #plot
    # RSET SIZE
    #

    #echo "set cbrange [0.00000001:10]" >> $FILE1
    #echo "set logscale cb" >> $FILE1

    #line splitting cpu/gpu
    echo  "set arrow 1 from -0.5, 18.5 to 18.5, 18.5 front nohead lc rgb \"#000000\" lw 2" >> $FILE1

    #lines surrounding k=2
    #echo  "set arrow 2 from -0.5, 0.5 to 18.5, 0.5 front nohead lc rgb \"#000000\" lw 2" >> $FILE1
    #echo  "set arrow 3 from -0.5, 1.5 to 18.5, 1.5 front nohead lc rgb \"#000000\" lw 2" >> $FILE1

    echo "\"CPUGPU-coop\"" $co_op_val_time | tee -a $RESULS_FILE_COALESCED
    echo "\"TinySTM-base\"" $cpu_val_time | tee -a $RESULS_FILE_COALESCED

    echo "set title \"$mode array walk\" font \"Computer Modern,14\"" >> $FILE1
    echo "plot '$RESULS_FILE_COALESCED' matrix rowheaders columnheaders w image,\\" >> $FILE1
    # "     '' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"x%.2f\",\$3)) : (sprintf(\"-\")))) with labels font \",11.5\",\\" >> $FILE1
    echo "     '' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"%.3f\",\$3)) : (sprintf(\" \")))):xtic(1):3 with labels font \"Computer Modern,10.7\" palette,\\" >> $FILE1
    echo >> $FILE1

    echo "unset arrow 2" >> $FILE1
    echo "unset arrow 3" >> $FILE1

    #lines surrounding k=4
    #echo  "set arrow 2 from -0.5, 3.5 to 10.5, 3.5 front nohead lc rgb \"#ffffff\" lw 1" >> $FILE1
    #echo  "set arrow 3 from -0.5, 4.5 to 10.5, 4.5 front nohead lc rgb \"#ffffff\" lw 1" >> $FILE1
    #TMP_SLICE="$TARGET_FOLDER/tmp-slice-1"
    #awk '{print $1, $2}' $RESULS_FILE_STRIDED > $TMP_SLICE
    #echo "set palette defined (0 \"forest-green\", 1 \"goldenrod\", 2 \"forest-green\", 3 \"goldenrod\", 4 \"forest-green\", 5 \"goldenrod\", 6 \"forest-green\", 7 \"goldenrod\", 8 \"forest-green\", 9 \"goldenrod\", 10 \"forest-green\", 11 \"goldenrod\", 12 \"forest-green\", 13 \"goldenrod\")" >> $FILE1

    #echo "unset xtics" >> $FILE1
    #echo "unset ytics" >> $FILE1
    #echo "unset border" >> $FILE1
    #echo "set bmargin screen 0.1" >> $FILE1
    #echo "set key samplen -1" >> $FILE1
    #echo "set style fill solid" >> $FILE1
    #echo "set palette model RGB defined ( 0 \"#fba28b\", 1 \"#e63407\", 2 \"#f73e10\", 3 \"#ffb545\", 4 \"#d6cd1f\", 5 \"#fa7a5a\",6 \"#fb8e72\",7 \"#ffb545\")" >> $FILE1
    #echo "set palette defined (0 \"forest-green\", 1 \"goldenrod\", 2 \"forest-green\", 3 \"goldenrod\", 4 \"forest-green\", 5 \"goldenrod\", 6 \"forest-green\", 7 \"goldenrod\", 8 \"forest-green\", 9 \"goldenrod\", 10 \"forest-green\", 11 \"goldenrod\", 12 \"forest-green\", 13 \"goldenrod\")" >> $FILE1
    #echo "plot for [col=1:12] '$RESULS_FILE_COALESCED' \\" >> $FILE1
    #echo "using (col):0:(0.45):(1.0):col with boxxy \\" >> $FILE1
    #echo "lc palette title columnhead(col)" >> $FILE1

    echo >> $FILE1


  done #done with seq, rand.

  break; #NO DATA FOR MULTITHREADED YET

done

echo "unset multiplot" >> $FILE1
gnuplot -p $FILE1

