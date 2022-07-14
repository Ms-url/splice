
% clear
% I=imread('C:\Users\Administrator\Desktop\k (1).jpg');
% [L,NumLabels]=superpixels(I,248);
% BW = boundarymask(L);

for i=1:NumLabels
   [a,b]=find(L==i);
   L2 = L(min(a):max(a),min(b):max(b));
   lis = unique(L2(L(min(a):max(a),min(b):max(b))~=i));
   lis = lis(lis > i);
   le = size(lis);
   for k=1:le
       fprintf('%d->%d  E(L==%d)-E(L==lis(%d))\n',i,lis(k),i,k);
   end
end

subplot(121);
imshow(imoverlay(I,BW,'cyan'),'InitialMagnification',67);

% clear
% I=imread('C:\Users\Administrator\Desktop\s3 (1).jpg');
% I=imresize(I,[500,700]);
% I=I(:,:,1);
% gabout=zeros(500,700); 
% tic
%  for i = 0:pi/8:pi*7/8
%         [~,gabout1] = gaborfilter1(I,5,5,0.25,i);
%         gabout = gabout + gabout1 ;
%  end
% toc
% imshow(gabout,[]);



