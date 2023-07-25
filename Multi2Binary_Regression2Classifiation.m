function [Acc]=Multi2Binary_Regression2Classifiation(LabelList,Regress,Y_Ground)
    [M,I]=max(Regress,[],2);
    Y_Predict=LabelList(I);
    Acc=sum(Y_Predict==Y_Ground)/length(Y_Ground);
    clear M I Y_Predict
end