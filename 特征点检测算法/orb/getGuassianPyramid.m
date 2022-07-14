function GuassianPyramid = getGuassianPyramid(img,n,sigma0,octaves)

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
    [r,c]=size(img);
    if octaves == 0
        octaves = fix(log2(min(r,c))) - 3;
        if octaves > 6
            octaves = 6;
        end
    end
    k = 2^(1.0 / n);
 
    sigma=[];
    for o =0:octaves-1
        sigma=[sigma ;(k)*sigma0*(2^o)];
    end
    
    for o=1:octaves
       samplePyramid(o).octaves = img(1:2^(o-1):r,1:2^(o-1):c);
    end

    for i=1:octaves
%             dim = fix(6*sigma(i) + 1); % 高斯模板大小,朝零取整
%             if rem(dim,2) == 0 
%                 dim =dim + 1;
%             end
%          GuassianPyramid(i).octaves = conv2(samplePyramid(i).octaves , GuassianKernel(sigma(i) , dim),'same');
 GuassianPyramid(i).octaves = samplePyramid(i).octaves ;
    end

end
            
            
            
            
            
            
            
            
            
            
       
