clc;clear;close all;
addpath('./fun');

dataset = 'ADvsNC';

if strcmp(dataset,'ADvsNC')
    load('../data/data_AD_vs_NC.mat');
elseif strcmp(dataset,'MCIvsNC')
    load('../data/data_MCI_vs_NC.mat');
elseif strcmp(dataset,'MCI-CvsMCI-NC')
    load('../data/data_MCI_C_vs_MCI_NC.mat');
end

kernel_type = 'rbf';
kernel_param = 8;
K1=calckernel(kernel_type,kernel_param,data{1},data{1});
K2=calckernel(kernel_type,kernel_param,data{2},data{2});
figure;
imagesc(K1);
set(gca,'xtick',[],'xticklabel',[]);
set(gca,'ytick',[],'yticklabel',[]);
figure;
imagesc(K2);
set(gca,'xtick',[],'xticklabel',[]);
set(gca,'ytick',[],'yticklabel',[]);
