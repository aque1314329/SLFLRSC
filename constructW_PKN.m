% construct similarity matrix with probabilistic k-nearest neighbors. It is a parameter free, distance consistent similarity.
function W = constructW_PKN(X, k, issymmetric)
% X: each column is a data point
% k: number of neighbors
% issymmetric: set W = (W+W')/2 if issymmetric=1
% W: similarity matrix

if nargin < 3
    issymmetric = 1;
end;
if nargin < 2
    k = 5;
end;

[dim, n] = size(X);
D = L2_distance_1(X, X); % 计算X行之间的距离，即波段间的距离
[dumb, idx] = sort(D, 2); % sort each row  选离中心点最近的像素

W = zeros(n);
for i = 1:n
    id = idx(i,2:k+2);  %% 获得k近邻索引。这一步原文其实算的不准，可改进（sxd 20230423）
    di = D(i, id); %% 获取k近邻对应距离
    W(i,id) = (di(k+1)-di)/(k*di(k+1)-sum(di(1:k))+eps); %% 这一步的意思有待进一步探究？？ sxd
end;

if issymmetric == 1
    W = (W+W')/2; %% 经过操作，W变成对角矩阵
end;




% compute squared Euclidean distance
% ||A-B||^2 = ||A||^2 + ||B||^2 - 2*A'*B
function d = L2_distance_1(a,b)
% a,b: two matrices. each column is a data
% d:   distance matrix of a and b



if (size(a,1) == 1)
  a = [a; zeros(1,size(a,2))]; 
  b = [b; zeros(1,size(b,2))]; 
end

aa=sum(a.*a); bb=sum(b.*b); ab=a'*b; 
d = repmat(aa',[1 size(bb,2)]) + repmat(bb,[size(aa,2) 1]) - 2*ab;

d = real(d);
d = max(d,0);

% % force 0 on the diagonal? 
% if (df==1)
%   d = d.*(1-eye(size(d)));
% end





