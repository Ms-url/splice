clear 
close all;
clc;
imgor= imread('pears.png');
imshow(imgor);
fprintf('Begin to choose the color chip')
choose=true;
while choose
    imshow(imgor)
    dot=ginput(4);       %ȡ�ĸ��㣬���������ϣ����£�����,����
    y=[dot(1,1),dot(2,1),dot(3,1),dot(4,1)];        %�ĸ�ԭ����
    x=[dot(1,2),dot(2,2),dot(3,2),dot(4,2)];
    plot_x=[x,x(1)];
    plot_y=[y,y(1)];
    hold on
    plot(plot_y,plot_x,'r','LineWidth',2)
    hold off
    fprintf('press 0 to rechose or press anything else to go\n');
    a=input('');
    if a~=0
        choose=false;
    end
end
w=round(max(dot(:,1))-min(dot(:,1)));
h=round(max(dot(:,2))-min(dot(:,2)));
%��ԭ�ı��λ���¾��θ�

%�������µĶ��㣬��ȡ�ľ���,Ҳ����������������״
%�����ԭͼ���Ǿ��Σ���ͼ���Ǵ�dot��ȡ�õĵ���ɵ������ı���.:)
Y=[1,1,w,w];     
X=[1,h,h,1];

Hi = homography([dot(:,2),dot(:,1)],[X;Y]');
Hi = Hi';

% B=[X(1),Y(1),X(2),Y(2),X(3),Y(3),X(4),Y(4)]';   %�任����ĸ����㣬�����ұߵ�ֵ
% %�����ⷽ���飬���̵�ϵ��
% A=[x(1),y(1),1,0,0,0,-X(1)*x(1),-X(1)*y(1);             
%    0,0,0,x(1),y(1),1,-Y(1)*x(1),-Y(1)*y(1);
%    x(2),y(2),1,0,0,0,-X(2)*x(2),-X(2)*y(2);
%    0,0,0,x(2),y(2),1,-Y(2)*x(2),-Y(2)*y(2);
%    x(3),y(3),1,0,0,0,-X(3)*x(3),-X(3)*y(3);
%    0,0 ,0,x(3),y(3),1,-Y(3)*x(3),-Y(3)*y(3);
%    x(4),y(4),1,0,0,0,-X(4)*x(4),-X(4)*y(4);
%    0,0,0,x(4),y(4),1,-Y(4)*x(4),-Y(4)*y(4)];%���任���������ʽ
cut_picture = zeros(h,w);
cut_picture2 = zeros(h,w);
OutPicture = zeros(h,w,3);
OutPicture = cast(OutPicture,'uint8');%���ͱ任Ϊuint8
% fa = A\B;
% fa = reshape([fa;1],[3,3]);%fa���Ǳ任����

cut = zeros(h+1,w+1);
BW = roipoly(imgor,y,x); %������ѡ������Ķ�ֵ��ͼ��cut
[coordinate_x,coordinate_y] = find(BW==1);%���ѡ�����������λ��
coordinate = [coordinate_x,coordinate_y,ones(length(coordinate_y),1)];%����z=1ֵ�Ա������߱任

cut = coordinate * Hi;%��������仯
cut(:,1) = cut(:,1)./cut(:,3);
cut(:,2) = cut(:,2)./cut(:,3);%���ͼ���϶�Ӧ��x��yֵ
cut = floor( cut + eps );

cut(cut(:,1:2)==0) = 1;%�߽�Ϊ��ĵ��Ϊ1��
cut_coordinate = cut(:,1:2);%��ñ任�������λ��

for k=1:3
    img = imgor(:,:,k);
    for i = 1:length(coordinate) 
        cut_picture(cut_coordinate(i,1),cut_coordinate(i,2)) = img(coordinate(i,1),coordinate(i,2));
    end  % ����Ӧ��������ض�Ӧ
    
    cut_picture=cast(cut_picture,'uint8');
  % B = zeros(5,5);
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
            end
        end
    end
    OutPicture(:,:,k) = cut_picture2;
end %�����Ƕ�ͼ����ͨ�����д���ģ����ڵõ���ɫͼ��
imshow(OutPicture);
