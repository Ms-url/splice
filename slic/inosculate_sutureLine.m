function E = inosculate_sutureLine(img1,img2,offset,c)

%: function : E
%��param img1 : �����ع���Ĳο�ͼ��
%��param img2 ����Ӧ�Ա仯���ƥ��ͼ�񣬺�img1��С��ͬ
%��param offset : ƥ��ͼ��˵㵥Ӧ�Ա仯�������
%: patam c : �ο�ͼ��Ŀ�ȣ�������
%��return dst : ��Ȩ�ںϺ��ͼ��
%======TODO========������ͨ�� 
%======TODO========����ͼ�����ߵĽ���
     
    img2 = double(img2); 
    img1 = double(img1); 
     
    [row,col,~]=size(img1); 

    seti = fix(min(offset)); 
    area_left = floor(seti(2)); 
    area_right = c; 
    processWidth = area_right-area_left; % �ص������� 
     
    overlap_region_img2 = img2(:,area_left:area_right); 
    overlap_region_img1 = img1(:,area_left:area_right);% �ص����� 
    overlap_gabout = zeros(row,processWidth+1);
    %%%%%%%%%%%%%% 
    tic
    overlap_color = overlap_region_img1 - overlap_region_img2; % ���ͼ��
    overlap_geometry_y = conv2(overlap_region_img1,[-2,-1,-2;0 0 0;2 1 2],'same') - conv2(overlap_region_img2,[-2,-1,-2;0 0 0;2 1 2],'same');
    overlap_geometry_x = conv2(overlap_region_img1,[-2,0,2;-1 0 1;-2 0 2],'same') - conv2(overlap_region_img2,[-2,0,2;-1 0 1;-2 0 2],'same');
    overlap_geometry = overlap_geometry_x + overlap_geometry_y;
   
    for i = 0:pi/8:pi*7/8
        [~,gabout1] = gaborfilter1(img1,5,5,0.2,i);
        [~,gabout2] = gaborfilter1(img2,5,5,0.2,i);
        overlap_gabout = overlap_gabout + gabout1 + gabout2;
    end

    E = (overlap_color + 0.5*overlap_geometry).* overlap_gabout ;
    
end
