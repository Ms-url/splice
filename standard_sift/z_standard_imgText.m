clear;
  img1 = imread('C:\Users\Administrator\Desktop\2Ԫ��\s1 (1).jpg');
  img2 = imread('C:\Users\Administrator\Desktop\2Ԫ��\s1 (2).jpg');

% img1 = imread('C:\Users\Administrator\Desktop\p (4).jpg');
% img2 = imread('C:\Users\Administrator\Desktop\P (2).jpg');
% img3 = imread('C:\Users\Administrator\Desktop\P (6).jpg');
img1 = imresize(img1,[1000,1400]);
img2 = imresize(img2,[1000,1400]);
% img3 = imresize(img3,[1300,1300]);
[KeyPoints1,discriptors1]=SIFT(img1(:,:,1));
[KeyPoints2,discriptors2]=SIFT(img2(:,:,1));
% [KeyPoints3,discriptors3]=SIFT(img3(:,:,1));

% [matchBox,rate] = matchOuShiDestion(discriptors1,discriptors2,0.6);
% [H,min_error]=ransac_homography2(KeyPoints1,KeyPoints2,matchBox,4000,100000);

% [matchBox,rate] = matchOuShiDestion(discriptors1,discriptors2,0.85);
% [H,newBox,max_num] = ransac_homography3(KeyPoints1,KeyPoints2,matchBox,4000);

% OutPicture1 = splitJoint_ss(img1,img2,H); % ��Ȩ
% [OutPicture2,E,A] = splitJoint_s(img1,img2,H); % �����

% figure(1);
% lianXiang(img1,KeyPoints1,discriptors1,img2,KeyPoints2,discriptors2,0.85);
% figure(2);
% imshow(img);title('ƴ��ǰ');
% 
% subplot(111);
% imshow(OutPicture,[]);title('ƴ�Ӻ�'); 


