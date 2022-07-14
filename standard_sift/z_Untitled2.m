
clear
img1 = imread('C:\Users\Administrator\Desktop\k1.jpg');
img2 = imread('C:\Users\Administrator\Desktop\k2.jpg');
img5 = imread('C:\Users\Administrator\Desktop\k5.jpg');
img1 = imresize(img1,[500,700]);
img2 = imresize(img2,[500,700]);
img5 = imresize(img5,[500,700]);

[KeyPoints1,discriptors1]=SIFT(img1(:,:,1));
[KeyPoints2,discriptors2]=SIFT(img2(:,:,1));
[KeyPoints5,discriptors5]=SIFT(img5(:,:,1));

[matchBox12,rate12] = matchOuShiDestion(discriptors1,discriptors2,0.6);
[matchBox15,rate15] = matchOuShiDestion(discriptors1,discriptors5,0.6);

[H12,min_error12]=ransac_homography2(KeyPoints1,KeyPoints2,matchBox12,4000,10000);
[H15,min_error15]=ransac_homography2(KeyPoints1,KeyPoints5,matchBox15,4000,10000);

%[H,newBox,max_num] = ransac_homography3(KeyPoints1,KeyPoints2,matchBox,4000);

out = splitJoint_middle(img1 ,img2 ,img5 , H12 ,H15 );
imshow(uint8(out));






