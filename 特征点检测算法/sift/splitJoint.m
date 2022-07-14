function dst=splitJoint(img1,img2,right_to)

[r1,c1]=size(img1);
[r2,c2]=size(img2);
offset=right_to*[1 1 1]';
offset_x=floor(offset(1));
offset_y=floor(offset(2));
size_r=r1+abs(offset_x);
size_c=c1+abs(offset_y);
dst=zeros(size_r,size_c); %建立r×c的0矩阵（平移结果矩阵），初始化为零（黑色）
         
for i=1:r1
    for j=1:c1                                                                
        dst(i,j)=img1(i,j);        
    end
end

for i=1:c2
    for j=1:r2
        temp=[j,i,1];                                %要平移变换的点,注意j,i顺序
        temp=right_to*temp';       
        x=temp(1);                                  
        y=temp(2);   
        if ceil(x)<=0||ceil(y)<=0
            x
            y
            continue
        end
        dst(ceil(x),ceil(y))=img2(j,i);        %得到平移结果矩阵，点(x,y)是由点(i,j)平移而来的，有对应关系 
        
    end
end

end