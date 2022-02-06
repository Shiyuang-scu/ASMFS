   function CC=f_lapMatrixV2(X,Y) 
        % lapMatrix.
        % 2X(D-M)X'   X=[x1,x2,...,xn];
        % K: the no. of task.
        if nargin<2
            t=1;           
        end      
        %K=length(X);
        K=length(Y);
        CC = cell(K,1);
        L=cell(K,1);
        ld=length(Y{1});
        tmpD=diag(ones(ld,1));
        for k=1:K           
           %M=jb_distBetweenX(X{k},t);
           M=Y{k}*Y{k}';
           M=M-tmpD;
           M(M<0)=0;
           L{k}=diag(sum(M,1))-M;
           CC{k}=2*X{k}'*L{k}*X{k};
        end
    end