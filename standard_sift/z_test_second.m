clear;

img1 = imread('C:\Users\Administrator\Desktop\s3 (1).jpg');
img2 = imread('C:\Users\Administrator\Desktop\s3 (2).jpg');
img1 = imresize(img1(:,:,1),[500,700]);
img2 = imresize(img2(:,:,1),[500,700]);
img = [img1,img2];

[KeyPoints1,discriptors1]=SIFT(img1);
[KeyPoints2,discriptors2]=SIFT(img2);

[matchBox1,rate] = matchOuShiDestion(discriptors1,discriptors2,0.6);
rate;

[H1,~]=ransac_homography2(KeyPoints1,KeyPoints2,matchBox1,4000,100000);
subplot(131);
OutPicture1 = splitJoint_ss(img1,img2,H1);
imshow(OutPicture1,[]);title('一次投影'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OutPictu = splitJoint_second_one(img2,H1);
[KeyPoints3,discriptors3]=SIFT(OutPictu);

[matchBox2,rate] = matchOuShiDestion(discriptors1,discriptors3,0.6);
rate;

[H2,~]=ransac_homography2(KeyPoints1,KeyPoints3,matchBox2,4000,100000);
subplot(132);

OutPicture2 = splitJoint_ss(img1,OutPictu,H2);
imshow(OutPicture2,[]);title('二次投影'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OutPicture = splitJoint_second_one(OutPictu,H2);
[KeyPoints4,discriptors4]=SIFT(OutPicture);

[matchBox3,rate] = matchOuShiDestion(discriptors1,discriptors4,0.6);
rate;

[H3,min_error]=ransac_homography2(KeyPoints1,KeyPoints4,matchBox3,4000,100000);
subplot(133);
OutPicture3 = splitJoint_ss(img1,OutPicture,H3);
imshow(OutPicture3,[]);title('三次投影'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure(1);
% 
% subplot(131);
% lianXiang(img1,KeyPoints1,discriptors1,OutPicture2,KeyPoints3,discriptors3,0.6);
% subplot(132);
% imshow(img);title('拼接前');
% subplot(133);
% imshow(OutPicture2,[]);title('拼接后'); 
