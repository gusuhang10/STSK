function [TestAcc,TrainAcc,training_time]=N_STSK(TrainData,TestData,RuleNum,HI,Order,tau,A,numbda)
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
    
    [yvp,ytp]=TSK_RuleAvailable(Xtr,Ytr_b,Xte,RuleBunch,Delta,Order,tau,A,numbda);
    training_time=cputime-training_time_ini;
    TrainAcc=Multi2Binary_Regression2Classifiation(LabelList,ytp,Ytr);
    TestAcc=Multi2Binary_Regression2Classifiation(LabelList,yvp,Yte);    
end

function [yvp,ytp]=TSK_RuleAvailable(x,y,xt,RuleBunch,Delta,Order,tau,A,numbda)
%x！！training set
%y！！label set of training set
% xt！！testing set
% Delta！！1
z0=fromXtoZ_N_Order_1_c_train(x,RuleBunch,Delta,Order);
zt=fromXtoZ_N_Order_1_c(xt,RuleBunch,Delta,Order);
len1=size(A{1,1},1);
len2=size(y,2);
for c=1:len2
    Ac=A{c,1};
    p(:,c)=(0.5/tau*eye(len1)+Ac*z0'*z0*Ac')\Ac*z0'*y(:,c);
    Ac=(numbda*eye(len1)+tau*p(:,c)*p(:,c)')\(tau*p(:,c)*y(:,c)'*z0+numbda*eye(len1))/(eye(len1)+z0'*z0);
    
    ytp(:,c)=p(:,c)'*Ac*z0';
    yvp(:,c)=p(:,c)'*Ac*zt';
end
clear zt z0
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