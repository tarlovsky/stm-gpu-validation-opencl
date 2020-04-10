
set terminal wxt size 1920,1080
set multiplot layout 1,3 rowsfirst title "intruder - detailed energy comsumption RAPL (J) " font ",16"
set bmargin 12
xlabeloffsety=-2
set tics scale 0
set xtics nomirror rotate by 45 right scale 0 font ",8"
set xtics offset 0, xlabeloffsety
# Thinner, filled bars
set style fill solid 1.00
set grid ytics lc rgb "#606060"
unset border
set yrange [0:*]
set style data histogram
set style histogram rowstacked gap 1
set boxwidth 0.9
unset key
set xtics offset 0, 0
leftcolumn_offset_4=9
leftcolumn_offset_8=18
leftcolumn_offset_16=36
set ylabel "Energy (J)"
set format y "%2.3f"
set grid ytics lc rgb "#606060"

set title "intruder" font ",12" tc rgb "#606060"
plot newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/2-intruder-cluster' u 14:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1+0.27):($14):(sprintf('%2.6f', $14)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1):($14):15 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-intruder-cluster' u 14:xtic(1) notitle lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1+0.27):($14):(sprintf('%2.6f', $14)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+leftcolumn_offset_4):($14):15 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-intruder-cluster' using 14:xtic(1) notitle lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1+0.27):($14):(sprintf('%2.6f', $14)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+leftcolumn_offset_8):($14):15 w yerr ls 1 lc rgb 'black' t ""

set title "intruder+" font ",12" tc rgb "#606060"
plot newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/2-intruder+-cluster' u 14:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1+0.27):($14):(sprintf('%2.6f', $14)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1):($14):15 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-intruder+-cluster' u 14:xtic(1) notitle lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1+0.27):($14):(sprintf('%2.6f', $14)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+leftcolumn_offset_4):($14):15 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-intruder+-cluster' using 14:xtic(1) notitle lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1+0.27):($14):(sprintf('%2.6f', $14)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+leftcolumn_offset_8):($14):15 w yerr ls 1 lc rgb 'black' t ""

set title "intruder++" font ",12" tc rgb "#606060"
plot newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/2-intruder++-cluster' u 14:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1+0.27):($14):(sprintf('%2.6f', $14)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1):($14):15 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-intruder++-cluster' u 14:xtic(1) notitle lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1+0.27):($14):(sprintf('%2.6f', $14)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+leftcolumn_offset_4):($14):15 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-intruder++-cluster' using 14:xtic(1) notitle lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1+0.27):($14):(sprintf('%2.6f', $14)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+leftcolumn_offset_8):($14):15 w yerr ls 1 lc rgb 'black' t ""
unset multiplot
