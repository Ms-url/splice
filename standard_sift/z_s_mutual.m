clear
close all;
clc;

img = imread('C:\Users\Administrator\Desktop\p1.jpg');
choose = true;
while choose
    imshow(img);
    title('ѡ��任����');
    hold on;
    
    dot1 = ginput(4);
    y1=[dot1(1,1),dot1(2,1),dot1(3,1),dot1(4,1)];        
    x1=[dot1(1,2),dot1(2,2),dot1(3,2),dot1(4,2)];
    plot_x1=[x1,x1(1)];
    plot_y1=[y1,y1(1)];
    plot(plot_y1,plot_x1,'r','LineWidth',2);
    
    title('ѡ��任�����״');
    
    dot2 = ginput(4);
    y2=[dot2(1,1),dot2(2,1),dot2(3,1),dot2(4,1)];        
    x2=[dot2(1,2),dot2(2,2),dot2(3,2),dot2(4,2)];
    plot_x2=[x2,x2(1)];
    plot_y2=[y2,y2(1)];
    plot(plot_y2,plot_x2,'b','LineWidth',2);
    
    hold off
    fprintf('����0����ѡ�������������������\n');
    a=input('');
    if a~=0
        choose=false;
    end

end

w = round(max(dot2(:,1))-min(dot2(:,1)));
h = round(max(dot2(:,2))-min(dot2(:,2)));

dot2(:,2)=dot2(:,2)-min(dot2(:,2))+1;
dot2(:,1)=dot2(:,1)-min(dot2(:,1))+1;

Hi = homography([dot1(:,2),dot1(:,1)],[dot2(:,2),dot2(:,1)]);
Hi = Hi'; % ��Ӧ�Ծ���

cut_picture = zeros(h,w);
cut_picture2 = zeros(h,w);
cut_picture3 = zeros(h,w);
OutPicture = zeros(h,w,3);
Out = zeros(h,w,3);
OutPicture = cast(OutPicture,'uint8');
Out = cast(Out,'uint8');

BW = roipoly(img,y1,x1); %������ѡ������Ķ�ֵ��ͼ��cut
[coordinate_x,coordinate_y] = find(BW==1); %���ѡ�����������λ��
coordinate = [coordinate_x,coordinate_y,ones(length(coordinate_y),1)];%����z=1ֵ�Ա������߱任

cut = coordinate * Hi;%��������仯
cut(:,1) = cut(:,1)./cut(:,3);
cut(:,2) = cut(:,2)./cut(:,3);%���ͼ���϶�Ӧ��x��yֵ
cut = floor( cut + eps );

cut(cut(:,1:2)==0) = 1;%�߽�Ϊ��ĵ��Ϊ1��
cut_coordinate = cut(:,1:2);%��ñ任�������λ��

for k=1:3 % ��ͨ�������õ���ɫͼ��
    imgo = img(:,:,k);
    for i = 1:length(coordinate) 
        cut_picture(cut_coordinate(i,1),cut_coordinate(i,2)) = imgo(coordinate(i,1),coordinate(i,2));
    end  % ����Ӧ��������ض�Ӧ
    
    cut_picture=cast(cut_picture,'uint8');
    D = padarray(cut_picture,[3 3],'replicate','both'); % �������
    for i=4:h+3
        for j=4:w+3
            if D(i,j)==0
                no_zero = find(D(i-1:i+1,j-1:j+1)~=0);
                [m,~] = size(no_zero);
                if m~=0
                    B = D(i-1:i+1,j-1:j+1);
                else
                    no_zero = find(D(i-2:i+2,j-2:j+2)~=0);
                    [m,~] = size(no_zero);
                    if m~=0
                        B = D(i-2:i+2,j-2:j+2);
                    else
                        no_zero = find(D(i-3:i+3,j-3:j+3)~=0);
                        B = D(i-3:i+3,j-3:j+3);
                    end % �����Ƕ�û�б����ĵ���д���
                end
                cut_picture2(i-3,j-3) = median(B(no_zero)); %ԭû�б���ֵ�ɹ������ص㣬����Χ�������ص���λ�����棻
            else
               cut_picture2(i-3,j-3) = cut_picture(i-3,j-3);
               cut_picture3(i-3,j-3) = cut_picture(i-3,j-3);
            end
        end
    end
   % OutPicture(:,:,k) = conv2(cut_picture2,GuassianKernel(1,3),'same');
   OutPicture(:,:,k) = cut_picture2;
   Out(:,:,k) = cut_picture3;
end 

figure(1);
imshow(OutPicture,[]);
% saveas(1,'change.png');







