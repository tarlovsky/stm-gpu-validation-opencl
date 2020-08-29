set terminal wxt size 1550,600
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 1,2 title "Array traversal (random element access), 1 thread, 4c-8th AMD 2400g APU, Vega 11 iGPU, TinySTM-WBETL default config. READS VALIDATED / TIME SPENT IN VALIDATION" font ",12"
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
set xlabel "RSET SIZE. Each loads at least 8 byte: (ENTRY, LOCK POINTER); 1 LOCK covers 4 READ-ENTRIES.
set arrow from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb "#efefef"
set label "$L1: 128KB" at 5.9, 50000000 
set arrow from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb "#dadada"
set label "\L3 GPU: 512KB" at 7.9, 50000000*2.5 
set arrow from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb "#bebebe"
set label "$L2: 1.024MB" at 8.9, 50000000*1.5 
set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb "#afafaf"
set label "$L3: 8MB" at 11.9, 50000000*2.5 
set title "Only CPU, threaded validation, random walk" font ",12"
set style data linespoints
unset logscale y
set yrange [0:1000000000]
set ytics 100000000
set title "VARYING #WORKGROUPS, (WORKITEMS/WKGP) - MAINTAINING FULL OCCUPANCY - FULL GPU VALIDATION" font ",10"
plot \
 'results-validation-array/TinySTM-igpu-persistent-coalesced-amd-g2816-l16-w176-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Vega 11 coalesced   2816GWS-176WKGPS-16WKGPSIZE-ACQ-REL" lw 1 dt new lc rgb "#b01313",\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-amd-g11264-l64-w176-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Vega 11 coalesced 11264GWS-176WKGPS-64WKGPSIZE-ACQ-REL" lw 1 pt 5 lc rgb "#b01313",\
 'results-validation-array/TinySTM-igpu-persistent-coalesced-amd-g11264-l256-w44-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Vega 11 coalesced 11264GWS-44WKGPS-256WKGPSIZE-ACQ-REL" lw 1 pt 4 lc rgb "#b01313",\

unset logscale y
set yrange [0:1000000000]
set ytics 100000000
set title "VARYING READS VALIDATED PER WORK-ITEM - COALESCED - FULL GPU VALIDATION" font ",10"
plot \
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-1'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*1" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-2'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*2" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-3'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*3" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-4'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*4" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-5'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*5" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-6'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*6" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-7'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*7" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-8'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*8" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-9'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*9" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-10'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*10" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-20'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*20" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-40'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*40" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-50'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*50" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-100'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*100" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-1000'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*1000" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-10000'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*10000" lw 1 ,\
 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-11915'    u ($0):($1/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 11264*11915" lw 1 ,\

unset multiplot
