
set terminal wxt size 2560,1080
set multiplot layout 2,3 rowsfirst title "vacation - Commit/abort rate " font ",16"
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
set title "vacation-high" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1-vacation-high-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1a-vacation-high-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1a):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/2-vacation-high-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_2):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_2):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/4-vacation-high-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/8-vacation-high-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/16-vacation-high-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_16):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_16):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/32-vacation-high-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_32):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_32):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-high+" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1-vacation-high+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1a-vacation-high+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1a):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/2-vacation-high+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_2):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_2):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/4-vacation-high+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/8-vacation-high+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/16-vacation-high+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_16):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_16):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/32-vacation-high+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_32):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_32):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-high++" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1-vacation-high++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1a-vacation-high++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1a):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/2-vacation-high++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_2):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_2):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/4-vacation-high++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/8-vacation-high++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/16-vacation-high++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_16):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_16):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/32-vacation-high++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_32):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_32):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-low" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1-vacation-low-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1a-vacation-low-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1a):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/2-vacation-low-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_2):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_2):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/4-vacation-low-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/8-vacation-low-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/16-vacation-low-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_16):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_16):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/32-vacation-low-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_32):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_32):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-low+" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1-vacation-low+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1a-vacation-low+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1a):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/2-vacation-low+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_2):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_2):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/4-vacation-low+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/8-vacation-low+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/16-vacation-low+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_16):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_16):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/32-vacation-low+-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_32):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_32):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""

set title "vacation-low++" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1-vacation-low++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_1 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-gpu/1a-vacation-low++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_1a rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_1a):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_1a):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/2-vacation-low++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_2 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_2):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_2):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/4-vacation-low++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_4 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_4):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_4):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/8-vacation-low++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_8 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_8):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_8):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/16-vacation-low++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_16 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_16):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_16):($6+$4):7 w yerr ls 1 lc rgb 'black' t "", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-gpu/32-vacation-low++-cluster' using 4:xtic(1) t col lc rgbcolor "#80b3ff" lt 1 fs pattern 3, \
      ''               u ($6) t col lc rgbcolor "#b3d1ff" lt 1 fs pattern 6, \
      ''               u ($0-1-0.27):($4):(sprintf('%d', $4)) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left textcolor rgb "#8f8800" font ",8", \
      ''               u ($0-1+0.27):($6+$4):(sprintf(  ($6<=149999)?('%d (%d%)'):('%.g (%d%)'), $6, (($6+$4>0)?(($6/($4+$6))*100):(0)))) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8", \
      ''               u ($0-1):($6-$6):(sprintf('%.g tx/s', (($16>0)?(($4+$6)/$16):(0)))) notitle w labels offset first leftcolumn_offset_32 rotate by 90 right font ",6", \
      ''               u ($0-1+leftcolumn_offset_32):($4):5 w yerr ls 1 lc rgb "#8f8800" t "", \
      ''               u ($0-1+leftcolumn_offset_32):($6+$4):7 w yerr ls 1 lc rgb 'black' t ""

unset multiplot
