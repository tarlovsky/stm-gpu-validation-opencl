set terminal wxt size 3200,1080
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 1,3 title "Validating random/sequential array traversal, Intel 6700k CPU vs. Intel HD530 iGPU, (TinySTM-WBETL)" font ",16"
set datafile missing '0'
set tics scale 0
set ytics
set grid ytics lc rgb "#606060"
set logscale y
set format x "%d"
set xtics nomirror rotate by 45 right font "Verdana,10" 
set datafile separator whitespace
set border lc rgb "black"
set style data linespoints

new = "-"
new1 = ".."
new2 = "_-_"
col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
set key font ",10"
set key left
set yrange [0.0000001:10]
set ylabel "Time (s)"
set arrow from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb "#efefef"
set label "$L1: 128KB" at 8.9,0.00000014 
set arrow from 10.8, graph 0 to 10.8, graph 1 nohead lc rgb "#dadada"
set label "\L3 GPU: 512KB" at 10.9,0.00000014*2.5 
set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb "#bebebe"
set label "$L2: 1.024MB" at 11.9,0.00000014*1.5 
set arrow from 14.8, graph 0 to 14.8, graph 1 nohead lc rgb "#afafaf"
set label "$L3: 8MB" at 14.9,0.00000014*2.5 
set title "Only CPU, threaded validation, sequential walk" font ",12"
set title "CPU with threads + GPU Persistent Kernel threads " font ",12"
plot \
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-random-GPU-NAIVE-CALL-KERNEL-EVERYTIME'    u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "Persistent Kernel 24WKGPS-224WKGPSIZE-SEQ-CST , random array traversal" lw 2 lc rgb "#3cde33" pt 16,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 3:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "24WKGPs 224WI/WKGP NO VALIDATION LOGIC, JUST POLL" dt new lc rgb col_24 pt 8,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-SEQ-CST'    u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "Persistent Kernel 24WKGPS-224WKGPSIZE-SEQ-CST , random array traversal" lw 1 lc rgb col_24 pt 16,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL'    u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "Persistent Kernel 24WKGPS-224WKGPSIZE-ACQ-REL , random array traversal" dt new lw 1 lc rgb col_24 pt 16,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-RELAXED'    u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "Persistent Kernel 24WKGPS-128WKGPSIZE-RELAXED, random array traversal" dt new1 lw 1 lc rgb col_24 pt 16,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-random-GPU-48WKGPS-128WKGPSIZE-SEQ-CST'    u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "Persistent Kernel 48WKGPS-128WKGPSIZE-SEQ-CST , random array traversal" lw 1 lc rgb col_48 pt 16,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-random-GPU-48WKGPS-128WKGPSIZE-ACQ-REL'    u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "Persistent Kernel 48WKGPS-128WKGPSIZE-ACQ-REL , random array traversal" dt new lw 1 lc rgb col_48 pt 16,\
 'results-validation-array/TinySTM-wbetl/1a-array-r99-w1-random-CPU-O2-16THREADS-VALIDATING' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU 02 16 THREADS VALIDATING random array traversal" dt new lc rgb "black" pt 7,\
 'results-validation-array/TinySTM-wbetl/1a-array-r99-w1-random-CPU-O2-8THREADS-VALIDATING' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU 02 8 THREADS VALIDATING random array traversal" lc rgb "black" pt 7,\
 'results-validation-array/TinySTM-wbetl/1a-array-r99-w1-random-CPU-O2-4THREADS-VALIDATING' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU 02 4 THREADS VALIDATING random array traversal" dt new1 lc rgb "black" pt 7,\
 'results-validation-array/TinySTM-wbetl/1a-array-r99-w1-random-CPU-O2-1THREADS-VALIDATING' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU 02 1 THREADS VALIDATING random array traversal" lc rgb col_gold pt 17,\
 'results-validation-array/TinySTM-wbetl/1a-array-r99-w1-sequential-CPU-O2-1THREADS-VALIDATING'u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU 02 1 THREADS VALIDATING sequential array traversal" dt new lc rgb col_gold pt 17,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-sequential-GPU-48WKGPS-128WKGPSIZE-SEQ-CST'    u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "Persistent Kernel 48WKGPS-128WKGPSIZE-SEQ-CST, sequential array traversal" lw 2 lc rgb col_48 pt 16,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-sequential-GPU-24WKGPS-224WKGPSIZE-SEQ-CST'    u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "Persistent Kernel 24WKGPS-224WKGPSIZE-SEQ-CST, sequential array traversal" lw 2 lc rgb col_24 pt 16
set title "CPU with threaded validation " font ",12"
plot \
 'results-validation-array/TinySTM-wbetl/1a-array-r99-w1-random-CPU-O2-16THREADS-VALIDATING' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "random walk CPU 02 16 THREADS VALIDATING" dt new lc rgb "black" pt 1,\
 'results-validation-array/TinySTM-wbetl/1a-array-r99-w1-random-CPU-O2-8THREADS-VALIDATING' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "random walk CPU 02   8 THREADS VALIDATING" lc rgb "black" pt 1,\
 'results-validation-array/TinySTM-wbetl/1a-array-r99-w1-random-CPU-O2-4THREADS-VALIDATING' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "random walk CPU 02   4 THREADS VALIDATING" dt new1 lc rgb "black" pt 1,\
 'results-validation-array/TinySTM-wbetl/1a-array-r99-w1-random-CPU-O2-1THREADS-VALIDATING' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "random walk CPU 02   1 THREADS VALIDATING" lw 2 lc rgb "black" pt 1,\
 'results-validation-array/TinySTM-wbetl/1a-array-r99-w1-sequential-CPU-O2-16THREADS-VALIDATING' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "sequential walk CPU O2 16 THREADS VALIDATING" dt new lc rgb col_gold pt 1,\
 'results-validation-array/TinySTM-wbetl/1a-array-r99-w1-sequential-CPU-O2-8THREADS-VALIDATING' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "sequential walk CPU O2   8 THREADS VALIDATING" lc rgb col_gold pt 1,\
 'results-validation-array/TinySTM-wbetl/1a-array-r99-w1-sequential-CPU-O2-4THREADS-VALIDATING' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "sequential walk CPU O2   4 THREADS VALIDATING" dt new1 lc rgb col_gold pt 1,\
 'results-validation-array/TinySTM-wbetl/1a-array-r99-w1-sequential-CPU-O2-1THREADS-VALIDATING' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "sequential walk CPU O2   1 THREADS VALIDATING" lw 2 dt new lc rgb col_gold pt 1
set yrange [0.0000001:0.0001]
set title "GPU C11 ATOMICS MEMORY ORDER COMPARISON + DIFFERENT GPU OCCUPANCY " font ",12"
plot \
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t col lw 2 lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 3:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t col dt new lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 4:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t col dt new1 lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t col lw 2 lc rgb col_24 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 3:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t col dt new lc rgb col_24 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 4:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t col dt new1 lc rgb col_24 pt 1

unset multiplot
