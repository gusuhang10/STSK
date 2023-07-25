function zt=fromXtoZ_N_Order_1_c(X,v,b,Order)
%xt����ѵ������ÿ����һ������
%b�����������������
%v�����������������
%Order����TSK�Ľ״�
N=size(X,1);

[M,D]=size(v);

for i=1:M
    v1=repmat(v(i,:),N,1);
    bb=repmat (b(i,:),N,1);
    wt(:,i)=exp(-sum((X-v1).^2./bb,2));%u(x)
end

wt2=sum(wt,2);%u(x)����
wt=wt./repmat(wt2,1,M);%u~(x)


% xt1=[X,ones(N,1)];
% xt1=1;

%�������ʽָ�����
OrderList=GetOrderList(size(X,2),Order);

%��ȡ����ʽָ�����
% TempList=load(strcat('List_Dim',num2str(D),'_Order',num2str(Order),'.mat'),'-mat');
% OrderList=TempList.List;
% clear TempList

OrderNum=size(OrderList,1);
xt1=zeros(N,OrderNum);
if N>OrderNum
    for o=1:OrderNum
        xt1(:,o)=prod(bsxfun(@power,X,double(OrderList(o,:))),2);
    end
else
    for n=1:N
        xt1(n,:)=prod(bsxfun(@power,X(n,:),double(OrderList)),2);
    end
end

zt=[];
for i=1:M
    wt1=wt(:,i);%u~(x)��һ�У���ĳ�����򣨾������ģ���������
    wt2=repmat(wt1,1,OrderNum);
    zt=[zt,xt1.*wt2];
end
