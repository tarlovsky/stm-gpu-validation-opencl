
set terminal wxt size 3200,1080
set multiplot layout 1,5 rowsfirst title "synth - geometric average representation of a variety of program arguments" font ",16"
set bmargin 12
xlabeloffsety=-2.75
set tics scale 0
set xtics nomirror rotate by 45 right scale 0 font ",8"
set xtics offset 0, xlabeloffsety
set datafile missing '0'
set style fill solid 1.00
set grid ytics lc rgb "#606060"
set format y "%0.3f"
unset border
set style data histogram
set style histogram rowstacked gap 1
unset key
leftcolumn_offset_2=0
leftcolumn_offset_4=5
leftcolumn_offset_8=10
leftcolumn_offset_16=15
leftcolumn_offset_32=20
set ylabel "Time (s)"
set format y "%2.3f"
set yrange [0:*]
set title "validation time/total execution time (s)" font ",12"
plot\
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-2-synth-cluster' u 2:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($16>=$2 ? $16-$2 : NaN) t col lc rgbcolor "#b3d1ff" fs pattern 6, \
      ''               u ($0-1-0.27):($2):(sprintf('%2.6f', $2)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($16):(sprintf('%2.6f', $16)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($2-$2):(sprintf('%2.1f%', $2/$16*100)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_2):($2):3 w yerr ls 1 lc rgb "#bab100" t "", \
      ''               u ($0-1+leftcolumn_offset_2):($16):17 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-4-synth-cluster' u 2:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($16>=$2 ? $16-$2 : NaN) t col lc rgbcolor "#b3d1ff" fs pattern 6, \
      ''               u ($0-1-0.27):($2):(sprintf('%2.6f', $2)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($16):(sprintf('%2.6f', $16)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($2-$2):(sprintf('%2.1f%', $2/$16*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_4):($2):3 w yerr ls 1 lc rgb "#bab100" t "", \
      ''               u ($0-1+leftcolumn_offset_4):($16):17 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-8-synth-cluster' u 2:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($16>=$2 ? $16-$2 : NaN) t col lc rgbcolor "#b3d1ff" fs pattern 6, \
      ''               u ($0-1-0.27):($2):(sprintf('%2.6f', $2)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($16):(sprintf('%2.6f', $16)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($2-$2):(sprintf('%2.1f%', $2/$16*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_8):($2):3 w yerr ls 1 lc rgb "#bab100" t "", \
      ''               u ($0-1+leftcolumn_offset_8):($16):17 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-16-synth-cluster' u 2:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($16>=$2 ? $16-$2 : NaN) t col lc rgbcolor "#b3d1ff" fs pattern 6, \
      ''               u ($0-1-0.27):($2):(sprintf('%2.6f', $2)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($16):(sprintf('%2.6f', $16)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($2-$2):(sprintf('%2.1f%', $2/$16*100)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_16):($2):3 w yerr ls 1 lc rgb "#bab100" t "", \
      ''               u ($0-1+leftcolumn_offset_16):($16):17 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-32-synth-cluster' u 2:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($16>=$2 ? $16-$2 : NaN) t col lc rgbcolor "#b3d1ff" fs pattern 6, \
      ''               u ($0-1-0.27):($2):(sprintf('%2.6f', $2)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($16):(sprintf('%2.6f', $16)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($2-$2):(sprintf('%2.1f%', $2/$16*100)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",8", \
      ''               u ($0-1+leftcolumn_offset_32):($2):3 w yerr ls 1 lc rgb "#bab100" t "", \
      ''               u ($0-1+leftcolumn_offset_32):($16):17 w yerr ls 1 lc rgb 'black' t ""
set ylabel ""
set format y ""
unset grid
set title "Validation success rate " font ",12" 
plot\
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-2-synth-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):($12):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($12+$10):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', $10/($10+$12)*100)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_2):($12):13 w yerr ls 1 lc rgb "#bab100"  t "", \
      ''               u ($0-1+leftcolumn_offset_2):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-4-synth-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):($12):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($12+$10):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', $10/($10+$12)*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($12):13 w yerr ls 1 lc rgb "#bab100"  t "", \
      ''               u ($0-1+leftcolumn_offset_4):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-8-synth-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):($12):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($12+$10):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', $10/($10+$12)*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($12):13 w yerr ls 1 lc rgb "#bab100"  t "", \
      ''               u ($0-1+leftcolumn_offset_8):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-16-synth-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):($12):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($12+$10):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', $10/($10+$12)*100)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_16):($12):13 w yerr ls 1 lc rgb "#bab100"  t "", \
      ''               u ($0-1+leftcolumn_offset_16):($12+$10):11 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-32-synth-cluster' using 12:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($10) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 3, \
      ''               u ($0-1-0.27):($12):(sprintf('%d', $12)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($12+$10):(sprintf('%d', $10)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($10-$10):(sprintf('%2.2f%', $10/($10+$12)*100)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_32):($12):13 w yerr ls 1 lc rgb "#bab100"  t "", \
      ''               u ($0-1+leftcolumn_offset_32):($12+$10):11 w yerr ls 1 lc rgb 'black' t ""
set xtics offset 0, 0
set ylabel ""
set format y ""
unset grid
set title "Reads validated/ms (avg.) " font ",12"
plot\
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-2-synth-cluster' using ( $8/($2/0.001) ):xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8/($2/0.001)):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-4-synth-cluster' using ( $8/($2/0.001) ):xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8/($2/0.001)):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-8-synth-cluster' using ( $8/($2/0.001) ):xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8/($2/0.001)):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-16-synth-cluster' using ( $8/($2/0.001) ):xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8/($2/0.001)):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-32-synth-cluster' using ( $8/($2/0.001) ):xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8/($2/0.001)):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"
set xtics offset 0, xlabeloffsety
set ylabel ""
set format y ""
unset grid
set title "Commit/Abort rate" font ",12" 
plot\
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-2-synth-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_2):($4):5 w yerr ls 1 lc rgb "#bab100" t "", \
      ''               u ($0-1+leftcolumn_offset_2):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-4-synth-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb "#bab100" t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-8-synth-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb "#bab100" t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-16-synth-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_16):($4):5 w yerr ls 1 lc rgb "#bab100" t "", \
      ''               u ($0-1+leftcolumn_offset_16):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-32-synth-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_32):($4):5 w yerr ls 1 lc rgb "#bab100" t "", \
      ''               u ($0-1+leftcolumn_offset_32):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""
set xtics offset 0, xlabeloffsety
unset grid
set ylabel "Energy (J)"
set format y "%2.3f"
set grid ytics lc rgb "#606060"
unset datafile
set title "synth, Energy consumption using Intel RAPL (J)" font ",12" 
plot\
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-2-synth-cluster' using 14:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1+0.27):($14):(sprintf('%2.6f', $14)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1+leftcolumn_offset_2):($14):15 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-4-synth-cluster' using 14:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1+0.27):($14):(sprintf('%2.6f', $14)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1+leftcolumn_offset_4):($14):15 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-8-synth-cluster' using 14:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1+0.27):($14):(sprintf('%2.6f', $14)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1+leftcolumn_offset_8):($14):15 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-16-synth-cluster' using 14:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1+0.27):($14):(sprintf('%2.6f', $14)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1+leftcolumn_offset_16):($14):15 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results/geometric-32-synth-cluster' using 14:xtic(1) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1+0.27):($14):(sprintf('%2.6f', $14)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1+leftcolumn_offset_32):($14):15 w yerr ls 1 lc rgb 'black' t ""

unset multiplot
