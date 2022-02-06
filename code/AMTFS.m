function [W,output] = AMTFS(X,Y,k,lambda,mu)
% X: m x 1 cell, each cell is a n x d data matrix
% y: n x m matrix, each column is a label vector for corrsponding modality data
%   (+1 for positive and -1 for negative)
% k: k nearest neighbors
% lambda and mu are parameters of regularization terms
%%
NITER = 20;
% NITER = 50;
ABSTOL = 1e-4;
modal = length(X);
[num,dim] = size(X{1});

%% initialize S
distX = zeros(num);
for i = 1:modal
    distX = distX + L2_distance_1(X{i}',X{i}');
end
y = Y(:,1);
idx_y = y*y';
distX(idx_y == -1) = inf;
[distX1, idx] = sort(distX,2);
S = zeros(num);
rr = zeros(num,1);
for i = 1:num
    di = distX1(i,2:k+2);
    rr(i) = 0.5*(k*di(k+1) - sum(di(1:k)));
    id = idx(i, 2:k+2);
    S(i,id) = (di(k+1)-di)/(k*di(k+1)-sum(di(1:k))+eps);
end
r = mean(rr);

%%
S0 = (S + S')/2;
Ds = diag(sum(S0));
Ls = Ds - S0;

W = zeros(dim,modal);
for i = 1:modal
    W(:,i) = (X{i}'*X{i} + diag(1e-5*ones(size(X{i},2),1)))\(X{i}'*Y(:,i));
end
% for i = 1:modal
%     W(:,i) = randn(size((X{i}'*X{i} + diag(1e-5*ones(size(X{i},2),1)))\(X{i}'*Y(:,i))));
% end


D = diag(1./(sqrt(sum(W.^2,2))+eps));
obj = zeros(NITER,1);
for iter = 1:NITER
    % fix S then update W
    for i = 1:modal
        W(:,i) = (X{i}'*X{i} + 4*lambda*X{i}'*Ls*X{i} + mu*D)\(X{i}'*Y(:,i));
    end
    % update D
    D = diag(1./(sqrt(sum(W.^2,2))+eps));
    
    % fix W then update S
    distx = zeros(num);
    for i = 1:modal
        distx = distx + L2_distance_1(W(:,i)'*X{i}',W(:,i)'*X{i}');
    end
    distx(idx_y == -1) = inf;
    [~,idx] = sort(distx,2);
    S = zeros(num);
    for i = 1:num
        idxa0 = idx(i,2:k+1);
        dxi = distx(i,idxa0);
        ad = -dxi/(2*r);
        S(i,idxa0) = EProjSimplex_new(ad);
    end
    S0 = (S+S')/2;
    Ds = diag(sum(S0));
    Ls = Ds - S0;
    obj(iter) = compute_obj(X,Y,W,S,Ls,lambda,mu,r);
    if iter > 1 && abs(obj(iter) - obj(iter-1)) < ABSTOL
        break;
    end
end
output.S = S;
output.obj = obj(1:iter);
end
function f = compute_obj(X,y,W,S,Ls,lambda,mu,r)
m = length(X);
n = size(X{1},1);

f = 0;
for i = 1:m
    f = f + 0.5*norm(y(:,i)-X{i}*W(:,i))^2 + lambda*2*W(:,i)'*X{i}'*Ls*X{i}*W(:,i);
end
f = f + lambda*r*sum(sum(S.^2))+mu*sum(sqrt(sum(W.^2,2)));

% t = 0;
% for i = 1:m
%     t = t + 0.5*norm(y(:,i)-X{i}*W(:,i))^2;
% end
% for i = 1:n
%     for j = 1:n
%         for k = 1:m
%             t = t + lambda*norm(X{k}(i,:)*W(:,k)-X{k}(j,:)*W(:,k))^2*S(i,j);
%         end
%         t = t + lambda*r*S(i,j)^2;
%     end
% end
% t = t + mu*sum(sqrt(sum(W.^2,2)));
end