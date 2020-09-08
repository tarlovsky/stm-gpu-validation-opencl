set terminal wxt size 1937,750
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 1,2 title "Validating array traversal (random element access), single-threaded, 4c-8th Intel 6700k CPU, Intel HD530 iGPU, AMD Vega 11 iGPU (TinySTM-WBETL default config). READS VALIDATED / TIME SPENT IN VALIDATION" font ",14"
set decimal locale "en_US.UTF-8"; show locale
set datafile missing '0'
set tics scale 0
set grid ytics lc rgb "#606060"
set grid xtics lc rgb "#bbbbbb"
set format x "%d"
set xtics out nomirror rotate by 35 right font "Computer Modern, 17.5" 
set datafile separator whitespace
set border lc rgb "black"
set style data lines

new = "-"
new1 = ".."
new2 = "_-_"
col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
set key top right font "Computer Modern,16.5"
set xlabel "RSET SIZE" offset 0, -2 font "Computer Modern, 16"
set arrow from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb "#efefef"
set label "$L1: 128KB" at 5.9, 50000000 font "Computer Modern, 15"
set arrow from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb "#dadada"
set label "\L3 GPU: 512KB" at 7.9, 50000000*2.5 font "Computer Modern, 15"
set arrow from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb "#bebebe"
set label "$L2: 1.024MB" at 8.9, 50000000*1.5 font "Computer Modern, 15"
set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb "#afafaf"
set label "$L3: 8MB" at 11.9, 50000000*2.5 font "Computer Modern, 15"
set title "Only CPU, threaded validation, random walk" font ",12"
set style data linespoints
set ylabel "Time (s)" font "Computer Modern, 13"
set logscale y
set ytics auto font "Computer Modern, 18"
set title "GPU C11 ATOMICS MEMORY ORDER COMPARISON INTEL ONLY " font ",12"
plot \
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 2:xtic(sprintf("%'d ",$1, ((($1*8))/1000000))) t "48WKGPS-128WI/WKGP SEQ-CST Persistent Kernel polling" lw 2 lc rgb col_48 pt 1,\
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 3:xtic(sprintf("%'d ",$1, ((($1*8))/1000000))) t "48WKGPS-128WI/WKGP REL-ACQ Persistent Kernel polling" dt new lc rgb col_48 pt 1,\
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 4:xtic(sprintf("%'d ",$1, ((($1*8))/1000000))) t "48WKGPS-128WI/WKGP RELAXED Persistent Kernel polling" dt new1 lc rgb col_48 pt 1,\
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 2:xtic(sprintf("%'d ",$1, ((($1*8))/1000000))) t "24WKGPS-224WI/WKGP SEQ-CST Persistent Kernel polling" lw 2 lc rgb col_24 pt 1,\
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 3:xtic(sprintf("%'d ",$1, ((($1*8))/1000000))) t "24WKGPS-224WI/WKGP REL-ACQ Persistent Kernel polling" dt new lc rgb col_24 pt 1,\
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 4:xtic(sprintf("%'d ",$1, ((($1*8))/1000000))) t "24WKGPS-224WI/WKGP RELAXED Persistent Kernel polling" dt new1 lc rgb col_24 pt 1

set ylabel offset -2,0 "Reads validated / s" font "Computer Modern, 14"
set style data linespoints
unset logscale y
set yrange [0:1600000000]
set ytics 100000000
set title "Reads validated/s - Best single-threaded alrogithms" font ",17"
plot \
 '../results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u ($0):($8/$2):xtic(sprintf("%'d ",$1, ((($1*8))/1000000))) t "TinySTM-untouched" lc rgb col_gold lw 2,\
 '../results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-strided-k-4/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:($1/$2):xtic(sprintf("%'d ",$1, ((($1*8))/1000000))) t "Intel cooperative, blocks of 5736*4, strided, sync WI on block" dt new lw 2 pt 4 lc rgb "#7dafff",\
 '../results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-amd-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:($1/$2):xtic(sprintf("%'d ",$1, ((($1*8))/1000000))) t "AMD cooperative, blocks of 11264*1, coalesced, sync WI on block" dt new lw 2 pt 4 lc rgb "#b01313",\
 '../results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-4-workers' u ($0):($8/$2):3:xtic(sprintf("%'d ",$1, ((($1*8))/1000000))) t "4 CPU validator threads" dt new1 lc rgb "black" lw 2,\

unset multiplot
