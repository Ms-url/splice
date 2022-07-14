clear;
hold off;
img1=imread('C:\Users\Administrator\Desktop\p11.jpg');
img2=imread('C:\Users\Administrator\Desktop\p12.jpg');
img1=img1(:,:,1);
img2=img2(:,:,1);
img1=im2double(img1);
img2=im2double(img2);
tic;
[KeyPoints1,discriptors1]=ORB(img1);
[KeyPoints2,discriptors2]=ORB(img2);
toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lianXiang(img1,KeyPoints1,discriptors1,img2,KeyPoints2,discriptors2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%