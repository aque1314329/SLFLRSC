function [Dataset] = get_data(id)
    %% import the dataset
    if(id==1)
            A = importdata('Indian_pines.mat');
            ground_truth = importdata('Indian_pines_gt.mat');
    end
       % case 'Salinas'
         %   A = importdata('Salinas.mat');
          %  ground_truth = importdata('Salinas_gt.mat');
       % case 'Pavia_University'
       if(id==2)
            A = importdata('PaviaU.mat');
            ground_truth = importdata('PaviaU_gt.mat');   
       end
       if(id==3)
            A = importdata('DC_mall.mat');
            ground_truth = importdata('DC_gt.mat');   
       end
       if(id==4)
            A = importdata('Houston_img.mat');
            ground_truth = importdata('Houston_gt.mat');   
       end
        if(id==5)
            A = importdata('HongHu.mat');
            ground_truth = importdata('HongHu_gt.mat');   
       end
        %case 'KSC'
         %   A = importdata('KSC.mat');
          %  ground_truth = importdata('KSC_gt.mat');
        %case 'Botswana'
         %   A = importdata('Botswana.mat');
          %  ground_truth = importdata('Botswana_gt.mat');
    %end
    %% definition and initialization
    A = double(A);
    minv = min(A(:));
    maxv = max(A(:));
    A = double(A - minv) / double(maxv - minv);
    
    %% Generalize the output
    X = permute(A, [3, 1, 2]);
    X = X(:, :);
    Dataset.X = X; 
    Dataset.A = A;
    Dataset.ground_truth = ground_truth;
end