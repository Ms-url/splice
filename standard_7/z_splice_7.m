clear;
img1 = imread('C:\Users\Administrator\Desktop\k1.jpg');
img2 = imread('C:\Users\Administrator\Desktop\k2.jpg');
img3 = imread('C:\Users\Administrator\Desktop\k3.jpg');
img4 = imread('C:\Users\Administrator\Desktop\k4.jpg');
img5 = imread('C:\Users\Administrator\Desktop\k5.jpg');
img6 = imread('C:\Users\Administrator\Desktop\k6.jpg');
img7 = imread('C:\Users\Administrator\Desktop\k7.jpg');

msize = 800;
img1 = imresize(img1,[msize,msize]);
img2 = imresize(img2,[msize,msize]);
img3 = imresize(img3,[msize,msize]);
img4 = imresize(img4,[msize,msize]);
img5 = imresize(img5,[msize,msize]);
img6 = imresize(img6,[msize,msize]);
img7 = imresize(img7,[msize,msize]);

%%%    6   7
%%%  5   1   2
%%%    4   3

[KeyPoints1,discriptors1]=SIFT(img1(:,:,1));
[KeyPoints2,discriptors2]=SIFT(img2(:,1:msize/2,1));
[KeyPoints3,discriptors3]=SIFT(img3(:,1:msize/2,1));
[KeyPoints4,discriptors4]=SIFT(img4(:,msize/2:msize,1));
KeyPoints4(:,2)=KeyPoints4(:,2)+msize/2;
[KeyPoints5,discriptors5]=SIFT(img5(:,msize/2:msize,1));
KeyPoints5(:,2)=KeyPoints5(:,2)+msize/2;
[KeyPoints6,discriptors6]=SIFT(img6(:,msize/2:msize,1));
KeyPoints6(:,2)=KeyPoints6(:,2)+msize/2;
[KeyPoints7,discriptors7]=SIFT(img7(:,1:msize/2,1));

[matchBox12,rate12] = matchOuShiDestion(discriptors1,discriptors2,0.6);
[matchBox15,rate15] = matchOuShiDestion(discriptors1,discriptors5,0.6);
[matchBox43,rate43] = matchOuShiDestion(discriptors4,discriptors3,0.6);
[matchBox67,rate67] = matchOuShiDestion(discriptors6,discriptors7,0.6);

[H12,min_error12] = ransac_homography2(KeyPoints1,KeyPoints2,matchBox12,4000,100000);
[H15,min_error15] = ransac_homography2(KeyPoints1,KeyPoints5,matchBox15,4000,100000);
[H43,min_error43] = ransac_homography2(KeyPoints4,KeyPoints3,matchBox43,4000,100000);
[H67,min_error67] = ransac_homography2(KeyPoints6,KeyPoints7,matchBox67,4000,100000);

out512 = splitJoint_middle(img1 ,img2 ,img5 , H12 ,H15 );
%out43 = splitJoint_up(img4, img3, H43);
out67 = splitJoint_up(img6, img7, H67);

out512t = zeros(2158,800,3);
out67t = zeros(1256,800,3);
for k=1:3
   out512t(:,:,k) = out512(:,:,k)';
   out67t(:,:,k) = out67(:,:,k)';
end
[KeyPoints_l,discriptors_l]=SIFT(out67t(:,400:800,1));
KeyPoints_l(:,2) = KeyPoints_l(:,2) + 400 ;
[KeyPoints_m,discriptors_m]=SIFT(out512t(:,1:400,1));
[matchBoxml,rateml] = matchOuShiDestion(discriptors_m,discriptors_l,0.6);
[H_ml,min_errorml] = ransac_homography2(KeyPoints_m,KeyPoints_l,matchBoxml,4000,100000);
out = splitJoint_up(out67t, out512t, H_ml);

% out512t(:,:,1) = out512';
% %out43t = out43';
% out67t = out67';

% [rr,cr,~]=size(out43t);
% [rm,cm,~]=size(out512t);
% [rl,cl,~]=size(out67t);
% 
% [KeyPoints_l,discriptors_l]=SIFT(out67t(:,:,1));
% [KeyPoints_m,discriptors_m]=SIFT(out512t(:,:,1));
% [KeyPoints_r,discriptors_r]=SIFT(out43t(:,:,1));
% 
% [matchBoxml,rateml] = matchOuShiDestion(discriptors_m,discriptors_l,0.6);
% [matchBoxmr,ratemr] = matchOuShiDestion(discriptors_m,discriptors_r,0.6);
% 
% [H_ml,min_errorml] = ransac_homography2(KeyPoints_m,KeyPoints_l,matchBoxml,4000,100000);
% [H_mr,min_errormr] = ransac_homography2(KeyPoints_m,KeyPoints_r,matchBoxmr,4000,100000);
% 
% out = splitJoint_middle(out512t ,out67t ,out43t , H_mr ,H_ml );
% out = out';












