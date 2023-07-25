function [TestAcc,TrainAcc,XXtr,XXte,training_time]=N_TSK_Classification(TrainData,TestData,RuleNum,HI,Order,tau)
%HI+1
%RuleNum:number of fuzzy rules
    training_time_ini=cputime;
    Xtr=TrainData(:,1:end-1);
    Ytr=TrainData(:,end);
    Xte=TestData(:,1:end-1);
    Yte=TestData(:,end);
    [~,d]=size(Xtr);
    
    LabelList=unique(TrainData(:,end));    
    [RuleBunch,~]=GetRuleBunch(RuleNum,HI,d,[]);
    %RuleBunch=RuleBunch;
    Delta=ones(RuleNum,d);
    Ytr_b=Multi2Binary(LabelList,Ytr);
    
    [yvp,ytp,XXtr,XXte]=TSK_RuleAvailable(Xtr,Ytr_b,Xte,RuleBunch,Delta,Order,tau); 
    training_time=cputime-training_time_ini;
    TrainAcc=Multi2Binary_Regression2Classifiation(LabelList,ytp,Ytr);
    TestAcc=Multi2Binary_Regression2Classifiation(LabelList,yvp,Yte);    
end

% function [yvp,ytp]=N_TSK(xt,yt,xv,RuleList,Delta,N)
%     [~,D]=size(xt);
%     OrderList=GetOrderList(D,N);
%     OrderNum=size(OrderList,1);
%     
%     [yvp,ytp,~ ] = TSK_RuleAvailable( xt,yt,xv,RuleList,Delta);
%     for o=2:OrderNum
%         xtp=prod(bsxfun(@power,xt,OrderList(o,:)),2);
%         xvp=prod(bsxfun(@power,xv,OrderList(o,:)),2);
%         y=(yt-ytp)./xtp;
%         [yvp1,ytp1,~ ] = TSK_RuleAvailable( xt,y,xv,RuleList,Delta);
%         ytp=ytp+ytp1.*xtp;
%         yvp=yvp+yvp1.*xvp;
%     end
%     
%     clear OrderList xtp xvp yvp1 ytp1
% end



function [yvp,ytp,z0,zt]=TSK_RuleAvailable(x,y,xt,RuleBunch,Delta,Order,tau)
%x！！training set
%y！！label set of training set
% xt！！testing set
% Delta！！1
z0=fromXtoZ_N_Order_1_c_train(x,RuleBunch,Delta,Order);
zt=fromXtoZ_N_Order_1_c(xt,RuleBunch,Delta,Order);

% p=(z0'*z0)\z0'*y;
% yvp=zt*p;
% ytp=z0*p;

%LLM:least learning machine
hth=z0'*z0;
[K,~]=size(hth);
p=(tau*eye(K)+hth)\z0'*y;
yvp=zt*p;
ytp=z0*p;
%clear zt z0
end

function [RuleBunch,RuleList]=GetRuleBunch(RuleNum,HI,D,RuleList)
    for i=1:RuleNum
        [~,RuleList]=ChooseRules(HI,D,RuleList);
    end
    RuleBunch=RuleList(end-RuleNum+1:end,:)/HI;
end

function [OneRule,RuleList]=ChooseRules(HI,D,RuleList)
    OneRuleX=zeros(1,D);
    while true
        for i=1:D
            OneRuleX(i)=randperm(HI+1,1)-1;
        end
        Repeated=HasBeenChoosed(OneRuleX,RuleList);
        if Repeated==false
            RuleList=[RuleList;OneRuleX];
            break;
        end
    end
    
    OneRule=OneRuleX/HI;
    clear OneRuleX
end

function [exist]=HasBeenChoosed(OneRule,RuleList)
    exist=false;
    
    if isempty(RuleList)
        return;
    end
    
    [rr,rc]=size(RuleList);
    for i=1:rr
        if length(OneRule(OneRule==RuleList(i,:)))==rc
            exist=true;
            break;
        end
    end
end

function [MultLabel]=Multi2Binary(LabelList,Y)
    Y_N=length(Y);
    L_N=length(LabelList);
    
    MultLabel=zeros(Y_N,L_N);
    
    for l=1:L_N
        MultLabel(Y==LabelList(l),l)=1;
    end
end

function [Acc]=Multi2Binary_Regression2Classifiation(LabelList,Regress,Y_Ground)
    [M,I]=max(Regress,[],2);
    Y_Predict=LabelList(I);
    Acc=sum(Y_Predict==Y_Ground)/length(Y_Ground);
    clear M I Y_Predict
end