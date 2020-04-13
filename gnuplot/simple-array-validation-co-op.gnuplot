set terminal wxt size 3300,1080
set multiplot layout 1,2 title "Validating random array traversal single-threaded,  Intel 6700k CPU (73%) + Intel HD530 iGPU (27%) CO-OP vs (TinySTM-WBETL)" font ",16"
set datafile missing " "
set border linewidth 2
set view map
set grid front lc rgb "#1c1c1c"
set datafile separator " "
set cbrange [0:5]
set palette rgb -21,-22,-23
set key autotitle columnhead
plot 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/table-heat-file' matrix rowheaders columnheaders w image,\
     'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/table-heat-file' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("%f",$3)) : (sprintf(" ")))) with labels

set cbrange [1:1.35]
set palette rgb -21,-22,-23
plot 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/table-heat-file-speedup' matrix rowheaders columnheaders w image,\
     'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1a/array-r99-w1-random-walk/table-heat-file-speedup' matrix rowheaders columnheaders using 1:2:((($3 > 0) ? (sprintf("x%.2f",$3)) : (sprintf(" ")))) with labels

unset multiplot
