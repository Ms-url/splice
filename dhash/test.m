img2 = imread('C:\Users\Administrator\Desktop\s3 (2).jpg');
img1 = imresize(img1(:,:,1),[500,700]);
[KeyPoints1,discriptors1]=SIFT(img1);

