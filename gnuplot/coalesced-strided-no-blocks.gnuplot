set terminal wxt size 1900,900
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 1,2 title "COALESCED vs. STRIDED MEMORY ACCESS PATTERNS, FULL iGPU VALIDATION - " font ",16"
set decimal locale "en_US.UTF-8"; show locale
set datafile missing '0'
set grid ytics lc rgb "#606060"
set datafile separator whitespace
set border lc rgb "black"
set style data lines

new = "-"
new1 = ".."
new2 = "_-_"
col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
set key top left
set key font ",10"
set xrange [0:*]
set yrange [0:2.6]
set ytics 0.1
set tics scale 0
set ytics
set format x "%d"
set xtics nomirror rotate by 45 right font "Verdana,10" 
set ylabel "Time (s)"
set xlabel "For each read-set entry load at least 8byte: R-ENTRY-T + LOCK; 1 lock covers 4 R-ENTRY-Ts.
set arrow 1 from 4.8, graph 0 to 4.8, graph 1 nohead lc rgb "#efefef"
set label 1 "$L1: 128KB" at 4.9,0.00000014 
set arrow 2 from 6.8, graph 0 to 6.8, graph 1 nohead lc rgb "#dadada"
set label 2 "\L3 GPU: 512KB" at 6.9,0.00000014*2.5 
set arrow 3 from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb "#bebebe"
set label 3 "$L2: 1.024MB" at 7.9,0.00000014*1.5 
set arrow 4 from 10.8, graph 0 to 10.8, graph 1 nohead lc rgb "#afafaf"
set label 4 "$L3: 8MB" at 10.9,0.00000014*2.5 

set title "array-r99-w1 (random ARRAY WALK)" font ",12"
plot \
 '<paste -d "" results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:($19/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "Full iGPU Coalesced mem (K=RSET/5376)" lc rgb col_48,\
 '<paste -d "" results-validation-array/TinySTM-igpu-persistent-strided-wbetl/1/array-r99-w1-random-walk/1-strided-mem results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:($19/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "Full iGPU Strided mem. (K=RSET/5376)" lc rgb "#3cde33",\
 '<paste -d "" results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-random-igpu results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:($19/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "Full iGPU, blocks of 5736 (=NO FOR LOOP to get idx), sync on block" dt new lc rgb "black",\
 '<paste -d "" results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-k-1/1/array-r99-w1-random-walk/1-random-cpu-validation results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:($31/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "Dynamic split K=1; blocks of 5736 on iGPU, sync on block (previous-best)" lc rgb "#b01313",\
 '<paste -d "" results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-strided-k-4/1/array-r99-w1-random-walk/1-random-cpu-validation results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:($31/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "Dynamic split K=4; blocks of 5736*4 on iGPU w/ strided mem., sync on block (new-best)" dt new lc rgb "#b01313",\
 '<paste -d"" results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-work-item-level-sync-strided-k-4/1/array-r99-w1-random-walk/1-random-cpu-validation results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:($31/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "Dynamic split K=4; gpu validates in blocks of 5736*4 w/ strided mem., sync on work-item" dt new lc rgb "#ea99ff"

set key top left
set key font ",10"
set xrange [0:*]
set yrange [0:2.6]
set ytics 0.1
set tics scale 0
set ytics
set format x "%d"
set xtics nomirror rotate by 45 right font "Verdana,10" 
set ylabel "Time (s)"
set xlabel "For each read-set entry load at least 8byte: R-ENTRY-T + LOCK; 1 lock covers 4 R-ENTRY-Ts.
set arrow 1 from 4.8, graph 0 to 4.8, graph 1 nohead lc rgb "#efefef"
set label 1 "$L1: 128KB" at 4.9,0.00000014 
set arrow 2 from 6.8, graph 0 to 6.8, graph 1 nohead lc rgb "#dadada"
set label 2 "\L3 GPU: 512KB" at 6.9,0.00000014*2.5 
set arrow 3 from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb "#bebebe"
set label 3 "$L2: 1.024MB" at 7.9,0.00000014*1.5 
set arrow 4 from 10.8, graph 0 to 10.8, graph 1 nohead lc rgb "#afafaf"
set label 4 "$L3: 8MB" at 10.9,0.00000014*2.5 

set title "array-r99-w1 (sequential ARRAY WALK)" font ",12"
plot \
 '<paste -d "" results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-sequential-walk/1-coalesced-mem results-validation-array/TinySTM-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u 0:($19/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "Full iGPU Coalesced mem (K=RSET/5376)" lc rgb col_48,\
 '<paste -d "" results-validation-array/TinySTM-igpu-persistent-strided-wbetl/1/array-r99-w1-sequential-walk/1-strided-mem results-validation-array/TinySTM-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u 0:($19/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "Full iGPU Strided mem. (K=RSET/5376)" lc rgb "#3cde33",\
 '<paste -d "" results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-sequential-walk/1-sequential-igpu results-validation-array/TinySTM-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u 0:($19/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "Full iGPU, blocks of 5736 (=NO FOR LOOP to get idx), sync on block" dt new lc rgb "black",\
 '<paste -d "" results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-k-1/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation results-validation-array/TinySTM-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u 0:($31/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "Dynamic split K=1; blocks of 5736 on iGPU, sync on block (previous-best)" lc rgb "#b01313",\
 '<paste -d "" results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-strided-k-4/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation results-validation-array/TinySTM-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u 0:($31/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "Dynamic split K=4; blocks of 5736*4 on iGPU w/ strided mem., sync on block (new-best)" dt new lc rgb "#b01313",\
 '<paste -d"" results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-work-item-level-sync-strided-k-4/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation results-validation-array/TinySTM-wbetl/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u 0:($31/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) t "Dynamic split K=4; gpu validates in blocks of 5736*4 w/ strided mem., sync on work-item" dt new lc rgb "#ea99ff"

unset multiplot
