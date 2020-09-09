

#for i in 2 4 8 16;do
  #bash run-choice-co-op.sh sb7_20 $i TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded wbetl
#done

#for i in 1 2 4 8 16;do
  #bash run-choice-co-op.sh sb7_20 $i TinySTM-igpu-cpu-persistent-dynamic-split-multithreaded wbetl-lsa
#done


for i in 2 4 8 16;do
  bash run-choice.sh sb7_20 $i TinySTM wbetl
done