clear;
img=imread('C:\Users\Administrator\Desktop\p12.jpg'); 
imageName='test12.pgm';
imwrite(img,imageName,'pgm');

tic
[image, descrips, locs] = sift('test12.pgm');
toc