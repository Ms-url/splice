function dot=fastfun(pics)

[M ,N ,D]=size(pics);

if D==3
    pic=pics(:,:,1);
end

mask=[...
0 0 1 1 1 0 0;...    
0 1 0 0 0 1 0;...
1 0 0 0 0 0 1;...
1 0 0 0 0 0 1;...
1 0 0 0 0 0 1;...
0 1 0 0 0 1 0;...
0 0 1 1 1 0 0];

mask=uint8(mask);
threshold=50;
%figure;imshow(img);title('FAST角点检测');hold on;
%tic;
dot = [];
for i=4:M-3
    for j=4:N-3  %若I1、I9与中心I0的差均小于阈值，则不是候选点
        delta1=abs(pic(i-3,j)-pic(i,j))>threshold;
        delta9=abs(pic(i+3,j)-pic(i,j))>threshold;
        delta5=abs(pic(i,j+3)-pic(i,j))>threshold;
        delta13=abs(pic(i,j-3)-pic(i,j))>threshold;
        
        if sum([delta1 delta9 delta5 delta13])>=3 
            block=pic(i-3:i+3,j-3:j+3);
            block=block.*mask;  %提取圆周16个点          
            pos=find(block);            
            block1=abs(block(pos)-pic(i,j))/threshold;           
            block2=floor(block1);           
            res=find(block2);
            
            if size(res,1)>=12 && sum(block2)>20             
                 dot=[dot;j,i];              
            end            
        end        
    end    
end

%toc; % 在命令窗口显示 tic 到 toc 的执行时间
end