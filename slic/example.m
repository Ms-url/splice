clc;clear;
I=imread('C:\Users\Administrator\Desktop\s3 (1).jpg');
figure,imshow(I);
 
s=100;
errTh=10^-2;
wDs=0.5^2;
Label=SLIC(I,s,errTh,wDs);
 
% ÏÔÊ¾ÂÖÀª
marker=zeros(size(Label));
[m,n]=size(Label);
for i=1:m
    for j=1:n
        top=Label(max(1,i-1),j);
        bottom=Label(min(m,i+1),j);
        left=Label(i,max(1,j-1));
        right=Label(i,min(n,j+1));
        if ~(top==bottom && bottom==left && left==right)
            marker(i,j)=1;
        end
    end
end
figure,imshow(marker);
 
I2=I;
for i=1:m
    for j=1:n
        if marker(i,j)==1
            I2(i,j,:)=0;
        end
    end
end
figure,imshow(I2);