#!/bin/bash

RESULTS_DIR="../results-validation-array"

mkdir -p "../gnuplot"
####################################################################################################################################################

declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")
declare -a gray_pallet=("696969" "808080" "A9A9A9" "C0C0C0" "D3D3D3" "DCDCDC" "696969")
declare -a all_pallet=("33ccff" "ccccff" "009933" "ff9900" "ff6666" "0033cc" "cc0000" "999966")

FILE="../gnuplot/simple-array-validation-all.gnuplot"

echo "set terminal wxt size 1550,1200" > $FILE

#echo "set size 1,1" >> $FILE
#echo "set origin 0,0" >> $FILE
echo "unset bmargin" >> $FILE
echo "unset tmargin" >> $FILE
echo "unset rmargin" >> $FILE
echo "unset lmargin" >> $FILE

echo "set multiplot layout 2,2 title \"Array traversal (random element access), 1 thread, 4c-8th Intel 6700k CPU, Intel HD530 iGPU, TinySTM-WBETL default config. READS VALIDATED / TIME SPENT IN VALIDATION\" font \",12\"" >> $FILE
echo "set decimal locale \"en_US.UTF-8\"; show locale" >> $FILE
echo "set datafile missing '0'" >> $FILE
#echo "unset ytics" >> $FILE
echo "set tics scale 0"  >> $FILE
#echo "set xtics nomirror rotate by 45 right scale 0 font \",8\"" >> $FILE
#echo "unset ytics" >> $FILE
echo "set ytics font \"Computer Modern, 13\"" >> $FILE
echo "set grid ytics lc rgb \"#606060\"" >> $FILE
echo "set grid xtics lc rgb \"#bbbbbb\"" >> $FILE
#echo "set format y2 \"%0.4f\"" >> $FILE
#echo "set logscale y" >> $FILE

echo "set format x \"%d\"" >> $FILE
echo "set xtics out nomirror rotate by 35 right font \"Computer Modern, 11.5\" " >> $FILE

echo "set datafile separator whitespace" >> $FILE

echo "set border lc rgb \"black\"" >> $FILE
#echo "unset border" >> $FILE

echo "set style data lines" >> $FILE


echo >> $FILE
echo "new = \"-\"" >> $FILE
echo "new1 = \"..\"" >> $FILE
echo "new2 = \"_-_\"" >> $FILE

echo "col_24=\"#c724d6\"" >> $FILE
echo "col_48=\"#44cd1\"" >> $FILE
echo "col_gold=\"#8f8800\"" >> $FILE

echo "set key top right font \"Computer Modern, 13.5\"" >> $FILE
#echo "set key left Left left Left inside top" >> $FILE


# LABELS
echo "set ylabel offset -2,0 \"Reads validated / s\" font \"Computer Modern, 14\""  >> $FILE
echo "set xlabel \"RSET SIZE\" font \"Computer Modern, 11\""  >> $FILE

#l1
echo  "set arrow from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb \"#efefef\"" >> $FILE
echo  "set label \"\$L1: 128KB\" at 5.9, 50000000 font \"Computer Modern, 11.5\"" >> $FILE
#intelhd l3
echo  "set arrow from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb \"#dadada\"" >> $FILE
echo  "set label \"\L3 GPU: 512KB\" at 7.9, 50000000*2.5 font \"Computer Modern, 11.5\"" >> $FILE
#l2
echo  "set arrow from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb \"#bebebe\"" >> $FILE
echo  "set label \"\$L2: 1.024MB\" at 8.9, 50000000*1.5 font \"Computer Modern, 11.5\"" >> $FILE
#l3
echo  "set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb \"#afafaf\"" >> $FILE
echo  "set label \"\$L3: 8MB\" at 11.9, 50000000*2.5 font \"Computer Modern, 11.5\"" >> $FILE


#MAIN TITLE
echo  "set title \"Only CPU, threaded validation, random walk\" font \",12\"" >> $FILE

#atomic memory_access_mode
echo "set style data linespoints" >> $FILE



##################################################################################################################################
declare -a KARRAY_INTEL=(1 2 3 4 5 6 7 8 9 10)
echo "unset logscale y" >> $FILE
echo "set yrange [0:1000000000]" >> $FILE
echo "set ytics 100000000" >> $FILE
#BEST INTEL PERSISTENT KERNEL COALESCED
echo "set title \"Varying Instant Kernel config\" font \"Computer Modern,17\"" >> $FILE
echo  "plot \\"  >> $FILE

#COALESCED mem access VARY # OF WORKGROUPS
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-48wkgps-128wi-each-acq-rel'    u (\$0):(\$8/\$2):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000))) t \"Intel HD 530 coalesced 48WKGPS-128WKGPSIZE-ACQ-REL\" lw 1 lc rgb col_24,\\"  >> $FILE
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-24wkgps-224wi-each-acq-rel'    u (\$0):(\$8/\$2):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000))) t \"Intel HD 530 coalesced 24WKGPS-224WKGPSIZE-ACQ-REL\" lw 1 pt 2 lc rgb col_48,\\"  >> $FILE
echo >> $FILE
##################################################################################################################################


echo "unset logscale y" >> $FILE

echo "set ytics 100000000" >> $FILE
#BEST INTEL PERSISTENT KERNEL COALESCED
echo "set title \"Strided vs. Coalesced - FULL GPU VALIDATION\" font \"Computer Modern,17\"" >> $FILE
echo  "plot \\"  >> $FILE
#COALESCED mem access VARY # OF WORKGROUPS
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-24wkgps-224wi-each-acq-rel'    u (\$0):(\$8/\$2):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000))) t \"Intel HD 530 coalesced 24WKGPS-224WKGPSIZE-ACQ-REL\" lw 1 pt 2 lc rgb col_48,\\"  >> $FILE
#STRIDED mem access 24WKGPS-224WKGPSIZE-ACQ-REL
echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-strided-wbetl/1/array-r99-w1-random-walk/1-strided-mem'    u (\$0):(\$8/\$2):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000))) t \"Intel HD 530 strided 24WKGPS-224WKGPSIZE-ACQ-REL\" lw 1 pt 4 lc rgb \"#${blue_pallet[((1))]}\",\\"  >> $FILE
echo >> $FILE
##################################################################################################################################


declare -a KARRAY_INTEL=(1 2 3 4 5 6 7 8 9 10 20 40 50 100 1000 10000 24966)
echo "unset logscale y" >> $FILE
echo "set key top right font \"Computer Modern, 10.5\"" >> $FILE
echo "set ytics 100000000" >> $FILE
#BEST INTEL PERSISTENT KERNEL COALESCED
echo "set title \"Varying validations/Work-item - Coalesced - Blocks\" font \"Computer Modern,17\"" >> $FILE
echo  "plot \\"  >> $FILE

#blocks
for w in ${KARRAY_INTEL[@]}; do

    echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-$w'    u (\$0):(\$8/\$2):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000))) t \"Blocks of 5376*$w\" lw 1,\\"  >> $FILE

done

echo >> $FILE
##################################################################################################################################

echo "unset logscale y" >> $FILE

echo "set ytics 100000000" >> $FILE
#BEST INTEL PERSISTENT KERNEL COALESCED
echo "set title \"Varying validations/Work-item - Strided - Blocks\" font \"Computer Modern,17\"" >> $FILE
echo  "plot \\"  >> $FILE

for w in ${KARRAY_INTEL[@]}; do

  echo  " '$RESULTS_DIR/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-$w'    u (\$0):(\$8/\$2):xtic(sprintf(\"%'d (%.2fMB)\",\$1, (((\$1*8))/1000000))) t \"Blocks of 5376*$w\" lw 1 ,\\"  >> $FILE

done

echo >> $FILE
##################################################################################################################################

echo "unset multiplot" >> $FILE
gnuplot -p $FILE

