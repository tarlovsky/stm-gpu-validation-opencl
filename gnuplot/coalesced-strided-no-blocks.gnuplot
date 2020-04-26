set terminal wxt size 1600,800
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 1,2 title "COALESCED vs. STRIDED MEMORY ACCESS PATTERNS, FULL iGPU VALIDATION - " font ",16"
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
set title "array-r99-w1 (RANDOM ARRAY WALK)" font ",12"
plot \
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) with yerrorlines t "Coalesced mem. Persistent Threads" lc rgb col_48,\
 'results-validation-array/TinySTM-igpu-persistent-strided-wbetl/1/array-r99-w1-random-walk/1-strided-mem' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) with yerrorlines t "Strided mem. Persistent Threads" lc rgb "#3cde33",\
 'results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) with yerrorlines t "TiynSTM untouched" lc rgb col_gold,\
 'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-BEST/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) with yerrorlines t "Dynamic split - gpu validates in blocks of 5736 (previous-best)" lc rgb "#b01313",\

set title "array-r99-w1 (SEQUENTIAL ARRAY WALK)" font ",12"
plot \
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-sequential-walk/1-coalesced-mem' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) with yerrorlines t "Coalesced mem. Persistent Threads" lc rgb col_48,\
 'results-validation-array/TinySTM-igpu-persistent-strided-wbetl/1/array-r99-w1-sequential-walk/1-strided-mem' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) with yerrorlines t "Strided mem. Persistent Threads" lc rgb "#3cde33",\
 'results-validation-array/TinySTM-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) with yerrorlines t "TiynSTM untouched" lc rgb col_gold,\
 'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-BEST/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) with yerrorlines t "Dynamic split - gpu validates in blocks of 5736 (previous-best)" lc rgb "#b01313",\

unset multiplot
