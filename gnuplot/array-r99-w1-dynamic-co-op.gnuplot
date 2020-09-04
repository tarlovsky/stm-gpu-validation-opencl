
set terminal wxt size 3200,700
set multiplot layout 1,2 rowsfirst title "TinySTM array-r99-w1 dynamic co-op workload distribution. CPU, GPU, intersected validation by both. BLOCK=5376*K K=1" font ",16"
set decimal locale "en_US.UTF-8"; show locale
col_gold="#e8e7ac"
xlabeloffsety=-0.95

set tics scale 0
set xtics nomirror rotate by 45 right scale 0 font "Computer Modern, 14"
set xtics offset 0, xlabeloffsety
set ytics nomirror font "Computer Modern, 14" 
set style fill solid 1
set grid ytics lc rgb "#606060"
set format y "%'g"
set datafile separator whitespace
unset border
set yrange [1:1000000000]
set boxwidth 1
set style data histogram
set style histogram
set key inside top left
set key font "Computer Modern, 15"
set ylabel offset -3,0 "Total reads validated" font "Computer Modern, 18"
set xlabel offset 0,-3 "READ SET ENTRIES" font "Computer Modern, 18"
set title "Random array walk" font "Computer Modern,19"
set logscale y
plot\
      'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-k-1/1/array-r99-w1-random-walk/1-random-cpu-validation'\
   u 14               t col lc rgbcolor col_gold lt 1 fs pattern 3, \
'' u 16               t col lc rgbcolor "#b5d2ff" fs pattern 3, \
'' u 18:xticlabels(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t col lc rgbcolor "#d1d1cd" fs pattern 10, \
      '<tail -n+2 results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-k-1/1/array-r99-w1-random-walk/1-random-cpu-validation' u ($0-0.104):(($14!=0)?($14+$14*0.20):NaN):(sprintf("%'d", $14)) notitle w labels rotate by 90 left textcolor rgb "#d4d281" font "Computer Modern,13.5", \
      ''               u ($0+0.11):(($16!=0)?($16+$16*0.20):NaN):(sprintf("%'d", $16)) notitle w labels rotate by 90 left textcolor rgb "#70a8ff" font "Computer Modern,13.5", \
      ''               u ($0+0.30):(($18!=0)?($18+$18*0.20):NaN):(sprintf("%'d", $18)) notitle w labels rotate by 90 left font "Computer Modern,13.5", \
      '' u ($0+0.0055):(1):(sprintf('%.2fx', ($16>$14)?(($16/$14)):0 )) t "" w labels offset char 0.76, char -0.66 font ",13.5", \
      ''               u ($0-0.10):($14):15 w yerr notitle ls 1 lc rgb '#8f8800' , \
      ''               u ($0+0.10):($16):17 w yerr notitle ls 1 lc rgb '#cacaca' , \
      ''               u ($0+0.31):($18):19 w yerr notitle ls 1 lc rgb '#919191' , \

set title "Sequential array walk" font "Computer Modern,16"
set logscale y
plot\
      'results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-k-1/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation'\
   u 14               t col lc rgbcolor col_gold lt 1 fs pattern 3, \
'' u 16               t col lc rgbcolor "#b5d2ff" fs pattern 3, \
'' u 18:xticlabels(sprintf("%'d (%.2fMB)",$1, ($1*8)/1000000)) t col lc rgbcolor "#d1d1cd" fs pattern 10, \
      '<tail -n+2 results-validation-array/TinySTM-igpu-cpu-persistent-dynamic-split-wbetl-block-level-sync-k-1/1/array-r99-w1-sequential-walk/1-sequential-cpu-validation' u ($0-0.124):(($14!=0)?($14+$14*0.20):NaN):(sprintf("%'d", $14)) notitle w labels rotate by 90 left textcolor rgb "black" font "Computer Modern,10", \
      ''               u ($0+0.09):(($16!=0)?($16+$16*0.20):NaN):(sprintf("%'d", $16)) notitle w labels rotate by 90 left font ",10", \
      ''               u ($0+0.30):(($18!=0)?($18+$18*0.20):NaN):(sprintf("%'d", $18)) notitle w labels rotate by 90 left font ",10", \
      '' u ($0+0.0055):(1):(sprintf('%.2fx', ($16>$14)?(($16/$14)):0 )) t "" w labels offset char 0,char -0.66 font ",9", \
      ''               u ($0-0.10):($14):15 w yerr notitle ls 1 lc rgb '#8f8800' , \
      ''               u ($0+0.10):($16):17 w yerr notitle ls 1 lc rgb '#cacaca' , \
      ''               u ($0+0.31):($18):19 w yerr notitle ls 1 lc rgb '#919191' , \

unset multiplot
