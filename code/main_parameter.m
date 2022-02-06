close all;clc;clear;
addpath(genpath('./fun'));

dataset = 'ADvsNC';
% dataset = 'MCIvsNC';
% dataset = 'MCI-CvsMCI-NC';

if strcmp(dataset,'ADvsNC')
    load('../data/data_AD_vs_NC.mat');
elseif strcmp(dataset,'MCIvsNC')
    load('../data/data_MCI_vs_NC.mat');
elseif strcmp(dataset,'MCI-CvsMCI-NC')
    load('../data/data_MCI_C_vs_MCI_NC.mat');
end

if strcmp(dataset,'ADvsNC')
    %     opt.repeat = 1:5;
    opt.repeat = 6:10;
    %     opt.repeat = 1:10;
    opt.lambda = [0.01 0.1 1 5 10 20 40 60 80 100];
    opt.mu = [5:5:25,30,40,50];
    opt.k = 1:2:20;
elseif strcmp(dataset,'MCIvsNC')
    opt.repeat = 1:5;
    %     opt.repeat = 6:10;
    %     opt.repeat = 1:10;
    opt.lambda = [0.01 0.1 1 5 10 20 40 60 80 100];
    opt.mu = [5:5:25,30,40,50];
    opt.k = 1:2:20;
elseif strcmp(dataset,'MCI-CvsMCI-NC')
%     opt.repeat = 1:5;
        opt.repeat = 6:10;
    %     opt.repeat = 1:10;
    opt.lambda = [0.01 0.1 1 5 10 20 40 60 80 100];
    opt.mu = [5:5:25,30,40,50];
    opt.k = 1:2:20;
end


%%
repeat = opt.repeat;
kfold = length(unique(indices(:,1)));
X = cell(2,1);
Xtest = cell(2,1);
Xsvm = cell(2,1);
Xsvmtest = cell(2,1);
for i = 1:length(repeat)
    for j = 1:kfold
        disp(['calculting repeat: ',num2str(repeat(i)),' kfold: ',num2str(j)]);
        % prepare data for training and testing
        idx_tr = indices(:,repeat(i)) ~= j;
        idx_te = indices(:,repeat(i)) == j;
        X{1} = data{1}(idx_tr,:);
        X{2} = data{2}(idx_tr,:);
        y = gnd(idx_tr);
        ytest = gnd(idx_te);
        Y = [y,y];
        acc_record = zeros(length(opt.k),length(opt.lambda),length(opt.mu));
        for k = 1:length(opt.k)
            for p = 1:length(opt.lambda)
                for q = 1:length(opt.mu)
                    
                    W = AMTFS(X,Y,opt.k(k),opt.lambda(p),opt.mu(q));
                    idx_fea = sum(W.^2,2) > 1e-5;
                    fea_num = sum(idx_fea);
                    if sum(idx_fea)==0 || sum(idx_fea)==size(W,1)
                        break;
                    end
                    Xsvm{1} = data{1}(idx_tr,idx_fea);
                    Xsvm{2} = data{2}(idx_tr,idx_fea);
                    Xsvmtest{1} = data{1}(idx_te,idx_fea);
                    Xsvmtest{2} = data{2}(idx_te,idx_fea);
                    
                    % classification
                    acc = mkl(Xsvm,y,Xsvmtest,ytest,'AMTFS',dataset);
                    acc_record(k,p,q) = acc;
                end
            end
        end
        save(['../results_AMTFS_parameter/AMTFS_repeat',num2str(repeat(i)),...
            '_kfold',num2str(j),'.mat'],...
            'acc_record','opt');
    end
end