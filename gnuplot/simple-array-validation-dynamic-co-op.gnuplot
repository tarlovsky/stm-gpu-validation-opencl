set terminal wxt size 2900,1100
set multiplot layout 4,2 title "Transactional array traversal application - Intel 6700k CPU + Intel HD530 iGPU co-operative validation with dynamic workload assignment vs. TinySTM-WBETL unmodified" font "Computer Modern,16"
set decimal locale "en_US.UTF-8"; show locale
set view map
set grid front lc rgb "#999966"
set datafile separator " "
set palette rgb -21,-22,-23
set key autotitle columnhead
set xlabel "Read-set size" font"Computer Modern, 14"
set ylabel "Program" font"Computer Modern, 12"
unset colorbox
set xtics font "Computer Modern, 13"
set format x "%'d"
set cbrange [0.78:3.8]
set palette rgb -21,-22,-23
set title "1 STM threads (random array walk) - speedup" font ",16"
plot '../results-validation-array/best-of-best-array-speedup' matrix rowheaders columnheaders w image, \
     '../results-validation-array/best-of-best-array-speedup' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("x%.2f",$3)) : (sprintf("-")))) with labels font "Computer Modern,15.5",\

unset multiplot
