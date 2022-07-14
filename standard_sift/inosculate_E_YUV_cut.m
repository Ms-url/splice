function [dst,overlap,L] = inosculate_E_YUV_cut(imgor1,imgor2,offset,c)

%: function : 
%：param img1 : 画板重构后的参考图像
%：param img2 ：单应性变化后的匹配图像，和img1大小相同
%：param offset : 匹配图像端点单应性变化后的坐标
%: patam c : 参考图像的宽度（列数）
%：return E : 
% ======TODO========处理三通道 
% ======TODO========计算图像边与边的交点
     
    img2 = double(rbg2gray(imgor2)); 
    img1 = double(rbg2gray(imgor1)); 
     
    [row,col,~]=size(img1); 

    seti = fix(min(offset)); 
    area_left = floor(seti(2)); 
    area_right = c; 
    processWidth = area_right-area_left; % 重叠区域宽度 
     
    overlap_region_img2 = img2(:,area_left:area_right); 
    overlap_region_img1 = img1(:,area_left:area_right);% 重叠区域 
    overlap_gabout = zeros(row,processWidth+1);
    %%%%%%%%%%%%%% 
    tic
    
    overlap_color = overlap_region_img1 - overlap_region_img2; % 差分图像
    
    overlap_geometry_y = conv2(overlap_region_img1,[-2,-1,-2;0 0 0;2 1 2],'same') - conv2(overlap_region_img2,[-2,-1,-2;0 0 0;2 1 2],'same');
    overlap_geometry_x = conv2(overlap_region_img1,[-2,0,2;-1 0 1;-2 0 2],'same') - conv2(overlap_region_img2,[-2,0,2;-1 0 1;-2 0 2],'same');
    overlap_geometry = overlap_geometry_x + overlap_geometry_y;
   
    for i = 0:pi/8:pi*7/8
        [~,gabout1] = gaborfilter1(overlap_region_img1,5,5,0.2,i);
        [~,gabout2] = gaborfilter1(overlap_region_img2,5,5,0.2,i);
        overlap_gabout = overlap_gabout + gabout1 + gabout2;
    end

    E = abs((overlap_color + 0.35*overlap_geometry).* overlap_gabout) ;
   % E = abs((overlap_color + 0.35*overlap_geometry)) ;
    
    [L,NumLabels]=superpixels(overlap_region_img1,548);
    BW = boundarymask(L);
    figure(8);
    imshow(imoverlay(uint8(overlap_region_img1),BW,'cyan'),'InitialMagnification',87);
    
%     a = getDiagram(E,L,NumLabels);
%     [r,totla] = maxFlow( a , NumLabels );
%     rt = triu(r);
%     tra = minCut(rt, NumLabels );
%     
%     overlap = zeros(row,processWidth+1); % 取出重叠区域并构建画板
%     overlapz = zeros(row,processWidth+1);
%     for i=1:NumLabels
%         if tra(i)==1
%             overlap(L==i) = overlap_region_img2(L==i); 
%             overlapz(L==i) = 1; 
%         else
%             overlap(L==i) = overlap_region_img1(L==i); 
%             overlapz(L==i) = 0; 
%         end
%     end
%    % overlap(overlap==0)=overlap_region_img1(overlap==0);
%     overlapz(L==NumLabels) = 0.5; 
%     
%     dst = [img1(:,1:area_left,:) , overlap , img2(:,area_right:col,:)];
%     figure(9);
%     imshow(overlapz);
%     
end