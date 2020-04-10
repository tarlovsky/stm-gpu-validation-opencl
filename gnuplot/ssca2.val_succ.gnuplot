
set terminal wxt size 2560,480
set multiplot layout 1,3 rowsfirst title "ssca2 - Validation success rate" font ",16"
xlabeloffsety=-2.75
set tics scale 0
set xtics nomirror rotate by 45 right scale 0 font ",8"
set style fill solid 1.00
set grid ytics lc rgb "#606060"
unset border
set yrange [0:*]
set bmargin -10
set datafile separator whitespace
set boxwidth 0.88
set style data histogram
set style histogram rowstacked gap 1
unset key
leftcolumn_offset_1= 0
leftcolumn_offset_1a=3
leftcolumn_offset_2= 6
leftcolumn_offset_4= 9
leftcolumn_offset_8= 12
leftcolumn_offset_16=15
leftcolumn_offset_32=18
set xtics offset 0, xlabeloffsety
set ylabel ""
set format y ""
unset grid
set title "ssca2" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1-ssca2-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1a-ssca2-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#7dafff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1a):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/2-ssca2-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#94bdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_2):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_2):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/4-ssca2-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_4):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_4):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/8-ssca2-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#adcdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_8):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_8):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/16-ssca2-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_16):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_16):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/32-ssca2-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_32):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_32):($12+$10):11 w yerr ls 1 lc rgb 'black' t ""

set title "ssca2+" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1-ssca2+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1a-ssca2+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#7dafff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1a):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/2-ssca2+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#94bdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_2):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_2):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/4-ssca2+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_4):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_4):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/8-ssca2+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#adcdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_8):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_8):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/16-ssca2+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_16):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_16):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/32-ssca2+-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_32):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_32):($12+$10):11 w yerr ls 1 lc rgb 'black' t ""

set title "ssca2++" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1-ssca2++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1a-ssca2++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#7dafff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_1a):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/2-ssca2++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#94bdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_2):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_2):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/4-ssca2++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_4):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_4):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/8-ssca2++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#adcdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_8):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_8):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/16-ssca2++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_16):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_16):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/32-ssca2++-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_32):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_32):($12+$10):11 w yerr ls 1 lc rgb 'black' t ""

unset multiplot
