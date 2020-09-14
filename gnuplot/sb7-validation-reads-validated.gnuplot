set terminal wxt noenhanced size 1400,1100
set bmargin 8
set lmargin -2
set multiplot layout 2,3 title "Reads validated/s normalized to TinySTM-untouched-Intel" font "Computer Modern,20"
col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
col_red="#b01313"
xlabeloffsety=0.15
set decimal locale "en_US.UTF-8"; show locale
set tics scale 0
set ytics nomirror font "Computer Modern, 21" 
set grid ytics lc rgb "#606060"
set grid xtics lc rgb "#bbbbbb"
set logscale y
set format x "%d"
set xtics font "Computer Modern, 19" 
set xtics offset 0, xlabeloffsety
set xtics offset 0, xlabeloffsety
set datafile separator whitespace
set border lc rgb "black"
set style data lines
set xlabel offset 0,-0.3 "threads" font "Computer Modern, 20"

new = "-"
new1 = ".."
new2 = "_-_"
unset key
set title "sb7_20-r-t-f" offset 0, -1.15 font "Computer Modern,23"
plot\
'../tmp/gnuplot-sb7_20-r-t-f-rval' u 2:xtic(1) t "TinySTM-wbetl" lw 3 lc rgb col_gold with linespoints, \
'../tmp/gnuplot-sb7_20-r-t-f-rval' u 3:xtic(1) t "AMD cooperative" lw 3 lc rgb col_red with linespoints, \
'../tmp/gnuplot-sb7_20-r-t-f-rval' u 4:xtic(1) t "Intel cooperative" lw 3 lc rgb "#1f84ff" with linespoints, \
'../tmp/gnuplot-sb7_20-r-t-f-rval' u 5:xtic(1) t "Intel coop LSA" lw 3 dt new lc rgb "#1f84ff" with linespoints, \

set title "sb7_20-rw-t-f" offset 0, -1.15 font "Computer Modern,23"
plot\
'../tmp/gnuplot-sb7_20-rw-t-f-rval' u 2:xtic(1) t "TinySTM-wbetl" lw 3 lc rgb col_gold with linespoints, \
'../tmp/gnuplot-sb7_20-rw-t-f-rval' u 3:xtic(1) t "AMD cooperative" lw 3 lc rgb col_red with linespoints, \
'../tmp/gnuplot-sb7_20-rw-t-f-rval' u 4:xtic(1) t "Intel cooperative" lw 3 lc rgb "#1f84ff" with linespoints, \
'../tmp/gnuplot-sb7_20-rw-t-f-rval' u 5:xtic(1) t "Intel coop LSA" lw 3 dt new lc rgb "#1f84ff" with linespoints, \

set title "sb7_20-w-t-f" offset 0, -1.15 font "Computer Modern,23"
plot\
'../tmp/gnuplot-sb7_20-w-t-f-rval' u 2:xtic(1) t "TinySTM-wbetl" lw 3 lc rgb col_gold with linespoints, \
'../tmp/gnuplot-sb7_20-w-t-f-rval' u 3:xtic(1) t "AMD cooperative" lw 3 lc rgb col_red with linespoints, \
'../tmp/gnuplot-sb7_20-w-t-f-rval' u 4:xtic(1) t "Intel cooperative" lw 3 lc rgb "#1f84ff" with linespoints, \
'../tmp/gnuplot-sb7_20-w-t-f-rval' u 5:xtic(1) t "Intel coop LSA" lw 3 dt new lc rgb "#1f84ff" with linespoints, \

set title "sb7_20-r-t-t" offset 0, -1.15 font "Computer Modern,23"
plot\
'../tmp/gnuplot-sb7_20-r-t-t-rval' u 2:xtic(1) t "TinySTM-wbetl" lw 3 lc rgb col_gold with linespoints, \
'../tmp/gnuplot-sb7_20-r-t-t-rval' u 3:xtic(1) t "AMD cooperative" lw 3 lc rgb col_red with linespoints, \
'../tmp/gnuplot-sb7_20-r-t-t-rval' u 4:xtic(1) t "Intel cooperative" lw 3 lc rgb "#1f84ff" with linespoints, \
'../tmp/gnuplot-sb7_20-r-t-t-rval' u 5:xtic(1) t "Intel coop LSA" lw 3 dt new lc rgb "#1f84ff" with linespoints, \

set title "sb7_20-rw-t-t" offset 0, -1.15 font "Computer Modern,23"
plot\
'../tmp/gnuplot-sb7_20-rw-t-t-rval' u 2:xtic(1) t "TinySTM-wbetl" lw 3 lc rgb col_gold with linespoints, \
'../tmp/gnuplot-sb7_20-rw-t-t-rval' u 3:xtic(1) t "AMD cooperative" lw 3 lc rgb col_red with linespoints, \
'../tmp/gnuplot-sb7_20-rw-t-t-rval' u 4:xtic(1) t "Intel cooperative" lw 3 lc rgb "#1f84ff" with linespoints, \
'../tmp/gnuplot-sb7_20-rw-t-t-rval' u 5:xtic(1) t "Intel coop LSA" lw 3 dt new lc rgb "#1f84ff" with linespoints, \

set key left right left Left reverse inside top font"Computer modern, 18"
set title "sb7_20-w-t-t" offset 0, -1.15 font "Computer Modern,23"
plot\
'../tmp/gnuplot-sb7_20-w-t-t-rval' u 2:xtic(1) t "TinySTM-wbetl" lw 3 lc rgb col_gold with linespoints, \
'../tmp/gnuplot-sb7_20-w-t-t-rval' u 3:xtic(1) t "AMD cooperative" lw 3 lc rgb col_red with linespoints, \
'../tmp/gnuplot-sb7_20-w-t-t-rval' u 4:xtic(1) t "Intel cooperative" lw 3 lc rgb "#1f84ff" with linespoints, \
'../tmp/gnuplot-sb7_20-w-t-t-rval' u 5:xtic(1) t "Intel coop LSA" lw 3 dt new lc rgb "#1f84ff" with linespoints, \


unset multiplot
