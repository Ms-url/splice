clear;
% hold off;
img1=imread('C:\Users\Administrator\Desktop\p01.jpg');
img2=imread('C:\Users\Administrator\Desktop\p02.jpg');
img1=img1(:,:,1);
img2=img2(:,:,1);

[KeyPoints1,discriptors1]=SIFT(img1);
[KeyPoints2,discriptors2]=SIFT(img2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%lianXiang(img1,KeyPoints1,discriptors1,img2,KeyPoints2,discriptors2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[imgr1,imgc1]=size(imgor1);
[imgr2,imgc2]=size(imgor2);
    
KeyPoints22 =[ KeyPoints2(:,1), KeyPoints2(:,2) + imgc1];
    
imgor2 = [imgor2;zeros(imgr1-imgr2,imgc2)];
img = [imgor1,imgor2];

imshow(img);
hold on;

 scatter(KeyPoints1(:,2),KeyPoints1(:,1),'ob');
 scatter(KeyPoints22(:,2),KeyPoints22(:,1),'ob');

[matchBox,rate] = matchOuShiDestion(discriptors1,discriptors2,0.6);

[k,~]=size(matchBox);
for i=1:k
   
    X=[KeyPoints1(matchBox(i,1),2),KeyPoints22(matchBox(i,2),2)];
    Y=[KeyPoints1(matchBox(i,1),1),KeyPoints22(matchBox(i,2),1)];
    plot(X,Y);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
