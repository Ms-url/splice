function dst = inosculate_sutureLine(img1,img2,offset,c)
%: function : Ѱ����ѷ����ƴ��
%��param img1 : �����ع���Ĳο�ͼ��
%��param img2 ����Ӧ�Ա仯���ƥ��ͼ�񣬺�img1��С��ͬ
%��param offset : ƥ��ͼ��˵㵥Ӧ�Ա仯�������
%: patam c : �ο�ͼ��Ŀ�ȣ�������
%��return dst : ��Ϻ��ͼ��
%======TODO========������ͨ�� 
     
    img2 = double(img2);
    img1 = double(img1);
     
    [row,col,~]=size(img1);

    seti = fix(min(offset));
    area_left = floor(seti(2));
    area_right = c;
    processWidth = area_right-area_left; % �ص�������
    
    overlap_region_img2 = img2(:,area_left:area_right);
    overlap_region_img1 = img1(:,area_left:area_right);% �ص�����
    overlap = zeros(row,processWidth+1);
   
    tic;
    overlap_color = overlap_region_img1 - overlap_region_img2; % ���ͼ��
    overlap_geometry_y = conv2(overlap_region_img1,[-2,-1,-2;0 0 0;2 1 2],'same') - conv2(overlap_region_img2,[-2,-1,-2;0 0 0;2 1 2],'same');
    overlap_geometry_x = conv2(overlap_region_img1,[-2,0,2;-1 0 1;-2 0 2],'same') - conv2(overlap_region_img2,[-2,0,2;-1 0 1;-2 0 2],'same');
    %%%%%%%%%%%%%%
    overlap_geometry = overlap_geometry_x + overlap_geometry_y;
    %%%%%%%%%%%%%%
    E = overlap_color.^2 + overlap_geometry ; % ��������
    toc;
    
    E_sum_loop =zeros(1,processWidth +1);
    path_list = zeros(processWidth +1,row);
    for j=1:processWidth +1
        line = zeros(1,row); % ������·���Ĵӵ�һ�е����һ�е�������
        E_sum = E(1,j);
        lis = j;
        line(1) = lis;
        for i= 2:row
            if lis==1 % ����һ�е��������رȽϣ�ȡ�����С������
                [emin ,poi] = min([1e+8,E(i,lis),E(i,lis+1)]); %
            elseif lis==processWidth+1
                [emin, poi] = min([E(i,lis-1),E(i,lis),1e+8]);
            else
                [emin, poi] = min([E(i,lis-1),E(i,lis),E(i,lis+1)]);
            end
            lis = lis + poi - 2;
            line(i) = lis;
            E_sum = E_sum + emin;
        end
         path_list(j,:) = line; % ÿһ�д治ͬ��·��
         E_sum_loop(j) = E_sum ; % ���治ͬ·��������
    end
    
    [~,sutureline_row]=min(E_sum_loop);
    
    bestLine = path_list(sutureline_row,:);
    for i=1:row
        overlap(i,1:bestLine(1)) = overlap_region_img1(i,1:bestLine(1));
        overlap(i,bestLine(1)+1:processWidth+1) = overlap_region_img2(i,bestLine(1)+1:processWidth+1);
    end
    overlap(overlap==0)= overlap_region_img1(overlap==0);
    dst = [img1(:,1:area_left,:) , overlap , img2(:,area_right:col,:)];
    
end
