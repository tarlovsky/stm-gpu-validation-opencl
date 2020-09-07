set terminal wxt size 850,2800
unset bmargin
unset tmargin
unset rmargin
set bmargin 11

new = "-"
new1 = ".."
new2 = "_-_"
col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
xlabeloffsety=0.15
set grid ytics lc rgb "#606060"
set grid xtics lc rgb "#bbbbbb"
set multiplot layout 4,1 
set decimal locale "en_US.UTF-8"; show locale
set tics scale 0
set ytics nomirror font "Computer Modern, 22" 
set ytics 0.2 
set yrange [0:2.5]
set format x "%d"
set xtics nomirror rotate by 45 right font "Computer Modern, 18" 
set xtics offset 0, xlabeloffsety
set datafile separator whitespace
set border lc rgb "black"
set style data lines
set xlabel offset 0,-2 "Read-set size" font "Computer Modern, 21"
set arrow 1 from 0, 1 to 19, 1 front nohead lc rgb "#000000" lw 1
set arrow 2 from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb "#efefef"
set label 2"$L1: 128KB" at 5.9, 0.54 font "Computer Modern, 18"
set arrow 4 from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb "#bebebe"
set label 4"$L2: 1.024MB" at 8.9, 0.62 font "Computer Modern, 18"
set arrow 5 from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb "#afafaf"
set label 5"$L3: 8MB" at 11.9, 0.71 font "Computer Modern, 18"
set key left Left left Left reverse inside top font"Computer modern, 22"
set title "1 STM threads" offset 0, -1.15 font "Computer modern,23"
plot \
 '< join ../results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation ../results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-8-workers' u ($0):(($24/($18*1)) / ($8/($2*1))):( sprintf( '%.2fx',(($24/($18*1)) / ($8/($2*1))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "8 validator threads" lw 3 with linespoints,\
 '< join ../results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation ../results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-4-workers' u ($0):(($24/($18*1)) / ($8/($2*1))):( sprintf( '%.2fx',(($24/($18*1)) / ($8/($2*1))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "4 validator threads" lw 3 with linespoints,\
 '< join ../results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation ../results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-2-workers' u ($0):(($24/($18*1)) / ($8/($2*1))):( sprintf( '%.2fx',(($24/($18*1)) / ($8/($2*1))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "2 validator threads" dt new1 lw 3  with linespoints,\

unset key
set title "2 STM threads" offset 0, -1.15 font "Computer modern,23"
plot \
 '< join ../results-validation-array/TinySTM-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation ../results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation-8-workers' u ($0):(($24/($18*2)) / ($8/($2*2))):( sprintf( '%.2fx',(($24/($18*2)) / ($8/($2*2))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "8 validator threads" lw 3 with linespoints,\
 '< join ../results-validation-array/TinySTM-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation ../results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation-4-workers' u ($0):(($24/($18*2)) / ($8/($2*2))):( sprintf( '%.2fx',(($24/($18*2)) / ($8/($2*2))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "4 validator threads" lw 3 with linespoints,\
 '< join ../results-validation-array/TinySTM-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation ../results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation-2-workers' u ($0):(($24/($18*2)) / ($8/($2*2))):( sprintf( '%.2fx',(($24/($18*2)) / ($8/($2*2))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "2 validator threads" dt new1 lw 3  with linespoints,\

unset key
set title "4 STM threads" offset 0, -1.15 font "Computer modern,23"
plot \
 '< join ../results-validation-array/TinySTM-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation ../results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation-8-workers' u ($0):(($24/($18*4)) / ($8/($2*4))):( sprintf( '%.2fx',(($24/($18*4)) / ($8/($2*4))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "8 validator threads" lw 3 with linespoints,\
 '< join ../results-validation-array/TinySTM-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation ../results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation-4-workers' u ($0):(($24/($18*4)) / ($8/($2*4))):( sprintf( '%.2fx',(($24/($18*4)) / ($8/($2*4))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "4 validator threads" lw 3 with linespoints,\
 '< join ../results-validation-array/TinySTM-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation ../results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation-2-workers' u ($0):(($24/($18*4)) / ($8/($2*4))):( sprintf( '%.2fx',(($24/($18*4)) / ($8/($2*4))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "2 validator threads" dt new1 lw 3  with linespoints,\

unset key
set title "8 STM threads" offset 0, -1.15 font "Computer modern,23"
plot \
 '< join ../results-validation-array/TinySTM-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation ../results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation-8-workers' u ($0):(($24/($18*8)) / ($8/($2*8))):( sprintf( '%.2fx',(($24/($18*8)) / ($8/($2*8))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "8 validator threads" lw 3 with linespoints,\
 '< join ../results-validation-array/TinySTM-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation ../results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation-4-workers' u ($0):(($24/($18*8)) / ($8/($2*8))):( sprintf( '%.2fx',(($24/($18*8)) / ($8/($2*8))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "4 validator threads" lw 3 with linespoints,\
 '< join ../results-validation-array/TinySTM-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation ../results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation-2-workers' u ($0):(($24/($18*8)) / ($8/($2*8))):( sprintf( '%.2fx',(($24/($18*8)) / ($8/($2*8))) ) ):xtic(sprintf("%'d ",$1, ($1*8)/1000000)) t "2 validator threads" dt new1 lw 3  with linespoints,\


unset multiplot
