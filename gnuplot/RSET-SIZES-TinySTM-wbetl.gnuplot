set terminal wxt size 2560,1080
set title "Read set sizes for all benchmark programs" font ",16"
set bmargin 10
set border 3
xlabeloffsety=-2.75
set tics scale 0
set xtics nomirror rotate by 45 right scale 0 font ",8"
set xtics offset 0, xlabeloffsety
set xtics offset 0, 0
set style fill solid 1.00
set grid ytics lc rgb "#606060"
set yrange [0:*]
set ylabel "Average Read-set size during validation"
set datafile separator whitespace
set boxwidth 0.88
set style data histogram
set style histogram rowstacked
unset grid
set key outside right top vertical Left
set key samplen 2.5 spacing 0.85
set key font ",11"

set title "TinySTM-wbetl" font ",12" tc rgb "#8f8800"
plot newhistogram "{Read set avg size}", \
      'results-cpu/RSET-SIZE-TinySTM-wbetl' u 2:xtic(1) notitle lc rgbcolor "#69a2ff" lt 1 fs pattern 6, \
      ''                              u ($3) notitle lc rgbcolor "#9cc2ff" lt 1 fs pattern 6, \
      ''                              u ($4) notitle lc rgbcolor "#adcdff" lt 1 fs pattern 8, \
      ''                              u ($5) notitle lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''                              u ($6) notitle lc rgbcolor "#7dafff" lt 1 fs pattern 3

