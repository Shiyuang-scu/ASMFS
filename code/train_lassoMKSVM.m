function train_lassoMKSVM(dataset)
%%
%----------------------- Load  Data -------------------------------------
if strcmp(dataset,'ADvsNC')
    load('../data/data_AD_vs_NC.mat');
elseif strcmp(dataset,'MCIvsNC')
    load('../data/data_MCI_vs_NC.mat');
elseif strcmp(dataset,'MCI-CvsMCI-NC')
    load('../data/data_MCI_C_vs_MCI_NC.mat');
end

repeat = size(indices,2);
kfold = length(unique(indices(:,1)));
acc_record = zeros(kfold,repeat);
if exist('../lassoMKSVM_results/')
    rmdir('../lassoMKSVM_results/','s');
end
mkdir('../lassoMKSVM_results/');
for i = 1:repeat
    for j = 1:kfold
        idx_tr = indices(:,i) ~= j;
        idx_te = indices(:,i) == j;
        X{1} = data{1}(idx_tr,:);
        X{2} = data{2}(idx_tr,:);
        y = gnd(idx_tr);
        Xtest{1} = data{1}(idx_te,:);
        Xtest{2} = data{2}(idx_te,:);
        ytest = gnd(idx_te);
        
        %===================== Feature selection ==========================
        %%
        rho = 0.7;
        
        %----------------------- Set optional items ------------------------
        opts=[];
        
        % Starting point
        opts.init=2;        % starting from a zero point
        
        % termination criterion
        opts.tFlag=5;       % run .maxIter iterations
        opts.maxIter=100;   % maximum number of iterations
        
        % normalization
        opts.nFlag=0;       % without normalization
        
        % regularization
        opts.rFlag=1;       % the input parameter 'rho' is a ratio in (0, 1)
        
        %----------------------- Run the code LeastR -----------------------
        opts.mFlag=0;       % treating it as compositive function
        opts.lFlag=0;       % Nemirovski's line search
        [w1, funVal1, ValueL1]= LeastR(X{1}, y, rho, opts);
        [w2, funVal1, ValueL1]= LeastR(X{2}, y, rho, opts);
        
        %------------------------- Feature Selection -----------------------
        idx1_fea = sum(w1.^2,2) > 1e-5;
        X{1} = X{1}(:,idx1_fea);
        Xtest{1} = Xtest{1}(:,idx1_fea);
        
        idx2_fea = sum(w2.^2,2) > 1e-5;
        X{2} = X{2}(:,idx2_fea);
        Xtest{2} = Xtest{2}(:,idx2_fea);
        
        %%
        %---------------------- Run multi-kernel SVM ----------------------
        [acc,label,dec_values] = mkl(X,y,Xtest,ytest,'lassoMKSVM',dataset);
        acc_record(j,i) = acc;
        save(['../lassoMKSVM_results/lassoMKSVM_repeat',num2str(i),...
            '_kfold',num2str(j),'.mat'],...
            'acc','label','dec_values','ytest');
    end
end
disp(mean(acc_record(:)));
end