
set terminal wxt size 1920,1080
set multiplot layout 2,3 rowsfirst title "vacation - detailed commit/abort rate" font ",16"
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
set ylabel "Transaction attempts Commit Abort rate"
set format y ""
unset grid
leftcolumn_offset_4=8
leftcolumn_offset_8=16
leftcolumn_offset_16=32

set title "vacation-high" font ",12" tc rgb "#606060"
plot newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/4-vacation-high-cluster' u 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first 0 rotate by 90 right font ",6", \
      ''               u ($0-1):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-vacation-high-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-vacation-high-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-high+" font ",12" tc rgb "#606060"
plot newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/4-vacation-high+-cluster' u 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first 0 rotate by 90 right font ",6", \
      ''               u ($0-1):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-vacation-high+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-vacation-high+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-high++" font ",12" tc rgb "#606060"
plot newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/4-vacation-high++-cluster' u 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first 0 rotate by 90 right font ",6", \
      ''               u ($0-1):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-vacation-high++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-vacation-high++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-low" font ",12" tc rgb "#606060"
plot newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/4-vacation-low-cluster' u 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first 0 rotate by 90 right font ",6", \
      ''               u ($0-1):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-vacation-low-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-vacation-low-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-low+" font ",12" tc rgb "#606060"
plot newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/4-vacation-low+-cluster' u 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first 0 rotate by 90 right font ",6", \
      ''               u ($0-1):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-vacation-low+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-vacation-low+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-low++" font ",12" tc rgb "#606060"
plot newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/4-vacation-low++-cluster' u 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first 0 rotate by 90 right font ",6", \
      ''               u ($0-1):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-vacation-low++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-vacation-low++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 8, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb 'black' t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""
unset multiplot
