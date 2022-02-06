function check_inter_modality
clc;
addpath(genpath('../fun'));
n = 100;
d = 10;
X = cell(2,1);
X{1} = randn(n,d);
X{2} = randn(n,d);
s = rand(n,1);
W = randn(d,2);

obj1 = obj_value(W(:),X,s);
obj2 = 0;
for i = 1:n
    obj2 = obj2 + s(i)*norm(X{1}(i,:)*W(:,1)-X{2}(i,:)*W(:,2))^2;
end
disp(abs(obj1-obj2));
order = 1;
% derivativeCheck(@obj_value,W(:),order,2,X,Y);
X{1} = X{1}';
X{2} = X{2}';
Y{1} = randn(n,1);
Y{2} = Y{1};
derivativeCheck(@compute_f_grad,W(:),order,2,X,Y,s);
end

function [funcVal,grad_W] = compute_f_grad(W,X,Y,s)
d = size(X{1},1);
W = reshape(W,d,2);
rho2 = 1;
rho_L2 = 0;
grad_W = [];
for t_ii = 1:2
    XY{t_ii} = X{t_ii}*Y{t_ii};
    XWi = X{t_ii}' * W(:,t_ii);
    XTXWi = X{t_ii}* XWi;
    grad_W = cat(2, grad_W, XTXWi - XY{t_ii});
end 
grad_W(:,1) = grad_W(:,1) + rho2*(2*X{1}*diag(s)*X{1}'*W(:,1) - 2*X{1}*diag(s)*X{2}'*W(:,2));
grad_W(:,2) = grad_W(:,2) + rho2*(2*X{2}*diag(s)*X{2}'*W(:,2) - 2*X{2}*diag(s)*X{1}'*W(:,1));
grad_W = grad_W + rho_L2 * 2 * W;
grad_W = grad_W(:);

funcVal = 0;
for i = 1: 2
    funcVal = funcVal + 0.5 * norm (Y{i} - X{i}' * W(:, i))^2;
end

funcVal = funcVal + ...
    rho2*(W(:,1)'*X{1}*diag(s)*X{1}'*W(:,1) + W(:,2)'*X{2}*diag(s)*X{2}'*W(:,2) - ...
    2*W(:,1)'*X{1}*diag(s)*X{2}'*W(:,2));
funcVal = funcVal + rho_L2 * norm(W, 'fro')^2;
end


function [f,grad] = obj_value(W,X,s)
d = size(X{1},2);
W = reshape(W,d,2);
n = length(s);
S = diag(s);
f = W(:,1)'*X{1}'*S*X{1}*W(:,1) + W(:,2)'*X{2}'*S*X{2}*W(:,2) - ...
    2*W(:,1)'*X{1}'*S*X{2}*W(:,2);
grad = zeros(size(W));
grad(:,1) = 2*X{1}'*S*X{1}*W(:,1) - 2*X{1}'*S*X{2}*W(:,2);
grad(:,2) = 2*X{2}'*S*X{2}*W(:,2) - 2*X{2}'*S*X{1}*W(:,1);
grad = grad(:);
end