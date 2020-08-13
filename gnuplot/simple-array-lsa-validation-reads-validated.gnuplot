set terminal wxt size 1400,1100
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 2,2 title "Disjoint array walk: READS VALIDATED / THREAD / SECOND (THROUGHPUT) " font ",14"
col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
xlabeloffsety=-0.75
set decimal locale "en_US.UTF-8"; show locale
set tics scale 0
set ytics
set grid ytics lc rgb "#606060"
set format x "%d"
set xtics nomirror rotate by 45 right font "Verdana,10" 
set xtics offset 0, xlabeloffsety
set datafile separator whitespace
set border lc rgb "black"
set style data lines

new = "-"
new1 = ".."
new2 = "_-_"
set key font ",9"
set key inside top right
set ylabel "READS VALIDATED / THREAD / SECOND"
set arrow from 1.8, graph 0 to 1.8, graph 1 nohead lc rgb "#efefef"
set label "$L1: 128KB" at 1.9, 100000+100000*0.50 
set arrow 2 from 3.8, graph 0 to 3.8, graph 1 nohead lc rgb "#dadada"
set label 2 "\L3 GPU: 512KB" at 3.9, 100000+100000*2 
set arrow from 4.8, graph 0 to 4.8, graph 1 nohead lc rgb "#bebebe"
set label "$L2: 1.024MB" at 4.9, 100000+100000*0.75 
set arrow from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb "#afafaf"
set label "$L3: 8MB" at 7.9, 100000+100000*2 
set title "Only CPU, threaded validation, sequential walk" font ",12"
set title "1 STM threads" font ",12"
plot \
 '< join results-validation-array/TinySTM-wbetl/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/1/array-strongly-scaled-sticky-thread-r99-w1-d1-random-walk/1-random' u ($0):(($28/($18*1)) / ($8/($2*1))):( sprintf( '%.2fx',(($28/($18*1)) / ($8/($2*1))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "CPU-GPU co-op; iGPU sticky thread (thread 0); blocks of 5736 on iGPU; sync on block" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/1/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/1-random' u ($0):(($28/($18*1)) / ($8/($2*1))):( sprintf( '%.2fx',(($28/($18*1)) / ($8/($2*1))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "CPU-GPU co-op; iGPU shared GPU (iGPU CAS pinballing); blocks of 5736 on iGPU; sync on block" dt new with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random results-validation-array/TinySTM-wbetl-lsa/1/array-strongly-scaled-r99-w1-d1-random-walk/1-random' u ($0):(($24/($18*1)) / ($8/($2*1))):( sprintf( '%.2fx',(($24/($18*1)) / ($8/($2*1))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl-lsa" dt new with linespoints,\

set title "2 STM threads" font ",12"
plot \
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-r99-w1-d1-random-walk/2-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/2/array-strongly-scaled-sticky-thread-r99-w1-d1-random-walk/2-random' u ($0):(($28/($18*2)) / ($8/($2*2))):( sprintf( '%.2fx',(($28/($18*2)) / ($8/($2*2))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "CPU-GPU co-op; iGPU sticky thread (thread 0); blocks of 5736 on iGPU; sync on block" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-r99-w1-d1-random-walk/2-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/2/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/2-random' u ($0):(($28/($18*2)) / ($8/($2*2))):( sprintf( '%.2fx',(($28/($18*2)) / ($8/($2*2))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "CPU-GPU co-op; iGPU shared GPU (iGPU CAS pinballing); blocks of 5736 on iGPU; sync on block" dt new with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/2/array-strongly-scaled-r99-w1-d1-random-walk/2-random results-validation-array/TinySTM-wbetl-lsa/2/array-strongly-scaled-r99-w1-d1-random-walk/2-random' u ($0):(($24/($18*2)) / ($8/($2*2))):( sprintf( '%.2fx',(($24/($18*2)) / ($8/($2*2))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl-lsa" dt new with linespoints,\

set title "4 STM threads" font ",12"
plot \
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-r99-w1-d1-random-walk/4-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/4/array-strongly-scaled-sticky-thread-r99-w1-d1-random-walk/4-random' u ($0):(($28/($18*4)) / ($8/($2*4))):( sprintf( '%.2fx',(($28/($18*4)) / ($8/($2*4))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "CPU-GPU co-op; iGPU sticky thread (thread 0); blocks of 5736 on iGPU; sync on block" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-r99-w1-d1-random-walk/4-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/4/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/4-random' u ($0):(($28/($18*4)) / ($8/($2*4))):( sprintf( '%.2fx',(($28/($18*4)) / ($8/($2*4))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "CPU-GPU co-op; iGPU shared GPU (iGPU CAS pinballing); blocks of 5736 on iGPU; sync on block" dt new with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/4/array-strongly-scaled-r99-w1-d1-random-walk/4-random results-validation-array/TinySTM-wbetl-lsa/4/array-strongly-scaled-r99-w1-d1-random-walk/4-random' u ($0):(($24/($18*4)) / ($8/($2*4))):( sprintf( '%.2fx',(($24/($18*4)) / ($8/($2*4))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl-lsa" dt new with linespoints,\

set title "8 STM threads" font ",12"
plot \
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-r99-w1-d1-random-walk/8-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/8/array-strongly-scaled-sticky-thread-r99-w1-d1-random-walk/8-random' u ($0):(($28/($18*8)) / ($8/($2*8))):( sprintf( '%.2fx',(($28/($18*8)) / ($8/($2*8))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "CPU-GPU co-op; iGPU sticky thread (thread 0); blocks of 5736 on iGPU; sync on block" with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-r99-w1-d1-random-walk/8-random results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded-wbetl/8/array-strongly-scaled-shared-gpu-r99-w1-d1-random-walk/8-random' u ($0):(($28/($18*8)) / ($8/($2*8))):( sprintf( '%.2fx',(($28/($18*8)) / ($8/($2*8))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "CPU-GPU co-op; iGPU shared GPU (iGPU CAS pinballing); blocks of 5736 on iGPU; sync on block" dt new with linespoints,\
 '< join results-validation-array/TinySTM-wbetl/8/array-strongly-scaled-r99-w1-d1-random-walk/8-random results-validation-array/TinySTM-wbetl-lsa/8/array-strongly-scaled-r99-w1-d1-random-walk/8-random' u ($0):(($24/($18*8)) / ($8/($2*8))):( sprintf( '%.2fx',(($24/($18*8)) / ($8/($2*8))) ) ):xtic(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t "TinySTM-wbetl-lsa" dt new with linespoints,\


unset multiplot
