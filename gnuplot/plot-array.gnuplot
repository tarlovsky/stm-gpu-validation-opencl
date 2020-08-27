set terminal wxt size 1900,900
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 1,2 title "COALESCED ACCESS FULL iGPU VALIDATION PERSISTENT KERNEL " font ",16"
set decimal locale "en_US.UTF-8"; show locale
set datafile missing '0'
set grid ytics lc rgb "#606060"
set logscale y
set datafile separator whitespace
set border lc rgb "black"
set style data lines

new = "-"
new1 = ".."
new2 = "_-_"
col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
set origin 0*0.5,0
set size 0.5,0.98 
set key top left
set key font ",10"
set xrange [0:*]
set yrange [0.0000001:10]
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
 'results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) with yerrorlines t "Full iGPU Coalesced mem (K=RSET/5376)" lc rgb col_48,\
 'results-validation-array/TinySTM-igpu-persistent-strided-wbetl/1/array-r99-w1-random-walk/1-strided-mem' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) with yerrorlines t "Full iGPU Strided mem. (K=RSET/5376)" lc rgb "#3cde33",\
 'results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) with yerrorlines t "TiynSTM untouched" lc rgb col_gold,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-random-igpu' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) with yerrorlines t "Full iGPU, blocks of 5736 (=NO FOR LOOP to get idx), sync on block" dt new lc rgb "black",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-k-1/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) with yerrorlines t "Dynamic split K=1; blocks of 5736 on iGPU, sync on block (previous-best)" lc rgb "#b01313",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-strided-k-4/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) with yerrorlines t "Dynamic split K=4; blocks of 5736*4 on iGPU w/ strided mem., sync on block (new-best)" dt new lc rgb "#b01313",\
 'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-work-item-level-sync-strided-k-4/1/array-r99-w1-random-walk/1-random-cpu-validation' u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*16))/1000000))) with yerrorlines t "Dynamic split K=4; gpu validates in blocks of 5736*4 w/ strided mem., sync on work-item" dt new lc rgb "#ea99ff",\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-amd-g2816-l16-w176-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem'    u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) w yerrorlines t "Vega 11 coalesced   2816GWS-176WKGPS-16WKGPSIZE-ACQ-REL" lw 1 dt new lc rgb "#b01313",\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-amd-g11264-l64-w176-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem'    u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) w yerrorlines t "Vega 11 coalesced 11264GWS-176WKGPS-64WKGPSIZE-ACQ-REL" lw 1 dt new1 lc rgb "#b01313",\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-amd-g11264-l256-w44-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem'    u 0:2:3:xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) w yerrorlines t "Vega 11 coalesced 11264GWS-44WKGPS-256WKGPSIZE-ACQ-REL" lw 1 dt new2 lc rgb "#b01313",\

unset title
unset key
unset arrow 1
unset arrow 2
unset arrow 3
unset arrow 4
unset label 1
unset label 2
unset label 3
unset label 4
set xlabel "Rset-size
set object 1 rect from -88,0.03 to -49,0.41
set object 1 rect fc rgb 'white' fillstyle solid 0.0 noborder
set origin 0.09,0.47
set size 0.19,0.350 
set xrange [15:17]
set yrange [0.075:0.35]
replot
set origin 0.32+(0.5*0),0.25
set size 0.17,0.350 
set xrange [9:11]
set yrange [0.0001:0.001]
replot
unset multiplot
