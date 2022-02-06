clc;
clear;
addpath(genpath('../fun'));
n = 10;
d = 2;
m = 2;
rng(0);
W = randn(d,m);
X = cell(m,1);
for m = 1:m
    X{m} = randn(n,d);
end
y = randn(n,1);
S = rand(n);
lambda = 1;
mu = 1;

%%
obj1 = 0;
for i = 1:m
    obj1 = obj1 + 0.5*norm(y-X{i}*W(:,i))^2;
    for j = 1:n
        for k = 1:n
            obj1 = obj1 + ...
                lambda*norm(X{i}(j,:)*W(:,i)-X{i}(k,:)*W(:,i))^2*S(j,k);
        end
    end
end
obj1 = obj1 + mu*sum(sqrt(sum(W.^2,2)));
A = (S+S')/2;
D = diag(sum(A));
Ls = D - A;
obj2 = compute_fg_W(W(:),X,y,Ls,lambda,mu);

order = 1;
type = 2;
derivativeCheck(@compute_fg_W,W(:),order,type,X,y,Ls,lambda,mu);