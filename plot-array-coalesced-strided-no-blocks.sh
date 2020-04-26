#!/bin/bash

RESULTS_DIR="results-validation-array"

mkdir -p "gnuplot"
####################################################################################################################################################

declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")
declare -a gray_pallet=("696969" "808080" "A9A9A9" "C0C0C0" "D3D3D3" "DCDCDC" "696969")
declare -a all_pallet=("33ccff" "ccccff" "009933" "ff9900" "ff6666" "0033cc" "cc0000" "999966")

FILE="gnuplot/coalesced-strided-no-blocks.gnuplot"

echo "set terminal wxt size 1600,800" > $FILE

#echo "set size 1,1" >> $FILE
#echo "set origin 0,0" >> $FILE
echo "unset bmargin" >> $FILE
echo "unset tmargin" >> $FILE
echo "unset rmargin" >> $FILE
echo "unset lmargin" >> $FILE

echo "set multiplot layout 1,2 title \"COALESCED vs. STRIDED MEMORY ACCESS PATTERNS, FULL iGPU VALIDATION - \" font \",16\"" >> $FILE
echo "set decimal locale \"en_US.UTF-8\"; show locale" >> $FILE
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

declare -a KARRAY=(1 2 3 4 5 6 7 8 9 10 20 40 50 100 200 500 1000 10000 24966)
declare -a RSET=(4096 8192 32768 65536 131072 262144 524288 1048576 2097152 16777216 134217728)

echo >> $FILE
echo "new = \"-\"" >> $FILE
echo "new1 = \"..\"" >> $FILE
echo "new2 = \"_-_\"" >> $FILE

echo "col_24=\"#c724d6\"" >> $FILE
echo "col_48=\"#44cd1\"" >> $FILE
echo "col_gold=\"#8f8800\"" >> $FILE

echo "set key font \",8\"" >> $FILE
#echo "set key left Left left Left inside top" >> $FILE
echo "set key top left" >> $FILE
echo "set yrange [0.0000001:10]" >> $FILE

# LABELS
echo "set ylabel \"Time (s)\""  >> $FILE
echo "set xlabel \"For each read-set entry load at least 8byte: R-ENTRY-T + LOCK; 1 lock covers 4 R-ENTRY-Ts."  >> $FILE

#l1
echo  "set arrow from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb \"#efefef\"" >> $FILE
echo  "set label \"\$L1: 128KB\" at 5.9,0.00000014 " >> $FILE
#intelhd l3
echo  "set arrow from 6.8, graph 0 to 6.8, graph 1 nohead lc rgb \"#dadada\"" >> $FILE
echo  "set label \"\L3 GPU: 512KB\" at 6.9,0.00000014*2.5 " >> $FILE
#l2
echo  "set arrow from 9.8, graph 0 to 9.8, graph 1 nohead lc rgb \"#bebebe\"" >> $FILE
echo  "set label \"\$L2: 1.024MB\" at 9.9,0.00000014*1.5 " >> $FILE
#l3
echo  "set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb \"#afafaf\"" >> $FILE
echo  "set label \"\$L3: 8MB\" at 11.9,0.00000014*2.5 " >> $FILE



echo "set title \"array-r99-w1 (RANDOM ARRAY WALK)\" font \",12\"" >> $FILE
echo "plot \\"  >> $FILE

#memory access modes
echo " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem' u 0:2:3:xtic(sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000))) with yerrorlines t \"Coalesced mem. Persistent Threads\" lc rgb col_48,\\" >> $FILE
echo " '$RESULTS_DIR/TinySTM-igpu-persistent-strided-wbetl/1/array-r99-w1-random-walk/1-strided-mem' u 0:2:3:xtic(sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000))) with yerrorlines t \"Strided mem. Persistent Threads\" lc rgb \"#3cde33\",\\" >> $FILE
#untouched TINYSTM
echo " '$RESULTS_DIR/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:2:3:xtic(sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000))) with yerrorlines t \"TiynSTM untouched\" lc rgb col_gold,\\"  >> $FILE
#co-op
echo " '$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-BEST/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:2:3:xtic(sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000))) with yerrorlines t \"Dynamic split - gpu validates in blocks of 5736 (previous-best)\" lc rgb \"#b01313\",\\" >> $FILE
echo >> $FILE

echo "set title \"array-r99-w1 (SEQUENTIAL ARRAY WALK)\" font \",12\"" >> $FILE
echo "plot \\"  >> $FILE
#memory access modes
echo " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-sequential-walk/1-coalesced-mem' u 0:2:3:xtic(sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000))) with yerrorlines t \"Coalesced mem. Persistent Threads\" lc rgb col_48,\\" >> $FILE
echo " '$RESULTS_DIR/TinySTM-igpu-persistent-strided-wbetl/1/array-r99-w1-sequential-walk/1-strided-mem' u 0:2:3:xtic(sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000))) with yerrorlines t \"Strided mem. Persistent Threads\" lc rgb \"#3cde33\",\\" >> $FILE
#untouched TINYSTM
echo " '$RESULTS_DIR/TinySTM-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u 0:2:3:xtic(sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000))) with yerrorlines t \"TiynSTM untouched\" lc rgb col_gold,\\"  >> $FILE
#co-op
echo " '$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-BEST/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u 0:2:3:xtic(sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000))) with yerrorlines t \"Dynamic split - gpu validates in blocks of 5736 (previous-best)\" lc rgb \"#b01313\",\\" >> $FILE


echo >> $FILE
#CPU l2 1.02400 megabytes
#CPU l1 128 KB



echo  "unset multiplot" >> $FILE

gnuplot -p $FILE

