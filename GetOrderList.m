function [OrderList,OrderNum]=GetOrderList(Dim,Order)

    Orders=cell(1,Order+1);
    
    Temp=zeros(1,Dim);
    
    while isempty(Temp)~=true    
        TempOrder=sum(Temp,2);
        
        if TempOrder<=Order
            Orders{TempOrder+1}=[Orders{TempOrder+1};Temp];
        end
        
        Temp=Increase_Complicate(Temp,Order);
    end

    OrderList=[];
    for o=1:Order+1
        OrderList=[OrderList;Orders{o}];
        OrderNum(o)=size(Orders{o},1);
    end
    
    clear Orders TempOrder Temp
end

function [OrderVector]=Increase(OrderVector,Order)
    if isempty(OrderVector)==true
        return;
    end
    
    Dim=length(OrderVector);
    OrderVector(1)=OrderVector(1)+1;
    
    for d=1:Dim
        if d<Dim
            if OrderVector(d)>Order
                OrderVector(d)=0;
                OrderVector(d+1)=OrderVector(d+1)+1;
            else
                break;
            end
        end
        
        if d==Dim
            if (OrderVector(d)>Order)||(OrderVector(d)==Order&&sum(OrderVector,2)>Order)
                OrderVector=[];
            end
        end
    end
end

function [OrderVector]=Increase_Complicate(OrderVector,Order)
    if isempty(OrderVector)==true
        return;
    end    

    OrderVector(1)=OrderVector(1)+1;
    Dim=length(OrderVector);
    
    for d=1:Dim
        if d<Dim
            if OrderVector(d)>Order
                OrderVector(d)=0;
                OrderVector(d+1)=OrderVector(d+1)+1;
            else
                break;
            end
        end
        
        if d==Dim
            if OrderVector(d)>Order
                OrderVector=[];
                return;
            end
        end
    end
    
    while sum(OrderVector,2)>Order
        NotZero=find(OrderVector~=0);
        LenNotZero=length(NotZero);
        
        Pos=LenNotZero;
        Temp=OrderVector(NotZero(Pos));
        while Temp<=Order
            Pos=Pos-1;
            Temp=Temp+OrderVector(NotZero(Pos));
        end
        
        if Pos==Dim
            OrderVector=[];
            return;
        end
        
        OrderVector(1:NotZero(Pos))=0;
        OrderVector(NotZero(Pos)+1)=OrderVector(NotZero(Pos)+1)+1;
        for d=NotZero(Pos)+1:Dim
            if d<Dim
                if OrderVector(d)>Order
                    OrderVector(d)=0;
                    OrderVector(d+1)=OrderVector(d+1)+1;
                else
                    break;
                end
            end
            if d==Dim
                if OrderVector(d)>Order
                    OrderVector=[];
                    return;
                end
            end            
        end
    end
end