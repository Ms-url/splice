function out = splitJoint_second_one(img2 ,H)
    [h,w,~] = size(img2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  重构画板
    H=H';
    offset=[1 1 1;1 w 1;h 1 1;h w 1]*H;
    offset = offset./offset(:,3);
    set1 = max(offset);
    set2 = min(offset);
    size_r=floor(set1(1));
    size_c=floor(set1(2));
    change_picture = zeros(size_r,size_c,3);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%      OutPicture = zeros(size_r,size_c,3);
%      OutPicture = cast(OutPicture,'uint8');
     
    for k=1:3
        [coordinate_x,coordinate_y] = find(img2(:,:,k)); %获得所有的坐标位置
        coordinate = [coordinate_x,coordinate_y,ones(length(coordinate_y),1)];% 增加 z=1
        
        change = coordinate * H ;%进行坐标变化
        change(:,1) = change(:,1)./change(:,3);
        change(:,2) = change(:,2)./change(:,3); %获得变化后图像上对应的x，y值
        change = floor( change + eps );
        
        change(change(:,1:2)==0) = 1; %边界为零的点变为1，
        change_coordinate = change(:,1:2); %获得变换后得坐标位置
        
        img = img2(:,:,k);
        
        for i=1:length(coordinate)
            if change_coordinate(i,1)<1||change_coordinate(i,2)<1||change_coordinate(i,1)>size_r||change_coordinate(i,2)>size_c
                continue
            end
            change_picture(change_coordinate(i,1),change_coordinate(i,2),k)=img(coordinate(i,1),coordinate(i,2));
        end 
        change_picture=cast(change_picture,'uint8');
    end
    
    for k=1:3 
        D = padarray(change_picture(:,:,k),[3 3],'replicate','both');%填充像素
        for i=4:size_r+3
            for j=floor(offset(1,2))+4:size_c+3
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
                        end
                        % 对没有被填充的点进行处理
                    end
                    
                    medi = median(B(no_zero));
                    if isnan(medi)
                        change_picture(i-3,j-3,k) = 0;
                    else
                        change_picture(i-3,j-3,k) = medi;
                    end
                    % 原没有被插值成功的像素点，以周围非零像素的中位数代替
                end
            end
        end
    end % 三通道处理，得到彩色图像
    out = change_picture(1:set1(1),fix(set2(2)):fix(set1(2)),:);
end