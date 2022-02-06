function train_AMTFS(dataset, opt)

%% Input
% dataset: 'AD vs. NC', 'MCI vs. NC' and 'MCI-C vs. MCI-NC'
% opt: opt.lambda: the regularizer coefficient for adaptive term
%      opt.mu: the regularizer coefficient on L21 norm
%      opt.k: the k nearest neighbors

%% Data
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
%         X{1} = imnoise(X{1},'gaussian');
%         X{2} = imnoise(X{2},'gaussian');
%         X{1} = imnoise(X{1},'poisson');
%         X{2} = imnoise(X{2},'poisson');
%         X{1} = imnoise(X{1},'salt & pepper');
%         X{2} = imnoise(X{2},'salt & pepper');
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
        
        [acc_max,idx] = max(acc_record(:));
        [k_best,p_best,q_best] = ind2sub(size(acc_record),idx);
        
        [W,output] = AMTFS(X,Y,opt.k(k_best),opt.lambda(p_best),opt.mu(q_best));
        idx_fea = sum(W.^2,2) > 1e-5;
        fea_num = sum(idx_fea);

        Xsvm{1} = data{1}(idx_tr,idx_fea);
        Xsvm{2} = data{2}(idx_tr,idx_fea);
        Xsvmtest{1} = data{1}(idx_te,idx_fea);
        Xsvmtest{2} = data{2}(idx_te,idx_fea);
        
        % classification
        [acc,label,dec_values] = mkl(Xsvm,y,Xsvmtest,ytest,'AMTFS',dataset);
        mkdir('../AMTFS_results/');
        save(['../AMTFS_results/AMTFS_repeat',num2str(repeat(i)),...
            '_kfold',num2str(j),'.mat'],...
            'acc','label','dec_values','W','output','acc_max','ytest','acc_record');
    end
end

end