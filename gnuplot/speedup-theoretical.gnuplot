set terminal wxt size 1440,1200
set multiplot layout 4,1 rowsfirst title " Theoretical speedup (validation time) accross all thread counts" font ",16"
set datafile missing '0'
set lmargin 10
set tics scale 0
set xtics nomirror rotate by 45 right scale 0 font ",8"
set bmargin 8
set style fill solid 1.00
unset border
set format y ""
set ylabel ""
set datafile separator whitespace
set boxwidth 0.96
set style data histogram
set style histogram rowstacked
unset grid
set key outside right vertical
set key invert
set key title "Threads"
set key font ",7"

set title "swissTM" font ",12" tc rgb "#8f8800" offset 0,0
plot newhistogram, \
      'results-cpu/speedup-theoretical-swissTM' u 2:xtic(1) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($3) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($4) t col lc rgbcolor "#808080" lt 1 fs pattern 3, \
      '' u ($5) t col lc rgbcolor "#A9A9A9" lt 1 fs pattern 3, \
      '' u ($6) t col lc rgbcolor "#C0C0C0" lt 1 fs pattern 3, \
      '' u ($7) t col lc rgbcolor "#D3D3D3" lt 1 fs pattern 3, \
      '' u ($0-1):($8):(sprintf('%.2fx', $9 )) notitle w labels rotate by 90 left font ",8", \
      6.296621 t sprintf('%.2fx', 1.278405) lc rgb "#c9413e" 

set title "TinySTM-wbetl" font ",12" tc rgb "#8f8800" offset 0,0
plot newhistogram, \
      'results-cpu/speedup-theoretical-TinySTM-wbetl' u 2:xtic(1) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($3) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($4) t col lc rgbcolor "#808080" lt 1 fs pattern 3, \
      '' u ($5) t col lc rgbcolor "#A9A9A9" lt 1 fs pattern 3, \
      '' u ($6) t col lc rgbcolor "#C0C0C0" lt 1 fs pattern 3, \
      '' u ($7) t col lc rgbcolor "#D3D3D3" lt 1 fs pattern 3, \
      '' u ($0-1):($8):(sprintf('%.2fx', $9 )) notitle w labels rotate by 90 left font ",8", \
      5.694947 t sprintf('%.2fx', 1.156247) lc rgb "#c9413e" 

set title "norec" font ",12" tc rgb "#8f8800" offset 0,0
plot newhistogram, \
      'results-cpu/speedup-theoretical-norec' u 2:xtic(1) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($3) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($4) t col lc rgbcolor "#808080" lt 1 fs pattern 3, \
      '' u ($5) t col lc rgbcolor "#A9A9A9" lt 1 fs pattern 3, \
      '' u ($6) t col lc rgbcolor "#C0C0C0" lt 1 fs pattern 3, \
      '' u ($7) t col lc rgbcolor "#D3D3D3" lt 1 fs pattern 3, \
      '' u ($0-1):($8):(sprintf('%.2fx', $9 )) notitle w labels rotate by 90 left font ",8", \
      5.861778 t sprintf('%.2fx', 1.671230) lc rgb "#c9413e" 

set title "tl2" font ",12" tc rgb "#8f8800" offset 0,0
plot newhistogram, \
      'results-cpu/speedup-theoretical-tl2' u 2:xtic(1) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($3) t col lc rgbcolor "#696969" lt 1 fs pattern 3, \
      '' u ($4) t col lc rgbcolor "#808080" lt 1 fs pattern 3, \
      '' u ($5) t col lc rgbcolor "#A9A9A9" lt 1 fs pattern 3, \
      '' u ($6) t col lc rgbcolor "#C0C0C0" lt 1 fs pattern 3, \
      '' u ($7) t col lc rgbcolor "#D3D3D3" lt 1 fs pattern 3, \
      '' u ($0-1):($8):(sprintf('%.2fx', $9 )) notitle w labels rotate by 90 left font ",8", \
      5.231303 t sprintf('%.2fx', 1.242898) lc rgb "#c9413e" 

unset multiplot
