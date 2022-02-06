function [f,g] = compute_fg_W(W,X,y,Ls,lambda,mu)
% W: d x M matrix
% X: M x 1 cell, each cell contains a N x d data matrix
% y: N x 1 vector, label vector
% Ls: N x N matrix, Laplacian matrix
% lambda and mu are regularization parameters

M = length(X);
d = size(X{1},2);
W = reshape(W,d,M);
f = 0;
g = zeros(size(W));
D = diag(1./(sqrt(sum(W.^2,2))));
for m = 1:M
    f = f + 0.5*norm(y - X{m}*W(:,m))^2 +...
        lambda*2*W(:,m)'*X{m}'*Ls*X{m}*W(:,m);
    
    g(:,m) = X{m}'*X{m}*W(:,m) - X{m}'*y +...
        lambda*4*X{m}'*Ls*X{m}*W(:,m) + mu*D*W(:,m);
end
f = f + mu*sum(sqrt(sum(W.^2,2)));
g = g(:);
end