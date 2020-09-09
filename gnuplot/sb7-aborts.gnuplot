set terminal wxt size 1400,1100
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
set datafile separator whitespace
set border lc rgb "black"
set style data lines
set xlabel offset 0,-0.3 "threads" font "Computer Modern, 20"

new = "-"
new1 = ".."
new2 = "_-_"
unset key
set ylabel offset -1, 0 "TX / SECOND / THREAD" font "Computer Modern, 16"
set title "sb7-r-t-f" offset 0, -1.15 font "Computer Modern,23"
plot\

set title "sb7-rw-t-f" offset 0, -1.15 font "Computer Modern,23"
plot\

set title "sb7-w-t-f" offset 0, -1.15 font "Computer Modern,23"
plot\

set title "sb7-r-t-t" offset 0, -1.15 font "Computer Modern,23"
plot\

set title "sb7-rw-t-t" offset 0, -1.15 font "Computer Modern,23"
plot\

set title "sb7-w-t-t" offset 0, -1.15 font "Computer Modern,23"
plot\


unset multiplot
