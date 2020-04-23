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
FILE1="gnuplot/simple-array-validation-K-choice.gnuplot"

#echo "set term postscript eps color solid" >> $FILE1
#echo "set output '1.eps'" >> $FILE1

echo "set terminal wxt size 2200,1100" > $FILE1

echo "set multiplot layout 2,2 title \"1 STM thread - transactional array walk - effects of COALESCED vs STRIDED memory access in a persistent kernel on Intel hd530\" font \"Computer Modern,16\"" >> $FILE1
echo "set decimal locale \"en_US.UTF-8\"; show locale" >> $FILE1
#echo "set datafile missing \" \"" >> $FILE1
echo "unset border" >> $FILE1
echo "set view map" >> $FILE1
echo "set grid front lc rgb \"#999966\"" >> $FILE1
echo "set datafile separator \" \"" >> $FILE1

echo "set palette model RGB defined ( 0.00001 \"#63d5ff\", 0.000025 \"#d663ff\", 0.000075 \"#9b7df0\", 0.000125 \"#b5d2ff\", 0.000795 \"#ff9900\", 0.00835 \"#d6cd1f\", 0.0145 \"#fa7a5a\",0.085 \"#fb8e72\",0.1055 \"#ffb545\")" >> $FILE1


#echo "set cbtics (4096 8192 32768 65536 131072 262144 524288 1048576 2097152 16777216 134217728)" >> $FILE1
echo "set key autotitle columnhead" >> $FILE1
echo "set ytics nomirror font \"Computer Modern, 11\" " >> $FILE1
echo "set xlabel \"READ-SET SIZE\" font \"Computer Modern, 11\" " >> $FILE1
echo "set ylabel \"PROGRAM\" font \"Computer Modern, 11\" " >> $FILE1
echo "unset colorbox" >> $FILE1
#echo "unset xtics" >> $FILE1
#echo "set style line 102 lc rgb'#101010' lt 0 lw 4" >> $FILE1
echo "set xtics rotate by 45 right scale 0 font \"Computer Modern,12\" offset 0,0,-0.04" >> $FILE1

#echo "set cbrange [0.00000001:2]" >> $FILE1
#echo "set palette rgb -21,-22,-23" >> $FILE1
declare -a KARRAY=(1 2 3 4 5 6 7 8 9 10 20 40 50 100) #ignoring 200. coalesced 200 did not finish and coalesced random was too slow
declare -a RSET=(4096 8192 32768 65536 131072 262144 524288 1048576 2097152 16777216 134217728)

#read-set-sizes
header=

for word in ${RSET[@]}; do
  header+="\"${word}\" "
done

#repeat for multithreaded
for i in 1 2 4 8; do
  for mode in "random" "sequential";
    do
    #folder of config we are comparing agains baseline tinystm
    #store all intermedeiate files here because they belong to them
    TARGET_FOLDER="$RESULTS_DIR/TinySTM-igpu-persistent-blocks-wbetl/$i/array-r99-w1-$mode-walk"

    RESULS_FILE_STRIDED="$TARGET_FOLDER/tabled-heatmap-data-STRIDED"
    RESULS_FILE_COALESCED="$TARGET_FOLDER/tabled-heatmap-data-COALESCED"
    TMP="$TARGET_FOLDER/tmp-best-cpu"
    TMP1="$TARGET_FOLDER/tmp-best-co-op"
    echo -n > $RESULS_FILE_COALESCED
    echo -n > $RESULS_FILE_STRIDED
    echo -n > $TMP
    echo -n > $TMP1
    #get cpu-only val_time

# EXTRACT ONLY DATAPOINTS FROM CPU AND BEST-CO-OP EXISTANT IN VARYING-K STATISTIC #

########################### CPU ###########################

    #extract only those datapoints/readsets we have with "varying K" files/stats
    for r in ${RSET[@]};
    do
      echo $(awk -v r=$r 'NR>1{if($1==r){print $0}}' "$RESULTS_DIR/TinySTM-wbetl/$i/array-r99-w1-$mode-walk/1-$mode-cpu-validation") >> $TMP
    done

########################### CO-OP ###########################
    #extract only those datapoints/readsets we have with "varying K" files/stats
    for r in ${RSET[@]};
    do
      echo $(awk -v r=$r 'NR>1{if($1==r){print $0}}' "$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-BEST/$i/array-r99-w1-$mode-walk/1-$mode-cpu-validation") >> $TMP1
    done
########################### CO-OP ###########################
    cpu_val_time=$(awk '{print $2}' $TMP)
    #get PREVIOUS BEST VAL_TIME. CO-OP- DYNAMIC SPLIT K=1, (THE ONE WITH A LOT OF SUBMERSIONS)
    co_op_val_time=$(awk '{print $2}' $TMP1)

    #i want these comparisons in both STRIDED and COALESCED files
    echo "\"NAME\" $header" | tee -a $RESULS_FILE_COALESCED $RESULS_FILE_STRIDED

    for k in ${KARRAY[@]};
    do
########################## COALESCED MEM ACCESS ##########################
      mem_access="coalesced"
      MEM_CONFIG_NAME="$i-STM-threads-$mem_access-K=$k"
      CURR_DATA_FILE="$TARGET_FOLDER/$i-$mem_access-mem-K-$k"
      mem_access_line=$(awk -v test=$((5376*$k)) 'NR>1{if($1 > test){print $2}else{print "-";}}' $CURR_DATA_FILE)
      #extract column 2 with val_times
      #put it into RESULT_FILE with name in $1
      echo \"$MEM_CONFIG_NAME\" $mem_access_line >> $RESULS_FILE_COALESCED
########################## STRIDED MEM ACCESS ##########################
      mem_access="strided"
      MEM_CONFIG_NAME="$i-STM-threads-$mem_access-K=$k"
      CURR_DATA_FILE="$TARGET_FOLDER/$i-$mem_access-mem-K-$k"
      mem_access_line=$(awk -v test=$((5376*$k)) 'NR>1{if($1 > test){print $2}else{print "-";}}' $CURR_DATA_FILE)
      #extract column 2 with val_times
      #put it into RESULT_FILE with name in $1
      echo \"$MEM_CONFIG_NAME\" $mem_access_line >> $RESULS_FILE_STRIDED
    done
    #plot
    # RSET SIZE
    #

    #echo "set cbrange [0.00000001:10]" >> $FILE1
    #echo "set logscale cb" >> $FILE1

    #line splitting cpu/gpu
    echo  "set arrow 1 from -0.5, 13.5 to 10.5, 13.5 front nohead lc rgb \"black\" lw 2" >> $FILE1

    #lines surrounding k=2
    echo  "set arrow 2 from -0.5, 0.5 to 10.5, 0.5 front nohead lc rgb \"#ffffff\" lw 1" >> $FILE1
    echo  "set arrow 3 from -0.5, 1.5 to 10.5, 1.5 front nohead lc rgb \"#ffffff\" lw 1" >> $FILE1

    echo "\"TINYSTM-BASELINE-CPU-ONLY\"" $cpu_val_time | tee -a $RESULS_FILE_COALESCED $RESULS_FILE_STRIDED
    echo "\"CO-OP-CPU+GPU\"" $co_op_val_time | tee -a $RESULS_FILE_COALESCED $RESULS_FILE_STRIDED

    echo "set title \"COALESCED access varying K (\'N-PER-WORK-ITEM\') ($mode array access)\" font \"Computer Modern,14\"" >> $FILE1
    echo "plot '$RESULS_FILE_COALESCED' matrix rowheaders columnheaders w image,\\" >> $FILE1
    # "     '' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"x%.2f\",\$3)) : (sprintf(\"-\")))) with labels font \",11.5\",\\" >> $FILE1
    echo "     '' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"%f\",\$3)) : (sprintf(\" \")))):xtic(1):3 with labels font \"Computer Modern,10.7\" palette,\\" >> $FILE1
    echo >> $FILE1

    echo "unset arrow 2" >> $FILE1
    echo "unset arrow 3" >> $FILE1
    #lines surrounding k=4
    #echo  "set arrow 2 from -0.5, 3.5 to 10.5, 3.5 front nohead lc rgb \"#ffffff\" lw 1" >> $FILE1
    #echo  "set arrow 3 from -0.5, 4.5 to 10.5, 4.5 front nohead lc rgb \"#ffffff\" lw 1" >> $FILE1
    #TMP_SLICE="$TARGET_FOLDER/tmp-slice-1"
    #awk '{print $1, $2}' $RESULS_FILE_STRIDED > $TMP_SLICE
    #echo "set palette defined (0 \"forest-green\", 1 \"goldenrod\", 2 \"forest-green\", 3 \"goldenrod\", 4 \"forest-green\", 5 \"goldenrod\", 6 \"forest-green\", 7 \"goldenrod\", 8 \"forest-green\", 9 \"goldenrod\", 10 \"forest-green\", 11 \"goldenrod\", 12 \"forest-green\", 13 \"goldenrod\")" >> $FILE1

    echo "set title \"STRIDED access (BEST) varying K (\'N-PER-WORK-ITEM\') ($mode array access)\" font \"Computer Modern,14\"" >> $FILE1
    echo "plot '$RESULS_FILE_STRIDED' matrix rowheaders columnheaders w image,\\" >> $FILE1
    # "     '' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"x%.2f\",\$3)) : (sprintf(\"-\")))) with labels font \",11.5\",\\" >> $FILE1
    echo "     '' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"%f\",\$3)) : (sprintf(\" \")))):xtic(1) with labels font \"Computer Modern ,10.7\" palette,\\" >> $FILE1
    echo >> $FILE1


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
    ################################################################################################################
    ################################################################################################################
    ########################################   GPU ONLY PERSISTENT BLOCKS   ########################################
    ################################################################################################################
    ################################################################################################################


  done #done with seq, rand.

  break; #NO DATA FOR MULTITHREADED YET

done

echo "unset multiplot" >> $FILE1
gnuplot -p $FILE1

