function ya=labelpre(y)
    labels=unique(y);
    classNum=length(labels);
    for i=1:classNum
        y(find(y==labels(i)))=i;
    end
    ya=zeros(length(y),classNum);
    for i=1:classNum
        ya(find(y==i),i)=1;
    end
end