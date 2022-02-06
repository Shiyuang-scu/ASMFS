clc;clear;close all;
clc;
clear;
% dataset = 'ADvsNC';
load '../data/93roinames.mat';
% dataset = 'MCIvsNC';
dataset = 'MCI-CvsMCI-NC';

method = 'AMTFS';

folderpath = ['../results_',dataset,'_',method];
% folderpath = ['../',method,'_results'];
filesname = dir([folderpath,'/*.mat']);

%--------------------------------------------------------------------------
featureWeight = 0;
for i = 1:length(filesname)
    filepath = fullfile(folderpath,filesname(i).name);
    load(filepath);
   featureWeight = featureWeight + W.^2;
end
[t,idx] = sort(sum(featureWeight,2),'descend');
z = r_name(idx(1:10));
disp(r_name(idx(1:10)));