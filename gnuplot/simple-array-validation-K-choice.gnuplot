set terminal wxt size 2200,1100
set multiplot layout 2,2 title "1 STM thread - transactional array walk - effects of COALESCED vs STRIDED memory access in a persistent kernel on Intel hd530" font "Computer Modern,16"
set decimal locale "en_US.UTF-8"; show locale
unset border
set view map
set grid front lc rgb "#999966"
set datafile separator " "
set palette model RGB defined ( 0.00001 "#63d5ff", 0.000025 "#d663ff", 0.000075 "#9b7df0", 0.000125 "#b5d2ff", 0.000795 "#ff9900", 0.00835 "#d6cd1f", 0.0145 "#fa7a5a",0.085 "#fb8e72",0.1055 "#ffb545")
set key autotitle columnhead
set ytics nomirror font "Computer Modern, 11" 
set xlabel "READ-SET SIZE" font "Computer Modern, 11" 
set ylabel "PROGRAM" font "Computer Modern, 11" 
unset colorbox
set xtics rotate by 45 right scale 0 font "Computer Modern,12" offset 0,0,-0.04
set arrow 1 from -0.5, 18.5 to 10.5, 18.5 front nohead lc rgb "black" lw 2
set arrow 2 from -0.5, 0.5 to 10.5, 0.5 front nohead lc rgb "#ffffff" lw 1
set arrow 3 from -0.5, 1.5 to 10.5, 1.5 front nohead lc rgb "#ffffff" lw 1
set title "COALESCED access varying K (\'N-PER-WORK-ITEM\') (random array access)" font "Computer Modern,14"
plot 'results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/tabled-heatmap-data-COALESCED' matrix rowheaders columnheaders w image,\
     '' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("%f",$3)) : (sprintf(" ")))):xtic(1):3 with labels font "Computer Modern,10.7" palette,\

unset arrow 2
unset arrow 3
set arrow 2 from -0.5, 0.5 to 10.5, 0.5 front nohead lc rgb "#ffffff" lw 1
set arrow 3 from -0.5, 9.5 to 10.5, 9.5 front nohead lc rgb "#ffffff" lw 1
set title "STRIDED access (BEST) varying K (\'N-PER-WORK-ITEM\') (random array access)" font "Computer Modern,14"
plot 'results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/tabled-heatmap-data-STRIDED' matrix rowheaders columnheaders w image,\
     '' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("%f",$3)) : (sprintf(" ")))):xtic(1) with labels font "Computer Modern ,10.7" palette,\


set arrow 1 from -0.5, 18.5 to 10.5, 18.5 front nohead lc rgb "black" lw 2
set arrow 2 from -0.5, 0.5 to 10.5, 0.5 front nohead lc rgb "#ffffff" lw 1
set arrow 3 from -0.5, 1.5 to 10.5, 1.5 front nohead lc rgb "#ffffff" lw 1
set title "COALESCED access varying K (\'N-PER-WORK-ITEM\') (sequential array access)" font "Computer Modern,14"
plot 'results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-sequential-walk/tabled-heatmap-data-COALESCED' matrix rowheaders columnheaders w image,\
     '' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("%f",$3)) : (sprintf(" ")))):xtic(1):3 with labels font "Computer Modern,10.7" palette,\

unset arrow 2
unset arrow 3
set arrow 2 from -0.5, 0.5 to 10.5, 0.5 front nohead lc rgb "#ffffff" lw 1
set arrow 3 from -0.5, 9.5 to 10.5, 9.5 front nohead lc rgb "#ffffff" lw 1
set title "STRIDED access (BEST) varying K (\'N-PER-WORK-ITEM\') (sequential array access)" font "Computer Modern,14"
plot 'results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-sequential-walk/tabled-heatmap-data-STRIDED' matrix rowheaders columnheaders w image,\
     '' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("%f",$3)) : (sprintf(" ")))):xtic(1) with labels font "Computer Modern ,10.7" palette,\


unset multiplot
