clear;
img1 = imread('C:\Users\Administrator\Desktop\2元集\s1 (1).jpg');
img2 = imread('C:\Users\Administrator\Desktop\2元集\s1 (2).jpg');

img1 = imresize(img1,[500,700]);
img2 = imresize(img2,[500,700]);

% [KeyPoints1,discriptors1]=SIFT(rgb2gray(img1));
% [KeyPoints2,discriptors2]=SIFT(rgb2gray(img2));
[KeyPoints1,discriptors1]=SIFT(img1(:,:,1));
[KeyPoints2,discriptors2]=SIFT(img2(:,:,1));

[matchBox,rate] = matchOuShiDestion(discriptors1,discriptors2,0.6);
[H,min_error]=ransac_homography2(KeyPoints1,KeyPoints2,matchBox,4000,100000);

out = splitJoint_cut_gray_3(img1,img2,H); % 缝合线
[OutPicture2,E,A] = splitJoint_s(img1,img2,H); % 缝合线



