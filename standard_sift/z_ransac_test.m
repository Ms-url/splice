
load('k1andk4data');
[matchBox,rate] = matchOuShiDestion(discriptors1,discriptors2,0.8); % ¥÷∆•≈‰
[H,newBox,max_num] = ransac_homography3(KeyPoints1,KeyPoints2,matchBox,2000);
[H2,min_error2] = ransac_homography2(KeyPoints1,KeyPoints2,newBox,4000,1000);
[H3,min_error3] = ransac_homography2(KeyPoints1,KeyPoints2,matchBox,4000,10000);

figure(1);
lianXiang(img1,KeyPoints1,discriptors1,img2,KeyPoints2,discriptors2,0.8);
figure(2);
[imgr1,imgc1]=size(img1);
[imgr2,imgc2]=size(img2);
    
KeyPoints22 =[ KeyPoints2(:,1), KeyPoints2(:,2) + imgc1,KeyPoints2(:,3:6)];

img2 = [img2;zeros(imgr1-imgr2,imgc2)];
img = [img1,img2];

imshow(img);
hold on;

scatter(KeyPoints1(:,2),KeyPoints1(:,1),'ob');
scatter(KeyPoints22(:,2),KeyPoints22(:,1),'ob');

[k,~]=size(newBox);
for i=1:k
    X=[KeyPoints1(newBox(i,1),2),KeyPoints22(newBox(i,2),2)];
    Y=[KeyPoints1(newBox(i,1),1),KeyPoints22(newBox(i,2),1)];
    plot(X,Y);
end

