function out = splitJoint_middle(img1 ,img2 ,img5 , H12 ,H15 )
% function : 
% param img1 & img2 & img5: ��С��ȵķ�����ά��
% param H : ��Ӧ�Ծ���
% return : 

    [r,c,~] = size(img1);
    [h,w,~] = size(img2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  ����ƫ�������ع�����
    H12=H12';
    H15=H15';
    offset12=[1 1 1;1 w 1;h 1 1;h w 1]*H12;
    offset15=[1 1 1;1 w 1;h 1 1;h w 1]*H15;

    set12_max = max(offset12./offset12(:,3));
    set12_min = min(offset12./offset12(:,3));
    set15_max = max(offset15./offset15(:,3));
    set15_min = min(offset15./offset15(:,3));
    
%     left_excursion = floor(min([1,set12_min(2),set15_min(2)]));
%     if left_excursion<1
%         left_excursion = abs(left_excursion)+1; % ��ƫ����
%     end
    up_excursion = floor(min([1,set12_min(1),set15_min(1)]));%%%%%
    if up_excursion<1
        up_excursion = abs(up_excursion)+1;% ��ƫ����
    end
%     right_excursion = ceil(max([c,set12_max(2),set15_max(2)])-c);% ��ƫ����
    down_excursion = ceil(max([r,set12_max(1),set15_max(1)])-r);% ��ƫ����
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    new_high = up_excursion + down_excursion + r ;
    change_picture1 = zeros(new_high ,r ,3); % �հ׻���
    change_picture2 = zeros(new_high ,ceil(set12_max(2)-set12_min(2)),3);
    change_picture5 = zeros(new_high ,ceil(set15_max(2)-set15_min(2)),3);%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%
    for k=1:3
        for i=1:r
            for j=1:c
                change_picture1(i + up_excursion,j,k)=img1(i,j,k);
            end
        end
    end
    %%%%%%��ñ任���δ��ֵͼ��
    change_picture2 = coordinateTransformation(img2, H12, change_picture2, up_excursion,set12_min(2));
    change_picture5 = coordinateTransformation(img5, H15, change_picture5, up_excursion,set15_min(2));
    change_picture2 = interpolation(change_picture2,new_high,set12_max(2)-set12_min(2));% ��λ��ֵ
    change_picture5 = interpolation(change_picture5,new_high,set15_max(2)-set15_min(2));% ��λ��ֵ
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

    out=[change_picture5(:,1:col5-floor(set15_max(2)),:),...
        overlap15,...       
        change_picture1(:,floor(set15_max(2)):floor(set12_min(2)),:),...
        overlap12,...
        change_picture2(:,c-floor(set12_min(2)):ceil(set12_max(2)-set12_min(2)),:)];
    
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

 function [overlap,overlapz] = inosculate_E(overlap_region1,overlap_regionn,processWidth)

%: function : 
%�� processWidth : �ص������� 
%��
    [row,~,~]=size(overlap_region1);
    overlap = zeros(row,processWidth,3); % ȡ���ص����򲢹�������
    overlapz = zeros(row,processWidth,3);

    for k = 1:3
        overlap_region_img1 = overlap_region1(:,:,k);
        overlap_region_imgn = overlap_regionn(:,:,k);

        overlap_gabout = zeros(row , processWidth);
        %%%%%%%%%%%%%%
        
        overlap_color = overlap_region_img1 - overlap_region_imgn; % ���ͼ��
        overlap_geometry_y = conv2(overlap_region_img1,[-2,-1,-2;0 0 0;2 1 2],'same') - conv2(overlap_region_imgn,[-2,-1,-2;0 0 0;2 1 2],'same');
        overlap_geometry_x = conv2(overlap_region_img1,[-2,0,2;-1 0 1;-2 0 2],'same') - conv2(overlap_region_imgn,[-2,0,2;-1 0 1;-2 0 2],'same');
        overlap_geometry = overlap_geometry_x + overlap_geometry_y;
        
        for i = 0:pi/8:pi*7/8
            [~,gabout1] = gaborfilter1(overlap_region_img1,5,5,0.2,i);
            [~,gabout2] = gaborfilter1(overlap_region_imgn,5,5,0.2,i);
            overlap_gabout = overlap_gabout + gabout1 + gabout2;
        end
        
        E = abs((overlap_color + 0.35*overlap_geometry).* overlap_gabout) ;
        
        [L,NumLabels]=superpixels(overlap_region_img1,548);
        BW = boundarymask(L);
%         figure(8);
%         imshow(imoverlay(overlap_region_img1,BW,'cyan'),'InitialMagnification',67);
        
        a = getDiagram(E,L,NumLabels);
        [r,totla] = maxFlow( a , NumLabels );
        rt = triu(r);
        tra = minCut(rt, NumLabels );
        
        overl = overlap(:,:,k);
        overlz = overlapz(:,:,k);
        for i=1:NumLabels
            if tra(i)==1
                overl(L==i) = overlap_region_imgn(L==i);
                overlz(L==i) = 1;
            else
                overl(L==i) = overlap_region_img1(L==i);
                overlz(L==i) = 0;
            end
        end
        overlz(L==NumLabels) = 0.5;
        overlap(:,:,k) = overl;
        overlapz(:,:,k) = overlz;
    end
end

function overl = inosculate_weighted(overlap_region1,overlap_regionn,processWidth)

%: function : ��Ȩ�ں��ص�����
%��return overl : ��Ȩ�ںϺ��ͼ��
   
    [row,~,~]=size(overlap_region1);
    overl = zeros(row,processWidth,3); 
    for k=1:3
        overlap_region_img1 = overlap_region1(:,:,k);
        overlap_region_imgn = overlap_regionn(:,:,k);
        overlap = zeros(row,processWidth); 
        
        overlap(overlap_region_imgn==0) = overlap_region_img1(overlap_region_imgn==0);
        % img2�������صĵ�ȡimg1�е�����
        
        [x , y] = find(overlap_region_imgn~=0);
        alpha = (processWidth - y) ./ processWidth;
        
        for i=1:length(x)
            overlap(x(i), y(i)) = overlap_region_img1(x(i) , y(i)) * alpha(i) + overlap_region_imgn(x(i) , y(i)) * (1 - alpha(i));
        end
        overl(:,:,k) = overlap;
        
    end
end
