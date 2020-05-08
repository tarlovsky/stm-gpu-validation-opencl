#!/bin/bash

# sudo bash plot-geometric.sh yada|intruder|vacation|kmeans| cpu|gpu

RESULTS_DIR="results-validation-array"


mkdir -p "gnuplot"
#mkdir -p "$RESULTS_DIR"

declare -a thread_count=(1 1a 2 4 8 16 32)
declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")
#get all stm+mods inside results dir

C=2
R=1

#TIMES
FILE="gnuplot/array-r99-w1-dynamic-co-op.gnuplot"
echo > $FILE

#echo "set terminal png size 1920,1080" >> $FILE
echo "set terminal wxt size 2100,700" >> $FILE
#echo "set output '$BENCHMARK-detailed.png'" >> $FILE
echo "set multiplot layout $R,$C rowsfirst title \"TinySTM array-r99-w1 dynamic co-op workload distribution. CPU, GPU, intersected validation by both. BLOCK=5376*K K=1\" font \",16\"" >> $FILE
echo "set decimal locale \"en_US.UTF-8\"; show locale" >> $FILE
#========================== VARS ==========================
echo "col_gold=\"#e8e7ac\"" >> $FILE
echo "xlabeloffsety=-0.75" >> $FILE
#==========================================================

echo "" >> $FILE
echo "set tics scale 0"  >> $FILE

echo "set xtics nomirror rotate by 45 right scale 0 font \",8\""  >> $FILE
echo "set xtics offset 0, xlabeloffsety" >> $FILE
#echo "set datafile missing '0'" >> $FILE
echo "set style fill solid 1"  >> $FILE
echo "set grid ytics lc rgb \"#606060\""  >> $FILE

echo "set format y \"%'g\"" >> $FILE
#echo "set ytics (10,50,100)"  >> $FIL1E
echo "set datafile separator whitespace" >> $FILE
echo "unset border"  >> $FILE
echo "set yrange [1:1000000000]" >> $FILE
echo "set boxwidth 1"  >> $FILE

echo "set style data histogram"  >> $FILE
echo "set style histogram"  >> $FILE
#echo "set style fill solid border -1"  >> $FILE

echo "set key inside top left" >> $FILE
#echo "set key samplen 2.5 spacing 0.85" >> $FILE
echo "set key font \",10\"" >> $FILE
echo "set xlabel \"READ SET ENTRIES\"" >> $FILE
echo "set ylabel \"READS VALIDATED\""  >> $FILE
#echo "set format y \"%2.2f\""  >> $FILE
COUNT=0

# $2 - validation time, $16 - total time
echo "set title \"Random array walk\" font \",12\"" >> $FILE
echo "set logscale y" >> $FILE
echo "plot\\"  >> $FILE
# $14 CPU Val Reads
# $16 GPU Val Reads
# $18 Wasted Val Reads
echo  "      '$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-k-1/1/array-r99-w1-random-walk/1-random-cpu-validation'\\" >> $FILE
#draw columns
echo  "   u 14               t col lc rgbcolor col_gold lt 1 fs pattern 3, \\"  >> $FILE
echo  "'' u 16               t col lc rgbcolor \"#${blue_pallet[((5))]}\" fs pattern 3, \\"  >> $FILE
echo  "'' u 18:xticlabels(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t col lc rgbcolor \"#d1d1cd\" fs pattern 10, \\"  >> $FILE
#draw labels
echo  "      '<tail -n+2 $RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-k-1/1/array-r99-w1-random-walk/1-random-cpu-validation' u (\$0-0.124):((\$14!=0)?(\$14+\$14*0.20):NaN):(sprintf(\"%'d\", \$14)) notitle w labels rotate by 90 left textcolor rgb \"black\" font \",10\", \\"  >> $FILE
echo  "      ''               u (\$0+0.09):((\$16!=0)?(\$16+\$16*0.20):NaN):(sprintf(\"%'d\", \$16)) notitle w labels rotate by 90 left font \",10\", \\"  >> $FILE
echo  "      ''               u (\$0+0.30):((\$18!=0)?(\$18+\$18*0.20):NaN):(sprintf(\"%'d\", \$18)) notitle w labels rotate by 90 left font \",10\", \\"  >> $FILE
#plot errors bars
echo  "      '' u (\$0+0.0055):(1):(sprintf('%.2fx', (\$16>\$14)?((\$16/\$14)):0 )) t \"\" w labels offset char 0,char -0.66 font \",9\", \\"  >> $FILE
echo  "      ''               u (\$0-0.10):(\$14):15 w yerr notitle ls 1 lc rgb '#8f8800' , \\"  >> $FILE
echo  "      ''               u (\$0+0.10):(\$16):17 w yerr notitle ls 1 lc rgb '#cacaca' , \\"  >> $FILE
echo  "      ''               u (\$0+0.31):(\$18):19 w yerr notitle ls 1 lc rgb '#919191' , \\"  >> $FILE
echo "" >> $FILE

echo "set title \"Sequential array walk\" font \",12\"" >> $FILE
echo "set logscale y" >> $FILE
echo "plot\\"  >> $FILE
# $14 CPU Val Reads
# $16 GPU Val Reads
# $18 Wasted Val Reads
echo  "      '$RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-k-1/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation'\\" >> $FILE
#draw columns
echo  "   u 14               t col lc rgbcolor col_gold lt 1 fs pattern 3, \\"  >> $FILE
echo  "'' u 16               t col lc rgbcolor \"#${blue_pallet[((5))]}\" fs pattern 3, \\"  >> $FILE
echo  "'' u 18:xticlabels(sprintf(\"%'d (%.2fMB)\",\$1, (\$1*8)/1000000)) t col lc rgbcolor \"#d1d1cd\" fs pattern 10, \\"  >> $FILE #sets xtic label to READSET/MB format
#draw labels
echo  "      '<tail -n+2 $RESULTS_DIR/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-k-1/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u (\$0-0.124):((\$14!=0)?(\$14+\$14*0.20):NaN):(sprintf(\"%'d\", \$14)) notitle w labels rotate by 90 left textcolor rgb \"black\" font \",10\", \\"  >> $FILE
echo  "      ''               u (\$0+0.09):((\$16!=0)?(\$16+\$16*0.20):NaN):(sprintf(\"%'d\", \$16)) notitle w labels rotate by 90 left font \",10\", \\"  >> $FILE
echo  "      ''               u (\$0+0.30):((\$18!=0)?(\$18+\$18*0.20):NaN):(sprintf(\"%'d\", \$18)) notitle w labels rotate by 90 left font \",10\", \\"  >> $FILE

echo  "      '' u (\$0+0.0055):(1):(sprintf('%.2fx', (\$16>\$14)?((\$16/\$14)):0 )) t \"\" w labels offset char 0,char -0.66 font \",9\", \\"  >> $FILE
#plot errors bars
echo  "      ''               u (\$0-0.10):(\$14):15 w yerr notitle ls 1 lc rgb '#8f8800' , \\"  >> $FILE
echo  "      ''               u (\$0+0.10):(\$16):17 w yerr notitle ls 1 lc rgb '#cacaca' , \\"  >> $FILE
echo  "      ''               u (\$0+0.31):(\$18):19 w yerr notitle ls 1 lc rgb '#919191' , \\"  >> $FILE

echo >> $FILE

echo  "unset multiplot" >> $FILE


gnuplot -p $FILE