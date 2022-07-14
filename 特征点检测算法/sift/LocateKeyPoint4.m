function KeyPoints = LocateKeyPoint4(DoG,sigma,GuassianPyramid,n)

% :param DoG: DoG Pyramid of the original img
% :param sigma: default sigma 1.6
% :param GuassianPyramid: the GuassianPyramid of the original img
% :param n: how many stacks of feature that you want to extract.
% :param BinNum: 1 direction per 10 degrees ,a total of 36 direction
% return :

    T = 0.04;
    %%%%%%%%%
    %减少方向提高速率
    binNum = 36 ; % 确定主方向时方向个数（直方图个数）
    %%%%%%%%%
    edgeThreshold = 10.0; % 边缘阈值
    SIFT_FIXPT_SCALE = 1; % 尺度(步长）
    threshold = 0.5*T/(n*SIFT_FIXPT_SCALE); % 阈值
    
    KeyPoints = [];
    [~,octaves,~] = size(DoG);

     for o=1:octaves
         
         img_1 = DoG(o).octaves(1).stacks;
         img_2 = DoG(o).octaves(2).stacks;
         img_3 = DoG(o).octaves(3).stacks;
         img_4 = DoG(o).octaves(4).stacks;
         img_5 = DoG(o).octaves(5).stacks;
         
         [r,c,~]=size(img_1);
         
         for i = 2:r
             for j = 2:c
                 val_2 = img_2(i,j);
                 val_3 = img_3(i,j);
                 val_4 = img_4(i,j);
                 eight_neiborhood_1 = img_1(max(1, i - 1):min(i + 1, r ), max(1, j - 1):min(j + 1,c ));
                 eight_neiborhood_2 = img_2(max(1, i - 1):min(i + 1, r ), max(1, j - 1):min(j + 1, c ));
                 eight_neiborhood_3 = img_3(max(1, i - 1):min(i + 1, r), max(1, j - 1):min(j + 1, c ));
                 eight_neiborhood_4 = img_4(max(1, i - 1):min(i + 1, r), max(1, j - 1):min(j + 1, c ));
                 eight_neiborhood_5 = img_5(max(1, i - 1):min(i + 1, r), max(1, j - 1):min(j + 1, c ));
                 
                 
                 if abs(val_2) > threshold &&...
                         ((val_2 > 0 && val_2 >= max(max(eight_neiborhood_1)) &&...
                         val_2 >= max(max(eight_neiborhood_2)) && val_2 >= max(max(eight_neiborhood_3)))...
                         || (val_2 < 0 && val_2 <= min(min(eight_neiborhood_1)) &&...
                         val_2 <= min(min(eight_neiborhood_2)) && val_2 <= min(min(eight_neiborhood_3))))
                     
                     [point,x,y,layer] = adjustLocalExtrema(DoG, o, 2, i, j, T, edgeThreshold, sigma, n, SIFT_FIXPT_SCALE);
                     
                     if point == 0
                         continue
                     end
                     
                     sigma1 = sigma*2^((o+layer)/(n+3));
                     %[direction ,nx] = GetMainDirection(GuassianPyramid(o).octaves(layer).stacks , x , y , sigma1 ,binNum );
                     [direction ,nx] = GetMainDirection2(GuassianPyramid(o).octaves(layer).stacks , x , y , sigma1 ,binNum );
                     if nx == 0
                         continue
                     end
                     
                     for hu=1:nx
                         KeyPoints =[KeyPoints;point,direction(nx)];
                     end
                     
                 elseif abs(val_3) > threshold &&...
                         ((val_3 > 0 && val_3 >= max(max(eight_neiborhood_2)) &&...
                         val_3 >= max(max(eight_neiborhood_3)) && val_3 >= max(max(eight_neiborhood_4)))...
                         || (val_3 < 0 && val_3 <= min(min(eight_neiborhood_2)) &&...
                         val_3 <= min(min(eight_neiborhood_3)) && val_3 <= min(min(eight_neiborhood_4))))
                     
                     [point,x,y,layer] = adjustLocalExtrema(DoG, o, 3, i, j, T, edgeThreshold, sigma, n, SIFT_FIXPT_SCALE);
                     
                     if point == 0
                         continue
                     end
                     
                     sigma1 = sigma*2^((o+layer)/(n+3));
                    %[direction ,nx] = GetMainDirection(GuassianPyramid(o).octaves(layer).stacks , x , y , sigma1 ,binNum );
                     [direction ,nx] = GetMainDirection2(GuassianPyramid(o).octaves(layer).stacks , x , y , sigma1 ,binNum );
                     if nx == 0
                         continue
                     end
                     
                     for hu=1:nx
                         KeyPoints =[KeyPoints;point,direction(nx)];
                     end
                     
                 elseif abs(val_4) > threshold &&...
                         ((val_4 > 0 && val_4 >= max(max(eight_neiborhood_3)) &&...
                         val_4 >= max(max(eight_neiborhood_4)) && val_4 >= max(max(eight_neiborhood_5)))...
                         || (val_2 < 0 && val_4 <= min(min(eight_neiborhood_3)) &&...
                         val_4 <= min(min(eight_neiborhood_4)) && val_4 <= min(min(eight_neiborhood_5))))
                     
                     [point,x,y,layer] = adjustLocalExtrema(DoG, o, 4, i, j, T, edgeThreshold, sigma, n, SIFT_FIXPT_SCALE);
                     
                     if point == 0
                         continue
                     end
                     
                     sigma1 = sigma*2^((o+layer)/(n+3));
                    %[direction ,nx] = GetMainDirection(GuassianPyramid(o).octaves(layer).stacks , x , y , sigma1 ,binNum );
                     [direction ,nx] = GetMainDirection2(GuassianPyramid(o).octaves(layer).stacks , x , y , sigma1 ,binNum );
                     if nx == 0
                         continue
                     end
                     
%                      for hu=1:nx
                         KeyPoints =[KeyPoints;point,direction(nx)];
%                      end
                     
                 end
             end
         end
     end
end

