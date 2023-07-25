function x = normalize(a)
    b=sqrt(sum(a.^2,2));
    x=bsxfun(@rdivide,a,b);
end
