function [L,W] = get_Laplice2(F,par,theta)
%kn      k近邻
%theta   同类相似度参数

%% 构建相似度矩阵
[~,n] = size(F);
kn = 0.3*n;            %设置k近邻个数
%W = zeros(n,n);
C = LLC_coding_appr(F',F',n,1e-4);    %LLC方法求解稀疏自表示矩阵

W = zeros(n,n);
results = getr(F,kn);                 %求k近邻坐标
for i = 1:n
    for j = max(i-par,1):min(i+par,n)    %扩大搜索范围
        p = fix(i-1)/par;
        if j>p*par && j<=(p+1)*par        %同类
            dist = norm(F(:,i)-F(:,j));
            W(i,j) = theta*C(i,j)/dist;
        end
    end
    for j = 1:kn                 %异类且k近邻
        results(i,j)
         dist = norm(F(:,i)-F(:,results(i,j)));
        W(i,results(i,j)) = C(i,results(i,j))/dist;
    end
    W(i,i) = 0;
end
%% 构建标准化拉普拉斯矩阵
D = diag(sum(W,2));        %度矩阵
I = eye(n,n);
L = I - D^(-1/2)*W*D^(-1/2);