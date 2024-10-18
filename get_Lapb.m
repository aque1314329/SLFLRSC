function [L]=get_Lapb(A,k)
[m,n]=size(A);
KNN=zeros(m,k+1);
w=zeros(m);
D=zeros(m);

for i=1:m
    KNN(i,:)=knnsearch(A,A(i,:),'k',k+1);
end
for i=1:m
    sigma1=0;
    sigma2=0;
    for j=2:k+1
            sigma1=sigma1+norm(A(i,:)-A(KNN(i,j),:));  % xxxx
            sigma2=sigma2+abs(i-KNN(i,j));
    end
    sigma1=sigma1/k;
    sigma2=sigma2/k;
    for h=2:k+1
            w(i,KNN(i,h))=(exp(-norm(A(i,:)-A(KNN(i,h),:))/(2*sigma1.^2)))*(exp(-abs(i-KNN(i,h))/(2*sigma2.^2)));
    end
end
w = (w+w')/2;
for i=1:m
    for j=1:m
        D(i,i)=D(i,i)+w(i,j);
    end
end
%I=eye(m);
%L=I-D^(-1/2)*w*D^(-1/2);
L=D-w;
end