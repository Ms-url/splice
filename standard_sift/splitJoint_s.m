function [dst,E,A] = splitJoint_s(img1 ,img2 ,H)
% function : 中位插值 ,调用缝合线融合inosculate_sutureLine
% param img1 & img2:
% param H : 单应性矩阵
% return : 

    [r,c,~] = size(img1);
    [h,w,~] = size(img2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  重构画板
    H=H';
    offset=[1 1 1;1 w 1;h 1 1;h w 1]*H;
  % set = max(offset)-min(offset);
    set = max(offset);
    size_r=floor(max(r,set(1)));
    size_c=floor(max(c,set(2)));
    change_picture_pad = zeros(size_r,size_c); %建立r×c的0矩阵（平移结果矩阵），初始化为零（黑色）
    change_picture = zeros(size_r,size_c);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:r
        for j=1:c
            change_picture_pad(i,j)=img1(i,j);
        end
    end
    
    % OutPicture = zeros(h,w,3);
    % OutPicture = cast(OutPicture,'uint8');

    tic;
    [coordinate_x,coordinate_y] = find(img2); %获得所有的坐标位置
    coordinate = [coordinate_x,coordinate_y,ones(length(coordinate_y),1)];% 增加 z=1
    
    change = coordinate * H ;%进行坐标变化
    change(:,1) = change(:,1)./change(:,3);
    change(:,2) = change(:,2)./change(:,3); %获得变化后图像上对应的x，y值
    change = floor( change + eps );
    
    change(change(:,1:2)==0) = 1; %边界为零的点变为1，
    change_coordinate = change(:,1:2); %获得变换后得坐标位置
    toc;
    
    % for k=1:3
    %     img = imgo(:,:,k);
    img = img2;
    for i=1:length(coordinate)
        if change_coordinate(i,1)<1||change_coordinate(i,2)<1||change_coordinate(i,1)>size_r||change_coordinate(i,2)>size_c
            continue
        end
        change_picture(change_coordinate(i,1),change_coordinate(i,2))=img(coordinate(i,1),coordinate(i,2));
    end % 将对应坐标的像素对应
    change_picture=cast(change_picture,'uint8');
    
    tic;
    D = padarray(change_picture,[3 3],'replicate','both');%填充像素
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
                    change_picture(i-3,j-3) = 0;
                else
                    change_picture(i-3,j-3) = medi;
                end
                % 原没有被插值成功的像素点，以周围非零像素的中位数代替
            end
        end
    end
    %     OutPicture(:,:,k)=change_picture_pad;
    % end % 三通道处理，得到彩色图像
    toc;
    
    dst = inosculate_sutureLine(change_picture_pad,change_picture,offset,c);
    [E,A] = inosculate_get_E(change_picture_pad,change_picture,offset,c);
    [dst,P,L] = inosculate_E_cut(change_picture_pad,change_picture,offset,c);
    figure(1);
    imshow(E,[]);
    figure(2);
    imshow(P,[]);
    figure(3)
    imshow(dst,[]);
    kl=90;

end