set terminal wxt size 3350,800
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 1,4 title "Validating random/sequential array traversal single-threaded, Intel 6700k CPU, Intel HD530 iGPU, (TinySTM-WBETL)" font ",16"
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
set key font ",7"
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
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-8-workers' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU 02 8 THREADS VALIDATING random array traversal" lc rgb "black" pt 7,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-4-workers' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU 02 4 THREADS VALIDATING random array traversal" dt new1 lc rgb "black" pt 7,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-2-workers' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU 02 2 THREADS VALIDATING random array traversal" dt new lc rgb "black" pt 7,\
 'results-validation-array/TinySTM-wbetl/1a/array-r99-w1-random-walk/1a-random-cpu-validation' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU 02 1 THREADS VALIDATING random array traversal" lc rgb col_gold pt 17,\
 'results-validation-array/TinySTM-wbetl/1a/array-r99-w1-sequential-walk/1a-sequential-cpu-validation'u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU 02 1 THREADS VALIDATING sequential array traversal" dt new lc rgb col_gold pt 17,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-sequential-GPU-48WKGPS-128WKGPSIZE-SEQ-CST'    u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "Persistent Kernel 48WKGPS-128WKGPSIZE-SEQ-CST, sequential array traversal" lw 2 lc rgb col_48 pt 16,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-sequential-GPU-24WKGPS-224WKGPSIZE-SEQ-CST'    u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "Persistent Kernel 24WKGPS-224WKGPSIZE-SEQ-CST, sequential array traversal" lw 2 lc rgb col_24 pt 16, \
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) notitle lw 2 lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 3:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) notitle dt new lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 4:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) notitle dt new1 lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) notitle lw 2 lc rgb col_24 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 3:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) notitle dt new lc rgb col_24 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 4:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) notitle dt new1 lc rgb col_24 pt 1
set title "CPU with threaded validation " font ",12"
plot \
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-8-workers' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "random walk CPU 02   8 THREADS VALIDATING" lc rgb "black" pt 1,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-4-workers' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "random walk CPU 02   4 THREADS VALIDATING" dt new1 lc rgb "black" pt 1,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-2-workers' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "random walk CPU 02   2 THREADS VALIDATING" dt new lc rgb "black" pt 1,\
 'results-validation-array/TinySTM-wbetl/1a/array-r99-w1-random-walk/1a-random-cpu-validation' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "random walk CPU 02   1 THREADS VALIDATING" lw 2 lc rgb "black" pt 1,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation-8-workers' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "sequential walk CPU O2   8 THREADS VALIDATING" lc rgb col_gold pt 1,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation-4-workers' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "sequential walk CPU O2   4 THREADS VALIDATING" dt new1 lc rgb col_gold pt 1,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation-2-workers' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "sequential walk CPU 02   2 THREADS VALIDATING" dt new lc rgb col_gold pt 1,\
 'results-validation-array/TinySTM-wbetl/1a/array-r99-w1-sequential-walk/1a-sequential-cpu-validation' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "sequential walk CPU O2   1 THREADS VALIDATING" lw 2 dt new lc rgb col_gold pt 1
set yrange [0.0000001:0.0001]
set title "GPU C11 ATOMICS MEMORY ORDER COMPARISON + DIFFERENT GPU OCCUPANCY " font ",12"
plot \
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t col lw 2 lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 3:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t col dt new lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 4:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t col dt new1 lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t col lw 2 lc rgb col_24 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 3:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t col dt new lc rgb col_24 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 4:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t col dt new1 lc rgb col_24 pt 1
set style data lines
set yrange [0.0000001:10]
set title "CPU GPU co-op validation VS. TinySTM-wbetl" font ",12"
plot \
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-55-gpu-45' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-55-gpu-45" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-56-gpu-44' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-56-gpu-44" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-57-gpu-43' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-57-gpu-43" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-58-gpu-42' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-58-gpu-42" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-59-gpu-41' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-59-gpu-41" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-60-gpu-40' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-60-gpu-40" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-61-gpu-39' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-61-gpu-39" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-62-gpu-38' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-62-gpu-38" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-63-gpu-37' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-63-gpu-37" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-64-gpu-36' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-64-gpu-36" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-65-gpu-35' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-65-gpu-35" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-66-gpu-34' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-66-gpu-34" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-67-gpu-33' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-67-gpu-33" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-68-gpu-32' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-68-gpu-32" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-69-gpu-31' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-69-gpu-31" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-70-gpu-30' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-70-gpu-30" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-71-gpu-29' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-71-gpu-29" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-72-gpu-28' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-72-gpu-28" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-73-gpu-27' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-73-gpu-27" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-74-gpu-26' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-74-gpu-26" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-75-gpu-25' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-75-gpu-25" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-76-gpu-24' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-76-gpu-24" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-77-gpu-23' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-77-gpu-23" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-78-gpu-22' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-78-gpu-22" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-79-gpu-21' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-79-gpu-21" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-80-gpu-20' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-80-gpu-20" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-81-gpu-19' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-81-gpu-19" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-82-gpu-18' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-82-gpu-18" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/1-random-cpu-84-gpu-16' u ($0 + 3):2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "1-random-cpu-84-gpu-16" lc rgb "#cacaca",\
 'results-validation-array/TinySTM-wbetl/1a/array-r99-w1-random-walk/1a-random-cpu-validation' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU 02 1 THREADS VALIDATING random array traversal" lc rgb col_gold pt 17

unset multiplot
