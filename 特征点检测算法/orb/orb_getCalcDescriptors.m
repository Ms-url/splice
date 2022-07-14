function descriptors = orb_getCalcDescriptors( GuassianPyramid ,KeyPoints)
    
     SIFT_DESCR_WIDTH = 4 ; %����ֱ��ͼ�Ŀ��
     SIFT_DESCR_HIST_BINS = 8 ;
     d = SIFT_DESCR_WIDTH ;
     n = SIFT_DESCR_HIST_BINS ;
     descriptors = [] ;
     r = size(KeyPoints) ;
     
     for i = 1:r
         kpt = KeyPoints(i,:);
         o = kpt(3);
         scale = 1.0 /(2^(o-1)) ;  
         ptf = [kpt(2) * scale, kpt(1) * scale] ; % ���������ڽ��������е�����
         img = GuassianPyramid(o).octaves ; % �õ����ڵĽ�����ͼ��
         de = orb_calcSIFTDescriptor(img, ptf, kpt(6));
         descriptors = [ descriptors; de] ;
         
     end

end