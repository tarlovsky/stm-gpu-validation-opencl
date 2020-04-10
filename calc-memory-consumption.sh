#!/bin/bash
echo '"Read set size" "persistent-kernel-GPU" "CPU"' > "results-gpu/1-MEMORY-CONSUMPTION"

for((i=64;i<=134217728;i*=2));do
  GPU=$(bc -l <<< "((24*16)+324480+($i*860160))/1000000";)
  CPU=$(bc -l <<< "(12+28*$i)/1000000";)
  echo "$i $GPU $CPU" >> "results-gpu/1-MEMORY-CONSUMPTION"
done