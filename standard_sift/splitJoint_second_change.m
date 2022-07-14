function out = splitJoint_second_change(img2 ,H)
%
%img : ��ά
%

    [h,w,~] = size(img2);
    H = H';
    offset=[1 1 1;1 w 1;h 1 1;h w 1]*H;
    set_max = max(offset./offset(:,3));
    set_min = min(offset./offset(:,3));
    
    left_excursion = floor(min([1,set_min(2)]));
    if left_excursion<1
        left_excursion = abs(left_excursion)+1; % ��ƫ����
    end
    up_excursion = floor(min([1,set_min(1)]));%%%%%
    if up_excursion<1
        up_excursion = abs(up_excursion)+1;% ��ƫ����
    end
    right_excursion = ceil(max([w,set_max(2)])-w);% ��ƫ����
    down_excursion = ceil(max([h,set_max(1)])-h);% ��ƫ����
    
    new_high = up_excursion + down_excursion + h ;
    
    change_picture2 = zeros(new_high ,ceil(set_max(2)-set_min(2)),3);
    change_picture2 = coordinateTransformation(img2, H, change_picture2, up_excursion,set_min(2));
    change_picture2 = interpolation(change_picture2,new_high,set_max(2)-set_min(2));% ��λ��ֵ
    out = change_picture2;
    
end

function change_picture = coordinateTransformation(img, H, change_picture, up_excursion, left_min)
%
% return : 8����ͼ��
%
    change_picture = cast(change_picture,'uint8');
    for k=1:3
        [coordinate_x,coordinate_y] = find(img(:,:,k));
        coordinate = [coordinate_x,coordinate_y,ones(length(coordinate_y),1)];% ���� z=1
        change = coordinate * H ;%��������仯
        change(:,1) = change(:,1)./change(:,3);
        change(:,2) = change(:,2)./change(:,3); %��ñ仯��ͼ���϶�Ӧ��x��yֵ
        change = floor( change + eps );
        change(change(:,1:2)==0) = 1; %�߽�Ϊ��ĵ��Ϊ1��
        change_coordinate = change(:,1:2); %��ñ任�������λ��
        
        imgc = img(:,:,k);
        for i=1:length(coordinate)
            change_picture(change_coordinate(i,1)+ up_excursion, change_coordinate(i,2)-floor(left_min)+1, k)=imgc(coordinate(i,1),coordinate(i,2));
        end
    end
    change_picture = cast(change_picture,'uint8');
    
end

function change_picture = interpolation(change_picture,size_r,size_c)
% param change_picture��8����ͼ��
% ��λ����ֵ
    for k=1:3
        D = padarray(change_picture(:,:,k),[3 3],'replicate','both');%�������
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
                        end % ��û�б����ĵ���д���
                    end
                    % ԭû�б���ֵ�ɹ������ص㣬����Χ�������ص���λ������
                    medi = median(B(no_zero));
                    if isnan(medi)
                        change_picture(i-3,j-3,k) = 0;
                    else
                        change_picture(i-3,j-3,k) = medi;
                    end
                end
            end
        end
       
     end % ��ͨ�������õ���ɫͼ��
end

