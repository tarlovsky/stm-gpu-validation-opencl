set terminal wxt size 1610,800
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 1,2 title "Transactional array walk application; multi-threaded validation; READS VALIDATED / VALIDATE CALL / THREAD / SECOND; Intel 6700k CPU 4cores-8threads vs TinySTM-WBETL untouched" font ",14"
set decimal locale "en_US.UTF-8"; show locale
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
set key left
set ylabel "READS VALIDATED / FUNCTION CALL / THREAD / SECOND"
set arrow from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb "#efefef"
set label "$L1: 128KB" at 5.9,0.000014 
set arrow from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb "#bebebe"
set label "$L2: 1.024MB" at 8.9,0.000014*1.5 
set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb "#afafaf"
set label "$L3: 8MB" at 11.9,0.000014*2.5 
set title "Only CPU, threaded validation, sequential walk" font ",12"
set yrange [1:10000000000]
set key bottom right inside
set title "RANDOM WALK" font ",14"
plot \
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-67-gpu-33' u ($0):((($14+$16)>0)?((($12/(ceil($14+$16)))/$2)/1):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "1 STM THREADS APU CO-OP       1-random-cpu-67-gpu-33" lw 2 lc rgb "#000000",\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-8-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/1):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "1 STM THREADS CPU -02 8 validation worker / STM thread" lc rgb "#1D4599",\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-4-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/1):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "1 STM THREADS CPU -02 4 validation worker / STM thread" dt new1 lc rgb "#1D4599",\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-2-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/1):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "1 STM THREADS CPU -02 2 validation worker / STM thread" dt new lc rgb "#1D4599",\
 'results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/1):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "1 STM THREADS CPU -02 1 validation worker / STM thread" lw 2 lc rgb "#1D4599",\
 'results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation-8-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/2):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "2 STM THREADS CPU -02 8 validation worker / STM thread" lc rgb "#11AD34",\
 'results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation-4-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/2):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "2 STM THREADS CPU -02 4 validation worker / STM thread" dt new1 lc rgb "#11AD34",\
 'results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation-2-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/2):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "2 STM THREADS CPU -02 2 validation worker / STM thread" dt new lc rgb "#11AD34",\
 'results-validation-array/TinySTM-wbetl/2/array-r99-w1-random-walk/2-random-cpu-validation' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/2):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "2 STM THREADS CPU -02 1 validation worker / STM thread" lw 2 lc rgb "#11AD34",\
 'results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation-8-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/4):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "4 STM THREADS CPU -02 8 validation worker / STM thread" lc rgb "#E69F17",\
 'results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation-4-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/4):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "4 STM THREADS CPU -02 4 validation worker / STM thread" dt new1 lc rgb "#E69F17",\
 'results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation-2-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/4):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "4 STM THREADS CPU -02 2 validation worker / STM thread" dt new lc rgb "#E69F17",\
 'results-validation-array/TinySTM-wbetl/4/array-r99-w1-random-walk/4-random-cpu-validation' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/4):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "4 STM THREADS CPU -02 1 validation worker / STM thread" lw 2 lc rgb "#E69F17",\
 'results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation-8-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/8):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "8 STM THREADS CPU -02 8 validation worker / STM thread" lc rgb "#E62B17",\
 'results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation-4-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/8):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "8 STM THREADS CPU -02 4 validation worker / STM thread" dt new1 lc rgb "#E62B17",\
 'results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation-2-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/8):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "8 STM THREADS CPU -02 2 validation worker / STM thread" dt new lc rgb "#E62B17",\
 'results-validation-array/TinySTM-wbetl/8/array-r99-w1-random-walk/8-random-cpu-validation' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/8):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "8 STM THREADS CPU -02 1 validation worker / STM thread" lw 2 lc rgb "#E62B17",\

set yrange [1:10000000000]
set title "SEQUENTIAL WALK" font ",14"
plot \
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation-8-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/1):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "1 STM THREADS CPU -02 8 validation worker / STM thread" lc rgb "#1D4599",\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation-4-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/1):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "1 STM THREADS CPU -02 4 validation worker / STM thread" dt new1 lc rgb "#1D4599",\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation-2-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/1):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "1 STM THREADS CPU -02 2 validation worker / STM thread" dt new lc rgb "#1D4599",\
 'results-validation-array/TinySTM-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/1):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "1 STM THREADS CPU -02 1 validation worker / STM thread" lw 2 lc rgb "#1D4599",\
 'results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-sequential-walk/2-sequential-cpu-validation-8-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/2):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "2 STM THREADS CPU -02 8 validation worker / STM thread" lc rgb "#11AD34",\
 'results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-sequential-walk/2-sequential-cpu-validation-4-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/2):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "2 STM THREADS CPU -02 4 validation worker / STM thread" dt new1 lc rgb "#11AD34",\
 'results-validation-array/TinySTM-threads-wbetl/2/array-r99-w1-sequential-walk/2-sequential-cpu-validation-2-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/2):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "2 STM THREADS CPU -02 2 validation worker / STM thread" dt new lc rgb "#11AD34",\
 'results-validation-array/TinySTM-wbetl/2/array-r99-w1-sequential-walk/2-sequential-cpu-validation' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/2):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "2 STM THREADS CPU -02 1 validation worker / STM thread" lw 2 lc rgb "#11AD34",\
 'results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-sequential-walk/4-sequential-cpu-validation-8-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/4):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "4 STM THREADS CPU -02 8 validation worker / STM thread" lc rgb "#E69F17",\
 'results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-sequential-walk/4-sequential-cpu-validation-4-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/4):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "4 STM THREADS CPU -02 4 validation worker / STM thread" dt new1 lc rgb "#E69F17",\
 'results-validation-array/TinySTM-threads-wbetl/4/array-r99-w1-sequential-walk/4-sequential-cpu-validation-2-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/4):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "4 STM THREADS CPU -02 2 validation worker / STM thread" dt new lc rgb "#E69F17",\
 'results-validation-array/TinySTM-wbetl/4/array-r99-w1-sequential-walk/4-sequential-cpu-validation' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/4):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "4 STM THREADS CPU -02 1 validation worker / STM thread" lw 2 lc rgb "#E69F17",\
 'results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-sequential-walk/8-sequential-cpu-validation-8-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/8):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "8 STM THREADS CPU -02 8 validation worker / STM thread" lc rgb "#E62B17",\
 'results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-sequential-walk/8-sequential-cpu-validation-4-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/8):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "8 STM THREADS CPU -02 4 validation worker / STM thread" dt new1 lc rgb "#E62B17",\
 'results-validation-array/TinySTM-threads-wbetl/8/array-r99-w1-sequential-walk/8-sequential-cpu-validation-2-workers' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/8):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "8 STM THREADS CPU -02 2 validation worker / STM thread" dt new lc rgb "#E62B17",\
 'results-validation-array/TinySTM-wbetl/8/array-r99-w1-sequential-walk/8-sequential-cpu-validation' u ($0):((($10+$12)>0)?((($8/(ceil($10+$12)))/$2)/8):(NaN)):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "8 STM THREADS CPU -02 1 validation worker / STM thread" lw 2 lc rgb "#E62B17",\


unset multiplot
