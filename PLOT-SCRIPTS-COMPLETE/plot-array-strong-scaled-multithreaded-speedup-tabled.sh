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
FILE1="../gnuplot/simple-array-validation-dynamic-co-op.gnuplot"

#echo "set term postscript eps color solid" >> $FILE1
#echo "set output '1.eps'" >> $FILE1

echo "set terminal wxt size 1400,1250" > $FILE1

echo "set multiplot layout 4,2 title \"Transactional array traversal application - Intel 6700k CPU + Intel HD530 iGPU co-operative validation with dynamic workload assignment vs. TinySTM-WBETL unmodified\" font \"Computer Modern,16\"" >> $FILE1
echo "set decimal locale \"en_US.UTF-8\"; show locale" >> $FILE1
#echo "set datafile missing \" \"" >> $FILE1
#echo "unset border" >> $FILE1
echo "set view map" >> $FILE1
echo "set tmargin 5" >> $FILE1
echo "set lmargin 15" >> $FILE1
echo "set grid front lc rgb \"#999966\"" >> $FILE1
echo "set datafile separator \" \"" >> $FILE1
echo "set palette rgb -21,-22,-23" >> $FILE1
echo "set key autotitle columnhead" >> $FILE1
echo "set ytics font \"Computer Modern, 11\"" >> $FILE1
#echo "set ztics font \"Computer Modern, 21\"" >> $FILE1
echo "set xlabel \"Read-set size\" offset 0, -1.6 font\"Computer Modern, 13\"" >> $FILE1
#echo "set ylabel offset -1.2 ,0 \"Program\" font\"Computer Modern, 15\"" >> $FILE1
echo "unset colorbox" >> $FILE1
#echo "unset xtics" >> $FILE1
#echo "set style line 102 lc rgb'#101010' lt 0 lw 4" >> $FILE1

echo "set xtics nomirror rotate by 40 right font \"Computer Modern, 16\"" >> $FILE1
echo "set format x \"%'d\"" >> $FILE1
echo "set cbrange [0.78:3.8]" >> $FILE1
echo "set palette rgb -21,-22,-23" >> $FILE1

#read-set-sizes
header=$(awk 'NR>5{print $1}' "$RESULTS_DIR/TinySTM-wbetl/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random")
rset_sizes=
empty_line=
for word in ${header[@]}; do
  rset_sizes+="\"${word}\" "
  empty_line+="- "
done

#repeat for multithreaded

# GETTING BEST OF BEST
for i in 1 2 4 8; do
  for mode in "random"; #"sequential";
    do
    #folder of config we are comparing agains baseline tinystm
    #store all intermedeiate files here because they belong to them
    TARGET_FOLDER="$RESULTS_DIR"

    #untouched
    cpu=$(awk 'NR>5{print $8/$2}' "$RESULTS_DIR/TinySTM-wbetl/$i/array-strongly-scaled-r99-w1-d1-$mode-walk/$i-$mode")
    #intel
    intel=$(awk 'NR>5{print $12/$2}' "$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/$i/array-strongly-scaled-shared-gpu-r99-w1-d1-$mode-walk/$i-$mode")
    #amd 
    amd=$(awk 'NR>5{print $12/$2}' "$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-amd-wbetl/$i/array-strongly-scaled-shared-gpu-r99-w1-d1-$mode-walk/$i-$mode")
    #validators
    validators=$(awk 'NR>5{print $8/$2}' "$RESULTS_DIR/TinySTM-threads-wbetl/$i/array-strongly-scaled-r99-w1-d1-$mode-walk/$i-$mode-4-workers")

    #parse speedup between them
    SPEEDUP_intel=$(paste <(echo "$intel") <(echo "$cpu") | awk '{if($1>$2){printf "%.2f ", $1/$2;}else{print "-"}}')
    SPEEDUP_amd=$(paste <(echo "$amd") <(echo "$cpu") | awk '{if($1>$2){printf "%.2f ", $1/$2;}else{print "-"}}')
    SPEEDUP_validators=$(paste <(echo "$validators") <(echo "$cpu") | awk '{if($1>$2){printf "%.2f ", $1/$2;}else{print "-"}}')

    RESUL_FILE_SPEEDUP="$TARGET_FOLDER/best-of-best-array-speedup-$i-threads"

    #such a fucking hack. create two files in order to FORMAT plots them differently, lol
    #one with speedups %.2f, and one with time in seconds.
    echo "\"NAME\"" $rset_sizes > $RESUL_FILE_SPEEDUP
    #echo $SPEEDUP
    echo "CPU-Validators" $SPEEDUP_validators >> $RESUL_FILE_SPEEDUP
    echo "AMD-cooperative" $SPEEDUP_amd >> $RESUL_FILE_SPEEDUP
    echo "INTEL-cooperative" $SPEEDUP_intel >> $RESUL_FILE_SPEEDUP

    #plot
    # RSET SIZE
    #
    echo "set title offset 0, -1 \"$i STM threads\" font \",17\"" >> $FILE1
    echo "plot '$RESUL_FILE_SPEEDUP' matrix rowheaders columnheaders w image , \\" >> $FILE1
    echo "     '$RESUL_FILE_SPEEDUP' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"x%.2f\",\$3)) : (sprintf(\"-\")))) with labels font \"Computer Modern, 16.5\",\\" >> $FILE1
    #echo "     '$RESUL_FILE' matrix rowheaders columnheaders using 1:2:(((\$3 > 0) ? (sprintf(\"%f\",\$3)) : (sprintf(\" \")))):xtic(1) with labels,\\" >> $FILE1
    echo >> $FILE1
    
  done #done with seq, rand.
  #echo >> $FILE1
  #break; #NO DATA FOR MULTITHREADED YET
done

echo "unset multiplot" >> $FILE1
gnuplot -p $FILE1

