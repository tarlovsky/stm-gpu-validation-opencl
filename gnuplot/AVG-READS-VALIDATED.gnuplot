set terminal wxt size 1440,1200
set decimal locale "en_US.UTF-8"; show locale
set multiplot layout 4,1 rowsfirst title "Average reads validated in STM benchmarks" font "Computer Modern,16"
set title "Average reads validated for all benchmark programs" font "Computer Modern,16"
set datafile missing '0'
set border 0
set tics scale 0
set bmargin 8
set style fill solid 1.00
set grid ytics lc rgb "#606060"
unset border
set yrange [0:*]
set ytics right font "Computer Modern,11" 
set xtics nomirror rotate by 45 right scale 0 font "Computer Moder,9.5"
set datafile separator whitespace
set boxwidth 0.95
set style data histogram
set style histogram rowstacked
set key outside right vertical
set key invert
set key title "Threads"
set key font "Computer Modern,10.75"

set title "swissTM" font "Computer Modern,12" tc rgb "#8f8800"
plot newhistogram, \
      'results-cpu/RSET-SIZE-swissTM' u 2:xtic(1) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($3) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($4) t col lc rgbcolor "#808080" lt 1 fs pattern 3, \
      '' u ($5) t col lc rgbcolor "#A9A9A9" lt 1 fs pattern 3, \
      '' u ($6) t col lc rgbcolor "#C0C0C0" lt 1 fs pattern 3, \
      '' u ($7) t col lc rgbcolor "#D3D3D3" lt 1 fs pattern 3, \
      '' u ($0-1):($8):(sprintf("%'d", $10)) notitle w labels rotate by 90 left font "Computer Modern,12.5",\
      25517.761194 t sprintf('%d', 1773.894737) lc rgb "#c9413e" 

set title "TinySTM-wbetl" font "Computer Modern,12" tc rgb "#8f8800"
plot newhistogram, \
      'results-cpu/RSET-SIZE-TinySTM-wbetl' u 2:xtic(1) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($3) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($4) t col lc rgbcolor "#808080" lt 1 fs pattern 3, \
      '' u ($5) t col lc rgbcolor "#A9A9A9" lt 1 fs pattern 3, \
      '' u ($6) t col lc rgbcolor "#C0C0C0" lt 1 fs pattern 3, \
      '' u ($7) t col lc rgbcolor "#D3D3D3" lt 1 fs pattern 3, \
      '' u ($0-1):($8):(sprintf("%'d", $10)) notitle w labels rotate by 90 left font "Computer Modern,12.5",\
      278633.567164 t sprintf('%d', 23157.070175) lc rgb "#c9413e" 

set title "norec" font "Computer Modern,12" tc rgb "#8f8800"
plot newhistogram, \
      'results-cpu/RSET-SIZE-norec' u 2:xtic(1) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($3) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($4) t col lc rgbcolor "#808080" lt 1 fs pattern 3, \
      '' u ($5) t col lc rgbcolor "#A9A9A9" lt 1 fs pattern 3, \
      '' u ($6) t col lc rgbcolor "#C0C0C0" lt 1 fs pattern 3, \
      '' u ($7) t col lc rgbcolor "#D3D3D3" lt 1 fs pattern 3, \
      '' u ($0-1):($8):(sprintf("%'d", $10)) notitle w labels rotate by 90 left font "Computer Modern,12.5",\
      1985.776119 t sprintf('%d', 126.675676) lc rgb "#c9413e" 

set title "tl2" font "Computer Modern,12" tc rgb "#8f8800"
plot newhistogram, \
      'results-cpu/RSET-SIZE-tl2' u 2:xtic(1) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($3) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($4) t col lc rgbcolor "#808080" lt 1 fs pattern 3, \
      '' u ($5) t col lc rgbcolor "#A9A9A9" lt 1 fs pattern 3, \
      '' u ($6) t col lc rgbcolor "#C0C0C0" lt 1 fs pattern 3, \
      '' u ($7) t col lc rgbcolor "#D3D3D3" lt 1 fs pattern 3, \
      '' u ($0-1):($8):(sprintf("%'d", $10)) notitle w labels rotate by 90 left font "Computer Modern,12.5",\
      3266.179104 t sprintf('%d', 264.928571) lc rgb "#c9413e" 

unset multiplot
set title "Average reads validated for all benchmark programs" font "Computer Modern,16"
