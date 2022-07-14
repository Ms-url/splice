clear;
imgor=imread('C:\Users\Administrator\Desktop\p01.jpg');
imgor=imgor(:,:,1);
imgor=im2double(imgor);

SIFT_SIGMA = 1.6;
SIFT_INIT_SIGMA = 0.5;   % ÉãÏñÍ·µÄ³ß¶È
sigma0 = sqrt(SIFT_SIGMA^2 - SIFT_INIT_SIGMA^2);

n = 3;

GuassianPyramid = getGuassianPyramid(imgor, n, sigma0 ,0 );

[regoin,KeyPoints] = orb_LocateKeyPoint(sigma0,GuassianPyramid,n);
% discriptors = orb_getCalcDescriptors( GuassianPyramid ,KeyPoints);
imshow(imgor);
hold on;

scatter(KeyPoints(:,2),KeyPoints(:,1),'ob');



