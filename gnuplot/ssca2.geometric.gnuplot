
set terminal wxt size 3400,520
set multiplot layout 1,5 rowsfirst title "ssca2 - geometric average representation of a variety of program arguments" font ",16"
set bmargin 10
xlabeloffsety=-2.75

set tics scale 0
set xtics nomirror rotate by 45 right scale 0 font ",8"
set xtics offset 0, xlabeloffsety
set style fill solid 1.00
set grid ytics lc rgb "#606060"
set format y "%0.3f"
set datafile separator whitespace
unset border
set yrange [0:*]
set boxwidth 0.88
set style data histogram
set style histogram rowstacked gap 1
unset key
leftcolumn_offset_1=0
leftcolumn_offset_1a=5
leftcolumn_offset_2=10
leftcolumn_offset_4=15
leftcolumn_offset_8=20
leftcolumn_offset_16=25
leftcolumn_offset_32=30
set ylabel "Time (s)"
set format y "%2.2f"
set title "validation time/total execution time (s)" font ",12"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-1-ssca2-cluster' u 2:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($16>=$2 ? $16-$2 : NaN) t col lc rgbcolor "#b3d1ff" fs pattern 6, \
      ''               u ($0-1-0.26):(($2!=0)?$2:NaN):(sprintf('%2.6f', $2)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",7", \
      ''               u ($0-1+0.26):(($16!=0)?$16:NaN):(sprintf('%2.6f', $16)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",7", \
      ''               u ($0-1):($2-$2):(sprintf('%2.1f%', ($16!=0)?($2/$16*100):0)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",7", \
      ''               u ($0-1+leftcolumn_offset_1):($2):3 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1):($16):17 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-1a-ssca2-cluster' u 2:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($16>=$2 ? $16-$2 : NaN) t col lc rgbcolor "#b3d1ff" fs pattern 6, \
      ''               u ($0-1-0.26):(($2!=0)?$2:NaN):(sprintf('%2.6f', $2)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",7", \
      ''               u ($0-1+0.26):(($16!=0)?$16:NaN):(sprintf('%2.6f', $16)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",7", \
      ''               u ($0-1):($2-$2):(sprintf('%2.1f%', ($16!=0)?($2/$16*100):0)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",7", \
      ''               u ($0-1+leftcolumn_offset_1a):($2):3 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($16):17 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-2-ssca2-cluster' u 2:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($16>=$2 ? $16-$2 : NaN) t col lc rgbcolor "#b3d1ff" fs pattern 6, \
      ''               u ($0-1-0.26):(($2!=0)?$2:NaN):(sprintf('%2.6f', $2)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",7", \
      ''               u ($0-1+0.26):(($16!=0)?$16:NaN):(sprintf('%2.6f', $16)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",7", \
      ''               u ($0-1):($2-$2):(sprintf('%2.1f%', ($16!=0)?($2/$16*100):0)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",7", \
      ''               u ($0-1+leftcolumn_offset_2):($2):3 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_2):($16):17 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-4-ssca2-cluster' u 2:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($16>=$2 ? $16-$2 : NaN) t col lc rgbcolor "#b3d1ff" fs pattern 6, \
      ''               u ($0-1-0.26):(($2!=0)?$2:NaN):(sprintf('%2.6f', $2)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",7", \
      ''               u ($0-1+0.26):(($16!=0)?$16:NaN):(sprintf('%2.6f', $16)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",7", \
      ''               u ($0-1):($2-$2):(sprintf('%2.1f%', ($16!=0)?($2/$16*100):0)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",7", \
      ''               u ($0-1+leftcolumn_offset_4):($2):3 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_4):($16):17 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-8-ssca2-cluster' u 2:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($16>=$2 ? $16-$2 : NaN) t col lc rgbcolor "#b3d1ff" fs pattern 6, \
      ''               u ($0-1-0.26):(($2!=0)?$2:NaN):(sprintf('%2.6f', $2)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",7", \
      ''               u ($0-1+0.26):(($16!=0)?$16:NaN):(sprintf('%2.6f', $16)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",7", \
      ''               u ($0-1):($2-$2):(sprintf('%2.1f%', ($16!=0)?($2/$16*100):0)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",7", \
      ''               u ($0-1+leftcolumn_offset_8):($2):3 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_8):($16):17 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-16-ssca2-cluster' u 2:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($16>=$2 ? $16-$2 : NaN) t col lc rgbcolor "#b3d1ff" fs pattern 6, \
      ''               u ($0-1-0.26):(($2!=0)?$2:NaN):(sprintf('%2.6f', $2)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",7", \
      ''               u ($0-1+0.26):(($16!=0)?$16:NaN):(sprintf('%2.6f', $16)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",7", \
      ''               u ($0-1):($2-$2):(sprintf('%2.1f%', ($16!=0)?($2/$16*100):0)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",7", \
      ''               u ($0-1+leftcolumn_offset_16):($2):3 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_16):($16):17 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-32-ssca2-cluster' u 2:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($16>=$2 ? $16-$2 : NaN) t col lc rgbcolor "#b3d1ff" fs pattern 6, \
      ''               u ($0-1-0.26):(($2!=0)?$2:NaN):(sprintf('%2.6f', $2)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",7", \
      ''               u ($0-1+0.26):(($16!=0)?$16:NaN):(sprintf('%2.6f', $16)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",7", \
      ''               u ($0-1):($2-$2):(sprintf('%2.1f%', ($16!=0)?($2/$16*100):0)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",7", \
      ''               u ($0-1+leftcolumn_offset_32):($2):3 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_32):($16):17 w yerr ls 1 lc rgb 'black' t ""
set ylabel ""
set format y ""
unset grid
set title "Validation success rate " font ",12" 
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-1-ssca2-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",7", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",7", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",7", \
      ''               u ($0-1+leftcolumn_offset_1):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-1a-ssca2-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#7dafff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",7", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",7", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",7", \
      ''               u ($0-1+leftcolumn_offset_1a):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-2-ssca2-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#94bdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",7", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",7", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",7", \
      ''               u ($0-1+leftcolumn_offset_2):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_2):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-4-ssca2-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",7", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",7", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",7", \
      ''               u ($0-1+leftcolumn_offset_4):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_4):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-8-ssca2-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#adcdff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",7", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",7", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",7", \
      ''               u ($0-1+leftcolumn_offset_8):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_8):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-16-ssca2-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",7", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",7", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",7", \
      ''               u ($0-1+leftcolumn_offset_16):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_16):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-32-ssca2-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):(($12!=0)?$12:NaN):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",7", \
      ''               u ($0-1+0.27):(($12+$10!=0)?$12+$10:NaN):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",7", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', (($10+$12)!=0)?($10/($10+$12)*100):100 )) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",7", \
      ''               u ($0-1+leftcolumn_offset_32):($12):13 w yerr ls 1 lc rgb "#8f8800"  t "", \
      ''               u ($0-1+leftcolumn_offset_32):($12+$10):11 w yerr ls 1 lc rgb 'black' t ""
set xtics offset 0, 0
set ylabel ""
set format y ""
unset grid
set title "Reads validated/s (avg.) " font ",12"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-1-ssca2-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-1a-ssca2-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-2-ssca2-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-4-ssca2-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-8-ssca2-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-16-ssca2-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/geometric-32-ssca2-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"
set xtics offset 0, xlabeloffsety
set ylabel ""
set format y ""
unset grid
set title "Commit/Abort rate" font ",12" 
set yrange [0:475067]
