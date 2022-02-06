function train_MKSVM(dataset)
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
X = cell(2,1);
Xtest = cell(2,1);
acc_record = zeros(kfold,repeat);
if exist('../MKSVM_results/')
    rmdir('../MKSVM_results/','s');
end
mkdir('../MKSVM_results/');
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
        
        % classification
        [acc,label,dec_values] = mkl(X,y,Xtest,ytest,'MKSVM',dataset);
        acc_record(j,i) = acc;
        save(['../MKSVM_results/MKSVM_repeat',num2str(i),...
            '_kfold',num2str(j),'.mat'],...
            'acc','label','dec_values','ytest');
    end
end
disp(mean(acc_record(:)));
end