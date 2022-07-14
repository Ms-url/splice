function [r_x,c_y,img22]=SearchForCuts(hash1,img2)

% function : 找到与hash1相匹配的img2中的1/6大小的区域
% :param hash1: hash指纹
% :param img2: 图像
% return : 与hash1相匹配的img2中的1/6大小的区域img22，r_x c_y 为img22左上角在img2的坐标

    [r1,c1]=size(img2);
    flag=0;
    for i=1:200:r1-200 % 行行步长200
        x=round(c1/3);
        y=round(r1/2);
        for j=1:100:c1-100 % 列行步长100
            hash2 = getdHash( img2(i:x,j:y));
            minghang = sum(hash1~=hash2); % 明汉距离
            
            if minghang > 5
                x = x + min(200,r1-x);
                y = y + min(100,c1-y);
            else
                r_x = i;
                c_y = j;
                img22 = img2(i:y,j:x);
                flag=1;
                break;
            end
        end
        
        if flag==1
            break;
        end
    end


end