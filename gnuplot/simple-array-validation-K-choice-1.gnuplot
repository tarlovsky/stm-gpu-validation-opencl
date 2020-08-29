
set terminal wxt size 1230,1100
set multiplot layout 2,1 title "Optimizing number of elements/work-item. RANDOM array walk - Intel HD530" font "Computer Modern,16"
set decimal locale "en_US.UTF-8"; show locale
unset border
set view map
set grid front lc rgb "#999966"
set datafile separator " "
set format x "%d"
set cbrange [0.01:15]
set palette model RGB defined (0.0 "#ffffff" , 0.05 "#bdd7ff" ,0.5 "#c1ff2a", 0.75 "#dcff87",1 "#efff4d",2 "#fff14c",3 "#ffa81b",4 "#fe971a",6 "#ff4e1d",7 "#ff1e1e")
set key autotitle columnhead
set ytics nomirror font "Computer Modern, 11" 
set xlabel "READ-SET SIZE" font "Computer Modern, 11" 
set ylabel "K = N PER WORK-ITEM" font "Computer Modern, 11" 
set xtics rotate by 45 right scale 0 font "Computer Modern,12" offset 0,0,-0.04
set arrow 1 from -0.5, 18.5 to 18.5, 18.5 front nohead lc rgb "#000000" lw 2
set arrow 2 from -0.5, 0.5 to 18.5, 0.5 front nohead lc rgb "#000000" lw 2
set arrow 3 from -0.5, 1.5 to 18.5, 1.5 front nohead lc rgb "#000000" lw 2
set title "COALESCED kernel memory access" font "Computer Modern,14"
plot 'results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/tabled-heatmap-data-COALESCED-random' matrix rowheaders columnheaders w image,\
     '' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("%.3f",$3)) : (sprintf(" ")))):xtic((sprintf("%'d (%.2fMB)",$1, ((($1*8))/1000000)))):3 with labels font "Computer Modern,10.7" palette,\

unset arrow 2
unset arrow 3
set arrow 2 from -0.5, -0.5 to 18.5, -0.5 front nohead lc rgb "#000000" lw 2
set arrow 3 from -0.5, 2.5 to 18.5, 2.5 front nohead lc rgb "#000000" lw 2
set title "STRIDED kernel memory access" font "Computer Modern,14"
plot 'results-validation-array/TinySTM-igpu-persistent-blocks-wbetl/1/array-r99-w1-random-walk/tabled-heatmap-data-STRIDED-random' matrix rowheaders columnheaders w image,\
     '' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("%.3f",$3)) : (sprintf(" ")))):xtic(1) with labels font "Computer Modern ,10.7" palette,\

set arrow 1 from -0.5, 18.5 to 18.5, 18.5 front nohead lc rgb "#000000" lw 2
set arrow 2 from -0.5, 0.5 to 18.5, 0.5 front nohead lc rgb "#000000" lw 2
set arrow 3 from -0.5, 1.5 to 18.5, 1.5 front nohead lc rgb "#000000" lw 2
unset arrow 2
unset arrow 3
unset multiplot
