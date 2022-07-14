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