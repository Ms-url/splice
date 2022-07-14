function fingerprint = getdHash( img )

% function : »ñÈ¡²îÒì¹şÏ£Ö¸ÎÆ
% :param img: »Ò¶ÈÍ¼Ïñ
% return £ºfingerprint ²îÒì¹şÏ£Ö¸ÎÆ

    fingerprint=zeros(1,64);
    im = imresize(img,[8,9]); 
    p=1;
    
    for i=1:8
        for j=1:8
            fingerprint(p)=im(j)<im(j+1);
            p=p+1;
        end
    end

end