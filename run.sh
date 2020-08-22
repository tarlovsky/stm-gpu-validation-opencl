
for i in 1 2 4 8 16;do
  bash run-choice-co-op.sh sb7 $i TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded wbetl
done

for i in 1 2 4 8 16;do
  bash run-choice-co-op.sh sb7 $i TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded wbetl-lsa
done