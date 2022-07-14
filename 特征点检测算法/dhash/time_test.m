img1=imread('C:\Users\Administrator\Desktop\p11.jpg');
img2=imread('C:\Users\Administrator\Desktop\p12.jpg');
img1=img1(:,:,1);
img2=img2(:,:,1);

hash1=getdHash(img1);
img22=[];

[r1,c1]=size(img2);
flag=0;
for i=1:200:r1-200
    x=round(c1/3);
    y=round(r1/2);
    for j=1:100:c1-100
        hash2 = getdHash( img2(i:x,j:y));
        minghang = sum(hash1~=hash2);
        
        if minghang > 5
            x = x + min(200,r1-x);
            y = y + min(100,c1-y);
        else
%             i
%             j
            img22 = img2(i:y,j:x);
            flag=1;
            break;
        end
    end
    
    if flag==1
        break;
    end
    
end
% subplot(121);
% imshow(img1);
% subplot(122);
% imshow(img22);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

