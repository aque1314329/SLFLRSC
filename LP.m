
function KH = LP(X)

v = length(X);   % nC数量
n = size(X{1},2);%波段数

%将每个数据点减去其波段上的均值，然后除以波段上的标准差
for i = 1 :v
    X{i} = X{i}';%转置，每行是一波段
    for  j = 1:n
        X{i}(j,:) = ( X{i}(j,:) - mean( X{i}(j,:) ) ) / std( X{i}(j,:) ) ;
    end
end

KH = zeros(n,n,v);
for idx = 1 : v
    A0 = constructW_PKN(X{idx}',10);
    A0 = A0-diag(diag(A0));
    A10 = (A0+A0')/2;
    D10 = diag(1./sqrt(sum(A10, 2)));
    KH(:,:,idx) = D10*A10*D10;  % 计算拉普拉斯矩阵
    
    %     dist = EuDist2(X{idx},X{idx},0);
    %     sigma = mean(min(dist,[],2).^0.5)*2;
    %     feaVec = exp(-dist/(2*sigma*sigma));
    %     KH(:,:,idx) = feaVec;
end

end