set terminal wxt size 1550,1200
unset bmargin
unset tmargin
unset rmargin
unset lmargin
set multiplot layout 2,2 title "Array traversal (random element access), 1 thread, 4c-8th Intel 6700k CPU, Intel HD530 iGPU, TinySTM-WBETL default config. READS VALIDATED / TIME SPENT IN VALIDATION" font ",12"
set decimal locale "en_US.UTF-8"; show locale
set datafile missing '0'
set tics scale 0
set ytics font "Computer Modern, 13"
set grid ytics lc rgb "#606060"
set grid xtics lc rgb "#bbbbbb"
set format x "%d"
set xtics out nomirror rotate by 35 right font "Computer Modern, 11.5" 
set datafile separator whitespace
set border lc rgb "black"
set style data lines

new = "-"
new1 = ".."
new2 = "_-_"
col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
set key top right font "Computer Modern, 13.5"
set ylabel offset -2,0 "Reads validated / s" font "Computer Modern, 14"
set xlabel "RSET SIZE" font "Computer Modern, 11"
set arrow from 5.8, graph 0 to 5.8, graph 1 nohead lc rgb "#efefef"
set label "$L1: 128KB" at 5.9, 50000000 font "Computer Modern, 11.5"
set arrow from 7.8, graph 0 to 7.8, graph 1 nohead lc rgb "#dadada"
set label "\L3 GPU: 512KB" at 7.9, 50000000*2.5 font "Computer Modern, 11.5"
set arrow from 8.8, graph 0 to 8.8, graph 1 nohead lc rgb "#bebebe"
set label "$L2: 1.024MB" at 8.9, 50000000*1.5 font "Computer Modern, 11.5"
set arrow from 11.8, graph 0 to 11.8, graph 1 nohead lc rgb "#afafaf"
set label "$L3: 8MB" at 11.9, 50000000*2.5 font "Computer Modern, 11.5"
set title "Only CPU, threaded validation, random walk" font ",12"
set style data linespoints
unset logscale y
set yrange [0:1000000000]
set ytics 100000000
set title "Varying Instant Kernel config" font "Computer Modern,17"
plot \
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-48wkgps-128wi-each-acq-rel'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Intel HD 530 coalesced 48WKGPS-128WKGPSIZE-ACQ-REL" lw 1 lc rgb col_24,\
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-24wkgps-224wi-each-acq-rel'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Intel HD 530 coalesced 24WKGPS-224WKGPSIZE-ACQ-REL" lw 1 pt 2 lc rgb col_48,\

unset logscale y
set ytics 100000000
set title "Strided vs. Coalesced - FULL GPU VALIDATION" font "Computer Modern,17"
plot \
 '../results-validation-array/TinySTM-igpu-persistent-coalesced-wbetl/1/array-r99-w1-random-walk/1-random-cpu-validation-24wkgps-224wi-each-acq-rel'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Intel HD 530 coalesced 24WKGPS-224WKGPSIZE-ACQ-REL" lw 1 pt 2 lc rgb col_48,\
 '../results-validation-array/TinySTM-igpu-persistent-strided-wbetl/1/array-r99-w1-random-walk/1-strided-mem'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Intel HD 530 strided 24WKGPS-224WKGPSIZE-ACQ-REL" lw 1 pt 4 lc rgb "#7dafff",\

unset logscale y
set key top right font "Computer Modern, 10.5"
set ytics 100000000
set title "Varying validations/Work-item - Coalesced - Blocks" font "Computer Modern,17"
plot \
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-1'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*1" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-2'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*2" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-3'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*3" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-4'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*4" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-5'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*5" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-6'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*6" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-7'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*7" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-8'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*8" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-9'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*9" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-10'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*10" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-20'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*20" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-40'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*40" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-50'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*50" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-100'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*100" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-1000'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*1000" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-10000'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*10000" lw 1,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-coalesced-mem-K-24966'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*24966" lw 1,\

unset logscale y
set ytics 100000000
set title "Varying validations/Work-item - Strided - Blocks" font "Computer Modern,17"
plot \
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-1'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*1" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-2'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*2" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-3'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*3" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-4'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*4" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-5'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*5" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-6'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*6" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-7'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*7" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-8'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*8" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-9'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*9" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-10'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*10" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-20'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*20" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-40'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*40" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-50'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*50" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-100'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*100" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-1000'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*1000" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-10000'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*10000" lw 1 ,\
 '../results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/1-strided-mem-K-24966'    u ($0):($8/$2):xtic(sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000))) t "Blocks of 5376*24966" lw 1 ,\

unset multiplot
