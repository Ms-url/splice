clear;
hold off;
img1=imread('C:\Users\Administrator\Desktop\p01.jpg');
img2=imread('C:\Users\Administrator\Desktop\p02.jpg');
img1=img1(:,:,1);
img2=img2(:,:,1);

[KeyPoints1,discriptors1]=SIFT(img1);
[KeyPoints2,discriptors2]=SIFT(img2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lianXiang(img1,KeyPoints1,discriptors1,img2,KeyPoints2,discriptors2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%