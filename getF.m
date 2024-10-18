function [X] = getF(Dataset,nC,par)
img = Dataset.A; %三维图

[labels,~] = cubseg(img,nC);  % ERS超像素分割 范围0-(S-1) 返回各超像素标签
labels = labels + 1; % +1更变范围 1-S
idx = label2idx(labels); % 提取分割区域 得到每超像素块对应像素点
X1 = (Dataset.X)'; 
[m,n]=size(X1); % m 像素数, n 波段数

%par = 5; % 每个区域latent feature个数
opt.disp = 0;
X_temp = cell(1,nC);
for i = 1 : nC
    [r,c]=ind2sub([m,n],idx{i}); % 提取各区域内像素点位置和标签
    X_temp{i} = X1(r,:);  % 存储各区域像素点数据
end
LX = LP(X_temp); % 计算各区域对应拉普拉斯矩阵 每个X_temp是a*220
for num = 1 : nC
    LX(:,:,num) = (LX(:,:,num)+LX(:,:,num)')/2; % 针对每个区域，计算LX = (L+L')/2
    [Hp, Hv] = eigs(LX(:,:,num), par, 'la', opt); % 计算LX中前par个最大特征值对应的特征向量
    X(:,:,num) = Hp; % 保存了par*Sc个特征向量
end
[W, H, L]=size(X);
X = reshape(X, W, H * L); % 由所有区域特征向量组成新的数据矩阵
X = X./ repmat(sqrt(sum(X.^2, 2)),1, H * L);  % 归一化？

%[Z,obj]=Z_F(X');
%W=(abs(Z)+abs(Z'))/2;
%C= SpectralClustering(W, 5, 3);
%Y=SelectBandFromClusRes(C,5,X');
%a=func_SVM(5,Y,1025,indexes)
end