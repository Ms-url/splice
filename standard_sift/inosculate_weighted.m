function dst = inosculate_weighted(img1,img2,offset,c)

%: function : ��Ȩ�ں��ص�����
%��param img1 : �����ع���Ĳο�ͼ��
%��param img2 ����Ӧ�Ա仯���ƥ��ͼ�񣬺�img1��С��ͬ
%��param offset : ƥ��ͼ��˵㵥Ӧ�Ա仯�������
%: patam c : �ο�ͼ��Ŀ�ȣ�������
%��return dst : ��Ȩ�ںϺ��ͼ��
%======TODO========������ͨ�� 
   
    [row,col,~]=size(img1);

    seti = fix(min(offset));
    area_left = floor(seti(2));
    area_right = c;
    processWidth = area_right-area_left; % �ص�������
    
    overlap_region_img2 = img2(:,area_left:area_right);
    overlap_region_img1 = img1(:,area_left:area_right);
    overlap = zeros(row,processWidth+1); % ȡ���ص����򲢹�������
    
    overlap(overlap_region_img2==0) = overlap_region_img1(overlap_region_img2==0); 
    % img2�������صĵ�ȡimg1�е�����
    
    [x , y] = find(overlap_region_img2~=0);
    alpha = (processWidth - y) ./ processWidth;
    
    for i=1:length(x)
         overlap(x(i), y(i)) = overlap_region_img1(x(i) , y(i)) * alpha(i) + overlap_region_img2(x(i) , y(i)) * (1 - alpha(i));
    end
    
    dst = [img1(:,1:area_left,:) , overlap , img2(:,area_right:col,:)];
    
end