%%%    6   7
%%%  5   1   2
%%%    4   3
clear;
img1 = imread('C:\Users\Administrator\Desktop\p1.jpg');
img2 = imread('C:\Users\Administrator\Desktop\p2.jpg');
img3 = imread('C:\Users\Administrator\Desktop\p3.jpg');
img4 = imread('C:\Users\Administrator\Desktop\p4.jpg');
img5 = imread('C:\Users\Administrator\Desktop\p5.jpg');
img6 = imread('C:\Users\Administrator\Desktop\p6.jpg');
img7 = imread('C:\Users\Administrator\Desktop\p7.jpg');

msize = 600;
img1 = imresize(img1,[msize,msize]);
img2 = imresize(img2,[msize,msize]);
img3 = imresize(img3,[msize,msize]);
img4 = imresize(img4,[msize,msize]);
img5 = imresize(img5,[msize,msize]);
img6 = imresize(img6,[msize,msize]);
img7 = imresize(img7,[msize,msize]);

[KeyPoints1,discriptors1]=SIFT(img1(:,:,1));
[KeyPoints2,discriptors2]=SIFT(img2(:,:,1));
[KeyPoints3,discriptors3]=SIFT(img3(:,:,1));
[KeyPoints4,discriptors4]=SIFT(img4(:,:,1));
[KeyPoints5,discriptors5]=SIFT(img5(:,:,1));
[KeyPoints6,discriptors6]=SIFT(img6(:,:,1));
[KeyPoints7,discriptors7]=SIFT(img7(:,:,1));

[matchBox12,rate12] = matchOuShiDestion(discriptors1,discriptors2,0.6);
%[matchBox13,rate13] = matchOuShiDestion(discriptors1,discriptors3,0.6);
%[matchBox14,rate14] = matchOuShiDestion(discriptors1,discriptors4,0.6);
[matchBox15,rate15] = matchOuShiDestion(discriptors1,discriptors5,0.6);
%[matchBox16,rate16] = matchOuShiDestion(discriptors1,discriptors6,0.6);
%[matchBox17,rate17] = matchOuShiDestion(discriptors1,discriptors7,0.6);
[matchBox43,rate43] = matchOuShiDestion(discriptors4,discriptors3,0.6);
[matchBox67,rate67] = matchOuShiDestion(discriptors6,discriptors7,0.6);

[H12,min_error12]=ransac_homography2(KeyPoints1,KeyPoints2,matchBox12,4000,100000);
% [H13,min_error13]=ransac_homography2(KeyPoints1,KeyPoints3,matchBox13,4000,100000);
% [H14,min_error14]=ransac_homography2(KeyPoints1,KeyPoints4,matchBox14,4000,100000);
[H15,min_error15]=ransac_homography2(KeyPoints1,KeyPoints5,matchBox15,4000,100000);
% [H16,min_error16]=ransac_homography2(KeyPoints1,KeyPoints6,matchBox16,4000,100000);
% [H17,min_error17]=ransac_homography2(KeyPoints1,KeyPoints7,matchBox17,4000,100000);
[H43,min_error43]=ransac_homography2(KeyPoints1,KeyPoints3,matchBox43,4000,100000);
[H67,min_error67]=ransac_homography2(KeyPoints1,KeyPoints3,matchBox67,4000,100000);

% [OutPicture2,E,A] = splitJoint_s(img1,img2,H); % ·ìºÏÏß





