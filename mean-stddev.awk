NR > 1 {
    n=NR-1
    for(i=1;i<=NF;i++){
        sum[i]+=$i;
        array[n,i]=$i
    }
}
END {
    if(NR>1){
        NR=NR-1
        for(i=1;i<=NF;i++){
            avg[i]=sum[i]/NR;
        }

        for(i=1;i<=NR;i++){
            for(j=1;j<=NF;j++){
                sumsq[j]+=((array[i,j]-(sum[j]/NR))**2);
            }
        }

        for(i=1;i<=NF;i++){
            p_avg=avg[i]
            p_sqrt=sqrt(sumsq[i]/NR)

            f_avg="%f "
            f_sqrt="%f "

            if(p_avg==0){
                f_avg="%d "
            }
            if(p_sqrt==0){
                f_sqrt="%d "
            }
            #printf "%f %f ", p_avg, p_sqrt;
            printf f_avg f_sqrt, p_avg, p_sqrt;
        }
    }
}
