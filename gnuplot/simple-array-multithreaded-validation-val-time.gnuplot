set terminal wxt size 1440,1200
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 2,2 title "Validating random array traversal multi-threaded validation, Intel 6700k CPU 4cores-8threads (TinySTM-WBETL)" font ",14"
set datafile missing "0"
set tics scale 0
set ytics
set grid ytics lc rgb "#606060"
set logscale y
set format x "%d"
set xtics nomirror rotate by 45 right font "Verdana,10" 
set datafile separator whitespace
set border lc rgb "black"
set style data lines

new = "-"
new1 = ".."
new2 = "_-_"
col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
set key font ",9"
set key left
set yrange [0.00001:10]
set ylabel "Time (s)"
set arrow from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb "#efefef"
set label "$L1: 128KB" at 8.9,0.000014 
set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb "#bebebe"
set label "$L2: 1.024MB" at 11.9,0.000014*1.5 
set arrow from 14.8, graph 0 to 14.8, graph 1 nohead lc rgb "#afafaf"
set label "$L3: 8MB" at 14.9,0.000014*2.5 
set title "Only CPU, threaded validation, sequential walk" font ",12"

set title "1 validation worker threads/STM thread" font ",14"
plot \
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-8-workers' u ($0):($2/1):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 8 validation worker / STM thread" lc rgb "black",\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-4-workers' u ($0):($2/1):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 4 validation worker / STM thread" dt new1 lc rgb "black" ,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-2-workers' u ($0):($2/1):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 2 validation worker / STM thread" dt new lc rgb "black" ,\
 'results-validation-array/TinySTM-wbetl/1a/array-r99-w1-random-walk/1a-random-cpu-validation' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 1 validation worker / STM thread" lw 2 lc rgb col_gold ,\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-73-gpu-27' u ($0):($2/1):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "GLOBAL MINUMUM 1-random-cpu-73-gpu-27" dt new lc rgb "#b01313",\


set title "2 validation worker threads/STM thread" font ",14"
plot \
 'results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation-8-workers' u ($0):($2/2):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 8 validation worker / STM thread" lc rgb "black",\
 'results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation-4-workers' u ($0):($2/2):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 4 validation worker / STM thread" dt new1 lc rgb "black" ,\
 'results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation-2-workers' u ($0):($2/2):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 2 validation worker / STM thread" dt new lc rgb "black" ,\
 'results-validation-array/TinySTM-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation' u ($0):($2/2):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 1 validation worker / STM thread" lw 2 lc rgb col_gold ,\


set title "4 validation worker threads/STM thread" font ",14"
plot \
 'results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation-8-workers' u ($0):($2/4):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 8 validation worker / STM thread" lc rgb "black",\
 'results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation-4-workers' u ($0):($2/4):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 4 validation worker / STM thread" dt new1 lc rgb "black" ,\
 'results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation-2-workers' u ($0):($2/4):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 2 validation worker / STM thread" dt new lc rgb "black" ,\
 'results-validation-array/TinySTM-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation' u ($0):($2/4):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 1 validation worker / STM thread" lw 2 lc rgb col_gold ,\


set title "8 validation worker threads/STM thread" font ",14"
plot \
 'results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation-8-workers' u ($0):($2/8):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 8 validation worker / STM thread" lc rgb "black",\
 'results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation-4-workers' u ($0):($2/8):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 4 validation worker / STM thread" dt new1 lc rgb "black" ,\
 'results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation-2-workers' u ($0):($2/8):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 2 validation worker / STM thread" dt new lc rgb "black" ,\
 'results-validation-array/TinySTM-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation' u ($0):($2/8):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 1 validation worker / STM thread" lw 2 lc rgb col_gold ,\

unset multiplot
