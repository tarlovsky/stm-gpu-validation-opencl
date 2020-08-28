set terminal wxt size 2860,550
set multiplot layout 1,2 title "1 STM thread - transactional array walk READS VALIDATED * 10^8 /s - persistent kernel validation in blocks of 11264*K on Vega 11 Ryzen 2400g APU" font "Computer Modern,16"
set decimal locale "en_US.UTF-8"; show locale
unset border
set view map
set grid front lc rgb "#999966"
set datafile separator " "
set cbrange [0.01:10]
set palette model RGB defined (0.0 "#ffffff",0.01 "#c1ff2a",0.1 "#dcff87",0.25 "#efff4d",0.5 "#fff14c",1 "#ffa81b",4 "#fe971a",6 "#ff4e1d",7 "#ff1e1e")
set key autotitle columnhead
set ytics nomirror font "Computer Modern, 11" 
set xlabel "READ-SET SIZE" font "Computer Modern, 11" 
set ylabel "K = N PER WORK-ITEM" font "Computer Modern, 11" 
set xtics rotate by 45 right scale 0 font "Computer Modern,12" offset 0,0,-0.04
set arrow 1 from -0.5, 18.5 to 18.5, 18.5 front nohead lc rgb "#000000" lw 2
set title "COALESCED access; varying K (\'N-ELEMENTS-PER-WORK-ITEM\') (random array access) READS VALIDATED*10^8/s " font "Computer Modern,14"
plot 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-random-walk/tabled-heatmap-data-COALESCED' matrix rowheaders columnheaders w image,\
     '' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("%.3f",$3)) : (sprintf(" ")))):xtic(1):3 with labels font "Computer Modern,10.7" palette,\

unset arrow 2
unset arrow 3

set arrow 1 from -0.5, 18.5 to 18.5, 18.5 front nohead lc rgb "#000000" lw 2
set title "COALESCED access; varying K (\'N-ELEMENTS-PER-WORK-ITEM\') (sequential array access) READS VALIDATED*10^8/s " font "Computer Modern,14"
plot 'results-validation-array/TinySTM-igpu-persistent-blocks-amd-wbetl/1/array-r99-w1-sequential-walk/tabled-heatmap-data-COALESCED' matrix rowheaders columnheaders w image,\
     '' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("%.3f",$3)) : (sprintf(" ")))):xtic(1):3 with labels font "Computer Modern,10.7" palette,\

unset arrow 2
unset arrow 3

unset multiplot
