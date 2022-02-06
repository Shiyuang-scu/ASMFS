% process data
%
clc;
clear;
load ./data202.mat MRI PET gnd4;
% gnd4: 1 AD 2 MCI-C 3 MCI-NC 4 NC

rng('default');
data = cell(2,1);
repeat = 10;
kfold = 10;

%% AD vs. NC
idx = (gnd4 == 1 | gnd4 == 4);
data{1} = zscore(MRI(idx,:));
% data{1} = bsxfun(@rdivide,data{1},sqrt(sum(data{1}.^2,2)));
data{2} = zscore(PET(idx,:));
% data{2} = bsxfun(@rdivide,data{2},sqrt(sum(data{2}.^2,2)));

gnd = gnd4(idx);
gnd(gnd == 4) = -1;
indices = zeros(length(gnd),repeat);
for i = 1:repeat
    indices(:,i) = crossvalind('Kfold',gnd,kfold);
end

save data_AD_vs_NC data gnd indices;

%% NC vs. MCI
idx = (gnd4 == 4 | gnd4 == 2 | gnd4 == 3);
data{1} = zscore(MRI(idx,:));
data{2} = zscore(PET(idx,:));
gnd = gnd4(idx);
gnd(gnd == 4) = -1;
gnd(gnd == 2 | gnd == 3) = 1;
indices = zeros(length(gnd),repeat);
for i = 1:repeat
    indices(:,i) = crossvalind('Kfold',gnd,kfold);
end

save data_MCI_vs_NC data gnd indices;

%% MCI-C vs. MCI-NC
idx = (gnd4 == 2 | gnd4 == 3);
data{1} = zscore(MRI(idx,:));
data{2} = zscore(PET(idx,:));
gnd = gnd4(idx);
gnd(gnd == 2) = 1;
gnd(gnd == 3) = -1;
indices = zeros(length(gnd),repeat);
for i = 1:repeat
    indices(:,i) = crossvalind('Kfold',gnd,kfold);
end

save data_MCI_C_vs_MCI_NC data gnd indices;