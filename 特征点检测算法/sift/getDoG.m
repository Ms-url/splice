function [DoG,GuassianPyramid]=getDoG(img,n,sigma0,stacks,octaves)

%%% warning %%%
% 图像过大时
% 建议 octaves 最大不超过 6
%%%%%%%%%%%%%%%

%:param img: the original img.
%:param sigma0: sigma of the first stack of the first octave. default 1.52 for complicate reasons.
%:param n: how many stacks of feature that you want to extract.
%:param stacks: how many stacks does every octave have. stacks must bigger than 3.
%:param k: the ratio of two adjacent stacks' scale.
%:param octaves: how many octaves do we have.
%:return: the DoG Pyramid
  
    [r,c,~]=size(img);
    if stacks == 0
        stacks = n + 3;
    end
    if octaves == 0
        octaves = fix(log2(min(r,c))) - 3;
        if octaves > 5
            octaves = 5;
        end
    end
    k = 2^(1.0 / n);
 
    sigma=[];
    for o =0:octaves-1
        tump=[];
        for  s = 0:stacks-1
           tump = [tump;(k^s)*sigma0*(2^o)];
        end
        sigma=[sigma ; tump'];
    end
    
    for o=1:octaves
       samplePyramid(o).octaves = img(1:2^(o-1):r,1:2^(o-1):c);
    end

    for i=1:octaves
        for j=1:stacks
            dim = fix(6*sigma(i,j) + 1); % 高斯模板大小,朝零取整
            if rem(dim,2) == 0 
                dim =dim + 1;
            end
            temp(j).stacks = conv2(samplePyramid(i).octaves , GuassianKernel(sigma(i,j) , dim),'same');

        end
        GuassianPyramid(i).octaves = temp ;
    end
    
        for o=1:octaves
            for s=1:stacks-1
                tkmp(s).stacks = GuassianPyramid(o).octaves(s+1).stacks - GuassianPyramid(o).octaves(s).stacks ;
            end
            DoG(o).octaves = tkmp ;
        end

end
            
            
            
            
            
            
            
            
            
            
       
