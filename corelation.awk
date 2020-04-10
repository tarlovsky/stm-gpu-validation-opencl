(NR>1 && NR%2==0){for(i=2;i<NF-2;i++){if($i>0){v=(($(i+1)-$i)/$i);x[i]+=v;n[i]+=1;}}}
(NR>1 && NR%2!=0){  for(i=2;i<NF-2;i++){if($i>0){v=(($(i+1)-$i)/$i);y[i]+=v;m[i]+=1;}}}
END{for(i=2;i<NF-2;i++){if(n[i]==0){v1=0;}else{v1=x[i]/n[i]};if(n[i]==0){v2=0;}else{v2=y[i]/n[i]};printf "cor $%d th %f %f\n", i, v1, v2}}