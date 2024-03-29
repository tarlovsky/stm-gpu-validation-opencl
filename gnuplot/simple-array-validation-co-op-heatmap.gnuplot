set terminal wxt size 2560,1080
set multiplot layout 1,2 title " " font ",16"
set datafile separator whitespace
set border lc rgb "black"
set xlabel "READ-SET SIZE"
set ylabel "CPU VALIDATION PERCENTAGE"
set zlabel "Validation execution time only (s)"

col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
set xtics nomirror rotate by 45 right scale 0 font ",8"
set title "Simple array random walk cpu-igpu co-op validation" font ",12"
set pm3d
set style data lines
splot 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/array-r99-w1-random-walk/1a/heat-file' u 2:1:3:xtic(1), \
      'results-validation-array/TinySTM-wbetl/array-r99-w1-random-walk/1a/heat-file' u 2:1:3:xtic(2) w l ls 15 

set title "Simple array sequential walk cpu-igpu co-op validation" font ",12"
splot 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/array-r99-w1-sequential-walk/1a/heat-file' u 2:1:3:xtic(1), \
      'results-validation-array/TinySTM-wbetl/array-r99-w1-sequential-walk/1a/heat-file' u 2:1:3:xtic(2) w l ls 15 

unset multiplot
