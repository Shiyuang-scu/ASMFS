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
for i = 1:length(repeat)
    for j = 1:kfold
        idx_tr = indices(:,i) ~= j;
        idx_te = indices(:,i) == j;
        X{1} = data{1}(idx_tr,:);
        X{2} = data{2}(idx_tr,:);
        y = gnd(idx_tr);
        Y{1} = y;
        Y{2} = y;
        Xtest{1} = data{1}(idx_te,:);
        Xtest{2} = data{2}(idx_te,:);
        ytest = gnd(idx_te);
        
        %===================== Feature selection ==========================
        %%
        s = sum((X{1} - X{2}).^2,2);
        
        %         opts.rho1 = 30;
        %         opts.rho_L3 = 10;
        opts.init = 0;      % guess start point from data.
        opts.tFlag = 1;     % terminate after relative objective value does not changes much.
        opts.tol = 10^-5;   % tolerance.
        opts.maxIter = 1000; % maximum iteration number of optimization.
        acc_record = zeros(length(opt.rho1),length(opt.rho2));
        for k = 1:length(opt.rho1)
            for p = 1:length(opt.rho2)
                %---------------------- Multi-task feature selection --------------
                opts.rho1 = opt.rho1(k);
                opts.rho2 = opt.rho2(p);
                
                W = IDMTFS(X, Y, opts.rho1, opts.rho2, s, opts);
                
                idx_fea1 = (W(:,1).^2 > 1e-5);
                idx_fea2 = (W(:,2).^2 > 1e-5);
                if sum(idx_fea1)==0 || sum(idx_fea1)==size(W,1) ...
                        ||sum(idx_fea2)==0 || sum(idx_fea2)==size(W,1)
                    break;
                end
                
                Xsvm{1} = X{1}(:,idx_fea1);
                Xsvm{2} = X{2}(:,idx_fea2);
                Xsvmtest{1} = Xtest{1}(:,idx_fea1);
                Xsvmtest{2} = Xtest{2}(:,idx_fea2);
                
                acc = mkl(Xsvm,y,Xsvmtest,ytest,'IDMTFS',dataset);
                acc_record(k,p) = acc;
            end
        end
        [acc_max,idx] = max(acc_record(:));
        [k_best,p_best] = ind2sub(size(acc_record),idx);
        opts.rho1 = opt.rho1(k_best);
        opts.rho2 = opt.rho2(p_best);
        W = IDMTFS(X, Y, opts.rho1, opts.rho2, s, opts);
        idx_fea1 = (W(:,1).^2 > 1e-5);
        idx_fea2 = (W(:,2).^2 > 1e-5);
        Xsvm{1} = X{1}(:,idx_fea1);
        Xsvm{2} = X{2}(:,idx_fea2);
        Xsvmtest{1} = Xtest{1}(:,idx_fea1);
        Xsvmtest{2} = Xtest{2}(:,idx_fea2);
        % classification
        [acc,label,dec_values] = mkl(Xsvm,y,Xsvmtest,ytest,'IDMTFS',dataset);
        save(['../IDMTFS_results/IDMTFS_repeat',num2str(repeat(i)),...
            '_kfold',num2str(j),'.mat'],...
            'acc','label','dec_values','acc_max','ytest','acc_record');
    end
end
end