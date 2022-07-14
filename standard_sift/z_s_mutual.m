clear
close all;
clc;

img = imread('C:\Users\Administrator\Desktop\p1.jpg');
choose = true;
while choose
    imshow(img);
    title('选择变换区域');
    hold on;
    
    dot1 = ginput(4);
    y1=[dot1(1,1),dot1(2,1),dot1(3,1),dot1(4,1)];        
    x1=[dot1(1,2),dot1(2,2),dot1(3,2),dot1(4,2)];
    plot_x1=[x1,x1(1)];
    plot_y1=[y1,y1(1)];
    plot(plot_y1,plot_x1,'r','LineWidth',2);
    
    title('选择变换后的形状');
    
    dot2 = ginput(4);
    y2=[dot2(1,1),dot2(2,1),dot2(3,1),dot2(4,1)];        
    x2=[dot2(1,2),dot2(2,2),dot2(3,2),dot2(4,2)];
    plot_x2=[x2,x2(1)];
    plot_y2=[y2,y2(1)];
    plot(plot_y2,plot_x2,'b','LineWidth',2);
    
    hold off
    fprintf('输入0重新选择，输入其它任意键继续\n');
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
Hi = Hi'; % 单应性矩阵

cut_picture = zeros(h,w);
cut_picture2 = zeros(h,w);
cut_picture3 = zeros(h,w);
OutPicture = zeros(h,w,3);
Out = zeros(h,w,3);
OutPicture = cast(OutPicture,'uint8');
Out = cast(Out,'uint8');

BW = roipoly(img,y1,x1); %生成所选中区域的二值化图像cut
[coordinate_x,coordinate_y] = find(BW==1); %获得选中区域的坐标位置
coordinate = [coordinate_x,coordinate_y,ones(length(coordinate_y),1)];%增加z=1值以便进行左边变换

cut = coordinate * Hi;%进行坐标变化
cut(:,1) = cut(:,1)./cut(:,3);
cut(:,2) = cut(:,2)./cut(:,3);%获得图像上对应的x，y值
cut = floor( cut + eps );

cut(cut(:,1:2)==0) = 1;%边界为零的点变为1，
cut_coordinate = cut(:,1:2);%获得变换后得坐标位置

for k=1:3 % 三通道处理，得到彩色图像
    imgo = img(:,:,k);
    for i = 1:length(coordinate) 
        cut_picture(cut_coordinate(i,1),cut_coordinate(i,2)) = imgo(coordinate(i,1),coordinate(i,2));
    end  % 将对应坐标的像素对应
    
    cut_picture=cast(cut_picture,'uint8');
    D = padarray(cut_picture,[3 3],'replicate','both'); % 填充像素
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
                    end % 以上是对没有被填充的点进行处理
                end
                cut_picture2(i-3,j-3) = median(B(no_zero)); %原没有被插值成功的像素点，以周围非零像素的中位数代替；
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







