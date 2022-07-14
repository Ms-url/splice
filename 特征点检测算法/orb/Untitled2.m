clear;
imgor=imread('C:\Users\Administrator\Desktop\p01.jpg');
imgor=imgor(:,:,1);
imgor=im2double(imgor);

SIFT_SIGMA = 1.6;
SIFT_INIT_SIGMA = 0.5;   % 摄像头的尺度
sigma0 = sqrt(SIFT_SIGMA^2 - SIFT_INIT_SIGMA^2);

n = 3;

GuassianPyramid = getGuassianPyramid(imgor, n, sigma0 ,0 );

KeyPoints = LocateKeyPoint(sigma0,GuassianPyramid,n);


     SIFT_DESCR_WIDTH = 4 ; %描述直方图的宽度
     SIFT_DESCR_HIST_BINS = 8 ;
     d = SIFT_DESCR_WIDTH ;
     n = SIFT_DESCR_HIST_BINS ;
     descriptors = [] ;
     r = size(KeyPoints) ;
     
     for i = 1:r
         kpt = KeyPoints(i,:);
         o = kpt(3);
         scale = 1.0 /(2^(o-1)) ;  
         ptf = [kpt(2) * scale, kpt(1) * scale] ; % 该特征点在金字塔组中的坐标
         img = GuassianPyramid(o).octaves ; % 该点所在的金字塔图像
         
         ori = kpt(6);
         x=ptf(1);
         y=ptf(2);
    
         if x>3 && y>3
             
             ORI=[cosd(ori),sind(ori);-sind(ori),cosd(ori)];
             
%              temp1 = 2*ones(1,32);
%              temp2 = [-1 -1 -1 0 0 0 1 1 1 -1 -1 -1 0 0 0  1 1 1 -1 -1 -1  0 0 0 1 1 1 -1 -1 -1 0 0];
%              temp4 = [1 0 -1 1 0 -1 1 0 -1 1 0 -1 1 0 -1 1 0 -1 1 0 -1 1 0 -1 1 0 -1 1 0 -1 1 0];
%              temp3 = [-2*ones(1,9) ,-1*ones(1,9),0*ones(1,9),1*ones(1,5)];
             
             Y = [2 -1 2 -1 2 -1 2 0 2 0 2 0 2 1 2 1 2 1 2 -1 2 -1 2 -1 2 0 2 0 2 ...
                 0 2 1 2 1 2 1 2 -1 2 -1 2 -1 2 0 2 0 2 0 2 1 2 1 2 1 2 -1 2 -1 2 -1 2 0 2 0];
             X = [-2 1 -2 0 -2 -1 -2 1 -2 0 -2 -1 -2 1 -2 0 -2 -1 -1 1 -1 0 -1 -1 -1 1 -1 0 -1 ...
                 -1 -1 1 -1 0 -1 -1 0 1 0 0 0 -1 0 1 0 0 0 -1 0 1 0 0 0 -1 1 1 1 0 1 -1 1 1 1 0];
             
%              Y=ones(1,64);
%              X=ones(1,64);
%              Y(1,1:2:64)=temp1;
%              Y(1,2:2:64)=temp2;
%              X(1,1:2:64)=temp3;
%              X(1,2:2:64)=temp4;
           
             a=[X;Y]'*ORI;
             X=a(:,1);
             Y=a(:,2);
             X=X+x;
             Y=Y+y;
             
             A=fix(X);
             B=fix(X)+1;
             C=fix(Y);
             D=fix(Y)+1;
             imgcb = [];
             imgCA = [];
             imgdb = [];
             imgda = [];
             for i=1:size(X)
                 imgcb = [imgcb,img(C(i) ,B(i))];
                 imgCA = [imgCA,img(C(i) ,A(i))];
                 imgdb = [imgdb,img(D(i) ,B(i))];
                 imgda = [imgda,img(D(i) ,A(i))];
             end
             ge = ( X - A ).*( imgcb - imgCA )+imgCA;
             gf = ( X - A ).*( imgdb - imgda )+imgda;
             gxy = ( Y - C ).*( ge - gf ) + ge ;
             
             figre = gxy(1:2:64)==gxy(2:2:64);
         else
             figre = -1*ones(1,32);
         end
         
         descriptors = [ descriptors; figre] ;
         
     end


imshow(imgor);
hold on;

scatter(KeyPoints(:,2),KeyPoints(:,1),'ob');
    






