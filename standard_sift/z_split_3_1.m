clear 
close all;
imgo = imread('pears.png');
imgor = imgo(:,:,1);
[h,w,~] = size(imgor);
% imgor = imread('C:\Users\Administrator\Desktop\p21s.jpg');
% imgor = imresize(imgor(:,:,1),[500,700]);

change_picture = zeros(h,w);
change_picture_pad = zeros(h,w);
OutPicture = zeros(h,w,3);

num = 600;

a=[...
0 0;...
0 num;...
num num;...
num 0];

b=[...
0 0;...
0 num/2;...
num/2 num;...
num/2 0];

Hi = homography( a , b );
Hi = Hi';

tic
% cut = zeros(h+1,w+1);
[coordinate_x,coordinate_y] = find(imgor); %获得所有的坐标位置
coordinate = [coordinate_x,coordinate_y,ones(length(coordinate_y),1)];%增加z=1值以便进行左边变换

change = coordinate * Hi ;%进行坐标变化
change(:,1) = change(:,1)./change(:,3);
change(:,2) = change(:,2)./change(:,3); %获得变化后图像上对应的x，y值
change = floor( change + eps );

change(change(:,1:2)==0) = 1; %边界为零的点变为1，
change_coordinate = change(:,1:2); %获得变换后得坐标位置
toc
% for k=1:3
%     img = imgo(:,:,k);
img = imgor;
for i=1:length(coordinate)
    change_picture(change_coordinate(i,1),change_coordinate(i,2))=img(coordinate(i,1),coordinate(i,2));
end %讲对应坐标的像素对应
change_picture=cast(change_picture,'uint8');

tic
D = padarray(change_picture,[3 3],'replicate','both');%填充像素
for i=4:h+3
    for j=4:w+3
        if D(i,j)==0
            no_zero=find(D(i-1:i+1,j-1:j+1)~=0);
            [m,n]=size(no_zero);
            if m~=0
                B = D(i-1:i+1,j-1:j+1);
            else
                no_zero=find(D(i-2:i+2,j-2:j+2)~=0);
                [m,n]=size(no_zero);
                if m~=0
                    B = D(i-2:i+2,j-2:j+2);
                else
                    no_zero = find(D(i-3:i+3,j-3:j+3)~=0);
                    B = D(i-3:i+3,j-3:j+3);
                end
                %对没有被填充的点进行处理
            end
            
            medi = median(B(no_zero));
            if isnan(medi)
                change_picture_pad(i-3,j-3)=0;
            else
                change_picture_pad(i-3,j-3)=medi;
            end
            %原没有被插值成功的像素点，以周围非零像素的中位数代替；
            
        else
            change_picture_pad(i-3,j-3) = change_picture(i-3,j-3);
        end
    end
end
%     OutPicture(:,:,k)=change_picture_pad;
% end %这里是对图像三通道进行处理的，便于得到彩色图像
toc

figure(1);
subplot(121)
imshow(imgor,[]);title('原图');
subplot(122)
imshow(change_picture_pad,[]);





