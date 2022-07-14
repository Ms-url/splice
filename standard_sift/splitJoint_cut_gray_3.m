function Out = splitJoint_cut_gray_3(img1 ,img2 ,H)
%
%img : ��ά
%

    [r,c,~] = size(img1);
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
    right_excursion = ceil(max([c,set_max(2)])-c);% ��ƫ����
    down_excursion = ceil(max([r,set_max(1)])-r);% ��ƫ����
    
    new_high = up_excursion + down_excursion + r ;
    
    change_picture1 = zeros(new_high ,r ,3); % �հ׻���
    change_picture2 = zeros(new_high ,ceil(set_max(2)-set_min(2)),3);
    
    %%%%%%%%%%
    for k=1:3
        for i=1:r
            for j=1:c
                change_picture1(i+up_excursion,j,k)=img1(i,j,k);
            end
        end
    end

    change_picture2 = coordinateTransformation(img2, H, change_picture2, up_excursion,set_min(2));
    change_picture2 = interpolation(change_picture2,new_high,set_max(2)-set_min(2));% ��λ��ֵ
    
    ovl = ceil(set_min(2))+1;
    ovr = floor(set_max(2)-set_min(2)-right_excursion);
    if c-ovl-ovr<=0
         ovl = ovl+ c-ovl-ovr +1; 
    end
    overlap1 = change_picture1(:,ovl:c,:);
    overlap2 = change_picture2(:,1:ovr,:);
    [overlap_tra,NumLabels,L] = inosculate_E_gray_cut(overlap1, overlap2, ovr);%�������ͼ
    overlap = t(overlap_tra,overlap1, overlap2, ovr,NumLabels,L);
    
    Out = [ change_picture1(:,1:ceil(set_min(2)),:),...
          overlap,...
          change_picture2(:,ceil(set_max(2)-set_min(2)-right_excursion):floor(set_max(2)-set_min(2)),:)];
    
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

function [tra,NumLabels,L] = inosculate_E_gray_cut(overlap_region1,overlap_regionn,processWidth)

%: function : 
%��param img1 : �ص�����3x3
%��param img2 ����Ӧ�Ա仯���ƥ��ͼ���ص�����3x3
%��
%��return E : 
% ======TODO========������ͨ�� 
% ======TODO========����ͼ�����ߵĽ���
    [row,~,~]=size(overlap_regionn);
%     overlap_region_img2 = double(rgb2gray(overlap_regionn));
%     overlap_region_img1 = double(rgb2gray(uint8(overlap_region1))); %�ص�����Ҷ�ͼ
     overlap_region_img2 = double(overlap_regionn(:,:,1));
     overlap_region_img1 = double(overlap_region1(:,:,1));
    
    overlap_gabout = zeros(row,processWidth);
    %%%%%%%%%%%%%% 
    tic
    overlap_color = overlap_region_img1 - overlap_region_img2; % ���ͼ��
    overlap_geometry_y = conv2(overlap_region_img1,[-2,-1,-2;0 0 0;2 1 2],'same') - conv2(overlap_region_img2,[-2,-1,-2;0 0 0;2 1 2],'same');
    overlap_geometry_x = conv2(overlap_region_img1,[-2,0,2;-1 0 1;-2 0 2],'same') - conv2(overlap_region_img2,[-2,0,2;-1 0 1;-2 0 2],'same');
    overlap_geometry = overlap_geometry_x + overlap_geometry_y;
   
    for i = 0:pi/8:pi*7/8
        [~,gabout1] = gaborfilter1(overlap_region_img1,5,5,0.2,i);
        [~,gabout2] = gaborfilter1(overlap_region_img2,5,5,0.2,i);
        overlap_gabout = overlap_gabout + gabout1 + gabout2;
    end

    E = abs((overlap_color + 0.35*overlap_geometry).* overlap_gabout) ;
    
    [L,NumLabels]=superpixels(overlap_region_img1,548);
    BW = boundarymask(L);
    figure(8);
    imshow(imoverlay(uint8(overlap_region_img1),BW,'cyan'),'InitialMagnification',87);
    a = getDiagram(E,L,NumLabels);
    [r,total] = maxFlow( a , NumLabels );
    rt = triu(r);
    tra = minCut(rt, NumLabels );
end

function overlap_out = t(tra,overlap_region_img1,overlap_region_img2,processWidth,NumLabels,L)
%
% img 3x3
%
    [row,~,~]=size(overlap_region_img1);
    overlap_out = zeros(row,processWidth,3); % ȡ���ص����򲢹�������
    overlapz_out = zeros(row,processWidth,3);
    for k=1:3
        overlap_region_img22 = overlap_region_img2(:,:,k);
        overlap_region_img11 = overlap_region_img1(:,:,k);
        overlap = overlap_out(:,:,k);
        overlapz = overlapz_out(:,:,k);
        for i=1:NumLabels
            if tra(i)==1
                overlap(L==i) = overlap_region_img22(L==i);
                overlapz(L==i) = 1;
            else
                overlap(L==i) = overlap_region_img11(L==i);
                overlapz(L==i) = 0;
            end
        end
        overlap_out(:,:,k) = overlap;
        overlapz_out(:,:,k) = overlapz ;
    end
    
   %overlap(overlap==0)=overlap_region_img1(overlap==0);
    overlapz(L==NumLabels) = 0.5; 
    
    figure(9);
    imshow(overlapz);
    
end
