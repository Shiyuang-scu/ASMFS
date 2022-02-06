function [H,Lh] = cons_hypergraph(X,k)
m = size(X,1);
H = zeros(m,m);    %H��incidence matrix;
for j = 1:m              %����KNN�㷨������ͼ������ŷʽ��������K���㹹��һ������
%     z = knn(X,X(j,:),k);  %knn�е�K�仯ʱ��DeҲҪ�仯��
    z = knnsearch(X,X(j,:),k);
    for i = 1:k
         H(z(i),j) = 1;
    end
end
A = eye(m);    % A��hyperedge weights�ԽǾ���ÿ�����ߵ�Ȩ����Ϊ1��
Dv = zeros(m,m);   %Dv�Ǳ�ʾ������ĶȵĶԽǾ���
tmp1 = sum(H'*A,2);
for i = 1:m
    Dv(i,i) = tmp1(i);
end
De = k*eye(m);  %De�Ǳ�ʾ�����ߵĶȵĶԽǾ���
theta1 = (Dv^-0.5)*H*A*(De^-1)*H'*(Dv^-0.5);
I = eye(m);
Lh = I - theta1;    % LapLacian matrix;
