% It is a testing demo.
dbstop if error
addpath(genpath('./fun'));
clc;
clear;
n = 100;
d = 5;
X = cell(2,1);
rng(0);
X{1} = randn(n,d);
X{2} = randn(n,d);
W = randn(d,2);
W([2,4],:) = 0;
y = [ones(n/2,1);-ones(n/2,1)];
y = [y,y];
% y = [X{1}*W(:,1),X{2}*W(:,2)];
% y = mean(y,2);
[acc,output] = mkl(X,y(:,1),X,y(:,1));
k = 5;
lambda = 1;
mu =.4*mean([max(abs(X{1}'*y(:,1)));max(abs(X{2}'*y(:,2)))]);
% mu = 1;R
[W_p,output] = AMTFS(X,y,k,lambda,mu);