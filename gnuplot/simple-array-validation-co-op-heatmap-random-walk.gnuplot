
set terminal wxt size 1440,1080
set title "Validation with varied cpu-gpu validation assignment (in %)" font ",16"
set datafile separator whitespace
set border lc rgb "black"
set xlabel "READ-SET SIZE" offset graph 0,0,-0.02
set ylabel "CPU VALIDATION PERCENTAGE" offset graph 0,0,-0.04
set zlabel "Time(s)" offset graph 0,0,0.56

col_24="#c724d6"
col_48="#44cd1"
col_gold="#8f8800"
set cbrange [0:1.6]
set title "TRANSACTIONAL RANDOM ARRAY WALK CPU+IGPU CO-OPERATIVE VALIDATION STATIC ASSIGNMENT IN %" font ",14"
set pm3d noborder
set style fill transparent solid 1
splot 'results-validation-array/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/heat-file' u 2:1:3:xtic(1) t "TINYSTM-WBETL CPU+GPU CO-OP VALIDATION" with pm3d, \
      'results-validation-array/TinySTM-wbetl/1/array-r99-w1-random-walk/heat-file' u 2:1:3:xtic(2) t "TINYSTM-WBETL UNTOUCHED" w surface lc "#22b5d2ff"

set title "TRANSACTIONAL SEQUENTIAL ARRAY WALK CPU+IGPU CO-OPERATIVE VALIDATION STATIC ASSIGNMENT IN %" font ",14"
