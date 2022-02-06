clc;
clear;
% files = dir('../AMTFS_results/');

% files = dir('../SVM_results/');
% files = dir('../lassoSVM_results/');
% files = dir('../results_ADvsNC_AMTFS');
% files = dir('../results_MCIvsNC_AMTFS/');
% files = dir('../results_MCI-CvsMCI-NC_AMTFS');
% files = dir('../MKSVM_results');
% files = dir('../lassoMKSVM_results');
files = dir('../MTFS_results/');
% files = dir('../M2TFS_results/');
% files = dir('../IDMTFS_results/');
accuracy = [];
label_pre = [];
gnd = [];
for i = 3:length(files)
    load([files(i).folder,'/',files(i).name]);
    accuracy = [accuracy;acc];
    label_pre = [label_pre;label];
    gnd = [gnd;ytest];
end
best_acc = mean(accuracy);
mean(gnd == label_pre)