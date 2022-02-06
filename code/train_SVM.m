function train_SVM(dataset)
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
if exist('../SVM_results/','dir')
    rmdir('../SVM_results/','s');
end
mkdir('../SVM_results/');
for i = 1:repeat
    for j = 1:kfold
        idx_tr = indices(:,i) ~= j;
        idx_te = indices(:,i) == j;
        X = [data{1}(idx_tr,:),data{2}(idx_tr,:)];
        y = gnd(idx_tr);
        Xtest = [data{1}(idx_te,:),data{2}(idx_te,:)];
        ytest = gnd(idx_te);
        
        %---------------------------- Run SVM ------------------------------
        options = ['-c 1000'];
        model = svmtrain(y,X,options);
        [label, accuracy, dec_values] = svmpredict(ytest, Xtest,model);
        acc = accuracy(1);
        acc_record(j,i) = acc;
        save(['../SVM_results/SVM_repeat',num2str(i),...
            '_kfold',num2str(j),'.mat'],...
            'acc','label','dec_values','ytest');
    end
end
disp(mean(acc_record(:)));
end