set terminal wxt size 3300,1100
set multiplot layout 4,2 title "Transactional array traversal application - Intel 6700k CPU + Intel HD530 iGPU co-operative validation with dynamic workload assignment vs. TinySTM-WBETL unmodified" font "Computer Modern,16"
set decimal locale "en_US.UTF-8"; show locale
set view map
set grid front lc rgb "#999966"
set datafile separator " "
set palette rgb -21,-22,-23
set key autotitle columnhead
set ytics nomirror
set xlabel "READ-SET SIZE"
set ylabel "PROGRAM"
unset colorbox
set xtics rotate by 45 right scale 0 font "Computer Modern,8" offset 0,0,-0.04
set cbrange [0.78:3.8]
set palette rgb -21,-22,-23
set title "1 STM threads (random array walk) - time in seconds" font ",16"
plot 'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-BEST/1/array-r99-w1-random-walk/tabled-data-speedup' matrix rowheaders columnheaders w image,\
     'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-BEST/1/array-r99-w1-random-walk/tabled-data-speedup' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("x%.2f",$3)) : (sprintf("-")))) with labels font ",11.5",\
     'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-BEST/1/array-r99-w1-random-walk/tabled-data' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("%f",$3)) : (sprintf(" ")))):xtic(1) with labels,\

set title "1 STM threads (sequential array walk) - time in seconds" font ",16"
plot 'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-BEST/1/array-r99-w1-sequential-walk/tabled-data-speedup' matrix rowheaders columnheaders w image,\
     'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-BEST/1/array-r99-w1-sequential-walk/tabled-data-speedup' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("x%.2f",$3)) : (sprintf("-")))) with labels font ",11.5",\
     'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-BEST/1/array-r99-w1-sequential-walk/tabled-data' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("%f",$3)) : (sprintf(" ")))):xtic(1) with labels,\

unset multiplot
