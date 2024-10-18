function [Z,W,obj,obj1] = singal(F,lamda1,lamda2)
[Z,~] = InitializeSIGs(F');      %初始化系数矩阵Z
[m,n] = size(Z);
[bands,~]=size(F);

A = 0;     %初始化A
p = 1.1; u = 1; umax = 100;    %初始化u

%L = get_Laplice(F,5,theta);
%L = get_Laplice2(F,5,theta);
L=get_Lap(F');

flag = 1;
iter = 0;
maxIter = 300;

while flag
    iter = iter + 1;
    
    %% update T
    Y = Z + (1/u).*A;      %构造Y矩阵
    [U,S,V] = svd(Y);       %对Y矩阵svd
    S = max(S - (lamda1/u),0);       %S矩阵减去1/u，并与0取大
    T = U*S*(V');              %重构T矩阵
    
    %% update Z
    %Z = (2*F*(F')+u*eye(bands))\(2*F*(F')-A+u.*T);
    Z = (2*F*(F')+u*eye(bands)+lamda2*F*(L+L')*(F'))\(2*F*(F')-A+u.*T);
    Z = Z - diag(diag(Z));
    Z = max(Z,0);
    
    %% update A,u
    A = A + u.*(Z - T);
    u = min(p*u,umax);
    
    %% cal obj
    temp1 = norm(F'-F'*Z,'fro')^2;
    temp2 = lamda1*sum(svd(Z));
    temp3 = lamda2*trace((Z')*F*L*(F')*Z);
    
    obj(iter) = temp1 + temp2 + temp3;
    %obj(iter) = temp1 + temp2;
    %obj
    obj1(iter) = temp1;
    %plot(obj);
    if (iter>2) && (abs((obj(iter-1)-obj(iter))/(obj(iter-1)))<1e-6 || iter>maxIter)
        flag = 0;
    end
end
W = (abs(Z) + abs(Z'))/2;
