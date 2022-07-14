function dst = inosculate_weighted(img1,img2,offset,c)

%: function : 加权融合重叠区域
%：param img1 : 画板重构后的参考图像
%：param img2 ：单应性变化后的匹配图像，和img1大小相同
%：param offset : 匹配图像端点单应性变化后的坐标
%: patam c : 参考图像的宽度（列数）
%：return dst : 加权融合后的图像
%======TODO========处理三通道 
   
    [row,col,~]=size(img1);

    seti = fix(min(offset));
    area_left = floor(seti(2));
    area_right = c;
    processWidth = area_right-area_left; % 重叠区域宽度
    
    overlap_region_img2 = img2(:,area_left:area_right);
    overlap_region_img1 = img1(:,area_left:area_right);
    overlap = zeros(row,processWidth+1); % 取出重叠区域并构建画板
    
    overlap(overlap_region_img2==0) = overlap_region_img1(overlap_region_img2==0); 
    % img2中无像素的点取img1中的像素
    
    [x , y] = find(overlap_region_img2~=0);
    alpha = (processWidth - y) ./ processWidth;
    
    for i=1:length(x)
         overlap(x(i), y(i)) = overlap_region_img1(x(i) , y(i)) * alpha(i) + overlap_region_img2(x(i) , y(i)) * (1 - alpha(i));
    end
    
    dst = [img1(:,1:area_left,:) , overlap , img2(:,area_right:col,:)];
    
end