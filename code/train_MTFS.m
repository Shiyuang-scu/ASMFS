function train_MTFS(dataset)
%%
%----------------------- Load  Data -------------------------------------
if strcmp(dataset,'ADvsNC')
    load('../data/data_AD_vs_NC.mat');
elseif strcmp(dataset,'MCIvsNC')
    load('../data/data_MCI_vs_NC.mat');
elseif strcmp(dataset,'MCI-CvsMCI-NC')
    load('../data/data_MCI_C_vs_MCI_NC.mat');
end

%%
repeat = size(indices,2);
kfold = length(unique(indices(:,1)));
acc_record = zeros(kfold,repeat);
Y = cell(2,1);
if exist('../MTFS_results/')
    rmdir('../MTFS_results/','s');
end
mkdir('../MTFS_results/');
for i = 1:repeat
    for j = 1:kfold
        idx_tr = indices(:,i) ~= j;
        idx_te = indices(:,i) == j;
        X{1} = data{1}(idx_tr,:);
        X{2} = data{2}(idx_tr,:);
%         X{1} = imnoise(X{1},'gaussian');
%         X{2} = imnoise(X{2},'gaussian');
%         X{1} = imnoise(X{1},'poisson');
%         X{2} = imnoise(X{2},'poisson');
        X{1} = imnoise(X{1},'salt & pepper');
        X{2} = imnoise(X{2},'salt & pepper');
        y = gnd(idx_tr);
        Y{1} = y;
        Y{2} = y;
        Xtest{1} = data{1}(idx_te,:);
        Xtest{2} = data{2}(idx_te,:);
        ytest = gnd(idx_te);
        
        %===================== Feature selection ==========================
        %%
        lambda = 0.5;
        opts.init = 0;      % guess start point from data.
        opts.tFlag = 1;     % terminate after relative objective value does not changes much.
        opts.tol = 10^-5;   % tolerance.
        opts.maxIter = 1000; % maximum iteration number of optimization.
        
        %---------------------- Multi-task feature selection --------------
        [W funcVal] = Least_L21(X, Y, lambda, opts);
        
        idx_fea = sum(W.^2,2) > 1e-5;
        
        X{1} = X{1}(:,idx_fea);
        X{2} = X{2}(:,idx_fea);
        Xtest{1} = Xtest{1}(:,idx_fea);
        Xtest{2} = Xtest{2}(:,idx_fea);
        
        [acc,label,dec_values] = mkl(X,y,Xtest,ytest,'MTFS',dataset);
        acc_record(j,i) = acc;
        save(['../MTFS_results/MTFS_repeat',num2str(i),...
            '_kfold',num2str(j),'.mat'],...
            'acc','label','dec_values','ytest');
    end
end
disp(mean(acc_record(:)));
end