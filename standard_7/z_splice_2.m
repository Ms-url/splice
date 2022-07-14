clear
img1 = imread('C:\Users\Administrator\Desktop\2元集\s1 (1).jpg');
img2 = imread('C:\Users\Administrator\Desktop\2元集\s1 (2).jpg');
img1 = imresize(img1,[900,500]);
img2 = imresize(img2,[900,500]);

[KeyPoints1,discriptors1]=SIFT(img1(:,:,1));
[KeyPoints2,discriptors2]=SIFT(img2(:,:,1));

[matchBox12,rate12] = matchOuShiDestion(discriptors1,discriptors2,0.6);

 [H12,min_error12]=ransac_homography2(KeyPoints1,KeyPoints2,matchBox12,4000,10000);

 %out1 = splitJoint_up(img1, img2, H12);
 out2 = splitJoint_2_line(img1, img2, H12);