
set terminal wxt size 2560,480
set multiplot layout 1,3 rowsfirst title "labyrinth - Average reads validated / ms" font ",16"
set bmargin 10
xlabeloffsety=-2.75
set tics scale 0
set xtics nomirror rotate by 45 right scale 0 font ",8"
set xtics offset 0, 0
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
set xtics offset 0, 0
set ylabel ""
set format y ""
unset grid
set title "labyrinth" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results/1-labyrinth-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results/1a-labyrinth-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/2-labyrinth-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-labyrinth-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-labyrinth-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results/16-labyrinth-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results/32-labyrinth-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"
set title "labyrinth+" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results/1-labyrinth+-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results/1a-labyrinth+-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/2-labyrinth+-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-labyrinth+-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-labyrinth+-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results/16-labyrinth+-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results/32-labyrinth+-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"
set title "labyrinth++" font ",12" tc rgb "#8f8800"
plot\
    newhistogram "{1 threads}" offset char 0,xlabeloffsety, \
      'results/1-labyrinth++-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#69a2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_1 rotate by 90 left font ",8", \
    newhistogram "{1a threads}" offset char 0,xlabeloffsety, \
      'results/1a-labyrinth++-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#7dafff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_1a rotate by 90 left font ",8", \
    newhistogram "{2 threads}" offset char 0,xlabeloffsety, \
      'results/2-labyrinth++-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#94bdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_2 rotate by 90 left font ",8", \
    newhistogram "{4 threads}" offset char 0,xlabeloffsety, \
      'results/4-labyrinth++-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#9cc2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_4 rotate by 90 left font ",8", \
    newhistogram "{8 threads}" offset char 0,xlabeloffsety, \
      'results/8-labyrinth++-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#adcdff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_8 rotate by 90 left font ",8", \
    newhistogram "{16 threads}" offset char 0,xlabeloffsety, \
      'results/16-labyrinth++-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#b5d2ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_16 rotate by 90 left font ",8", \
    newhistogram "{32 threads}" offset char 0,xlabeloffsety, \
      'results/32-labyrinth++-cluster' using ($2!=0?($8/($2/0.001)):0):xtic(1) t col lc rgbcolor "#bdd7ff" lt 1 fs pattern 10, \
      ''               u ($0-1):($2>0?($8/($2/0.001)):0):( sprintf('%d', $8/($2/0.001)) ) notitle w labels offset first leftcolumn_offset_32 rotate by 90 left font ",8"
unset multiplot
