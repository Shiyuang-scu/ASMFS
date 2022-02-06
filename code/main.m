function main
clc;
clear;
dbstop if error
% profile on;
addpath(genpath('./fun'));

%%
dataset = 'ADvsNC';
% dataset = 'MCIvsNC';
% dataset = 'MCI-CvsMCI-NC';


% method = 'AMTFS';

% method = 'SVM'; % concatenation data with all features
% method = 'lassoSVM'; % concatenation data with selected features via lasso
% method = 'MKSVM'; % classification by multi-kernel svm
% method = 'lassoMKSVM'; % classification with selected features via lasso on single modality
method = 'MTFS'; % multi-task feature selection
% method = 'M2TFS'; % manifold regularized multi-task feature selection
% method = 'IDMTFS';

%%
if strcmp(method,'MKSVM')
    
    train_MKSVM(dataset);
    
elseif strcmp(method,'AMTFS')
    
%     opt.repeat = 1:5;
            opt.repeat = 6:10;
%     opt.repeat = 1:10;
    
    opt.lambda = 10 .^ (-5:5);
    %     opt.mu = [1,10,20,30,40,50,60];
    opt.mu = [20];
    opt.k = 1:2:9;
    train_AMTFS(dataset,opt);
    
elseif strcmp(method,'SVM')
    
    train_SVM(dataset);
    
elseif strcmp(method,'lassoSVM')
    
    train_lassoSVM(dataset);
    
elseif strcmp(method,'lassoMKSVM')
    
    train_lassoMKSVM(dataset);
    
elseif strcmp(method,'MTFS')
    
    train_MTFS(dataset);
    
elseif strcmp(method,'M2TFS')
    
%     opt.repeat = 1:5;
            opt.repeat = 6:10;
    
    opt.rho_L3 = 1;
    opt.rho1 = [1,10,20,30,40,50,60];
    
    train_M2TFS(dataset,opt);
    
elseif strcmp(method,'IDMTFS')
    
    opt.repeat = 1:10;
    
    opt.rho1 = 1;
    opt.rho2 = 1;
    
    train_IDMTFS(dataset,opt);
    
end
end
% profile viewer;