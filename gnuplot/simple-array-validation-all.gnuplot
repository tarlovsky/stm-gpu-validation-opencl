set terminal wxt size 3350,800
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 1,4 title "Validating array traversal (random element access), single-threaded, 4c-8th Intel 6700k CPU, Intel HD530 iGPU, AMD Vega 11 iGPU (TinySTM-WBETL default config). READS VALIDATED / TIME SPENT IN VALIDATION" font ",14"
set decimal locale "en_US.UTF-8"; show locale
set datafile missing '0'
set tics scale 0
set ytics
set grid ytics lc rgb "#606060"
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
set ylabel "Reads validated / s"
set xlabel "For each read-set entry load at least 8byte: R-ENTRY-T + LOCK; 1 lock covers 4 R-ENTRY-Ts.
set arrow from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb "#efefef"
set label "$L1: 128KB" at 5.9,0.00000014 
set arrow from 6.8, graph 0 to 6.8, graph 1 nohead lc rgb "#dadada"
set label "\L3 GPU: 512KB" at 6.9,0.00000014*2.5 
set arrow from 9.8, graph 0 to 9.8, graph 1 nohead lc rgb "#bebebe"
set label "$L2: 1.024MB" at 9.9,0.00000014*1.5 
set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb "#afafaf"
set label "$L3: 8MB" at 11.9,0.00000014*2.5 
set title "Only CPU, threaded validation, random walk" font ",12"
set style data linespoints
set logscale y
set yrange [0.0000001:0.0001]
set title "GPU C11 ATOMICS MEMORY ORDER COMPARISON INTEL ONLY " font ",12"
plot \
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "48WKGPS-128WI/WKGP SEQ-CST Persistent Kernel polling" lw 2 lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "48WKGPS-128WI/WKGP REL-ACQ Persistent Kernel polling" dt new lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-48WKGP-128WKGPSIZE' u 4:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "48WKGPS-128WI/WKGP RELAXED Persistent Kernel polling" dt new1 lc rgb col_48 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "24WKGPS-224WI/WKGP SEQ-CST Persistent Kernel polling" lw 2 lc rgb col_24 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "24WKGPS-224WI/WKGP REL-ACQ Persistent Kernel polling" dt new lc rgb col_24 pt 1,\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-ATOMICS-POLLING-OVERHEAD-PT-24WKGP-224WKGPSIZE' u 4:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "24WKGPS-224WI/WKGP RELAXED Persistent Kernel polling" dt new1 lc rgb col_24 pt 1
unset logscale y
set yrange [0:2000000000]
set ytics 100000000
set title "BEST INTEL" font ",12"
plot \
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1a-array-r99-w1-random-GPU-NAIVE-CALL-KERNEL-EVERYTIME'    u 2:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "OpenCL 1.2 non-persistent, Intel HD 530, coalesced 24WKGPS-224WKGPSIZE-SEQ-CST" lw 1 lc rgb "#3cde33" pt 16,\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-48wkgps-128wi-each-acq-rel'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Intel HD 530 coalesced 48WKGPS-128WKGPSIZE-ACQ-REL" lw 1 lc rgb col_48,\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-24wkgps-224wi-each-acq-rel'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Intel HD 530 coalesced 24WKGPS-224WKGPSIZE-ACQ-REL" lw 1 lc rgb col_24,\
 'results-validation-array/TinySTM-igpu-persistent-strided-wbetl/1/array-r99-w1-random-walk/1-strided-mem'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Intel HD 530 strided 24WKGPS-224WKGPSIZE-ACQ-REL" lw 1 lc rgb "#7dafff",\
 'results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Strided mem access Intel HD 530 validate in blocks of 5376 24WKGPS-224WKGPSIZE-ACQ-REL" lw 1 lc rgb col_gold,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Coalesced mem access Intel HD 530 validate in blocks of 5376 24WKGPS-224WKGPSIZE-ACQ-REL" lw 1 dt new lc rgb col_gold,\
 'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-strided-k-4/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "CPU-GPU-CO-OP; iGPU blocks of 5736*4 on iGPU w/ strided mem access, sync WI on block" dt new lw 1 pt 4 lc rgb "#7dafff",\

set title "BEST AMD " font ",12"
plot \
 'results-validation-array/TinySTM-igpu-persistent-coalesced-amd-g2816-l16-w176-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Vega 11 coalesced   2816GWS-176WKGPS-16WKGPSIZE-ACQ-REL" lw 1 dt new lc rgb "#b01313",\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-amd-g11264-l64-w176-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Vega 11 coalesced 11264GWS-176WKGPS-64WKGPSIZE-ACQ-REL" lw 1 dt new1 lc rgb "#b01313",\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-amd-g11264-l256-w44-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Vega 11 coalesced 11264GWS-44WKGPS-256WKGPSIZE-ACQ-REL" lw 1 lc rgb "#b01313",\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Coalesced mem access Vega 11 coalesced validate in blocks of 11264 44WKGPS-256WKGPSIZE-ACQ-REL" lw 2 dt new lc rgb col_gold,\

set style data linespoints
set title "BEST OF THE BEST" font ",12"
plot \
 'results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "TinySTM-untouched" lc rgb col_gold,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-2'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Coalesced mem access Intel iGPU validate in blocks of 5376*2 24WKGPS-224WKGPSIZE-ACQ-REL"lw 1 lc rgb col_48,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-2'      u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Strided mem access Intel iGPU validate in blocks of 5376*2 24WKGPS-224WKGPSIZE-ACQ-REL" lw 1 lc rgb "#7dafff",\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-3'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Coalesced mem access Vega 11 coalesced validate in blocks of 11264*3 44WKGPS-256WKGPSIZE-ACQ-REL" lw 1 dt new lc rgb "#b01313",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-k-1/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "Intel CPU-GPU-CO-OP; GPU blocks of 5736*1 w/ coalesced mem access, sync WI on block" lc rgb "#b01313",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-strided-k-4/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "Intel CPU-GPU-CO-OP; GPU blocks of 5736*4 w/ strided mem access, sync WI on block" dt new lw 1 pt 4 lc rgb "#7dafff",\

unset multiplot
