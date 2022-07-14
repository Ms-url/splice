function out = splitJoint_middle(img1 ,img2 ,img5 , H12 ,H15 )
% function : 
% param img1 & img2 & img5: 大小相等的方阵（三维）
% param H : 单应性矩阵
% return : 

    [r,c,~] = size(img1);
    [h2,w2,~] = size(img2);
    [h5,w5,~] = size(img2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  计算偏移量，重构画板
    H12=H12';
    H15=H15';
    offset12=[1 1 1;1 w2 1;h2 1 1;h2 w2 1]*H12;
    offset15=[1 1 1;1 w5 1;h5 1 1;h5 w5 1]*H15;

    set12_max = max(offset12./offset12(:,3));
    set12_min = min(offset12./offset12(:,3));
    set15_max = max(offset15./offset15(:,3));
    set15_min = min(offset15./offset15(:,3));
    
%     left_excursion = floor(min([1,set12_min(2),set15_min(2)]));
%     if left_excursion<1
%         left_excursion = abs(left_excursion)+1; % 左偏移量
%     end
    up_excursion = floor(min([1,set12_min(1)-1e-8,set15_min(1)-1e-8]));%%%%%
    if up_excursion<1
        up_excursion = abs(up_excursion)+1;% 上偏移量
    end
%     right_excursion = ceil(max([c,set12_max(2),set15_max(2)])-c);% 右偏移量
    down_excursion = ceil(max([r,set12_max(1),set15_max(1)])-r);% 下偏移量
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    new_high = up_excursion + down_excursion + r ;
    change_picture1 = zeros(new_high ,r ,3); % 空白画板
    change_picture2 = zeros(new_high ,ceil(set12_max(2)-set12_min(2)),3);
    change_picture5 = zeros(new_high ,ceil(set15_max(2)-set15_min(2)),3);%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%
    for k=1:3
        for i=1:r
            for j=1:c
                change_picture1(i+up_excursion,j,k)=img1(i,j,k);
            end
        end
    end
    %%%%%%获得变换后的未插值图像
    change_picture2 = coordinateTransformation(img2, H12, change_picture2, up_excursion,set12_min(2));
    change_picture5 = coordinateTransformation(img5, H15, change_picture5, up_excursion,set15_min(2));
    change_picture2 = interpolation(change_picture2,new_high,set12_max(2)-set12_min(2));% 中位插值
    change_picture5 = interpolation(change_picture5,new_high,set15_max(2)-set15_min(2));% 中位插值
    col5 = ceil(set15_max(2)-set15_min(2));
   
    change_picture2 = double(change_picture2); 
    change_picture5 = double(change_picture5); 
   
    overlap_region_img1_5 = change_picture1(:,1:ceil(set15_max(2)),:);
    overlap_region_img5 = change_picture5(:,col5-floor(set15_max(2)):col5,:);
    overlap_region_img1_2 = change_picture1(:,floor(set12_min(2)):c,:);
    overlap_region_img2 = change_picture2(:,1:c-floor(set12_min(2))+1,:);
    
%     [overlap15,overlapz15] = inosculate_E(overlap_region_img1_5, overlap_region_img5, ceil(set15_max(2)));
%     [overlap12,overlapz12] = inosculate_E(overlap_region_img1_2, overlap_region_img2, c-floor(set12_min(2))+1);
    overlap15 = inosculate_weighted(overlap_region_img5, overlap_region_img1_5, ceil(set15_max(2)));
    overlap12 = inosculate_weighted(overlap_region_img1_2, overlap_region_img2, c-floor(set12_min(2))+1);    

    out=[change_picture5(up_excursion+1:up_excursion+r,1:col5-floor(set15_max(2)),:),...
        overlap15(up_excursion+1:up_excursion+r,:,:),...
        change_picture1(up_excursion+1:up_excursion+r,floor(set15_max(2)):floor(set12_min(2)),:),...
        overlap12(up_excursion+1:up_excursion+r,:,:),...
        change_picture2(up_excursion+1:up_excursion+r,c-floor(set12_min(2)):ceil(set12_max(2)-set12_min(2)),:)];
%     out=[change_picture5(:,1:col5-floor(set15_max(2)),:),...
%         overlap15(:,:,:),...
%         change_picture1(:,floor(set15_max(2)):floor(set12_min(2)),:),...
%         overlap12(:,:,:),...
%         change_picture2(:,c-floor(set12_min(2)):ceil(set12_max(2)-set12_min(2)),:)];    


end

function change_picture = coordinateTransformation(img, H, change_picture, up_excursion, left_min)
%
% return : 8进制图像
%
    change_picture = cast(change_picture,'uint8');
    for k=1:3
        [coordinate_x,coordinate_y] = find(img(:,:,k));
        coordinate = [coordinate_x,coordinate_y,ones(length(coordinate_y),1)];% 增加 z=1
        change = coordinate * H ;%进行坐标变化
        change(:,1) = change(:,1)./change(:,3);
        change(:,2) = change(:,2)./change(:,3); %获得变化后图像上对应的x，y值
        change = floor( change + eps );
        change(change(:,1:2)==0) = 1; %边界为零的点变为1，
        change_coordinate = change(:,1:2); %获得变换后得坐标位置
        
        imgc = img(:,:,k);
        for i=1:length(coordinate)
            change_picture(change_coordinate(i,1)+ up_excursion, change_coordinate(i,2)-floor(left_min)+1, k)=imgc(coordinate(i,1),coordinate(i,2));
        end
    end
    change_picture = cast(change_picture,'uint8');
    
end

function change_picture = interpolation(change_picture,size_r,size_c)
% param change_picture：8进制图像
% 中位数插值
    for k=1:3
        D = padarray(change_picture(:,:,k),[3 3],'replicate','both');%填充像素
        for i=4:size_r+3 
            for j=4:size_c+3 
                if D(i,j)==0 
                    no_zero=find(D(i-1:i+1,j-1:j+1)~=0); 
                    [m,~]=size(no_zero); 
                    if m~=0
                        B = D(i-1:i+1,j-1:j+1);
                    else
                        no_zero=find(D(i-2:i+2,j-2:j+2)~=0);
                        [m,~]=size(no_zero);
                        if m~=0
                            B = D(i-2:i+2,j-2:j+2);
                        else
                            no_zero = find(D(i-3:i+3,j-3:j+3)~=0);
                            B = D(i-3:i+3,j-3:j+3);
                        end % 对没有被填充的点进行处理
                    end
                    % 原没有被插值成功的像素点，以周围非零像素的中位数代替
                    medi = median(B(no_zero));
                    if isnan(medi)
                        change_picture(i-3,j-3,k) = 0;
                    else
                        change_picture(i-3,j-3,k) = medi;
                    end
                end
            end
        end
       
     end % 三通道处理，得到彩色图像
    
end


function overl = inosculate_weighted(overlap_region1,overlap_regionn,processWidth)

%: function : 加权融合重叠区域
%：return overl : 加权融合后的图像
   
    [row,~,~]=size(overlap_region1);
    overl = zeros(row,processWidth,3); 
    for k=1:3
        overlap_region_img1 = overlap_region1(:,:,k);
        overlap_region_imgn = overlap_regionn(:,:,k);
        overlap = zeros(row,processWidth); 
        
        overlap(overlap_region_imgn==0) = overlap_region_img1(overlap_region_imgn==0);
        % img2中无像素的点取img1中的像素
        
        [x , y] = find(overlap_region_imgn~=0);
        alpha = (processWidth - y) ./ processWidth;
        
        for i=1:length(x)
            overlap(x(i), y(i)) = overlap_region_img1(x(i) , y(i)) * alpha(i) + overlap_region_imgn(x(i) , y(i)) * (1 - alpha(i));
        end
        overl(:,:,k) = overlap;
        
    end
end
