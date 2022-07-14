clear;
% img1 = imread('C:\Users\Administrator\Desktop\2元集\s1 (1).jpg');
% img2 = imread('C:\Users\Administrator\Desktop\2元集\s1 (2).jpg');

img1 = imread('C:\Users\Administrator\Desktop\p1.jpg');
img2 = imread('C:\Users\Administrator\Desktop\p6.jpg');
img1 = imresize(img1(:,:,1),[900,500]);
img2 = imresize(img2(:,:,1),[900,500]);
img = [img1,img2];

[KeyPoints1,discriptors1]=SIFT(img1);
[KeyPoints2,discriptors2]=SIFT(img2);

[matchBox,rate] = matchOuShiDestion(discriptors1,discriptors2,0.6);
[H,min_error]=ransac_homography2(KeyPoints1,KeyPoints2,matchBox,4000,100000);

% [matchBox,rate] = matchOuShiDestion(discriptors1,discriptors2,0.85);
% [H,newBox,max_num] = ransac_homography3(KeyPoints1,KeyPoints2,matchBox,4000);

OutPicture1 = splitJoint_ss(img1,img2,H); % 加权
[OutPicture2,E,A] = splitJoint_s(img1,img2,H); % 缝合线

% figure(1);
% lianXiang(img1,KeyPoints1,discriptors1,img2,KeyPoints2,discriptors2,0.85);
% figure(2);
% imshow(img);title('拼接前');

