
set terminal wxt size 1920,1080
set multiplot layout 1,3 rowsfirst title "intruder - detailed validation success rate" font ",16"
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
set ylabel "Validation success/failure"
set format y ""
unset grid
leftcolumn_offset_4=8
leftcolumn_offset_8=16
leftcolumn_offset_16=32

set title "intruder" font ",12" tc rgb "#606060"
plot newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/2-intruder-cluster' u 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):($12):(sprintf('%d', $12)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($12+$10):(sprintf('%d', $10)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', $10/($10+$12)*100)) notitle w labels offset first 0 rotate by 90 right font ",6", \
      ''               u ($0-1):($12):13 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-intruder-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):($12):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($12+$10):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', $10/($10+$12)*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($12):13 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_4):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-intruder-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):($12):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($12+$10):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', $10/($10+$12)*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($12):13 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_8):($12+$10):11 w yerr ls 1 lc rgb 'black' t ""

set title "intruder+" font ",12" tc rgb "#606060"
plot newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/2-intruder+-cluster' u 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):($12):(sprintf('%d', $12)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($12+$10):(sprintf('%d', $10)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', $10/($10+$12)*100)) notitle w labels offset first 0 rotate by 90 right font ",6", \
      ''               u ($0-1):($12):13 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-intruder+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):($12):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($12+$10):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', $10/($10+$12)*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($12):13 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_4):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-intruder+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):($12):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($12+$10):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', $10/($10+$12)*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($12):13 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_8):($12+$10):11 w yerr ls 1 lc rgb 'black' t ""

set title "intruder++" font ",12" tc rgb "#606060"
plot newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/2-intruder++-cluster' u 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):($12):(sprintf('%d', $12)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($12+$10):(sprintf('%d', $10)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', $10/($10+$12)*100)) notitle w labels offset first 0 rotate by 90 right font ",6", \
      ''               u ($0-1):($12):13 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-intruder++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):($12):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($12+$10):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', $10/($10+$12)*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($12):13 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_4):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-intruder++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):($12):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($12+$10):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', $10/($10+$12)*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($12):13 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_8):($12+$10):11 w yerr ls 1 lc rgb 'black' t ""
unset multiplot
