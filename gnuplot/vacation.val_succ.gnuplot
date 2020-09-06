
set terminal wxt size 2560,1180
set multiplot layout 2,3 rowsfirst title "vacation - Validation success rate" font ",16"
set bmargin 3
set border 1 lc rgb "#606060" 
xlabeloffsety=-2.75
set tics scale 0
set xtics nomirror rotate by 45 right scale 0 font ",8"
set style fill solid 1.00
set grid ytics lc rgb "#606060"
set yrange [0:*]
set format y "%0.3f"
set datafile separator whitespace
set boxwidth 0.88
set style data histogram
set style histogram rowstacked gap 1
unset key
leftcolumn_offset_1= 0
leftcolumn_offset_1a=5
leftcolumn_offset_2= 10
leftcolumn_offset_4= 15
leftcolumn_offset_8= 20
leftcolumn_offset_16=25
leftcolumn_offset_32=30
set xtics offset 0, xlabeloffsety
set ylabel ""
set format y ""
unset grid
set title "vacation-high" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-vacation-high-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-vacation-high-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#7dafff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1a):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-vacation-high-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#94bdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_2):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_2):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-vacation-high-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_4):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_4):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-vacation-high-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#adcdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_8):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_8):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-vacation-high-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_16):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_16):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-vacation-high-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_32):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_32):($12+$10):11 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-high+" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-vacation-high+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-vacation-high+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#7dafff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1a):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-vacation-high+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#94bdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_2):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_2):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-vacation-high+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_4):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_4):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-vacation-high+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#adcdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_8):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_8):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-vacation-high+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_16):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_16):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-vacation-high+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_32):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_32):($12+$10):11 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-high++" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-vacation-high++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-vacation-high++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#7dafff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1a):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-vacation-high++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#94bdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_2):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_2):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-vacation-high++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_4):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_4):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-vacation-high++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#adcdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_8):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_8):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-vacation-high++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_16):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_16):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-vacation-high++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_32):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_32):($12+$10):11 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-low" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-vacation-low-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-vacation-low-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#7dafff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1a):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-vacation-low-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#94bdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_2):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_2):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-vacation-low-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_4):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_4):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-vacation-low-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#adcdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_8):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_8):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-vacation-low-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_16):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_16):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-vacation-low-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_32):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_32):($12+$10):11 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-low+" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-vacation-low+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-vacation-low+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#7dafff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1a):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-vacation-low+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#94bdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_2):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_2):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-vacation-low+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_4):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_4):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-vacation-low+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#adcdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_8):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_8):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-vacation-low+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_16):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_16):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-vacation-low+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_32):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_32):($12+$10):11 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-low++" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-vacation-low++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-vacation-low++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#7dafff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1a):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-vacation-low++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#94bdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_2):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_2):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-vacation-low++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_4):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_4):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-vacation-low++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#adcdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_8):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_8):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-vacation-low++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_16):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_16):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-vacation-low++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_32):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_32):($12+$10):11 w yerr ls 1 lc rgb 'black' t ""

unset multiplot
