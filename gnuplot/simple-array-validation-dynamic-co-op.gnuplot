set terminal wxt size 1400,1250
set multiplot layout 4,2 title "Transactional array traversal application - Intel 6700k CPU + Intel HD530 iGPU co-operative validation with dynamic workload assignment vs. TinySTM-WBETL unmodified" font "Computer Modern,16"
set decimal locale "en_US.UTF-8"; show locale
set view map
set tmargin 5
set lmargin 15
set grid front lc rgb "#999966"
set datafile separator " "
set palette rgb -21,-22,-23
set key autotitle columnhead
set ytics font "Computer Modern, 11"
set xlabel "Read-set size" offset 0, -1.6 font"Computer Modern, 13"
unset colorbox
set xtics nomirror rotate by 40 right font "Computer Modern, 16"
set format x "%'d"
set cbrange [0.78:3.8]
set palette rgb -21,-22,-23
set title offset 0, -1 "1 STM threads" font ",17"
plot '../results-validation-array/best-of-best-array-speedup-1-threads' matrix rowheaders columnheaders w image , \
     '../results-validation-array/best-of-best-array-speedup-1-threads' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("x%.2f",$3)) : (sprintf("-")))) with labels font "Computer Modern, 16.5",\

set title offset 0, -1 "2 STM threads" font ",17"
plot '../results-validation-array/best-of-best-array-speedup-2-threads' matrix rowheaders columnheaders w image , \
     '../results-validation-array/best-of-best-array-speedup-2-threads' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("x%.2f",$3)) : (sprintf("-")))) with labels font "Computer Modern, 16.5",\

set title offset 0, -1 "4 STM threads" font ",17"
plot '../results-validation-array/best-of-best-array-speedup-4-threads' matrix rowheaders columnheaders w image , \
     '../results-validation-array/best-of-best-array-speedup-4-threads' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("x%.2f",$3)) : (sprintf("-")))) with labels font "Computer Modern, 16.5",\

set title offset 0, -1 "8 STM threads" font ",17"
plot '../results-validation-array/best-of-best-array-speedup-8-threads' matrix rowheaders columnheaders w image , \
     '../results-validation-array/best-of-best-array-speedup-8-threads' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("x%.2f",$3)) : (sprintf("-")))) with labels font "Computer Modern, 16.5",\

unset multiplot
