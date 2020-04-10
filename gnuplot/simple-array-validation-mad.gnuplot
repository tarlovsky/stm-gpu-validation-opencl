set terminal wxt size 1200,1080
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 1,1 title "Execute MAD isntructions instead of array validation, Intel 6700k CPU vs. Intel HD530 iGPU, (TinySTM-WBETL)" font ",16"
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
set key font ",9"
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
set yrange [0.0000001:10]
set title "CPU VS GPU MAD VALIDATION" font ",12"
plot \
 'results-gpu/1a-array-r99-w1-random-MAD-VALIDATE' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU O2 MAD instead of VALIDATE" lw 1 lc rgb col_gold pt 1,\
 'results-gpu/1a-array-r99-w1-random-MAD-VALIDATE' u 3:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "Persistent Kernel Threads 24WKGPS 224WI/WKGP, MAD instead of VALIDATE" lw 1 lc rgb col_48 pt 1,\
 'results-gpu/1a-array-r99-w1-random-CPU-O2-1THREADS-VALIDATING' u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "CPU 02 1 THREADS VALIDATING random array traversal" lw 2 lc rgb col_gold pt 17,\
 'results-gpu/1a-array-r99-w1-random-GPU-24WKGPS-224WKGPSIZE-ACQ-REL'    u 2:xtic(sprintf("%d/ %.2fMB",$1, ($1*8)/1000000)) t "Persistent Kernel 24WKGPS-224WKGPSIZE-ACQ-REL , random array traversal" lw 2 lc rgb col_48 pt 16

unset multiplot
