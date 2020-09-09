set terminal wxt size 1400,1100
set bmargin 11
set lmargin 8
set multiplot layout 2,3 title "TX/S normalized to TinySTM-untouched-Intel" font "Computer Modern,20"
col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
col_red="#b01313"
xlabeloffsety=0.15
set decimal locale "en_US.UTF-8"; show locale
set tics scale 0
set ytics nomirror font "Computer Modern, 21" 
set ytics (0,0.5,1.0,1.5,2.0,2.5) 
set ytics 0.1
set grid ytics lc rgb "#606060"
set grid xtics lc rgb "#bbbbbb"
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
plot\
'../tmp/gnuplot-sb7-r-t-f-txps' u 2:xtic(1) 
'../tmp/gnuplot-sb7-r-t-f-txps' u 3:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-amd-wbetl" lw 2 lc rgb col_red with linespoints with linespoints
'../tmp/gnuplot-sb7-r-t-f-txps' u 4:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl" lw 2 lc rgb "#b5d2ff" with linespoints
'../tmp/gnuplot-sb7-r-t-f-txps' u 5:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa" lw 2 lc rgb "#b5d2ff" dt new with linespoints

plot\
'../tmp/gnuplot-sb7-rw-t-f-txps' u 2:xtic(1) 
'../tmp/gnuplot-sb7-rw-t-f-txps' u 3:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-amd-wbetl" lw 2 lc rgb col_red with linespoints with linespoints
'../tmp/gnuplot-sb7-rw-t-f-txps' u 4:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl" lw 2 lc rgb "#b5d2ff" with linespoints
'../tmp/gnuplot-sb7-rw-t-f-txps' u 5:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa" lw 2 lc rgb "#b5d2ff" dt new with linespoints

plot\
'../tmp/gnuplot-sb7-w-t-f-txps' u 2:xtic(1) 
'../tmp/gnuplot-sb7-w-t-f-txps' u 3:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-amd-wbetl" lw 2 lc rgb col_red with linespoints with linespoints
'../tmp/gnuplot-sb7-w-t-f-txps' u 4:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl" lw 2 lc rgb "#b5d2ff" with linespoints
'../tmp/gnuplot-sb7-w-t-f-txps' u 5:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa" lw 2 lc rgb "#b5d2ff" dt new with linespoints

plot\
'../tmp/gnuplot-sb7-r-t-t-txps' u 2:xtic(1) 
'../tmp/gnuplot-sb7-r-t-t-txps' u 3:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-amd-wbetl" lw 2 lc rgb col_red with linespoints with linespoints
'../tmp/gnuplot-sb7-r-t-t-txps' u 4:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl" lw 2 lc rgb "#b5d2ff" with linespoints
'../tmp/gnuplot-sb7-r-t-t-txps' u 5:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa" lw 2 lc rgb "#b5d2ff" dt new with linespoints

plot\
'../tmp/gnuplot-sb7-rw-t-t-txps' u 2:xtic(1) 
'../tmp/gnuplot-sb7-rw-t-t-txps' u 3:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-amd-wbetl" lw 2 lc rgb col_red with linespoints with linespoints
'../tmp/gnuplot-sb7-rw-t-t-txps' u 4:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl" lw 2 lc rgb "#b5d2ff" with linespoints
'../tmp/gnuplot-sb7-rw-t-t-txps' u 5:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa" lw 2 lc rgb "#b5d2ff" dt new with linespoints

plot\
'../tmp/gnuplot-sb7-w-t-t-txps' u 2:xtic(1) 
'../tmp/gnuplot-sb7-w-t-t-txps' u 3:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-amd-wbetl" lw 2 lc rgb col_red with linespoints with linespoints
'../tmp/gnuplot-sb7-w-t-t-txps' u 4:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl" lw 2 lc rgb "#b5d2ff" with linespoints
'../tmp/gnuplot-sb7-w-t-t-txps' u 5:xtic(1) t "TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa" lw 2 lc rgb "#b5d2ff" dt new with linespoints


unset multiplot
