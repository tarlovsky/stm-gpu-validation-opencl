
set terminal wxt size 2560,1080
set multiplot layout 2,3 rowsfirst title "linkedlist - Commit/abort rate " font ",16"
set bmargin 10
xlabeloffsety=-2.75
set tics scale 0
set xtics nomirror rotate by 45 right scale 0 font ",8"
set xtics offset 0, xlabeloffsety
set datafile missing '0'
set style fill solid 1.00
set grid ytics lc rgb "#606060"
unset border
set yrange [0:*]
set format y "%0.3f"
set datafile separator whitespace
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
set xtics offset 0, xlabeloffsety
set ylabel ""
set format y ""
unset grid
set title "linkedlist-l-w" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results/1-linkedlist-l-w-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results/1a-linkedlist-l-w-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1a):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/2-linkedlist-l-w-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_2):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_2):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-linkedlist-l-w-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-linkedlist-l-w-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results/16-linkedlist-l-w-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_16):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_16):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results/32-linkedlist-l-w-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_32):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_32):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""
set title "linkedlist-l-r" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results/1-linkedlist-l-r-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results/1a-linkedlist-l-r-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1a):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/2-linkedlist-l-r-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_2):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_2):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-linkedlist-l-r-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-linkedlist-l-r-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results/16-linkedlist-l-r-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_16):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_16):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results/32-linkedlist-l-r-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_32):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_32):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""
set title "linkedlist-s-w" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results/1-linkedlist-s-w-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results/1a-linkedlist-s-w-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1a):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/2-linkedlist-s-w-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_2):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_2):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-linkedlist-s-w-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-linkedlist-s-w-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results/16-linkedlist-s-w-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_16):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_16):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results/32-linkedlist-s-w-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_32):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_32):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""
set title "linkedlist-s-r" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results/1-linkedlist-s-r-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results/1a-linkedlist-s-r-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1a):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/2-linkedlist-s-r-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_2):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_2):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-linkedlist-s-r-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-linkedlist-s-r-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results/16-linkedlist-s-r-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_16):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_16):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results/32-linkedlist-s-r-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf('%d', $6)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%2.1f%', $6/$4*100)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_32):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_32):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""
unset multiplot
