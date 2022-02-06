clc;clear;
path1 = '../testROC1/';
path2 = '../testROC2/';

files1 = dir(path1);
files2 = dir(path2);

gnd = [];
values = [];
acc1 = [];
for i = 3:length(files1)
    load([path1,files1(i).name]);
    gnd = cat(1,gnd,ytest);
    values = cat(1,values,dec_values);
    acc1 = cat(1,acc1,acc);
end

[X,Y,T,auc]=perfcurve(gnd,values,1);
plot(X,Y);
% legend('ROC1');
hold on;

gnd = [];
values = [];
acc2 = [];
for i = 3:length(files2)
    load([path2,files2(i).name]);
    gnd = cat(1,gnd,ytest);
    values = cat(1,values,dec_values);
    acc2 = cat(1,acc2,acc);
end
[X,Y,T,auc]=perfcurve(gnd,values,1);
plot(X,Y);
legend('ROC1','ROC2');
