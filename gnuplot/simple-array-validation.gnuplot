set terminal wxt size 3350,800
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 1,4 title "Validating random/sequential array traversal single-threaded, Intel 6700k CPU, Intel HD530 iGPU, (TinySTM-WBETL)" font ",16"
set decimal locale "en_US.UTF-8"; show locale
set datafile missing '0'
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
set key top left
set yrange [0.0000001:10]
set ylabel "Time (s)"
set xlabel "For each read-set entry load at least 8byte: R-ENTRY-T + LOCK; 1 lock covers 4 R-ENTRY-Ts.
set arrow from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb "#efefef"
set label "$L1: 128KB" at 5.9,0.00000014 
set arrow from 6.8, graph 0 to 6.8, graph 1 nohead lc rgb "#dadada"
set label "\L3 GPU: 512KB" at 6.9,0.00000014*2.5 
set arrow from 9.8, graph 0 to 9.8, graph 1 nohead lc rgb "#bebebe"
set label "$L2: 1.024MB" at 9.9,0.00000014*1.5 
set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb "#afafaf"
set label "$L3: 8MB" at 11.9,0.00000014*2.5 
set title "Only CPU, threaded validation, sequential walk" font ",12"
set title "CPU worker threads; GPU Persistent Kernel threads;CPU+GPU co-operation" font ",12"
plot \
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-NAIVE-CALL-KERNEL-EVERYTIME'    u 2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Persistent Kernel 24WKGPS-224WKGPSIZE-SEQ-CST , random array traversal" lw 2 lc rgb "#3cde33" pt 16,\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-48wkgps-128wi-each-acq-rel'    u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) w yerrorlines t "Persistent Kernel 48WKGPS-128WKGPSIZE-ACQ-REL , random array traversal" lw 2 lc rgb col_48,\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-24wkgps-224wi-each-acq-rel'    u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) w yerrorlines t "Persistent Kernel 24WKGPS-224WKGPSIZE-ACQ-REL , random array traversal" lw 2 lc rgb col_24,\
 'results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) with yerrorlines t "CPU 02 1 THREADS VALIDATING random array traversal" lc rgb col_gold,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-2-workers' u ($0):2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) w yerrorlines t "CPU 02 2 THREADS VALIDATING random array traversal" dt new lc rgb "black",\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-4-workers' u ($0):2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) w yerrorlines t "CPU 02 4 THREADS VALIDATING random array traversal" dt new1 lc rgb "black",\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-8-workers' u ($0):2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) w yerrorlines t "CPU 02 8 THREADS VALIDATING random array traversal" lc rgb "black",\
 'results-validation-array/TinySTM-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) w yerrorlines t "CPU 02 1 THREADS VALIDATING sequential array traversal" dt new lc rgb col_gold pt 17,\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-67-gpu-33' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) w yerrorlines t "GLOBAL MINUMUM " dt new lc rgb "#b01313",\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "24WKGPS 224WI/WKGP NO VALIDATION LOGIC, PERSISTENT KERNEL POLLING OVERHEAD" dt new lc rgb col_24 pt 8,\

set title "CPU with threaded validation " font ",12"
plot \
 'results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u 2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "random walk CPU 02   1 THREADS VALIDATING" lw 2 lc rgb "black" pt 1,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-2-workers' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "random walk CPU 02   2 THREADS VALIDATING" dt new lc rgb "black" pt 1,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-4-workers' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "random walk CPU 02   4 THREADS VALIDATING" dt new1 lc rgb "black" pt 1,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-8-workers' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "random walk CPU 02   8 THREADS VALIDATING" lc rgb "black" pt 1,\
 'results-validation-array/TinySTM-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u 2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "sequential walk CPU O2   1 THREADS VALIDATING" lw 2 dt new lc rgb col_gold pt 1,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation-2-workers' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "sequential walk CPU 02   2 THREADS VALIDATING" dt new lc rgb col_gold pt 1,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation-4-workers' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "sequential walk CPU O2   4 THREADS VALIDATING" dt new1 lc rgb col_gold pt 1,\
 'results-validation-array/TinySTM-threads-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation-8-workers' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "sequential walk CPU O2   8 THREADS VALIDATING" lc rgb col_gold pt 1,\

set style data linespoints
set yrange [0.0000001:0.0001]
set title "GPU C11 ATOMICS MEMORY ORDER COMPARISON + DIFFERENT GPU OCCUPANCY " font ",12"
plot \
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "48WKGPS-128WI/WKGP SEQ-CST Persistent Kernel polling" lw 2 lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "48WKGPS-128WI/WKGP REL-ACQ Persistent Kernel polling" dt new lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 4:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "48WKGPS-128WI/WKGP RELAXED Persistent Kernel polling" dt new1 lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "24WKGPS-224WI/WKGP SEQ-CST Persistent Kernel polling" lw 2 lc rgb col_24 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "24WKGPS-224WI/WKGP REL-ACQ Persistent Kernel polling" dt new lc rgb col_24 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 4:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "24WKGPS-224WI/WKGP RELAXED Persistent Kernel polling" dt new1 lc rgb col_24 pt 1
set style data lines
set yrange [0.0000001:10]
set title "CPU GPU co-op validation VS. TinySTM-wbetl, multiple balance" font ",12"
plot \
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-17-gpu-83' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-18-gpu-82' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-19-gpu-81' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-20-gpu-80' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-21-gpu-79' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-22-gpu-78' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-23-gpu-77' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-24-gpu-76' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-25-gpu-75' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-26-gpu-74' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-27-gpu-73' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-28-gpu-72' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-29-gpu-71' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-30-gpu-70' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-31-gpu-69' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-32-gpu-68' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-33-gpu-67' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-34-gpu-66' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-35-gpu-65' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-36-gpu-64' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-37-gpu-63' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-38-gpu-62' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-39-gpu-61' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-40-gpu-60' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-41-gpu-59' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-42-gpu-58' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-43-gpu-57' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-44-gpu-56' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-45-gpu-55' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-46-gpu-54' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-47-gpu-53' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-48-gpu-52' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-49-gpu-51' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-50-gpu-50' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-51-gpu-49' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-52-gpu-48' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-53-gpu-47' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-54-gpu-46' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-55-gpu-45' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-56-gpu-44' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-57-gpu-43' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-58-gpu-42' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-59-gpu-41' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-60-gpu-40' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-61-gpu-39' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-62-gpu-38' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-63-gpu-37' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-64-gpu-36' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-65-gpu-35' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-66-gpu-34' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-67-gpu-33' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-68-gpu-32' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-69-gpu-31' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-70-gpu-30' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-71-gpu-29' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-72-gpu-28' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-73-gpu-27' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-74-gpu-26' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-75-gpu-25' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-76-gpu-24' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-77-gpu-23' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-78-gpu-22' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-79-gpu-21' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-80-gpu-20' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-81-gpu-19' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-82-gpu-18' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-83-gpu-17' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-84-gpu-16' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-85-gpu-15' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-86-gpu-14' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-87-gpu-13' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-88-gpu-12' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-89-gpu-11' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-90-gpu-10' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-91-gpu-9' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-92-gpu-8' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-93-gpu-7' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-94-gpu-6' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-95-gpu-5' u ($0):2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) notitle lc rgb "#11cacaca",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-67-gpu-33' u ($0):2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) w yerrorlines t "GLOBAL MINUMUM 1-random-cpu-67-gpu-33" dt new lc rgb "#b01313",\
 'results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) w yerrorlines t "CPU 02 1 THREADS VALIDATING random array traversal" lc rgb col_gold pt 17

unset multiplot
set ytics nomirror
set y2tics
set grid
