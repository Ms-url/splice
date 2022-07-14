function dst=splitJoint(img1,img2,right_to)

[r1,c1]=size(img1);
[r2,c2]=size(img2);
offset=right_to*[1 1 1]';
offset_x=floor(offset(1));
offset_y=floor(offset(2));
size_r=r1+abs(offset_x);
size_c=c1+abs(offset_y);
dst=zeros(size_r,size_c); %����r��c��0����ƽ�ƽ�����󣩣���ʼ��Ϊ�㣨��ɫ��
         
for i=1:r1
    for j=1:c1                                                                
        dst(i,j)=img1(i,j);        
    end
end

for i=1:c2
    for j=1:r2
        temp=[j,i,1];                                %Ҫƽ�Ʊ任�ĵ�,ע��j,i˳��
        temp=right_to*temp';       
        x=temp(1);                                  
        y=temp(2);   
        if ceil(x)<=0||ceil(y)<=0
            x
            y
            continue
        end
        dst(ceil(x),ceil(y))=img2(j,i);        %�õ�ƽ�ƽ�����󣬵�(x,y)���ɵ�(i,j)ƽ�ƶ����ģ��ж�Ӧ��ϵ 
        
    end
end

end