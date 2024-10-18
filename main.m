function [Y]=main(nc)
%nc represents the number of superpixel blocks
Dataset=get_data(1);
F = getF(Dataset,nc,5);
BandK = 5 : 5 : 30;
[Z,obj] = Z_knn_F(0.001,1,100,5,7,F);
for iBand = 1:length(BandK)
    kk= BandK(iBand);
    C= clu_ncut(Z, kk);
    Y=SelectBandFromClusResE(C,kk,Dataset.X);
end