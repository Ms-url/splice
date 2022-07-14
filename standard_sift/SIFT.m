function [KeyPoints,discriptors] = SIFT(img)

% :param img: the original img
% :return : KeyPoints and discriptors

    SIFT_SIGMA = 1.6;
    SIFT_INIT_SIGMA = 0.5;   % 摄像头的尺度
    sigma0 = sqrt(SIFT_SIGMA^2 - SIFT_INIT_SIGMA^2);

    n = 3;

    [DoG,GuassianPyramid] = getDoG(img, n, sigma0 ,0 ,0);
    KeyPoints = LocateKeyPoint4(DoG, sigma0 , GuassianPyramid, n);
    discriptors = getCalcDescriptors( GuassianPyramid ,KeyPoints);
    
end

function [DoG,GuassianPyramid] = getDoG(img,n,sigma0,stacks,octaves)

%%% warning %%%
% 图像过大时
% 建议 octaves 最大不超过 6
%%%%%%%%%%%%%%%

%:param img: the original img.
%:param sigma0: sigma of the first stack of the first octave. default 1.52 for complicate reasons.
%:param n: how many stacks of feature that you want to extract.
%:param stacks: how many stacks does every octave have. stacks must bigger than 3.
%:param k: the ratio of two adjacent stacks' scale.
%:param octaves: how many octaves do we have.
%:return: the DoG Pyramid
  
    [r,c,~]=size(img);
    if stacks == 0
        stacks = n + 3;
    end
    if octaves == 0
        octaves = fix(log2(min(r,c))) - 3;
        if octaves > 5
            octaves = 5;
        end
    end
    k = 2^(1.0 / n);
 
    sigma=[];
    for o =0:octaves-1
        tump=[];
        for  s = 0:stacks-1
           tump = [tump;(k^s)*sigma0*(2^o)];
        end
        sigma=[sigma ; tump'];
    end
    
%     sigma=zeros(stacks,octave);
%     for o =0:octave-1
%         tump=zeros(1,stacks);
%         for  s = 0:stacks-1
%            tump(s+1) = (k^s)*sigma0*(2^o);
%         end
%         sigma(o+1,:)= tump;
%     end
    
    for o=1:octaves
       samplePyramid(o).octaves = img(1:2^(o-1):r,1:2^(o-1):c);
    end

    for i=1:octaves
        for j=1:stacks
            dim = fix(6*sigma(i,j) + 1); % 高斯模板大小,朝零取整
            if rem(dim,2) == 0 
                dim =dim + 1;
            end
            temp(j).stacks = conv2(samplePyramid(i).octaves , GuassianKernel(sigma(i,j) , dim),'same');

        end
        GuassianPyramid(i).octaves = temp ;
    end
    
        for o=1:octaves
            for s=1:stacks-1
                tkmp(s).stacks = GuassianPyramid(o).octaves(s+1).stacks - GuassianPyramid(o).octaves(s).stacks ;
            end
            DoG(o).octaves = tkmp ;
        end

end

function KeyPoints = LocateKeyPoint4(DoG,sigma,GuassianPyramid,n)

% :param DoG: DoG Pyramid of the original img
% :param sigma: default sigma 1.6
% :param GuassianPyramid: the GuassianPyramid of the original img
% :param n: how many stacks of feature that you want to extract.
% :param BinNum: 1 direction per 10 degrees ,a total of 36 direction
% return :

    T = 0.04;
    %%%%%%%%%
    %减少方向提高速率
    binNum = 36 ; % 确定主方向时方向个数（直方图个数）
    %%%%%%%%%
    edgeThreshold = 10.0; % 边缘阈值
    SIFT_FIXPT_SCALE = 1; % 尺度(步长）
    threshold = 0.5*T/(n*SIFT_FIXPT_SCALE); % 阈值
    
    KeyPoints = [];
    [~,octaves,~] = size(DoG);

     for o=1:octaves
         
         img_1 = DoG(o).octaves(1).stacks;
         img_2 = DoG(o).octaves(2).stacks;
         img_3 = DoG(o).octaves(3).stacks;
         img_4 = DoG(o).octaves(4).stacks;
         img_5 = DoG(o).octaves(5).stacks;
         
         [r,c,~]=size(img_1);
         
         for i = 2:r
             for j = 2:c
                 val_2 = img_2(i,j);
                 val_3 = img_3(i,j);
                 val_4 = img_4(i,j);
                 eight_neiborhood_1 = img_1(max(1, i - 1):min(i + 1, r ), max(1, j - 1):min(j + 1,c ));
                 eight_neiborhood_2 = img_2(max(1, i - 1):min(i + 1, r ), max(1, j - 1):min(j + 1, c ));
                 eight_neiborhood_3 = img_3(max(1, i - 1):min(i + 1, r), max(1, j - 1):min(j + 1, c ));
                 eight_neiborhood_4 = img_4(max(1, i - 1):min(i + 1, r), max(1, j - 1):min(j + 1, c ));
                 eight_neiborhood_5 = img_5(max(1, i - 1):min(i + 1, r), max(1, j - 1):min(j + 1, c ));
                 
                 
                 if abs(val_2) > threshold &&...
                         ((val_2 > 0 && val_2 >= max(max(eight_neiborhood_1)) &&...
                         val_2 >= max(max(eight_neiborhood_2)) && val_2 >= max(max(eight_neiborhood_3)))...
                         || (val_2 < 0 && val_2 <= min(min(eight_neiborhood_1)) &&...
                         val_2 <= min(min(eight_neiborhood_2)) && val_2 <= min(min(eight_neiborhood_3))))
                     
                     [point,x,y,layer] = adjustLocalExtrema(DoG, o, 2, i, j, T, edgeThreshold, sigma, n, SIFT_FIXPT_SCALE);
                     
                     if point == 0
                         continue
                     end
                     
                     sigma1 = sigma*2^((o+layer)/(n+3));
                     [direction ,nx] = GetMainDirection2(GuassianPyramid(o).octaves(layer).stacks , x , y , sigma1 ,binNum );
                     if nx == 0
                         continue
                     end
                                          
                     KeyPoints =[KeyPoints;point,direction(nx)];
                                       
                 elseif abs(val_3) > threshold &&...
                         ((val_3 > 0 && val_3 >= max(max(eight_neiborhood_2)) &&...
                         val_3 >= max(max(eight_neiborhood_3)) && val_3 >= max(max(eight_neiborhood_4)))...
                         || (val_3 < 0 && val_3 <= min(min(eight_neiborhood_2)) &&...
                         val_3 <= min(min(eight_neiborhood_3)) && val_3 <= min(min(eight_neiborhood_4))))
                     
                     [point,x,y,layer] = adjustLocalExtrema(DoG, o, 3, i, j, T, edgeThreshold, sigma, n, SIFT_FIXPT_SCALE);
                     
                     if point == 0
                         continue
                     end
                     
                     sigma1 = sigma*2^((o+layer)/(n+3));
                     [direction ,nx] = GetMainDirection2(GuassianPyramid(o).octaves(layer).stacks , x , y , sigma1 ,binNum );
                     if nx == 0
                         continue
                     end

                     KeyPoints =[KeyPoints;point,direction(nx)];
                     
                 elseif abs(val_4) > threshold &&...
                         ((val_4 > 0 && val_4 >= max(max(eight_neiborhood_3)) &&...
                         val_4 >= max(max(eight_neiborhood_4)) && val_4 >= max(max(eight_neiborhood_5)))...
                         || (val_2 < 0 && val_4 <= min(min(eight_neiborhood_3)) &&...
                         val_4 <= min(min(eight_neiborhood_4)) && val_4 <= min(min(eight_neiborhood_5))))
                     
                     [point,x,y,layer] = adjustLocalExtrema(DoG, o, 4, i, j, T, edgeThreshold, sigma, n, SIFT_FIXPT_SCALE);
                     
                     if point == 0
                         continue
                     end
                     
                     sigma1 = sigma*2^((o+layer)/(n+3));
                     [direction ,nx] = GetMainDirection2(GuassianPyramid(o).octaves(layer).stacks , x , y , sigma1 ,binNum );
                     if nx == 0
                         continue
                     end
                    
                     KeyPoints =[KeyPoints;point,direction(nx)];
                     
                 end
             end
         end
     end
end

function [point,x,y,s] = adjustLocalExtrema(DoG, o, s, x, y, contrastThreshold, edgeThreshold, sigma, n, SIFT_FIXPT_SCALE)

% :param DoG：DoG Pyramid of the original img
% :param o：the octave of the center pixel.
% :param s：the stack of the center pixel.
% :param x,y：the location of the pixel.
% :param contrastThreshold：parameter T.
% :param edgeThreshold：edgeThreshold you want to set.
% :param sigma：sigma of the first stack of the first octave.(default 1.52) 
% :param n：how many stacks of feature that you want to extract.
% :param SIFT_FIXPT_SCALE：
% return : 

    SIFT_MAX_INTERP_STEPS = 5; % 最大迭代次数
    % SIFT_IMG_BORDER = 5;
    SIFT_IMG_BORDER = 3; % 边界
   
    img = DoG(o).octaves(s).stacks;
    [r,c,~]=size(img);
    A=fix(log2(min(r,c))) - 3;
    flag=1;
    i = 0;
    
    img_scale = 1.0 / SIFT_FIXPT_SCALE ; % 尺度（步长）h
    deriv_scale = img_scale * 0.5 ; % 一阶差分
    second_deriv_scale = img_scale ; % 二阶差分
    cross_deriv_scale = img_scale * 0.25 ; % 交叉差分
    
    while i < SIFT_MAX_INTERP_STEPS
        
        if s<=1 || s>n+1 || y<= SIFT_IMG_BORDER || y > (c - SIFT_IMG_BORDER) ||...
                x <= SIFT_IMG_BORDER || x > (r - SIFT_IMG_BORDER) || isnan(s)
            point=0;
            flag=0;
            break;
        else
            
            img = DoG(o).octaves(s).stacks;
            prev = DoG(o).octaves(s-1).stacks;
            next = DoG(o).octaves(s+1).stacks;
            
            dD = [ (img(x,y + 1) - img(x, y - 1)) * deriv_scale,...
                (img(x + 1, y) - img(x - 1, y)) * deriv_scale,...
                (next(x, y) - prev(x, y)) * deriv_scale ];
            
            op = img(x, y) * 2 ;
            dxx = (img(x, y + 1) + img(x, y - 1) - op) * second_deriv_scale;
            dyy = (img(x + 1, y) + img(x - 1, y) - op) * second_deriv_scale;
            dss = (next(x, y) + prev(x, y) - op) * second_deriv_scale;
            dxy = (img(x + 1, y + 1) - img(x + 1, y - 1) - img(x - 1, y + 1) + img(x - 1, y - 1)) * cross_deriv_scale;
            dxs = (next(x, y + 1) - next(x, y - 1) - prev(x, y + 1) + prev(x, y - 1)) * cross_deriv_scale;
            dys = (next(x + 1, y) - next(x - 1, y) - prev(x + 1, y) + prev(x - 1, y)) * cross_deriv_scale;
            
            H=[ dxx, dxy, dxs;
                dxy, dyy, dys;
                dxs, dys, dss];
            
            if det(H)==0
                point=0;
                flag=0;
                break;
            end
            
            X = (H^-1)*dD';
            
            %%%%% X计算结果为【x y i】'，x y与传入的x y坐标系相反
            xc = -X(1); %%%%%【x y i】中 x为传入的 y的增量
            xr = -X(2);
            xi = -X(3);
            
            if abs(xi) < 0.5 && abs(xr) < 0.5 && abs(xc) < 0.5
                break
            end
            % 迭代
            
            y = y + fix(round(xc));
            x = x + fix(round(xr));
            s = s + fix(round(xi));
            
            i=i+1;
        end
    end
       
    
        if flag==0
        else
            
            if s<=1 || s>n+1 || y<= SIFT_IMG_BORDER || y > (c - SIFT_IMG_BORDER) ||...
                    x <= SIFT_IMG_BORDER || x > (r - SIFT_IMG_BORDER)|| isnan(s)
                point=0;
                
            else
                       
                contr = img(x,y) * img_scale +  0.5 * dD' * [xc, xr, xi];
                %contr = img(y,x) * img_scale +  0.5 * dD' * [xc, xr, xi];
                %%%利用Hessian矩阵的迹和行列式计算主曲率的比值
                tr = dxx + dyy ;
                dett = dxx * dyy - dxy * dxy ;
                
                if i >= SIFT_MAX_INTERP_STEPS % 超过迭代次数
                    point=0;
            %%% elseif abs( contr)*1.95^(6-A) < (contrastThreshold)*255  %
            % elseif abs( contr)* 0.2568*A^2  -3.825*A + 14.36  < (contrastThreshold)*255  % 对比度过低 
            %%% 2021.9.27
            %%% 对比度过低  
                elseif abs( contr)*1.95^(6-A)  < (contrastThreshold)*205  % 对比度过低 
                    point=0;
                elseif dett <= 0 || tr * tr * edgeThreshold >= (edgeThreshold + 1) * (edgeThreshold + 1) * dett % 边缘效应去除
                    point=0;
                else
                    point=[(x + xr) * (2^(o-1)) ,...
                        ( y + xc) * (2^(o-1)), ...
                        o , s ...
                        sigma *(2.0^((s + n*o +xi)/ n))]; % inclouded k=2^(1.0 / n);
                    
                end
            end
        end
end

function  [direction , n] = GetMainDirection2( img , x, y, sigma , binNum)

% :param img:
% :param x: row
% :param y: col
% :param binNum:
% return : 返回MainDirection(角度)及其个数 ,超出边界时返回 -1

    [r,c,~]=size(img);
   % binBox = zeros(1, binNum); 
    R = round(3*1.5*sigma);
    Box=[];
    
    % 裁取正方形区域
    if x-R-1 <=0 || x+R+1>r || y-R-1<=0 || y+R+1>c
        direction = -1;
        n = 0;
    else
        imgor = img( x-R-1:x+R+1, y-R-1:y+R+1);
        % 高斯模糊
        G_imgor = conv2( imgor, GuassianKernel(sigma*1.5 , 5),'same');
        % 圆形区域上半部分
        for i=R-1:-1:0
            chord = getChordLength( i, R) ;
            for j=0:chord-1
                postion_x = R-i+1;
                postion_y = R-(chord-1)/2 + 2 + j;
                % 幅值
                mold = ( (G_imgor(postion_x+1,postion_y)-G_imgor(postion_x-1,postion_y))^2 ...
                    + (G_imgor(postion_x,postion_y+1)-G_imgor(postion_x,postion_y-1))^2)^0.5;
                % 幅角
                angle = atan( ( G_imgor( postion_x+1 ,postion_y) - G_imgor( postion_x-1 ,postion_y)) / ...
                    ( G_imgor( postion_x ,postion_y+1) - G_imgor( postion_x ,postion_y-1)) );
                
                Box = [Box; mold , angle ];
                
            end
        end
        
        % 圆形区域下半部分
        for i=R+2:2*R-1
            chord = getChordLength( i-R-1, R) ;
            for j=0:chord-1
                postion_x = i;
                postion_y = R-(chord-1)/2 + 2 + j;
                % 幅值
                mold = ( (G_imgor(postion_x+1,postion_y)-G_imgor(postion_x-1,postion_y))^2 ...
                    + (G_imgor(postion_x,postion_y+1)-G_imgor(postion_x,postion_y-1))^2)^0.5;
                % 幅角
                angle = atan( ( G_imgor( postion_x+1 ,postion_y) - G_imgor( postion_x-1 ,postion_y)) / ...
                    ( G_imgor( postion_x ,postion_y+1) - G_imgor( postion_x ,postion_y-1)) );
               
                 Box = [Box; mold , angle ];
                
            end
        end
        
        binBox = BallotBox2(Box,binNum);
        [value,index] = sort( binBox, 'descend');
        
        if value(2)/value(1) >= 0.8 %判断第二方向是否存在
            n = 2;
            direction = zeros(1,2);
            for k=1:n
                if index(k) == binNum
                    direction(k) = 0;
                else
                    direction(k) = index(k)*(360/binNum);
                end
            end
        else
            n = 1;
            if index(1) == binNum
                direction = 0;
            else
                direction = index(1)*(360/binNum);
            end
         end
    end
end

function descriptors = getCalcDescriptors( GuassianPyramid ,KeyPoints)
    
     SIFT_DESCR_WIDTH = 4 ; %描述直方图的宽度
     SIFT_DESCR_HIST_BINS = 8 ;
     d = SIFT_DESCR_WIDTH ;
     n = SIFT_DESCR_HIST_BINS ;
     descriptors = [] ;
     r = size(KeyPoints) ;
     
     for i = 1:r
         kpt = KeyPoints(i,:);
         o = kpt(3);
         s = kpt(4); % 该特征点所在的组序号和层序号
         scale = 1.0 /(2^(o-1)) ;  % 缩放倍数
         sizep = kpt(5) * scale ;  % 该特征点所在组的图像尺寸
         ptf = [kpt(2) * scale, kpt(1) * scale] ; % 该特征点在金字塔组中的坐标
         img = GuassianPyramid(o).octaves(s).stacks ; % 该点所在的金字塔图像
         de = calcSIFTDescriptor(img, ptf, kpt(6), sizep*0.5 , d, n);
         descriptors = [ descriptors; de./sum(de)] ;
         
     end

end
    
function dst = calcSIFTDescriptor( img, ptf, ori, scl, d, n)
    dst = [] ;
    SIFT_DESCR_SCL_FCTR = 3.0;
    SIFT_DESCR_MAG_THR = 0.2;
    SIFT_INT_DESCR_FCTR = 512.0;
    FLT_EPSILON = 1.19209290E-07;
    pt = [round(ptf(1)), round(ptf(2))] ; % 坐标点取整
    cos_t = cos(ori * (pi / 180)) ; % 余弦值
    sin_t = sin(ori * (pi / 180)) ; % 正弦值
    bins_per_rad = n / 360.0 ;
    exp_scale = -1.0 / (d * d * 0.5) ;
    hist_width = SIFT_DESCR_SCL_FCTR * scl ;
    radius = round(hist_width * 1.4142135623730951 * (d + 1) * 0.5) ;
    cos_t = cos_t / hist_width ;
    sin_t = sin_t / hist_width ;

    [rows,cols,~] = size(img) ; 

    hist = zeros(1,(d+2)*(d+2)*(n+2)) ;
    X = [] ;
    Y = [] ;
    RBin = [] ;
    CBin = [] ;
    W = [] ;

    k = 0 ;
    for i = 1-radius : radius
        for j = 1-radius : radius

            c_rot = j * cos_t - i * sin_t ;
            r_rot = j * sin_t + i * cos_t ;
            rbin = r_rot + fix(d / 2) - 0.5 ;
            cbin = c_rot + fix(d / 2) - 0.5 ;
            r = pt(2) + i ;
            c = pt(1) + j ;

            if rbin > -1 && rbin < d && cbin > -1 && cbin < d && r > 1 && r < rows  && c > 1 && c < cols 
                dx = (img(r, c+1) - img(r, c-1)) ;
                dy = (img(r-1, c) - img(r+1, c)) ;
                X = [ X, dx] ;
                Y = [ Y, dy] ;
                RBin = [ RBin, rbin] ;
                CBin = [ CBin, cbin] ;
                W = [ W, (c_rot * c_rot + r_rot * r_rot) * exp_scale];
                k = k+1;
            end
        end
    end

    length = k ;
    Ori = atan(Y./X).*180/pi ;
    Mag = (X.^ 2 + Y.^ 2).^ 0.5 ;
    W = W.^0.5 ;

    for k =1:length
        rbin = RBin(k) ;
        cbin = CBin(k) ;
        obin = (Ori(k) - ori) * bins_per_rad ;
        mag = Mag(k) * W(k) ;
        
        if isnan(obin)
             obin=1;
        end
        
        r0 = fix(rbin);
        c0 = fix(cbin);
        o0 = fix(obin);
        rbin = rbin - r0;
        cbin = cbin - c0;
        obin = obin - o0;
           
        if o0 < 0
            o0 =o0 + n;
        end
        if o0 >= n
            o0 =o0 - n;
        end
        
        % histogram update using tri-linear interpolation
        v_r1 = mag * rbin ;
        v_r0 = mag - v_r1 ;

        v_rc11 = v_r1 * cbin ;
        v_rc10 = v_r1 - v_rc11 ;

        v_rc01 = v_r0 * cbin ;
        v_rc00 = v_r0 - v_rc01 ;

        v_rco111 = v_rc11 * obin ;
        v_rco110 = v_rc11 - v_rco111 ;

        v_rco101 = v_rc10 * obin ;
        v_rco100 = v_rc10 - v_rco101 ;

        v_rco011 = v_rc01 * obin ;
        v_rco010 = v_rc01 - v_rco011 ;

        v_rco001 = v_rc00 * obin ;
        v_rco000 = v_rc00 - v_rco001 ;
        
        idx = ((r0 + 1) * (d + 2) + c0 + 1) * (n + 2) + o0 ;
        
        
        hist(idx) = hist(idx)+ v_rco000;
        hist(idx+1) =hist(idx+1)+ v_rco001;
        hist(idx + (n+2)) =hist(idx +(n+2))+ v_rco010;
        hist(idx + (n+3)) =hist(idx +(n+3))+ v_rco011;
        hist(idx+(d+2) * (n+2)) =hist(idx+(d+2) * (n+2))+ v_rco100;
        hist(idx+(d+2) * (n+2)+1) =hist(idx+(d+2) * (n+2)+1)+ v_rco101;
        hist(idx+(d+3) * (n+2)) =hist(idx+(d+3) * (n+2))+ v_rco110;
        hist(idx+(d+3) * (n+2)+1) =hist(idx+(d+3) * (n+2)+1)+ v_rco111;
    end

    % finalize histogram, since the orientation histograms are circular
    for i = 0:d-1
        for j =0:d-1
            idx = ((i+1) * (d+2) + (j+1)) * (n+2) +1;
            hist(idx) = hist(idx)+ hist(idx+n);
            hist(idx+1) = hist(idx+1)+ hist(idx+n+1);
            for k =0:n-1
                dst = [dst,hist(idx+k)];
            end
        end
    end

    nrm2 = 0 ;
    length = d * d * n ;
    for k =1:length
        nrm2 = nrm2 + dst(k) * dst(k);
    end
    thr = ( nrm2^0.5) * SIFT_DESCR_MAG_THR;

    nrm2 = 0;
    for i =1:length
        val = min(dst(i), thr);
        dst(i) = val;
        nrm2 = nrm2 + val * val;
    end
    nrm2 = SIFT_INT_DESCR_FCTR / max(sqrt(nrm2), FLT_EPSILON) ;
    for k = 1:length
        dst(k) = min(max(dst(k) * nrm2 ,0),255);
    end

end

function result = GuassianKernel(sigma , dim)

% :param sigma: Standard deviation
% :param dim: dimension(must be positive and also an odd number)
% :return: return the required Gaussian kernel.

    tump=[];
    for t=0:dim-1
        tump = [tump , t - fix(dim/2)];
    end
    assistant = [];
    for i=1:dim
        assistant=[assistant;tump];
    end
    temp = 2*sigma*sigma;
    result = (1.0/(temp*pi))*exp(-(assistant.^2+(assistant').^2)./temp);
    result = result/sum(sum(result)); % 归一化 0.010~0.02s
    
end
   
function binBox = BallotBox2( Box, binNum)

% function: 按直方图数量生成投票范围，并根据范围进行一次投票
% param mold: 幅度
% param angle：幅角 , 幅度制
% param binBox: 投票箱
% param binNum: 直方图数量
% return：binBox
    
    binBox=zeros(1,binNum);
    mold = Box(:,1);
    angle = Box(:,2).*(180/pi);

    angle(angle<0) = 360 - abs(angle(angle<0));
    angle(angle==360) = angle(angle==360)-1;
    
    minRange = 360/binNum ;
    
    angle = fix( angle./ minRange );
    for i=1:binNum
        binBox(i)=sum(mold(angle==(i-1)));
    end
    
end

function ch = getChordLength( h, r) 

% function :get chord length of radiu 获取弦长
 
    ch = 2 * round((r^2 - h^2)^0.5) + 1;
    if ch<=0
        ch=1;
    end

end



