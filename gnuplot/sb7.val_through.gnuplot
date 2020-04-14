
set terminal wxt size 2560,1180
set multiplot layout 4,3 rowsfirst title "sb7 - Reads validated/s (avg.)" font ",16"
set bmargin 3
set border 1 lc rgb "#606060" 
xlabeloffsety=-2.75
set tics scale 0
set xtics nomirror rotate by 45 right scale 0 font ",8"
set xtics offset 0, 0
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
set xtics offset 0, 0
set ylabel ""
set format y "%2.0t{/Symbol \264}10^{%L}"
set title "sb7-r-f-f" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-sb7-r-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-sb7-r-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-sb7-r-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-sb7-r-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-sb7-r-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-sb7-r-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-sb7-r-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

set title "sb7-rw-f-f" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-sb7-rw-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-sb7-rw-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-sb7-rw-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-sb7-rw-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-sb7-rw-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-sb7-rw-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-sb7-rw-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

set title "sb7-w-f-f" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-sb7-w-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-sb7-w-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-sb7-w-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-sb7-w-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-sb7-w-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-sb7-w-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-sb7-w-f-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

set title "sb7-r-t-f" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-sb7-r-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-sb7-r-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-sb7-r-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-sb7-r-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-sb7-r-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-sb7-r-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-sb7-r-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

set title "sb7-rw-t-f" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-sb7-rw-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-sb7-rw-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-sb7-rw-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-sb7-rw-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-sb7-rw-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-sb7-rw-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-sb7-rw-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

set title "sb7-w-t-f" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-sb7-w-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-sb7-w-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-sb7-w-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-sb7-w-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-sb7-w-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-sb7-w-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-sb7-w-t-f-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

set title "sb7-r-f-t" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-sb7-r-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-sb7-r-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-sb7-r-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-sb7-r-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-sb7-r-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-sb7-r-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-sb7-r-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

set title "sb7-rw-f-t" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-sb7-rw-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-sb7-rw-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-sb7-rw-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-sb7-rw-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-sb7-rw-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-sb7-rw-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-sb7-rw-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

set title "sb7-w-f-t" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-sb7-w-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-sb7-w-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-sb7-w-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-sb7-w-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-sb7-w-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-sb7-w-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-sb7-w-f-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

set title "sb7-r-t-t" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-sb7-r-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-sb7-r-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-sb7-r-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-sb7-r-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-sb7-r-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-sb7-r-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-sb7-r-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

set title "sb7-rw-t-t" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-sb7-rw-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-sb7-rw-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-sb7-rw-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-sb7-rw-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-sb7-rw-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-sb7-rw-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-sb7-rw-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

set title "sb7-w-t-t" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-sb7-w-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-sb7-w-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-sb7-w-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-sb7-w-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-sb7-w-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-sb7-w-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-sb7-w-t-t-cluster' using ($2!=0?($8/($2)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2)):0):( sprintf('%.2g', $8/($2)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

unset multiplot
