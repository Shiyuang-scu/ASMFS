clc;clear;close all;

dataset = 'ADvsNC';
% dataset = 'MCIvsNC';
% dataset = 'MCI-CvsMCI-NC';

methods = cell(4,1);
colors = cell(4,1);


% % methods{1} = 'MKSVM';
% methods{1} = 'SVM';
% methods{2} = 'lassoSVM';
% methods{3} = 'MKSVM';
% methods{4} = 'AMTFS';
% 
methods{1} = 'lassoMKSVM';
methods{2} = 'MTFS';
methods{3} = 'M2TFS';
methods{4} = 'AMTFS';

colors{1} = 'm';
colors{2} = 'b';
colors{3} = 'k';
colors{4} = 'r';
hold on;
for i = 1:length(methods)
    gnd = [];
    values = [];
    acc1 = [];
    
    folderpath = ['../results_',dataset,'_',methods{i}];
    filesname = dir([folderpath,'/*.mat']);
    for j = 1:length(filesname)
        filepath = fullfile(folderpath,filesname(j).name);
        load(filepath);
        gnd = cat(1,gnd,ytest);
        values = cat(1,values,dec_values);
        acc1 = cat(1,acc1,acc);
    end
    
    [X,Y,T,auc]=perfcurve(gnd,values,1);
    plot(X,Y,colors{i},'LineWidth',1);
end
hold off;
legend(methods{1},methods{2},methods{3},'ASMFS');
box on;
if strcmp(dataset,'ADvsNC')
    title('ROC curve (AD vs. NC)');
elseif strcmp(dataset,'MCIvsNC')
    title('ROC curve (MCI vs. NC)');
elseif strcmp(dataset,'MCI-CvsMCI-NC')
    title('ROC curve (MCI-C vs. MCI-NC)');
end

xlabel('False positive rate');
ylabel('True positive rate');
set(gca,'FontSize',15);