clc;
clear;
% dataset = 'ADvsNC';
% dataset = 'MCIvsNC';
dataset = 'MCI-CvsMCI-NC';
% method = 'SVM';
% method = 'lassoSVM';
% method = 'MKSVM';
% method = 'lassoMKSVM';
% method = 'MTFS';
% method = 'M2TFS';
method = 'AMTFS';

% foldername = strcat('results_',dataset,'_',method);
% folderpath = fullfile('..',foldername);

% folderpath = '../SVM_results';
% folderpath = '../lassoSVM_results';
% folderpath = '../MKSVM_results';
% folderpath = '../lassoMKSVM_results';
% folderpath = '../MTFS_results';
% folderpath = '../M2TFS_results';
% folderpath = '../testROC1';
folderpath = '../AMTFS_results';
% folderpath = ['../results_',dataset,'_',method];
% folderpath = ['../results_MCIvsNC_SVM_backup'];
filesname = dir([folderpath,'/*.mat']);

%--------------------------------------------------------------------------
result_record = zeros(length(filesname),6);% accuracy record
gnd = [];
values = [];
for i = 1:length(filesname)
    filepath = fullfile(folderpath,filesname(i).name);
    load(filepath);
    order = [1,-1];
    C = confusionmat(ytest,label,'order',order);
    TP = C(1,1);TN = C(2,2);FN = C(1,2);FP = C(2,1);
    sensitivity = (TP+0.00001)/(TP + FN)*100;
    specificity = TN/(FP + TN)*100;
    precision = TP/(TP+FP+0.00001)*100;
    F1score = 2*(precision*sensitivity)/(precision+sensitivity);
    [~,~,T,auc] = perfcurve(ytest,dec_values,1);
    result_record(i,:) = [acc,sensitivity,specificity,precision,F1score,auc];
    gnd = cat(1,gnd,ytest);
    values = cat(1,values,dec_values);
end
disp('     Acc       Sen      Spe        PREC        F1score        AUC');
disp(mean(result_record));
disp(std(result_record/100));
[X,Y,T,auc]=perfcurve(gnd,values,1);
plot(X,Y);