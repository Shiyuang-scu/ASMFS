function [acc_max,label_p,dec_values_p] = mkl(X,y,Xtest,ytest,method,dataset)
% compute linear kernel
modal = length(X);
K = cell(modal,1);
Ktest = cell(modal,1);
for i = 1:modal
    K{i} = X{i}*X{i}';
    Ktest{i} = Xtest{i}*X{i}';
end

% alpha = 0:0.4:1;
%---------------------------- AMTFS ---------------------------------------
if strcmp(method,'AMTFS') && strcmp(dataset,'ADvsNC')
    alpha = 0:0.2:1;
    %     C = 0.002; % for AMTFS and AD vs. NC
    C = 1;
    
elseif strcmp(method,'AMTFS') && strcmp(dataset,'MCIvsNC')
        alpha = 0.3;
    C = 1; % for AMTFS and MCI vs. NC
elseif strcmp(method,'AMTFS') && strcmp(dataset,'MCI-CvsMCI-NC')
    alpha = 0.5;
    C = 1; % for AMTFS and MCI-C vs. MCI-NC
    
    %---------------------------- MKSVM -----------------------------------
elseif strcmp(method,'MKSVM') && strcmp(dataset,'ADvsNC')
    alpha = 0:0.25:1;
    C = 1;
elseif strcmp(method,'MKSVM') && strcmp(dataset,'MCIvsNC')
    alpha = 0:0.3:1;
    %         C = 0.00388; % for MKSVM and MCI vs. NC
    C = 1   ;
elseif strcmp(method,'MKSVM') && strcmp(dataset,'MCI-CvsMCI-NC')
    alpha = 0:0.53:1;
    C = 1;
    
    %-------------------------- lassoMKSVM --------------------------------
elseif strcmp(method,'lassoMKSVM') && strcmp(dataset,'ADvsNC')
    C = 1; % for lassoMKSVM and AD vs. NC
elseif strcmp(method,'lassoMKSVM') && strcmp(dataset,'MCIvsNC')
    C = 1; % for lassoMKSVM and MCI vs. NC
elseif strcmp(method,'lassoMKSVM') && strcmp(dataset,'MCI-CvsMCI-NC')
    alpha = 0:0.2:1;
    C = 1; % for lassoMKSVM and MCI vs. NC
    
    %----------------------------- MTFS -----------------------------------
elseif strcmp(method,'MTFS') && strcmp(dataset,'ADvsNC')
    alpha = 0.3;
    C = 1; % for multi-task feature selection and AD vs. NC
elseif strcmp(method,'MTFS') && strcmp(dataset,'MCIvsNC')
    alpha = 0:0.2:1;
    C = 1; % for multi-task feature selection and MCI vs. NC
elseif strcmp(method,'MTFS') && strcmp(dataset,'MCI-CvsMCI-NC')
    alpha = 0:0.3:1;
    C = 1; % for multi-task feature selection and MCI-C vs. MCI-NC
    
    %---------------------------- M2TFS -----------------------------------
elseif strcmp(method,'M2TFS') && strcmp(dataset,'ADvsNC')
    %         C = 0.02; % for manifold regularized multi-task feature selection
    alpha = 0.3;
    C = 1;
elseif strcmp(method,'M2TFS') && strcmp(dataset,'MCIvsNC')
    %         C = 0.02; % for manifold regularized multi-task feature selection
    alpha = 0:0.3:1;
    C = 1;
elseif strcmp(method,'M2TFS') && strcmp(dataset,'MCI-CvsMCI-NC')
    %         C = 0.02; % for manifold regularized multi-task feature selection
    alpha = 0:0.6:1;
    C = 1;
    
elseif strcmp(method,'IDMTFS') && strcmp(dataset,'ADvsNC')
    %     C = 0.02; % for manifold regularized multi-task feature selection
    C = 1;
end

% w1 = 1;
% w2 = 2;

acc_max = 0;
for i = 1:length(alpha)
    beta = 1 - alpha(i);
    for j = 1:length(C)
        %                 options = ['-t 4 -c ', num2str(C(j)),' -w1 1 -w-1 10'];
        options = ['-t 4 -c ', num2str(C(j))];
        model = svmtrain(y,[(1:length(y))',alpha(i)*K{1}+beta*K{2}], options);
        [label, acc, dec_values] = svmpredict(ytest, [(1:length(ytest))',alpha(i)*Ktest{1}+beta*Ktest{2}],model);
        if acc_max < acc(1)
            acc_max = acc(1);
            label_p = label;
            dec_values_p = dec_values;
        end
    end
end

end