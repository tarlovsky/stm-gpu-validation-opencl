
set terminal wxt size 2560,480
set multiplot layout 1,3 rowsfirst title "yada - Transactions/s (avg.)" font ",16"
set bmargin 10
xlabeloffsety=-2.75
set tics scale 0
set xtics nomirror rotate by 45 right scale 0 font ",8"
set style fill solid 1.00
set grid ytics lc rgb "#606060"
unset border
set yrange [0:*]
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
set xtics offset 0, 0
set ylabel ""
set format y ""
unset grid
set title "yada" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-yada-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-yada-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-yada-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-yada-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-yada-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-yada-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-yada-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

set title "yada+" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-yada+-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-yada+-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-yada+-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-yada+-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-yada+-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-yada+-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-yada+-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

set title "yada++" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1-yada++-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results-cpu/1a-yada++-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/2-yada++-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/4-yada++-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/8-yada++-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/16-yada++-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results-cpu/32-yada++-cluster' using ($8!=0?(($4+$6)/($8)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($8>0?(($4+$6)/($8)):0):( sprintf('%f', ($4+$6)/($8)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"

unset multiplot
