#!/bin/bash

# sudo bash plot-geometric.sh yada|intruder|vacation|kmeans| cpu|gpu

BENCHMARK=$1
DIR=$2

if [[ "$#" -ne 2 ]];then
    echo "Illegal number of arguments. Correct usage:"
    echo "bash plot-detaild.sh BENCH DIR"
    echo "bash plot-detaild.sh ssca2 cpu"
    echo ""
    exit;
fi

if [[ ! $DIR =~ ^(cpu|gpu)$  ]];then
    echo "second argument can only be cpu or gpu."
    exit;
fi

RESULTS_DIR="results-$DIR"


mkdir -p "gnuplot"
#mkdir -p "$RESULTS_DIR"

benchmarks=("tpcc" "sb7" "synth" "redblacktree" "linkedlist" "hashmap" "skiplist" "genome" "intruder" "kmeans" "labyrinth" "ssca2" "vacation" "yada")

declare -a thread_count=(1 1a 2 4 8 16 32)
declare -a blue_pallet=("69a2ff" "7dafff" "94bdff" "9cc2ff" "adcdff" "b5d2ff" "bdd7ff")
#get all stm+mods inside results dir

if [[ ! " ${benchmarks[@]} " =~ " ${BENCHMARK} " ]]; then
    echo "Benchmark does not exist. Exiting."
    exit;
fi

C=5
R=1

#TIMES
FILE="gnuplot/$BENCHMARK.geometric.gnuplot"

echo > $FILE

#echo "set terminal png size 1920,1080" >> $FILE
echo "set terminal wxt size 3400,720" >> $FILE
#echo "set output '$BENCHMARK-detailed.png'" >> $FILE
echo "set multiplot layout $R,$C rowsfirst title \"$BENCHMARK - geometric average representation of a variety of program arguments\" font \",16\"" >> $FILE

echo "set bmargin 15" >> $FILE
echo "xlabeloffsety=-2.75" >> $FILE
echo "" >> $FILE
echo "set tics scale 0"  >> $FILE

echo "set xtics nomirror rotate by 45 right scale 0 font \",8\""  >> $FILE
echo "set xtics offset 0, xlabeloffsety" >> $FILE
#echo "set datafile missing '0'" >> $FILE
echo "set style fill solid 1.00"  >> $FILE
echo "set grid ytics lc rgb \"#606060\""  >> $FILE


echo "set format y \"%0.3f\"" >> $FILE
#echo "set ytics (10,50,100)"  >> $FIL1E
echo "set datafile separator whitespace" >> $FILE
echo "unset border"  >> $FILE
echo "set yrange [0:*]" >> $FILE
echo "set boxwidth 0.88"  >> $FILE

echo "set style data histogram"  >> $FILE
echo "set style histogram rowstacked gap 1"  >> $FILE
#echo "set style fill solid border -1"  >> $FILE



#TODO:
echo "unset key" >> $FILE
#echo "set key outside bottom horizontal Left" >> $FILE
#echo "set key samplen 2.5 spacing 0.85" >> $FILE
#echo "set key font \",8\"" >> $FILE

if [[ $DIR == "cpu" ]]; then
  step=5
else
  step=5
fi

echo "leftcolumn_offset_1= $((step*0))" >> $FILE
echo "leftcolumn_offset_1a=$((step*1))" >> $FILE
echo "leftcolumn_offset_2= $((step*2))" >> $FILE
echo "leftcolumn_offset_4= $((step*3))" >> $FILE
echo "leftcolumn_offset_8= $((step*4))" >> $FILE
echo "leftcolumn_offset_16=$((step*5))" >> $FILE
echo "leftcolumn_offset_32=$((step*6))" >> $FILE

########################################### VALIDATION TIME/TOTAL TIME#####################################################
echo "set ylabel \"Time (s)\""  >> $FILE
echo "set format y \"%2.2f\""  >> $FILE

# $2 - validation time, $16 - total time
echo "set title \"Validation time/total execution time (s)\" font \",12\"" >> $FILE

echo "plot\\"  >> $FILE
COUNT=0
for i in ${!thread_count[@]}; do
    n=${thread_count[$i]}
    echo  "    newhistogram \"{$n threads}\" offset char 0,xlabeloffsety, \\"  >> $FILE
    echo  "      '$RESULTS_DIR/geometric-$n-${BENCHMARK}-cluster' u 2:xtic(1) t col lc rgbcolor \"#${blue_pallet[((COUNT))]}\" lt 1 fs pattern 3, \\"  >> $FILE
    echo  "      ''               u (\$16>=\$2 ? \$16-\$2 : NaN) t col lc rgbcolor \"#${blue_pallet[((COUNT++))]}\" fs pattern 6, \\"  >> $FILE
    echo  "      ''               u (\$0-1-0.26):((\$2!=0)?\$2:NaN):(sprintf('%2.6f', \$2)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left textcolor rgb \"#8f8800\" font \",7\", \\"  >> $FILE
    echo  "      ''               u (\$0-1+0.26):((\$16!=0)?\$16:NaN):(sprintf('%2.6f', \$16)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left font \",7\", \\"  >> $FILE
    echo  "      ''               u (\$0-1):(\$2-\$2):(sprintf('%2.1f%', (\$16!=0)?(\$2/\$16*100):0)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 right font \",7\", \\"  >> $FILE
    echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$2):3 w yerr ls 1 lc rgb \"#8f8800\" t \"\", \\"  >> $FILE
    if [[ "$n" == "${thread_count[-1]}" ]]; then
        echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$16):17 w yerr ls 1 lc rgb 'black' t \"\""  >> $FILE
    else
        echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$16):17 w yerr ls 1 lc rgb 'black' t \"\", \\"  >> $FILE
    fi
done

########################################### Validation success rate #####################################################
echo "set ylabel \"\""  >> $FILE
echo "set format y \"\""  >> $FILE
echo "unset grid"  >> $FILE

echo "set title \"Validation success rate \" font \",12\" " >> $FILE
echo "plot\\"  >> $FILE
COUNT=0
for i in ${!thread_count[@]}; do
    n=${thread_count[$i]}

    echo  "    newhistogram \"{$n threads}\" offset char 0,xlabeloffsety, \\"  >> $FILE
    echo  "      '$RESULTS_DIR/geometric-$n-${BENCHMARK}-cluster' using 12:xtic(1) t col lc rgbcolor \"#b3d1ff\" lt 1 fs pattern 6, \\"  >> $FILE
    echo  "      ''               u (\$10) t col lc rgbcolor \"#${blue_pallet[((COUNT++))]}\" lt 1 fs pattern 3, \\"  >> $FILE
    #Lables 10 val succ 12 val fail
    echo  "      ''               u (\$0-1-0.27):((\$12!=0)?\$12:NaN):(sprintf('%d', \$12)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left textcolor rgb \"#8f8800\" font \",7\", \\"  >> $FILE
    echo  "      ''               u (\$0-1+0.27):((\$12+\$10!=0)?\$12+\$10:NaN):(sprintf('%d', \$10)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left font \",7\", \\"  >> $FILE
    #8-validation calls percentage compared to commits
    echo  "      ''               u (\$0-1):(\$10-\$10):(sprintf('%2.2f%', ((\$10+\$12)!=0)?(\$10/(\$10+\$12)*100):100 )) notitle w labels offset first leftcolumn_offset_$n rotate by 90 right font \",7\", \\"  >> $FILE
    #errors
    echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$12):13 w yerr ls 1 lc rgb \"#8f8800\"  t \"\", \\"  >> $FILE
    if [[ "$n" == "${thread_count[-1]}" ]]; then
        echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$12+\$10):11 w yerr ls 1 lc rgb 'black' t \"\""  >> $FILE
    else
        echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$12+\$10):11 w yerr ls 1 lc rgb 'black' t \"\", \\"  >> $FILE
    fi
done


########################################### average Read entries validated / s #####################################################
echo "set xtics offset 0, 0" >> $FILE
echo "set ylabel \"\""  >> $FILE
echo "set format y \"%g\""  >> $FILE
echo "unset grid"  >> $FILE

echo "set title \"Reads validated/s (avg.) \" font \",12\"" >> $FILE
echo "plot\\"  >> $FILE
COUNT=0
for i in ${!thread_count[@]}; do
    n=${thread_count[$i]}
    echo  "    newhistogram \"{$n threads}\" offset char 0,xlabeloffsety, \\"  >> $FILE
    echo  "      '$RESULTS_DIR/geometric-$n-${BENCHMARK}-cluster' using (\$2!=0?(\$8/(\$2)):0):xtic(1) t col lc rgbcolor \"#${blue_pallet[((COUNT++))]}\" lt 1 fs pattern 10, \\"  >> $FILE
    #Lables 2 val time 8 reads validated total
    if [[ "$n" == "${thread_count[-1]}" ]]; then
        echo  "      ''               u (\$0-1):(\$2>0?(\$8/(\$2)):0):( sprintf('%.2g', \$8/(\$2)) ) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left font \",8\""  >> $FILE
    else
        echo  "      ''               u (\$0-1):(\$2>0?(\$8/(\$2)):0):( sprintf('%.2g', \$8/(\$2)) ) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left font \",8\", \\"  >> $FILE
    fi
done

########################################### COMMITS/ABORTS #####################################################
echo "set xtics offset 0, xlabeloffsety" >> $FILE
echo "set ylabel \"\""  >> $FILE
echo "set format y \"\""  >> $FILE
echo "unset grid"  >> $FILE

echo "set title \"Commit/Abort rate\" font \",12\" " >> $FILE

################### for large outliers on the plot #################
get_ymax(){
    # col 1
    # col 2
    # filename
    echo $(awk -v col1=$1 -v col2=$2 '(NR>1){C+=$col1;A+=$col2;n+=1;}END{Cavg=(C/n);Aavg=(A/n);if(C>A){printf "%ld", Cavg;}else{printf "%ld", Aavg;}}' "$3")
}
ymax=0

for i in ${!thread_count[@]}; do
    n=${thread_count[$i]}
    v=$(get_ymax 4 6 "$RESULTS_DIR/geometric-$n-${BENCHMARK}-cluster")
    #echo "geometric-$n-$BENCHMARK-cluster ymax[0:$v]"
    ymax=$(bc -l <<< "$ymax+l($v)";)
done
ymax=$(bc -l <<< "e($ymax/${#thread_count[@]})";)
echo $ymax

#activate it
#echo "set yrange [0:$ymax]" >> $FILE
#####################################################################

echo "plot\\"  >> $FILE
COUNT=0
for i in ${!thread_count[@]}; do
    n=${thread_count[$i]}
    echo  "    newhistogram \"{$n threads}\" offset char 0,xlabeloffsety, \\"  >> $FILE
    echo  "      '$RESULTS_DIR/geometric-$n-${BENCHMARK}-cluster' using 4:xtic(1) t col lc rgbcolor \"#80b3ff\" lt 1 fs pattern 3, \\"  >> $FILE
    echo  "      ''               u (\$6) t col lc rgbcolor \"#${blue_pallet[((COUNT++))]}\" lt 1 fs pattern 6, \\"  >> $FILE
    #Lables 10 val succ 12 val fail
    echo  "      ''               u (\$0-1-0.27):(\$4):(sprintf('%d', \$4)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left textcolor rgb \"#8f8800\" font \",7\", \\"  >> $FILE
    echo  "      ''               u (\$0-1+0.27):(\$6+\$4):(sprintf(  (\$6<=149999)?('%d (%d%)'):('%.g (%d%)'), \$6, ((\$6+\$4>0)?((\$6/(\$4+\$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left font \",7\", \\"  >> $FILE
    #8-validation calls percentage compared to commits
    echo  "      ''               u (\$0-1):(\$6-\$6):(sprintf('%.g tx/s', ((\$16>0)?((\$4)/\$16):(0)))) notitle w labels offset first leftcolumn_offset_$n rotate by 90 right font \",6\", \\"  >> $FILE
    #errors
    echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$4):5 w yerr ls 1 lc rgb \"#8f8800\" t \"\", \\"  >> $FILE
    if [[ "$n" == "${thread_count[-1]}" ]]; then
        echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$6+\$4):7 w yerr ls 1 lc rgb 'black' t \"\""  >> $FILE
    else
        echo  "      ''               u (\$0-1+leftcolumn_offset_$n):(\$6+\$4):7 w yerr ls 1 lc rgb 'black' t \"\", \\"  >> $FILE
    fi
done


########################################### ENERGY #####################################################
echo "set xtics offset 0, 0" >> $FILE
echo "unset grid"  >> $FILE
echo "set ylabel \"Power consumption (W)\""  >> $FILE
echo "set format y \"%2.0f\""  >> $FILE
echo "set grid ytics lc rgb \"#606060\""  >> $FILE
echo "unset datafile" >> $FILE

echo "set title \"Energy consumption using Intel RAPL (W)\" font \",12\" " >> $FILE
echo "plot\\"  >> $FILE
COUNT=0
for i in ${!thread_count[@]}; do
    n=${thread_count[$i]}
    echo  "    newhistogram \"{$n threads}\" offset char 0,xlabeloffsety, \\"  >> $FILE
    echo  "      '$RESULTS_DIR/geometric-$n-${BENCHMARK}-cluster' using ( \$14/\$16 ):xtic(1) t col lc rgbcolor \"#${blue_pallet[((COUNT++))]}\" lt 1 fs pattern 6, \\"  >> $FILE
    if [[ "$n" == "${thread_count[-1]}" ]]; then
        echo  "      ''               u (\$0-1):(\$14/\$16):(sprintf('%2.1f', \$14/\$16)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left font \",8\""  >> $FILE
    else
        echo  "      ''               u (\$0-1):(\$14/\$16):(sprintf('%2.1f', \$14/\$16)) notitle w labels offset first leftcolumn_offset_$n rotate by 90 left font \",8\", \\"  >> $FILE
    fi
done

echo >> $FILE

echo  "unset multiplot" >> $FILE


gnuplot -p $FILE