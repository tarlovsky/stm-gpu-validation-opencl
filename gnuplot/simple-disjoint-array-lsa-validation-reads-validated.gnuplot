set terminal wxt size 1400,1100
set tmargin -3
set bmargin 12
set lmargin 7
set multiplot layout 2,2 title "DISJOINT set READS VALIDATED/S normalized to TinySTM-untouched-Intel" font ",18"
col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
col_red="#b01313"
xlabeloffsety=0.15
set decimal locale "en_US.UTF-8"; show locale
set tics scale 0
set ytics nomirror font "Computer Modern, 18" 
set ytics (0,1.0,1.5,2.0,2.5) 
set arrow 1 from 0, 1 to 12, 1 front nohead lc rgb "#000000" lw 1
set grid ytics lc rgb "#606060"
set grid xtics lc rgb "#bbbbbb"
set yrange [0:2.5]
set format x "%d"
set xtics nomirror rotate by 45 right font "Computer Modern, 14" 
set xtics offset 0, xlabeloffsety
set datafile separator whitespace
set border lc rgb "black"
set style data lines
set xlabel offset 0,-1.6 "Read-set size" font "Computer Modern, 15"

new = "-"
new1 = ".."
new2 = "_-_"
unset key
set arrow from 1.8, graph 0 to 1.8, graph 1 nohead lc rgb "#efefef"
set label "$L1: 128KB" at 1.9, 0.08 font "Computer Modern, 14"
set arrow 2 from 3.8, graph 0 to 3.8, graph 1 nohead lc rgb "#dadada"
set label 2 "$L3 GPU: 512KB" at 3.9, 0.27 font "Computer Modern, 14"
set arrow from 4.8, graph 0 to 4.8, graph 1 nohead lc rgb "#bebebe"
set label "$L2: 1.024MB" at 4.9, 0.12 font "Computer Modern, 14"
set arrow from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb "#afafaf"
set label "$L3: 8MB" at 7.9, 0.19 font "Computer Modern, 14"
set title "Only CPU, threaded validation, sequential walk" font "Computer Modern, 25"
set title "1 STM threads" offset 0, -1.15 font "Computer modern,16"
plot \
 '< join results-validation-array/TinySTM-wbetl/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random results-validation-array/TinySTM-wbetl-lsa/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random' u ($0):(($24/($18*1)) / ($8/($2*1))):( sprintf( '%.2fx',(($24/($18*1)) / ($8/($2*1))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl-lsa" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\
 '< join results-validation-array/TinySTM-wbetl/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/1/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/1-random' u ($0):(($28/($18*1)) / ($8/($2*1))):( sprintf( '%.2fx',(($28/($18*1)) / ($8/($2*1))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "Intel CPU-GPU co-op; GPU CAS; Blocks of 5736; sync on block" pt 2 lw 2 lc rgb "#b5d2ff" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa/1/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/1-random' u ($0):(($28/($18*1)) / ($8/($2*1))):( sprintf( '%.2fx',(($28/($18*1)) / ($8/($2*1))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "Intel CPU-GPU co-op; GPU CAS; Blocks of 5736; sync on block; LSA" pt 2 lw 2 lc rgb "#b5d2ff" dt new with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-amd-wbetl/1/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/1-random' u ($0):(($28/($18*1)) / ($8/($2*1))):( sprintf( '%.2fx',(($28/($18*1)) / ($8/($2*1))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "AMD CPU-GPU co-op; GPU CAS; Blocks of 11264; sync on block" pt 2 lw 2 lc rgb col_red with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random results-validation-array/TinySTM-threads-wbetl/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random-4-workers' u ($0):(($24/($18*1)) / ($8/($2*1))):( sprintf( '%.2fx',(($24/($18*1)) / ($8/($2*1))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl 4 validation worker threads" pt 1 lw 2 lc rgb "#696969" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random results-validation-array/TinySTM-threads-wbetl-lsa/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random-4-workers' u ($0):(($24/($18*1)) / ($8/($2*1))):( sprintf( '%.2fx',(($24/($18*1)) / ($8/($2*1))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl 4 validation worker threads LSA" pt 1 lw 2 lc rgb "#696969" dt new1 with linespoints,\

set title "2 STM threads" offset 0, -1.15 font "Computer modern,16"
plot \
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-r99-w1-d1-random-walk/2-random results-validation-array/TinySTM-wbetl-lsa/2/array-strongly-scaled-r99-w1-d1-random-walk/2-random' u ($0):(($24/($18*2)) / ($8/($2*2))):( sprintf( '%.2fx',(($24/($18*2)) / ($8/($2*2))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl-lsa" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-r99-w1-d1-random-walk/2-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/2/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/2-random' u ($0):(($28/($18*2)) / ($8/($2*2))):( sprintf( '%.2fx',(($28/($18*2)) / ($8/($2*2))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "Intel CPU-GPU co-op; GPU CAS; Blocks of 5736; sync on block" pt 2 lw 2 lc rgb "#b5d2ff" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-r99-w1-d1-random-walk/2-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa/2/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/2-random' u ($0):(($28/($18*2)) / ($8/($2*2))):( sprintf( '%.2fx',(($28/($18*2)) / ($8/($2*2))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "Intel CPU-GPU co-op; GPU CAS; Blocks of 5736; sync on block; LSA" pt 2 lw 2 lc rgb "#b5d2ff" dt new with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-r99-w1-d1-random-walk/2-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-amd-wbetl/2/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/2-random' u ($0):(($28/($18*2)) / ($8/($2*2))):( sprintf( '%.2fx',(($28/($18*2)) / ($8/($2*2))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "AMD CPU-GPU co-op; GPU CAS; Blocks of 11264; sync on block" pt 2 lw 2 lc rgb col_red with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-r99-w1-d1-random-walk/2-random results-validation-array/TinySTM-threads-wbetl/2/array-strongly-scaled-r99-w1-d1-random-walk/2-random-4-workers' u ($0):(($24/($18*2)) / ($8/($2*2))):( sprintf( '%.2fx',(($24/($18*2)) / ($8/($2*2))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl 4 validation worker threads" pt 1 lw 2 lc rgb "#696969" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-r99-w1-d1-random-walk/2-random results-validation-array/TinySTM-threads-wbetl-lsa/2/array-strongly-scaled-r99-w1-d1-random-walk/2-random-4-workers' u ($0):(($24/($18*2)) / ($8/($2*2))):( sprintf( '%.2fx',(($24/($18*2)) / ($8/($2*2))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl 4 validation worker threads LSA" pt 1 lw 2 lc rgb "#696969" dt new1 with linespoints,\

set title "4 STM threads" offset 0, -1.15 font "Computer modern,16"
plot \
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-r99-w1-d1-random-walk/4-random results-validation-array/TinySTM-wbetl-lsa/4/array-strongly-scaled-r99-w1-d1-random-walk/4-random' u ($0):(($24/($18*4)) / ($8/($2*4))):( sprintf( '%.2fx',(($24/($18*4)) / ($8/($2*4))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl-lsa" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-r99-w1-d1-random-walk/4-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/4/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/4-random' u ($0):(($28/($18*4)) / ($8/($2*4))):( sprintf( '%.2fx',(($28/($18*4)) / ($8/($2*4))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "Intel CPU-GPU co-op; GPU CAS; Blocks of 5736; sync on block" pt 2 lw 2 lc rgb "#b5d2ff" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-r99-w1-d1-random-walk/4-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa/4/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/4-random' u ($0):(($28/($18*4)) / ($8/($2*4))):( sprintf( '%.2fx',(($28/($18*4)) / ($8/($2*4))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "Intel CPU-GPU co-op; GPU CAS; Blocks of 5736; sync on block; LSA" pt 2 lw 2 lc rgb "#b5d2ff" dt new with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-r99-w1-d1-random-walk/4-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-amd-wbetl/4/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/4-random' u ($0):(($28/($18*4)) / ($8/($2*4))):( sprintf( '%.2fx',(($28/($18*4)) / ($8/($2*4))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "AMD CPU-GPU co-op; GPU CAS; Blocks of 11264; sync on block" pt 2 lw 2 lc rgb col_red with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-r99-w1-d1-random-walk/4-random results-validation-array/TinySTM-threads-wbetl/4/array-strongly-scaled-r99-w1-d1-random-walk/4-random-4-workers' u ($0):(($24/($18*4)) / ($8/($2*4))):( sprintf( '%.2fx',(($24/($18*4)) / ($8/($2*4))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl 4 validation worker threads" pt 1 lw 2 lc rgb "#696969" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-r99-w1-d1-random-walk/4-random results-validation-array/TinySTM-threads-wbetl-lsa/4/array-strongly-scaled-r99-w1-d1-random-walk/4-random-4-workers' u ($0):(($24/($18*4)) / ($8/($2*4))):( sprintf( '%.2fx',(($24/($18*4)) / ($8/($2*4))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl 4 validation worker threads LSA" pt 1 lw 2 lc rgb "#696969" dt new1 with linespoints,\

set key left Left left Left reverse inside top font"Computer modern, 11"
set title "8 STM threads" offset 0, -1.15 font "Computer modern,16"
plot \
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-r99-w1-d1-random-walk/8-random results-validation-array/TinySTM-wbetl-lsa/8/array-strongly-scaled-r99-w1-d1-random-walk/8-random' u ($0):(($24/($18*8)) / ($8/($2*8))):( sprintf( '%.2fx',(($24/($18*8)) / ($8/($2*8))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl-lsa" with linespoints pt 1 lw 2 lc rgb col_gold dt new,\
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-r99-w1-d1-random-walk/8-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/8/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/8-random' u ($0):(($28/($18*8)) / ($8/($2*8))):( sprintf( '%.2fx',(($28/($18*8)) / ($8/($2*8))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "Intel CPU-GPU co-op; GPU CAS; Blocks of 5736; sync on block" pt 2 lw 2 lc rgb "#b5d2ff" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-r99-w1-d1-random-walk/8-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl-lsa/8/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/8-random' u ($0):(($28/($18*8)) / ($8/($2*8))):( sprintf( '%.2fx',(($28/($18*8)) / ($8/($2*8))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "Intel CPU-GPU co-op; GPU CAS; Blocks of 5736; sync on block; LSA" pt 2 lw 2 lc rgb "#b5d2ff" dt new with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-r99-w1-d1-random-walk/8-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-amd-wbetl/8/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/8-random' u ($0):(($28/($18*8)) / ($8/($2*8))):( sprintf( '%.2fx',(($28/($18*8)) / ($8/($2*8))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "AMD CPU-GPU co-op; GPU CAS; Blocks of 11264; sync on block" pt 2 lw 2 lc rgb col_red with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-r99-w1-d1-random-walk/8-random results-validation-array/TinySTM-threads-wbetl/8/array-strongly-scaled-r99-w1-d1-random-walk/8-random-4-workers' u ($0):(($24/($18*8)) / ($8/($2*8))):( sprintf( '%.2fx',(($24/($18*8)) / ($8/($2*8))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl 4 validation worker threads" pt 1 lw 2 lc rgb "#696969" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-r99-w1-d1-random-walk/8-random results-validation-array/TinySTM-threads-wbetl-lsa/8/array-strongly-scaled-r99-w1-d1-random-walk/8-random-4-workers' u ($0):(($24/($18*8)) / ($8/($2*8))):( sprintf( '%.2fx',(($24/($18*8)) / ($8/($2*8))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl 4 validation worker threads LSA" pt 1 lw 2 lc rgb "#696969" dt new1 with linespoints,\


unset multiplot
