set terminal wxt size 1600,550
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 1,3 title "array DISJOINT sets, 100 rounds, Round-Robin neighbour write / per round: TRANSACTIONS/s " font ",24"
col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
col_red="#b01313"
set decimal locale "en_US.UTF-8"; show locale
set tics scale 0
set ytics
set grid ytics lc rgb "#606060"
set grid xtics lc rgb "#bbbbbb"
set ytics nomirror font "Computer Modern, 17" 
set yrange [0:2.5]
set format x "%d"
set xtics nomirror rotate by 45 right font "Computer Modern, 13" 
set datafile separator whitespace
set border lc rgb "black"
set style data lines
set xlabel offset 0,-0.25 "Read-set size" font "Computer Modern, 17"

new = "-"
new1 = ".."
new2 = "_-_"
set key font ",9"
set key inside top right
set ylabel ""
set arrow 1 from 0, 1 to 12, 1 front nohead lc rgb "#000000" lw 1
unset key
set arrow from 1.8, graph 0 to 1.8, graph 1 nohead lc rgb "#efefef"
set label "$L1: 128KB" at 1.9, 0.55 
set arrow 2 from 3.8, graph 0 to 3.8, graph 1 nohead lc rgb "#dadada"
set label 2 "$L3 GPU: 512KB" at 3.9, 0.69 
set arrow from 4.8, graph 0 to 4.8, graph 1 nohead lc rgb "#bebebe"
set label "$L2: 1.024MB" at 4.9, 0.60 
set arrow from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb "#afafaf"
set label "$L3: 8MB" at 7.9, 0.69 
set title "Only CPU, threaded validation, sequential walk" font ",12"
set title "2 STM threads" offset 0, -1.15 font "Computer Modern,23"
plot \
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/2-random results-validation-array/TinySTM-wbetl-lsa/2/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/2-random' u ($0):(($20/($32*2)) / ($4/($16*2))):( sprintf( '%.2fx',(($20/($32*2)) / ($4/($16*2))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "TinySTM-wbetl-lsa" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/2-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/2/array-strongly-scaled-all-large-tx-shared-gpu-r99-w1-d1-RR-kick-random-walk/2-random' u ($0):(($24/($46*2)) / ($4/($16*2))):( sprintf( '%.2fx',(($24/($46*2)) / ($4/($16*2))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "Intel cooperative" pt 2 lw 2 lc rgb "#b5d2ff" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/2-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa/2/array-strongly-scaled-all-large-tx-shared-gpu-r99-w1-d1-RR-kick-random-walk/2-random' u ($0):(($24/($46*2)) / ($4/($16*2))):( sprintf( '%.2fx',(($24/($46*2)) / ($4/($16*2))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "Intel cooperative - LSA" pt 2 lw 2 lc rgb "#b5d2ff" dt new with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/2-random ' u ($0):(($24/($46*2)) / ($4/($16*2))):( sprintf( '%.2fx',(($24/($46*2)) / ($4/($16*2))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "AMD cooperative" pt 2 lw 2 lc rgb col_red with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/2-random results-validation-array/TinySTM-threads-wbetl/2/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/2-random-4-workers' u ($0):(($20/($32*2)) / ($4/($16*2))):( sprintf( '%.2fx',(($20/($32*2)) / ($4/($16*2))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "TinySTM-wbetl 4 validators" pt 1 lw 2 lc rgb "#696969" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/2-random results-validation-array/TinySTM-threads-wbetl-lsa/2/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/2-random-4-workers' u ($0):(($20/($32*2)) / ($4/($16*2))):( sprintf( '%.2fx',(($20/($32*2)) / ($4/($16*2))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "TinySTM-wbetl 4  validators - LSA" pt 1 lw 2 lc rgb "#696969" dt new1 with linespoints,\

set title "4 STM threads" offset 0, -1.15 font "Computer Modern,23"
plot \
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/4-random results-validation-array/TinySTM-wbetl-lsa/4/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/4-random' u ($0):(($20/($32*4)) / ($4/($16*4))):( sprintf( '%.2fx',(($20/($32*4)) / ($4/($16*4))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "TinySTM-wbetl-lsa" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/4-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/4/array-strongly-scaled-all-large-tx-shared-gpu-r99-w1-d1-RR-kick-random-walk/4-random' u ($0):(($24/($46*4)) / ($4/($16*4))):( sprintf( '%.2fx',(($24/($46*4)) / ($4/($16*4))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "Intel cooperative" pt 2 lw 2 lc rgb "#b5d2ff" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/4-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa/4/array-strongly-scaled-all-large-tx-shared-gpu-r99-w1-d1-RR-kick-random-walk/4-random' u ($0):(($24/($46*4)) / ($4/($16*4))):( sprintf( '%.2fx',(($24/($46*4)) / ($4/($16*4))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "Intel cooperative - LSA" pt 2 lw 2 lc rgb "#b5d2ff" dt new with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/4-random ' u ($0):(($24/($46*4)) / ($4/($16*4))):( sprintf( '%.2fx',(($24/($46*4)) / ($4/($16*4))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "AMD cooperative" pt 2 lw 2 lc rgb col_red with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/4-random results-validation-array/TinySTM-threads-wbetl/4/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/4-random-4-workers' u ($0):(($20/($32*4)) / ($4/($16*4))):( sprintf( '%.2fx',(($20/($32*4)) / ($4/($16*4))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "TinySTM-wbetl 4 validators" pt 1 lw 2 lc rgb "#696969" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/4-random results-validation-array/TinySTM-threads-wbetl-lsa/4/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/4-random-4-workers' u ($0):(($20/($32*4)) / ($4/($16*4))):( sprintf( '%.2fx',(($20/($32*4)) / ($4/($16*4))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "TinySTM-wbetl 4  validators - LSA" pt 1 lw 2 lc rgb "#696969" dt new1 with linespoints,\

set title "8 STM threads" offset 0, -1.15 font "Computer Modern,23"
set key right right right right inside top font "Computer modern, 15"
plot \
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/8-random results-validation-array/TinySTM-wbetl-lsa/8/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/8-random' u ($0):(($20/($32*8)) / ($4/($16*8))):( sprintf( '%.2fx',(($20/($32*8)) / ($4/($16*8))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "TinySTM-wbetl-lsa" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/8-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/8/array-strongly-scaled-all-large-tx-shared-gpu-r99-w1-d1-RR-kick-random-walk/8-random' u ($0):(($24/($46*8)) / ($4/($16*8))):( sprintf( '%.2fx',(($24/($46*8)) / ($4/($16*8))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "Intel cooperative" pt 2 lw 2 lc rgb "#b5d2ff" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/8-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa/8/array-strongly-scaled-all-large-tx-shared-gpu-r99-w1-d1-RR-kick-random-walk/8-random' u ($0):(($24/($46*8)) / ($4/($16*8))):( sprintf( '%.2fx',(($24/($46*8)) / ($4/($16*8))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "Intel cooperative - LSA" pt 2 lw 2 lc rgb "#b5d2ff" dt new with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/8-random ' u ($0):(($24/($46*8)) / ($4/($16*8))):( sprintf( '%.2fx',(($24/($46*8)) / ($4/($16*8))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "AMD cooperative" pt 2 lw 2 lc rgb col_red with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/8-random results-validation-array/TinySTM-threads-wbetl/8/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/8-random-4-workers' u ($0):(($20/($32*8)) / ($4/($16*8))):( sprintf( '%.2fx',(($20/($32*8)) / ($4/($16*8))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "TinySTM-wbetl 4 validators" pt 1 lw 2 lc rgb "#696969" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/8-random results-validation-array/TinySTM-threads-wbetl-lsa/8/array-strongly-scaled-all-large-tx-r99-w1-d1-RR-kick-random-walk/8-random-4-workers' u ($0):(($20/($32*8)) / ($4/($16*8))):( sprintf( '%.2fx',(($20/($32*8)) / ($4/($16*8))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "TinySTM-wbetl 4  validators - LSA" pt 1 lw 2 lc rgb "#696969" dt new1 with linespoints,\


unset multiplot
