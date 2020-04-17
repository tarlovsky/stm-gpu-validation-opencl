RESULTS_DIR="results-validation-array"
for((j=0;j<=100;j++));do
  A="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-wbetl/1/array-r99-w1-random-walk/1-random-cpu-$j-gpu-$((100-$j))"
  B="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-wbetl/1b/array-r99-w1-random-walk/1-random-cpu-$j-gpu-$((100-$j))"
  C="$RESULTS_DIR/TinySTM-igpu-cpu-persistent-wbetl/1c/array-r99-w1-random-walk/1-random-cpu-$j-gpu-$((100-$j))"
  exit;
  #head -n9 $A > $C
  #tail -n6 $B >> $C
  #tail -n5 $A >> $C
done