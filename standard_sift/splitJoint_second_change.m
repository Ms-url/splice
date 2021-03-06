function out = splitJoint_second_change(img2 ,H)
%
%img : 三维
%

    [h,w,~] = size(img2);
    H = H';
    offset=[1 1 1;1 w 1;h 1 1;h w 1]*H;
    set_max = max(offset./offset(:,3));
    set_min = min(offset./offset(:,3));
    
    left_excursion = floor(min([1,set_min(2)]));
    if left_excursion<1
        left_excursion = abs(left_excursion)+1; % 左偏移量
    end
    up_excursion = floor(min([1,set_min(1)]));%%%%%
    if up_excursion<1
        up_excursion = abs(up_excursion)+1;% 上偏移量
    end
    right_excursion = ceil(max([w,set_max(2)])-w);% 右偏移量
    down_excursion = ceil(max([h,set_max(1)])-h);% 下偏移量
    
    new_high = up_excursion + down_excursion + h ;
    
    change_picture2 = zeros(new_high ,ceil(set_max(2)-set_min(2)),3);
    change_picture2 = coordinateTransformation(img2, H, change_picture2, up_excursion,set_min(2));
    change_picture2 = interpolation(change_picture2,new_high,set_max(2)-set_min(2));% 中位插值
    out = change_picture2;
    
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

