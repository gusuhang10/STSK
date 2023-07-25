function Dis=medianDis(X)
    N=size(X,1);
    dist=EuDist2(X,X); 
    dist=reshape(dist,1,N*N);
    Dis=median(dist);
end