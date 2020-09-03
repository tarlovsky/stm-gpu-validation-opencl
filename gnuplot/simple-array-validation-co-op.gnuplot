set terminal wxt size 1350,1080
set multiplot layout 1,2 title "Transactional random array traversal application; single-threaded; Intel 6700k CPU + Intel HD530 iGPU co-operative validation vs TinySTM-WBETL untouched" font "Computer Modern,16"
set datafile missing " "
unset border
set view map
set grid front lc rgb "#1c1c1c"
set datafile separator " "
set palette rgb -21,-22,-23
set ytics nomirror
set xlabel "read-set size" font "Computer Modern, 13"
set xtics rotate by 45 right scale 0 font "Computer Moder, 12" offset 0,0,-0.04
set colorbox size 2,5
unset key
set cbrange [10000000:1000000000]
set palette rgb -21,-22,-23
set title "Reads validated/s" font "Computer Modern ,14"
plot 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/table-heat-file' matrix rowheaders columnheaders w image,\
     'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/table-heat-file' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("%.2f",$3/100000000)) : (sprintf(" ")))) with labels font "Computer Modern, 9.5"

set cbrange [1:2.2]
set palette rgb -21,-22,-23
set title "Reads validated/s normalized to TinySTM-untouched" font "Computer Modern ,14"
plot 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/table-heat-file-speedup' matrix rowheaders columnheaders w image,\
     'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/table-heat-file-speedup' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("%.2f",$3)) : (sprintf(" ")))) with labels font "Computer Modern, 9.5"

unset multiplot
