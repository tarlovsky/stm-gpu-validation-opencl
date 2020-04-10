set terminal wxt size 800,1200
set multiplot layout 4,1 rowsfirst title "Read-set sizes in lengthiest STM benchmarks" font ",16"
set datafile missing '0'
set datafile separator whitespace
unset border
set tics scale 0
set style fill solid 1.00
set grid ytics lc rgb "#606060"
set yrange [0:*]
set style data linespoints
set key autotitle columnhead
set key outside right vertical
set key invert
set key title "Benchmark"
set key font ",9"
set title "swissTM" font ",12" tc rgb "#8f8800"
plot \
      'results-gpu/RSET-SIZE-sorted-top-transposed-swissTM' u 2:xtic(1) t col lt 1, \
      '' u ($0) t col lt 0

set title "TinySTM-wbetl" font ",12" tc rgb "#8f8800"
plot \
      'results-gpu/RSET-SIZE-sorted-top-transposed-TinySTM-wbetl' u 2:xtic(1) t col lt 1, \
      '' u ($0) t col lt 0

set title "norec" font ",12" tc rgb "#8f8800"
plot \
      'results-gpu/RSET-SIZE-sorted-top-transposed-norec' u 2:xtic(1) t col lt 1, \
      '' u ($0) t col lt 0

set title "tl2" font ",12" tc rgb "#8f8800"
plot \
      'results-gpu/RSET-SIZE-sorted-top-transposed-tl2' u 2:xtic(1) t col lt 1, \
      '' u ($0) t col lt 0

unset multiplot
