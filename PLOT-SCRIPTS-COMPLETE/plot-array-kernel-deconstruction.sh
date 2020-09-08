#!/bin/bash

RESULTS_DIR="../results-validation-array"

mkdir -p "../gnuplot"
####################################################################################################################################################

declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")
declare -a gray_pallet=("696969" "808080" "A9A9A9" "C0C0C0" "D3D3D3" "DCDCDC" "696969")
declare -a all_pallet=("33ccff" "ccccff" "009933" "ff9900" "ff6666" "0033cc" "cc0000" "999966")

FILE="../gnuplot/kernel-deconstruction.gnuplot"

echo "set terminal wxt size 1440,1180" > $FILE
#echo "set size 1,1" >> $FILE
#echo "set origin 0,0" >> $FILE
echo "set bmargin at screen 0.250" >> $FILE
echo "unset tmargin" >> $FILE
echo "unset rmargin" >> $FILE
echo "set lmargin at screen 0.135" >> $FILE

#echo "set multiplot layout 1,1 title \"Kernel deconstruction - Array traversal application; Occupancy configuration: 24WKGPS 224WI/WKGP ACQ-REL\" font \",16\"" >> $FILE
echo "set multiplot layout 1,1" >> $FILE
echo "set datafile missing '0'" >> $FILE
echo "set decimal locale \"en_US.UTF-8\"; show locale" >> $FILE
#echo "unset ytics" >> $FILE
echo "set tics scale 0"  >> $FILE
#echo "set xtics nomirror rotate by 45 right scale 0 font \",8\"" >> $FILE
#echo "unset ytics" >> $FILE
echo "set ytics" >> $FILE

echo "set grid ytics lc rgb \"#606060\"" >> $FILE
echo "set grid xtics lc rgb \"#bbbbbb\"" >> $FILE
#echo "set format y2 \"%0.4f\"" >> $FILE
echo "set logscale y" >> $FILE

echo "set format x \"%d\"" >> $FILE
echo "set xtics nomirror rotate by 45 right font \"Computer Modern, 24\" " >> $FILE
echo "set ytics nomirror font \"Computer Modern, 25\" " >> $FILE
echo "set datafile separator whitespace" >> $FILE

echo "set border lc rgb \"black\"" >> $FILE
#echo "unset border" >> $FILE

echo "set style data linespoints" >> $FILE



echo >> $FILE
echo "new = \"-\"" >> $FILE
echo "new1 = \"..\"" >> $FILE
echo "new2 = \"_-_\"" >> $FILE

echo "col_24=\"#c724d6\"" >> $FILE
echo "col_48=\"#44cd1\"" >> $FILE
echo "col_gold=\"#8f8800\"" >> $FILE

#echo "set key font \"Computer Modern, 13\"" >> $FILE
echo "set key left Left left Left reverse inside top font\"Computer modern, 22\"" >> $FILE
#echo "set key font \",26\" width -4 top left outside maxrows 3" >> $FILE

echo "set ylabel offset -10,0 \"Reads validated/s\" font \"Computer Modern, 25\""  >> $FILE
echo "set xlabel offset 2,-6 \"Read-set size\" font \"Computer Modern, 26\""  >> $FILE

#l1
echo  "set arrow from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb \"#efefef\"" >> $FILE
echo  "set label \"\$L1: 128KB\" at 5.9, 1.4*10000000 font \"Computer Modern, 17\"" >> $FILE
#intelhd l3
echo  "set arrow from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb \"#dadada\"" >> $FILE
echo  "set label \"\L3 GPU: 512KB\" at 7.9, 1.4*25000000 font \"Computer Modern, 17\"" >> $FILE
#l2
echo  "set arrow from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb \"#bebebe\"" >> $FILE
echo  "set label \"\$L2: 1.024MB\" at 8.9, 1.4*12000000 font \"Computer Modern, 17\"" >> $FILE
#l3
echo  "set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb \"#afafaf\"" >> $FILE
echo  "set label \"\$L3: 8MB\" at 11.9, 1.4*25000000 font \"Computer Modern, 17\"" >> $FILE
echo  "set title \"Only CPU, threaded validation, sequential walk\" font \",12\"" >> $FILE

echo "set yrange [10000000:190000000000000]" >> $FILE
echo "set title \"Persistent kernel deconstruction of work done by each work-item - Intel HD530\" font \"Computer Modern, 22\"" >> $FILE
echo  "plot \\"  >> $FILE
#echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-24wkgps-224wi-each-acq-rel'    u 0:(\$8/\$2):3:xtic(sprintf(\"%'d\",\$1, (((\$1*8))/1000000))) t \"Persistent Kernel 24WKGPS-224WKGPSIZE-ACQ-REL , random array traversal\" lw 3 lc rgb col_24,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u (\$1/\$7):xtic(sprintf(\"%'d\",\$1, (\$1*8)/1000000)) t \"Validation API call - STM thread preparing metadata; ignore GPU\" lw 3 ps 2 dt new lc rgb \"black\" pt 4,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u (\$1/\$6):xtic(sprintf(\"%'d\",\$1, (\$1*8)/1000000)) t \"Work-items polling, WKGPs signal COMPLETE (REMOVE: GPU17-30)\" lw 3 ps 2 dt new lc rgb \"black\" pt 8,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u (\$1/\$5):xtic(sprintf(\"%'d\",\$1, (\$1*8)/1000000)) t \"Calculate for loop start-end (GPU17), check index out of bounds (GPU18)\" lw 3 ps 2 dt new lc rgb col_24 pt 8,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u (\$1/\$4):xtic(sprintf(\"%'d\",\$1, (\$1*8)/1000000)) t \"Load read-entry (add GPU19)\" lw 3 ps 2 lc rgb col_24 pt 1,\\"  >> $FILE #Work-items don't load lock (GPU20), still
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u (\$1/\$3):xtic(sprintf(\"%'d\",\$1, (\$1*8)/1000000)) t \"Load lock (add GPU20)\" lw 3 ps 2 dt new1 lc rgb col_24 pt 1,\\"  >> $FILE #no branching logic (REMOVE: GPU21-29).
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u (\$1/\$2):xtic(sprintf(\"%'d\",\$1, (\$1*8)/1000000)) t \"Add branching logic, full GPU execution\" lw 3 ps 2 dt new lc rgb col_24 pt 1,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation'      u 0:(\$8/\$2):3:xtic(sprintf(\"%'d\",\$1, (\$1*8)/1000000)) t \"TinySTM-untouched\" lw 3 ps 2 lc rgb col_gold pt 1,\\"  >> $FILE
echo >> $FILE

echo  "unset multiplot" >> $FILE


gnuplot -p $FILE





