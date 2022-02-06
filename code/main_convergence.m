clc;clear;
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

%%
X = data;
Y =cell(2,1);
Y{1} = gnd;
Y{2} = gnd;
d = size(X{1}, 2);  % dimensionality.

lambda = [100];

rng('default');     % reset random generator. Available from Matlab 2011.
opts.init = 0;      % guess start point from data.
opts.tFlag = 1;     % terminate after relative objective value does not changes much.
opts.tol = 10^-5;   % tolerance.
opts.maxIter = 1000; % maximum iteration number of optimization.

sparsity = zeros(length(lambda), 1);
log_lam  = log(lambda);

[W funcVal] = Least_L21(X, Y, lambda, opts);
% set the solution as the next initial point.
% this gives better efficiency.
opts.init = 1;
opts.W0 = W;
sparsity = nnz(sum(W,2 )==0)/d;


% draw figure
h = figure;
plot(funcVal(1:20),'ro-');
xlabel('Iteration')
ylabel('Ojbective function Value')
title(dataset);
set(gca,'FontSize',12);
print('-dpdf', '-r100', 'LeastL21Exp');
