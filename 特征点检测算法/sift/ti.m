img1=imread('C:\Users\Administrator\Desktop\p01.jpg');
img1=imresize(img1(:,:,1),[384,512]);
[a,b]=SIFT(img1);
