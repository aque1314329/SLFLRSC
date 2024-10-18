function [L]=get_Lap(A,k)
[m,n]=size(A);
KNN=zeros(m,k+1);
w=zeros(m);
D=zeros(m);

for i=1:m
    KNN(i,:)=knnsearch(A,A(i,:),'k',k+1);
end

for i=1:m
    sigma=0;
    for j=2:k+1
            sigma=sigma+norm(A(i,:)-A(KNN(i,j),:));  % xxxx
    end
    sigma=sigma/k;
    for h=2:k+1
            w(i,KNN(i,h))=exp(-norm(A(i,:)-A(KNN(i,h),:))/(2*(sigma.^2)));
    end
end
w = (w+w')/2;
for i=1:m
    for j=1:m
        D(i,i)=D(i,i)+w(i,j);
    end
end
L= D-w;
end