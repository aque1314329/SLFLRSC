function [S, D] = InitializeSIGs(X, k, issymmetric)
% X: each column is a data point
% k: number of neighbors
% issymmetric: set S = (S+S')/2 if issymmetric=1
% S: similarity matrix, each row is a data point
% Ref: F. Nie, X. Wang, M. I. Jordan, and H. Huang, The constrained
% Laplacian rank algorithm for graph-based clustering, in AAAI, 2016.

if nargin < 3
    issymmetric = 1;
end
if nargin < 2
    k = 15;
end

[~, n] = size(X); %n为X列数
D = L2_distance_1(X, X); %计算两两数据点（波段所有特征）的欧式距离 （数据点为1*（par*Sc））
[~, idx] = sort(D, 2); % 每一行第一个节点为目标节点，其余结点与目标结点越近，排在越前面

S = zeros(n);
for i = 1:n
    id = idx(i,2:k+2);
    di = D(i, id);
    S(i,id) = (di(k+1)-di)/(k*di(k+1)-sum(di(1:k))+eps); % （max-xi）/（sum(max-xi)） % 归一化，S结果与中心越接近权重越大
end

if issymmetric == 1
    S = (S+S')/2;       % S变成对称矩阵
end