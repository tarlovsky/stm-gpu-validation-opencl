(NR>1 && NR%2==0){for(i=2;i<NF-1;i++){x[i]+=($i/$(i+1));n[i]+=1}}
(NR>1 && NR%2!=0){for(i=2;i<NF-1;i++){y[i]+=($i/$(i+1));m[i]+=1}}
END{for(i=2;i<NF-1;i++){printf "$%d %f %f\n", i+1, x[i]/n[i], y[i]/m[i];}}