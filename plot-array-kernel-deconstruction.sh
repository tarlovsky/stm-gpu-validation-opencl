#!/bin/bash

RESULTS_DIR="results-validation-array"

mkdir -p "gnuplot"
####################################################################################################################################################

declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")
declare -a gray_pallet=("696969" "808080" "A9A9A9" "C0C0C0" "D3D3D3" "DCDCDC" "696969")
declare -a all_pallet=("33ccff" "ccccff" "009933" "ff9900" "ff6666" "0033cc" "cc0000" "999966")

FILE="gnuplot/kernel-deconstruction.gnuplot"

echo "set terminal wxt size 1200,1080" > $FILE
#echo "set size 1,1" >> $FILE
#echo "set origin 0,0" >> $FILE
echo "unset bmargin" >> $FILE
echo "unset tmargin" >> $FILE
echo "unset rmargin" >> $FILE
echo "unset lmargin" >> $FILE

echo "set multiplot layout 1,1 title \"Kernel deconstruction - Array traversal application; Occupancy configuration: 24WKGPS 224WI/WKGP ACQ-REL\" font \",16\"" >> $FILE
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

echo "set style data linespoints" >> $FILE

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
echo "set yrange [0.0000001:10]" >> $FILE
echo "set ylabel \"Time (s)\""  >> $FILE

#l1
echo  "set arrow from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb \"#efefef\"" >> $FILE
echo  "set label \"\$L1: 128KB\" at 7.9,0.00000014 " >> $FILE
#intelhd l3
echo  "set arrow from 9.8, graph 0 to 9.8, graph 1 nohead lc rgb \"#dadada\"" >> $FILE
echo  "set label \"\L3 GPU: 512KB\" at 9.9,0.00000014*2.5 " >> $FILE
#l2
echo  "set arrow from 10.8, graph 0 to 10.8, graph 1 nohead lc rgb \"#bebebe\"" >> $FILE
echo  "set label \"\$L2: 1.024MB\" at 10.9,0.00000014*1.5 " >> $FILE
#l3
echo  "set arrow from 13.8, graph 0 to 13.8, graph 1 nohead lc rgb \"#afafaf\"" >> $FILE
echo  "set label \"\$L3: 8MB\" at 13.9,0.00000014*2.5 " >> $FILE
echo  "set title \"Only CPU, threaded validation, sequential walk\" font \",12\"" >> $FILE

echo "set yrange [0.00000001:1]" >> $FILE
echo "set title \"Persistent threads kernel deconstruction by phase\" font \",12\"" >> $FILE
echo  "plot \\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-24wkgps-224wi-each-acq-rel'    u 0:2:3:xtic(sprintf(\"%d/ %.2fMB\",\$1, (((\$1*8))/1000000))) w yerrorlines t \"Persistent Kernel 24WKGPS-224WKGPSIZE-ACQ-REL , random array traversal\" lw 2 lc rgb col_24,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u 3:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"Normal execution (GPU)\" dt new lc rgb col_24 pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u 4:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"No branching logic (GPU)\" dt new1 lc rgb col_24 pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u 5:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"work-items don't load lock, load read-entry.(GPU)\" lw 1 lc rgb col_24 pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u 6:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"Work-items don't load read-entry. Only calculate for loop start-end.\" dt new lc rgb col_24 pt 8,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u 7:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) t \"No validation inside kernel. Basic kernel polling (GPU) in every WI\" dt new lc rgb \"black\" pt 8,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation'      u 0:2:3:xtic(sprintf(\"%d/ %.2fMB\",\$1, (\$1*8)/1000000)) w yerrorlines t \"Validation API func call, no work, no communication with the GPU\" lc rgb col_gold pt 1,\\"  >> $FILE
echo >> $FILE

echo  "unset multiplot" >> $FILE


gnuplot -p $FILE





