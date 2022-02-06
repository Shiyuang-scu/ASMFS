function train_lassoSVM(dataset)
%% Data
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
if exist('../lassoSVM_results/','dir')
    rmdir('../lassoSVM_results/','s');
end
mkdir('../lassoSVM_results/');
for i = 1:repeat
    for j = 1:kfold
        idx_tr = indices(:,i) ~= j;
        idx_te = indices(:,i) == j;
        X = [data{1}(idx_tr,:),data{2}(idx_tr,:)];
        y = gnd(idx_tr);
        Xtest = [data{1}(idx_te,:),data{2}(idx_te,:)];
        ytest = gnd(idx_te);
        
        %%
        if strcmp(dataset,'ADvsNC')
            rho = 0.15;
        elseif strcmp(dataset,'MCIvsNC')
            rho = 0.1;
        elseif strcmp(dataset,'MCI-CvsMCI-NC')
            rho = 0.2;
        end
        
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
        [w, funVal1, ValueL1]= LeastR(X, y, rho, opts);
        
        %------------------------- Feature Selection -----------------------
        idx_fea = sum(w.^2,2) > 1e-5;
        X = X(:,idx_fea);
        Xtest = Xtest(:,idx_fea);
        
        %%
        %---------------------------- Run SVM ------------------------------
        options = ['-c 1'];
        model = svmtrain(y,X,options);
        [label, accuracy, dec_values] = svmpredict(ytest, Xtest,model);
        acc = accuracy(1);
        
        %-------------------------- Save results ---------------------------
        acc_record(j,i) = acc;
        save(['../lassoSVM_results/lassoSVM_repeat',num2str(i),...
            '_kfold',num2str(j),'.mat'],...
            'acc','label','dec_values','ytest');
    end
end
disp(mean(acc_record(:)));
end