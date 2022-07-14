function region = getNeighborhood( img , x , y , ori)

    img = im2double(img);
    [r_x,c_y]=size(img);
    if x>16 && y>16 && x<c_y - 16 && y<r_x - 16
    
        ORI=[1 0 y;0 1 x;0 0 1]*[cosd(ori),-sind(ori),0;sind(ori),cosd(ori),0;0 0 1]*[1 0 -y;0 1 -x;0 0 1];
        num = 11;
        region_x = [x-num, x-num, x+num, x+num];
        region_y = [y-num, y+num, y+num, y-num];
        
        BW = roipoly(img,region_x,region_y); % 生成所选中区域的二值化图像cut
        [coordinate_x,coordinate_y] = find( BW==1 ); % 获得选中区域的坐标位置
   
        a=ORI*[coordinate_x';coordinate_y'; ones(1,length(coordinate_x))];
   
        X = a(1,:);
        Y = a(2,:);
        A=fix(X);
        B=fix(X)+1;
        C=fix(Y);
        D=fix(Y)+1;
        
        imgcb = [];
        imgCA = [];
        imgdb = [];
        imgda = [];
        
        for i=1:(num)*(num)*4
            imgcb = [imgcb,img(C(i) ,B(i))];
            imgCA = [imgCA,img(C(i) ,A(i))];
            imgdb = [imgdb,img(D(i) ,B(i))];
            imgda = [imgda,img(D(i) ,A(i))];
        end
        ge = ( X - A ).*( imgcb - imgCA )+imgCA;
        gf = ( X - A ).*( imgdb - imgda )+imgda;
        region = ( Y - C ).*( ge - gf ) + ge ;
    else
        region = 0;
    end
end