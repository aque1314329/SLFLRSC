function [Z,obj] = Z_knn_F(lamda1,lamda2,lamda3,k1,k2,X)
[Z,~] = InitializeSIGs(X');
[m,n] = size(Z);
miu=1;
maxu=100;
p=1.1;
A =zeros(m,n);

Lh1=get_Lap(X',k1);
Lh2=get_Lapb(X,k2);

flag=1;
maxIter = 100;
iter = 0;
while flag
iter = iter + 1;
    [U,S,V]=svd(Z+(1/miu).*A);
    [r,c] = size(S);
    D=eye(r,c);
    D=(lamda1/miu).*D;
    S=S-D;
    S(S<0)=0;
    J=U*S*(V');

    Z=inv((2*X*(X')+miu*eye(m)+lamda2*X*(Lh1+Lh1')*(X')+lamda3*(Lh2+Lh2')))*(2*X*(X')-A+miu.*J);
    Z=Z-diag(diag(Z)); 
    Z(Z<0)=0;

    A=A+miu.*(Z-J); 

    miu=miu*p;     
    if(miu>maxu) miu=maxu;
    end

    tmp1=norm(X'-X'*Z,'fro')^2;
    [U,S,V]=svd(Z);
    tmp2=lamda1*sum(diag(S));
    tmp3=lamda2*trace((Z')*X*Lh1*(X')*Z);
    tmp4=lamda3*trace((Z')*Lh2*Z);
    tmp=tmp1+tmp2+tmp3+tmp4;
    obj(iter) = tmp;
    if ((iter>2) && (abs((obj(iter-1)-obj(iter))/obj(iter-1))<1e-4) || iter>maxIter)
        flag = 0;
    end
end
end