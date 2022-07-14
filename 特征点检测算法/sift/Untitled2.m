
clear;
hold off;
% img=imread('pears.png');
% [r,c,k]=size(img);
% img1=img(:,1:c*2/3,1);
% img2=img(:,c/3:c,1);
% img=[img1,img2];
img1=imread('C:\Users\Administrator\Desktop\p01.jpg');
img2=imread('C:\Users\Administrator\Desktop\p02.jpg');
img1=img1(:,1:300,1);
img2=img2(:,220:456,1);
img=[img1,[img2;zeros(4,237)]];

[KeyPoints1,discriptors1]=SIFT(img1);
[KeyPoints2,discriptors2]=SIFT(img2);

[matchBox,rate] = matchOuShiDestion(discriptors1,discriptors2,0.6);
rate;
[right_to,min_error]=ransac_homography2(KeyPoints1,KeyPoints2,matchBox,2000,1000);
min_error;
dst=splitJoint(img1,img2,right_to);
figure(1);
subplot(121);
imshow(img);title('拼接前');
subplot(122);
imshow(uint8(dst));title('拼接后'); 


