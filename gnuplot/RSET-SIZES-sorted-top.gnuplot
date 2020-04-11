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
      'results-cpu/RSET-SIZE-sorted-top-transposed-swissTM' u 2:xtic(1) t col lt 1, \
      '' u ($3) t col lt 3, \
      '' u ($4) t col lt 4, \
      '' u ($5) t col lt 5, \
      '' u ($6) t col lt 6, \
      '' u ($7) t col lt 7, \
      '' u ($8) t col lt 8, \
      '' u ($9) t col lt 9, \
      '' u ($10) t col lt 10, \
      '' u ($11) t col lt 11, \
      '' u ($12) t col lt 12, \
      '' u ($13) t col lt 13

set title "TinySTM-wbetl" font ",12" tc rgb "#8f8800"
plot \
      'results-cpu/RSET-SIZE-sorted-top-transposed-TinySTM-wbetl' u 2:xtic(1) t col lt 1, \
      '' u ($3) t col lt 3, \
      '' u ($4) t col lt 4, \
      '' u ($5) t col lt 5, \
      '' u ($6) t col lt 6, \
      '' u ($7) t col lt 7

set title "norec" font ",12" tc rgb "#8f8800"
plot \
      'results-cpu/RSET-SIZE-sorted-top-transposed-norec' u 2:xtic(1) t col lt 1, \
      '' u ($3) t col lt 3, \
      '' u ($4) t col lt 4, \
      '' u ($5) t col lt 5, \
      '' u ($6) t col lt 6

set title "tl2" font ",12" tc rgb "#8f8800"
plot \
      'results-cpu/RSET-SIZE-sorted-top-transposed-tl2' u 2:xtic(1) t col lt 1, \
      '' u ($3) t col lt 3, \
      '' u ($4) t col lt 4, \
      '' u ($5) t col lt 5

unset multiplot
