set terminal wxt size 1400,1100
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 2,2 title "Random array walk: READS VALIDATED PER SECOND (THROUGHPUT) - using CPU thread pool to validate (higher is better)" font ",14"
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
set key font ",8"
set key inside bottom right
set ylabel "READS VALIDATED / SECOND"
set arrow from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb "#efefef"
set label "$L1: 128KB" at 5.9,0.00014 
set arrow from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb "#bebebe"
set label "$L2: 1.024MB" at 8.9,0.00014*1.5 
set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb "#afafaf"
set label "$L3: 8MB" at 11.9,0.00014*2.5 
set title "Only CPU, threaded validation, sequential walk" font ",12"
set yrange [10000:10000000000]
set title "1 STM threads" font ",12"
plot \
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-8-workers' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/1) /  ($2/1) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 8 validation worker / STM thread" lc rgb "#000000",\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-4-workers' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/1) /  ($2/1) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 4 validation worker / STM thread" dt new1 lc rgb "#000000",\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-2-workers' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/1) /  ($2/1) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 2 validation worker / STM thread" dt new lc rgb "#000000",\
 'results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/1) /  ($2/1) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 1 validation worker / STM thread" lw 2 lc rgb "#8f8d08",\

set title "2 STM threads" font ",12"
plot \
 'results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation-8-workers' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/2) /  ($2/2) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 8 validation worker / STM thread" lc rgb "#696969",\
 'results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation-4-workers' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/2) /  ($2/2) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 4 validation worker / STM thread" dt new1 lc rgb "#696969",\
 'results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation-2-workers' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/2) /  ($2/2) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 2 validation worker / STM thread" dt new lc rgb "#696969",\
 'results-validation-array/TinySTM-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/2) /  ($2/2) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 1 validation worker / STM thread" lw 2 lc rgb "#a77f0e",\

set title "4 STM threads" font ",12"
plot \
 'results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation-8-workers' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/4) /  ($2/4) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 8 validation worker / STM thread" lc rgb "#808080",\
 'results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation-4-workers' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/4) /  ($2/4) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 4 validation worker / STM thread" dt new1 lc rgb "#808080",\
 'results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation-2-workers' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/4) /  ($2/4) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 2 validation worker / STM thread" dt new lc rgb "#808080",\
 'results-validation-array/TinySTM-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/4) /  ($2/4) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 1 validation worker / STM thread" lw 2 lc rgb "#916a09",\

set title "8 STM threads" font ",12"
plot \
 'results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation-8-workers' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/8) /  ($2/8) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 8 validation worker / STM thread" lc rgb "#A9A9A9",\
 'results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation-4-workers' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/8) /  ($2/8) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 4 validation worker / STM thread" dt new1 lc rgb "#A9A9A9",\
 'results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation-2-workers' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/8) /  ($2/8) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 2 validation worker / STM thread" dt new lc rgb "#A9A9A9",\
 'results-validation-array/TinySTM-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation' u ($0):((($10+$12)>0)?( (($8/(ceil($10+$12)))/8) /  ($2/8) ):(NaN)):xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU -02 1 validation worker / STM thread" lw 2 lc rgb "#914a09",\


unset multiplot
