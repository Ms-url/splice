function [point,x,y,s] = adjustLocalExtrema(DoG, o, s, x, y, contrastThreshold, edgeThreshold, sigma, n, SIFT_FIXPT_SCALE)

% :param DoG��DoG Pyramid of the original img
% :param o��the octave of the center pixel.
% :param s��the stack of the center pixel.
% :param x,y��the location of the pixel.
% :param contrastThreshold��parameter T.
% :param edgeThreshold��edgeThreshold you want to set.
% :param sigma��sigma of the first stack of the first octave.(default 1.52) 
% :param n��how many stacks of feature that you want to extract.
% :param SIFT_FIXPT_SCALE��
% return : 

    SIFT_MAX_INTERP_STEPS = 5; % ����������
    % SIFT_IMG_BORDER = 5;
    SIFT_IMG_BORDER = 3; % �߽�
   
    img = DoG(o).octaves(s).stacks;
    [r,c,~]=size(img);
    A=fix(log2(min(r,c))) - 3;
    flag=1;
    i = 0;
    
    img_scale = 1.0 / SIFT_FIXPT_SCALE ; % �߶ȣ�������h
    deriv_scale = img_scale * 0.5 ; % һ�ײ��
    second_deriv_scale = img_scale ; % ���ײ��
    cross_deriv_scale = img_scale * 0.25 ; % ������
    
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
            
            %%%%% X������Ϊ��x y i��'��x y�봫���x y����ϵ�෴
            xc = -X(1); %%%%%��x y i���� xΪ����� y������
            xr = -X(2);
            xi = -X(3);
            
            if abs(xi) < 0.5 && abs(xr) < 0.5 && abs(xc) < 0.5
                break
            end
            % ����
            
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
                %%%����Hessian����ļ�������ʽ���������ʵı�ֵ
                tr = dxx + dyy ;
                dett = dxx * dyy - dxy * dxy ;
                
                if i >= SIFT_MAX_INTERP_STEPS % ������������
                    point=0;
                elseif abs( contr)*1.95^(6-A) < (contrastThreshold)*255  % �Աȶȹ���   
               % elseif abs( contr)*0.55  < (contrastThreshold)*255  % �Աȶȹ��� 
               % elseif abs( contr)* 0.2568*A^2  -3.825*A + 14.36  < (contrastThreshold)*255  % �Աȶȹ��� 
                    point=0;
                elseif dett <= 0 || tr * tr * edgeThreshold >= (edgeThreshold + 1) * (edgeThreshold + 1) * dett % ��ԵЧӦȥ��
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
    
    
    
    
    