set terminal wxt size 1400,1100
set bmargin 11
set lmargin 8
set multiplot layout 2,2 title "Contention on READS VALIDATED/S, normalized to TinySTM-untouched-Intel; INTEL-COOP - CAS COMPETE FOR IGPU" font ",12"
col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
col_red="#b01313"
xlabeloffsety=0.15
set decimal locale "en_US.UTF-8"; show locale
set tics scale 0
set ytics nomirror font "Computer Modern, 21" 
set ytics (0,0.5,1.0,1.5,2.0,2.5) 
set ytics 0.2 
set arrow 1 from 0, 1 to 12, 1 front nohead lc rgb "#000000" lw 2
set grid ytics lc rgb "#606060"
set grid xtics lc rgb "#bbbbbb"
set yrange [0:2.5]
set format x "%d"
set xtics nomirror rotate by 45 right font "Computer Modern, 17" 
set xtics offset 0, xlabeloffsety
set datafile separator whitespace
set border lc rgb "black"
set style data lines
set xlabel offset 0,-2.1 "Read-set size" font "Computer Modern, 20"

new = "-"
new1 = ".."
new2 = "_-_"
unset key
set arrow 2 from 1.8, graph 0 to 1.8, graph 1 nohead lc rgb "#efefef"
set label 2"$L1: 128KB" at 1.9, 0.24 font "Computer Modern, 14"
set arrow 3 from 3.8, graph 0 to 3.8, graph 1 nohead lc rgb "#dadada"
set label 3 "$L3 GPU: 512KB" at 3.9, 0.44 font "Computer Modern, 14"
set arrow 4 from 4.8, graph 0 to 4.8, graph 1 nohead lc rgb "#bebebe"
set label 4"$L2: 1.024MB" at 4.9, 0.26 font "Computer Modern, 14"
set arrow 5 from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb "#afafaf"
set label 5"$L3: 8MB" at 7.9, 0.34 font "Computer Modern, 14"
set title "Only CPU, threaded validation, sequential walk" font "Computer Modern, 25"
set title "1 STM threads" offset 0, -1.15 font "Computer Modern,23"
plot \
 '< join ../results-cpu/TinySTM-wbetl/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random ../results-cpu/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/1/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/1-random' u ($0):(($28/($18*1)) / ($8/($2*1))):( sprintf( '%.2fx',(($28/($18*1)) / ($8/($2*1))) ) ):xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "No contention (disjoint arrays)" pt 2 lw 2 lc rgb "#94bdff" dt new with linespoints,\
 '< join ../results-cpu/TinySTM-wbetl/1/array-strongly-scaled-r99-w1-d0-random-walk/1-random ../results-cpu/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/1/array-strongly-scaled-shared-gpu-r99-w1-d0-random-walk/1-random' u ($0):(($28/($18*1)) / ($8/($2*1))):( sprintf( '%.2fx',(($28/($18*1)) / ($8/($2*1))) ) ):xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "Medium contention (conjoint array)" pt 2 lw 2 lc rgb "#94bdff" with linespoints,\

set title "2 STM threads" offset 0, -1.15 font "Computer Modern,23"
plot \
 '< join ../results-cpu/TinySTM-wbetl/2/array-strongly-scaled-r99-w1-d1-random-walk/2-random ../results-cpu/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/2/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/2-random' u ($0):(($28/($18*2)) / ($8/($2*2))):( sprintf( '%.2fx',(($28/($18*2)) / ($8/($2*2))) ) ):xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "No contention (disjoint arrays)" pt 2 lw 2 lc rgb "#94bdff" dt new with linespoints,\
 '< join ../results-cpu/TinySTM-wbetl/2/array-strongly-scaled-r99-w1-d0-random-walk/2-random ../results-cpu/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/2/array-strongly-scaled-shared-gpu-r99-w1-d0-random-walk/2-random' u ($0):(($28/($18*2)) / ($8/($2*2))):( sprintf( '%.2fx',(($28/($18*2)) / ($8/($2*2))) ) ):xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "Medium contention (conjoint array)" pt 2 lw 2 lc rgb "#94bdff" with linespoints,\

set title "4 STM threads" offset 0, -1.15 font "Computer Modern,23"
plot \
 '< join ../results-cpu/TinySTM-wbetl/4/array-strongly-scaled-r99-w1-d1-random-walk/4-random ../results-cpu/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/4/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/4-random' u ($0):(($28/($18*4)) / ($8/($2*4))):( sprintf( '%.2fx',(($28/($18*4)) / ($8/($2*4))) ) ):xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "No contention (disjoint arrays)" pt 2 lw 2 lc rgb "#94bdff" dt new with linespoints,\
 '< join ../results-cpu/TinySTM-wbetl/4/array-strongly-scaled-r99-w1-d0-random-walk/4-random ../results-cpu/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/4/array-strongly-scaled-shared-gpu-r99-w1-d0-random-walk/4-random' u ($0):(($28/($18*4)) / ($8/($2*4))):( sprintf( '%.2fx',(($28/($18*4)) / ($8/($2*4))) ) ):xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "Medium contention (conjoint array)" pt 2 lw 2 lc rgb "#94bdff" with linespoints,\

set key left Left left Left reverse inside top font"Computer modern, 18"
set title "8 STM threads" offset 0, -1.15 font "Computer Modern,23"
plot \
 '< join ../results-cpu/TinySTM-wbetl/8/array-strongly-scaled-r99-w1-d1-random-walk/8-random ../results-cpu/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/8/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/8-random' u ($0):(($28/($18*8)) / ($8/($2*8))):( sprintf( '%.2fx',(($28/($18*8)) / ($8/($2*8))) ) ):xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "No contention (disjoint arrays)" pt 2 lw 2 lc rgb "#94bdff" dt new with linespoints,\
 '< join ../results-cpu/TinySTM-wbetl/8/array-strongly-scaled-r99-w1-d0-random-walk/8-random ../results-cpu/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/8/array-strongly-scaled-shared-gpu-r99-w1-d0-random-walk/8-random' u ($0):(($28/($18*8)) / ($8/($2*8))):( sprintf( '%.2fx',(($28/($18*8)) / ($8/($2*8))) ) ):xtic(sprintf("%'d",$1, ($1*8)/1000000)) t "Medium contention (conjoint array)" pt 2 lw 2 lc rgb "#94bdff" with linespoints,\


unset multiplot
