clc;clear;
%% Demo of using libsvm
[gnd, subject] = libsvmread('./heart_scale');
option = '-c 1 -g 0.07 -b 1';
model = svmtrain(gnd, subject, option);
[label, acc, p] = svmpredict(gnd, subject, model, '-b 1');