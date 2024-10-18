function [Y] = SelectBandFromClusResE(lable, K, img)
% img: d*N
Y = [];
for i=1:K
    index = find(lable==i);
    tempdata = img(index,:);
    E = Entrop(tempdata);
    [dumb idx] = sort(E,'descend');
    Y = [Y,index(idx(1))];
end