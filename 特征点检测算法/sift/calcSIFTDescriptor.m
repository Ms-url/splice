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
