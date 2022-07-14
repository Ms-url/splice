clear;
% hold off;
img1=imread('C:\Users\Administrator\Desktop\p11.jpg');
img2=imread('C:\Users\Administrator\Desktop\p12.jpg');
img1=img1(:,:,1);
img2=img2(:,:,1);

SIFT_SIGMA = 1.6;
SIFT_INIT_SIGMA = 0.5;   % ÉãÏñÍ·µÄ³ß¶È
sigma0 = sqrt(SIFT_SIGMA^2 - SIFT_INIT_SIGMA^2);

n = 3;

GuassianPyramid1 = getGuassianPyramid(img1, n, sigma0 ,0 );
KeyPoints1 = LocateKeyPoint(sigma0,GuassianPyramid1,n);
discriptors1 = orb_getCalcDescriptors( GuassianPyramid1 ,KeyPoints1);

GuassianPyramid2 = getGuassianPyramid(img2, n, sigma0 ,0 );
KeyPoints2 = LocateKeyPoint(sigma0,GuassianPyramid2,n);
discriptors2 = orb_getCalcDescriptors( GuassianPyramid2 ,KeyPoints2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%lianXiang(img1,KeyPoints1,discriptors1,img2,KeyPoints2,discriptors2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[imgr1,imgc1]=size(img1);
[imgr2,imgc2]=size(img2);
    
KeyPoints22 =[ KeyPoints2(:,1), KeyPoints2(:,2) + imgc1];
    
img2 = [img2;zeros(imgr1-imgr2,imgc2)];
img = [img1,img2];

imshow(img);
hold on;

 scatter(KeyPoints1(:,2),KeyPoints1(:,1),'ob');
 scatter(KeyPoints22(:,2),KeyPoints22(:,1),'ob');

%[matchBox,rate] = matchMingHanDestion(discriptors1,discriptors2,0.6);
matchBox=[];
    [len,~] = size(discriptors1);
    for i=1:len
        N=discriptors1(i,:);
        if N(1)~=-1
            NM = N~=discriptors2; % [(x1-x2),(y1-y2)...]
            [a,b] = sort(sum(NM'));
            
            if a(1)<5 %&& a(1)/a(2) > 0.8
                matchBox=[matchBox;i, b(1)];
            end
        end
    end
%     if size(matchBox) <= 4
%         [matchBox,rate] = matchMingHanDestion(discriptors1,discriptors2,0.8+0.05);
%     end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[k,~]=size(matchBox);
for i=1:k
   
    X=[KeyPoints1(matchBox(i,1),2),KeyPoints22(matchBox(i,2),2)];
    Y=[KeyPoints1(matchBox(i,1),1),KeyPoints22(matchBox(i,2),1)];
    plot(X,Y);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
