function descriptors = getCalcDescriptors( GuassianPyramid ,KeyPoints)
    
     SIFT_DESCR_WIDTH = 4 ; %����ֱ��ͼ�Ŀ��
     SIFT_DESCR_HIST_BINS = 8 ;
     d = SIFT_DESCR_WIDTH ;
     n = SIFT_DESCR_HIST_BINS ;
     descriptors = [] ;
     r = size(KeyPoints) ;
     
     for i = 1:r
         kpt = KeyPoints(i,:);
         o = kpt(3);
         s = kpt(4); % �����������ڵ�����źͲ����
         scale = 1.0 /(2^(o-1)) ;  % ���ű���
         sizep = kpt(5) * scale ;  % ���������������ͼ��ߴ�
         ptf = [kpt(2) * scale, kpt(1) * scale] ; % ���������ڽ��������е�����
         img = GuassianPyramid(o).octaves(s).stacks ; % �õ����ڵĽ�����ͼ��
         de = calcSIFTDescriptor(img, ptf, kpt(6), sizep*0.5 , d, n);
         descriptors = [ descriptors; de./sum(de)] ;
         
     end

end