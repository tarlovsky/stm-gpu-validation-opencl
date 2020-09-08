set terminal wxt size 1440,1180
set bmargin at screen 0.250
unset tmargin
unset rmargin
set lmargin at screen 0.135
set multiplot layout 1,1
set datafile missing '0'
set decimal locale "en_US.UTF-8"; show locale
set tics scale 0
set ytics
set grid ytics lc rgb "#606060"
set grid xtics lc rgb "#bbbbbb"
set format x "%d"
set xtics nomirror rotate by 45 right font "Computer Modern, 24" 
set ytics nomirror font "Computer Modern, 25" 
set datafile separator whitespace
set border lc rgb "black"
set style data linespoints

new = "-"
new1 = ".."
new2 = "_-_"
col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
set key left Left left Left reverse inside top font"Computer modern, 22"
set ylabel offset -10,0 "Reads validated/s" font "Computer Modern, 25"
set xlabel offset 2,-6 "Read-set size" font "Computer Modern, 26"
set arrow from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb "#efefef"
set label "$L1: 128KB" at 5.9, 1.4*10000000 font "Computer Modern, 17"
set arrow from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb "#dadada"
set label "\L3 GPU: 512KB" at 7.9, 1.4*25000000 font "Computer Modern, 17"
set arrow from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb "#bebebe"
set label "$L2: 1.024MB" at 8.9, 1.4*12000000 font "Computer Modern, 17"
set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb "#afafaf"
set label "$L3: 8MB" at 11.9, 1.4*25000000 font "Computer Modern, 17"
set title "Only CPU, threaded validation, sequential walk" font ",12"
set yrange [10000000:190000000000000]
set title "Persistent kernel deconstruction of work done by each work-item - Intel HD530" font "Computer Modern, 22"
plot \
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u ($1/$7):xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "Validation API call - STM thread preparing metadata; ignore GPU" lw 3 ps 2 dt new lc rgb "black" pt 4,\
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u ($1/$6):xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "Work-items polling, WKGPs signal COMPLETE (REMOVE: GPU17-30)" lw 3 ps 2 dt new lc rgb "black" pt 8,\
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u ($1/$5):xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "Calculate for loop start-end (GPU17), check index out of bounds (GPU18)" lw 3 ps 2 dt new lc rgb col_24 pt 8,\
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u ($1/$4):xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "Load read-entry (add GPU19)" lw 3 ps 2 lc rgb col_24 pt 1,\
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u ($1/$3):xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "Load lock (add GPU20)" lw 3 ps 2 dt new1 lc rgb col_24 pt 1,\
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL' u ($1/$2):xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "Add branching logic, full GPU execution" lw 3 ps 2 dt new lc rgb col_24 pt 1,\
 '../results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation'      u 0:($8/$2):3:xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "TinySTM-untouched" lw 3 ps 2 lc rgb col_gold pt 1,\

unset multiplot
