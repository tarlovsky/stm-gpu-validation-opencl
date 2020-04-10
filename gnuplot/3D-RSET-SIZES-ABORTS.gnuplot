set terminal wxt size 2440,1200
set multiplot layout 2,2 title "Avg reads validated, aborts (programs with reads validated > avg)" font ",16"
set xtics center offset -2,-0.6,-14
set ytics center offset -3,-0.65,0
set ztics center offset 1,1,0
set datafile missing '0'
set xlabel "threads" offset 6, -2,3
set ylabel "Aborts" offset -9,-2,-6
set zlabel "Rset size" offset 5,50,0
set grid back
set border ls 2 lc rgb "black"
set view 45, 45, 1, 1.1
set key outside top right
set title "swissTM" font ",16" tc rgb "#8f8800"
splot \
 'results-gpu/3D-RSET-SIZE-ABORTS-TOP-TRANSPOSED-swissTM' using (int($0)):-2:-1:xtic(1) t col with linespoints

set title "TinySTM-wbetl" font ",16" tc rgb "#8f8800"
splot \
 'results-gpu/3D-RSET-SIZE-ABORTS-TOP-TRANSPOSED-TinySTM-wbetl' using (int($0)):-2:-1:xtic(1) t col with linespoints

set title "norec" font ",16" tc rgb "#8f8800"
splot \
 'results-gpu/3D-RSET-SIZE-ABORTS-TOP-TRANSPOSED-norec' using (int($0)):-2:-1:xtic(1) t col with linespoints

set title "tl2" font ",16" tc rgb "#8f8800"
splot \
 'results-gpu/3D-RSET-SIZE-ABORTS-TOP-TRANSPOSED-tl2' using (int($0)):-2:-1:xtic(1) t col with linespoints

unset multiplot
