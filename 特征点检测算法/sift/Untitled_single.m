clear;
imgor=imread('C:\Users\Administrator\Desktop\p01.jpg');
%imgor=imread('pears.png');
imgor=imgor(:,:,1);

SIFT_SIGMA = 1.6;
SIFT_INIT_SIGMA = 0.5;   % ÉãÏñÍ·µÄ³ß¶È
sigma0 = sqrt(SIFT_SIGMA^2 - SIFT_INIT_SIGMA^2);

n = 3;

[DoG,GuassianPyramid] = getDoG(imgor, n, sigma0 ,0 ,0);

KeyPoints = LocateKeyPoint4(DoG,sigma0,GuassianPyramid,n);

imshow(imgor);
hold on;

scatter(KeyPoints(:,2),KeyPoints(:,1),'ob');
%drawFanXiang(KeyPoints);


