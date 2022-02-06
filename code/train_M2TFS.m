function train_M2TFS(dataset,opt)
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
repeat = opt.repeat;
kfold = length(unique(indices(:,1)));

X = cell(2,1);
Y = cell(2,1);
Xtest = cell(2,1);
Xsvm = cell(2,1);
Xsvmtest = cell(2,1);
% if exist('../M2TFS_results/')
%     rmdir('../M2TFS_results/','s');
% end
% mkdir('../M2TFS_results/');
for i = 1:length(repeat)
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
        S = f_lapMatrixV2(X,Y);
        
        %         opts.rho1 = 30;
        %         opts.rho_L3 = 10;
        opts.init = 0;      % guess start point from data.
        opts.tFlag = 1;     % terminate after relative objective value does not changes much.
        opts.tol = 10^-5;   % tolerance.
        opts.maxIter = 1000; % maximum iteration number of optimization.
        acc_record = zeros(length(opt.rho1),length(opt.rho_L3));
        acc_record = zeros(length(opt.rho1),length(opt.rho_L3));
        for k = 1:length(opt.rho1)
            for p = 1:length(opt.rho_L3)
                %---------------------- Multi-task feature selection --------------
                opts.rho1 = opt.rho1(k);
                opts.rho_L3 = opt.rho_L3(p);
                
                W = jb_MTM_APG(X,Y,opts,S);
                
                idx_fea = sum(W.^2,2) > 1e-5;
                if sum(idx_fea)==0 || sum(idx_fea)==size(W,1)
                    break;
                end
                
                Xsvm{1} = X{1}(:,idx_fea);
                Xsvm{2} = X{2}(:,idx_fea);
                Xsvmtest{1} = Xtest{1}(:,idx_fea);
                Xsvmtest{2} = Xtest{2}(:,idx_fea);
                
                acc = mkl(Xsvm,y,Xsvmtest,ytest,'M2TFS',dataset);
                acc_record(k,p) = acc;
            end
        end
        [acc_max,idx] = max(acc_record(:));
        [k_best,p_best] = ind2sub(size(acc_record),idx);
        opts.rho1 = opt.rho1(k_best);
        opts.rho_L3 = opt.rho_L3(p_best);
        W = jb_MTM_APG(X,Y,opts,S);
        idx_fea = sum(W.^2,2) > 1e-5;
        Xsvm{1} = X{1}(:,idx_fea);
        Xsvm{2} = X{2}(:,idx_fea);
        Xsvmtest{1} = Xtest{1}(:,idx_fea);
        Xsvmtest{2} = Xtest{2}(:,idx_fea);
        % classification
        [acc,label,dec_values] = mkl(Xsvm,y,Xsvmtest,ytest,'M2TFS',dataset);
        save(['../M2TFS_results/M2TFS_repeat',num2str(repeat(i)),...
            '_kfold',num2str(j),'.mat'],...
            'acc','label','dec_values','acc_max','ytest','acc_record');
    end
end
end