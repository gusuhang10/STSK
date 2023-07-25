function XIncre=feature_increment(Xdata)
    [len1,N]=size(Xdata);
    randnum=randi([1 len1],1,N);
    for i=1:N
        Xdata(len1+1,i)=Xdata(randnum(i),i);
        if Xdata(len1+1,i)==0
            Xdata(len1+1,i)=eps;
        end
    end
    XIncre=Xdata;
end