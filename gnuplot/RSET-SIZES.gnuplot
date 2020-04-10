set terminal wxt size 1440,1200
set multiplot layout 4,1 rowsfirst title "Average read-set size in STM benchmarks" font ",16"
set title "Average reads validated for all benchmark programs" font ",16"
set datafile missing '0'
set border 0
set tics scale 0
set xtics nomirror rotate by 45 right scale 0 font ",8"
set bmargin 8
set style fill solid 1.00
set grid ytics lc rgb "#606060"
unset border
set yrange [0:*]
set datafile separator whitespace
set boxwidth 0.95
set style data histogram
set style histogram rowstacked
set key outside right vertical
set key invert
set key title "Threads"
set key font ",9"

set title "swissTM" font ",12" tc rgb "#8f8800"
plot newhistogram, \
      'results-gpu/RSET-SIZE-swissTM' u 2:xtic(1) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($3) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($4) t col lc rgbcolor "#808080" lt 1 fs pattern 3, \
      '' u ($5) t col lc rgbcolor "#A9A9A9" lt 1 fs pattern 3, \
      '' u ($6) t col lc rgbcolor "#C0C0C0" lt 1 fs pattern 3, \
      '' u ($7) t col lc rgbcolor "#D3D3D3" lt 1 fs pattern 3, \
      '' u ($0-1):($8):(sprintf('%d', $10)) notitle w labels rotate by 90 left font ",8",\
       t sprintf('%d', ) lc rgb "#c9413e" 

set title "TinySTM-wbetl" font ",12" tc rgb "#8f8800"
plot newhistogram, \
      'results-gpu/RSET-SIZE-TinySTM-wbetl' u 2:xtic(1) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($3) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($4) t col lc rgbcolor "#808080" lt 1 fs pattern 3, \
      '' u ($5) t col lc rgbcolor "#A9A9A9" lt 1 fs pattern 3, \
      '' u ($6) t col lc rgbcolor "#C0C0C0" lt 1 fs pattern 3, \
      '' u ($7) t col lc rgbcolor "#D3D3D3" lt 1 fs pattern 3, \
      '' u ($0-1):($8):(sprintf('%d', $10)) notitle w labels rotate by 90 left font ",8",\
       t sprintf('%d', ) lc rgb "#c9413e" 

set title "norec" font ",12" tc rgb "#8f8800"
plot newhistogram, \
      'results-gpu/RSET-SIZE-norec' u 2:xtic(1) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($3) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($4) t col lc rgbcolor "#808080" lt 1 fs pattern 3, \
      '' u ($5) t col lc rgbcolor "#A9A9A9" lt 1 fs pattern 3, \
      '' u ($6) t col lc rgbcolor "#C0C0C0" lt 1 fs pattern 3, \
      '' u ($7) t col lc rgbcolor "#D3D3D3" lt 1 fs pattern 3, \
      '' u ($0-1):($8):(sprintf('%d', $10)) notitle w labels rotate by 90 left font ",8",\
       t sprintf('%d', ) lc rgb "#c9413e" 

set title "tl2" font ",12" tc rgb "#8f8800"
plot newhistogram, \
      'results-gpu/RSET-SIZE-tl2' u 2:xtic(1) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($3) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($4) t col lc rgbcolor "#808080" lt 1 fs pattern 3, \
      '' u ($5) t col lc rgbcolor "#A9A9A9" lt 1 fs pattern 3, \
      '' u ($6) t col lc rgbcolor "#C0C0C0" lt 1 fs pattern 3, \
      '' u ($7) t col lc rgbcolor "#D3D3D3" lt 1 fs pattern 3, \
      '' u ($0-1):($8):(sprintf('%d', $10)) notitle w labels rotate by 90 left font ",8",\
       t sprintf('%d', ) lc rgb "#c9413e" 

unset multiplot
set title "Average reads validated for all benchmark programs" font ",16"
