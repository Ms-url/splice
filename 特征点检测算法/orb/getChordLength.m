function ch = getChordLength( h, r) 

% function :get chord length of radiu ªÒ»°œ“≥§
 
    ch = 2 * round((r^2 - h^2)^0.5) + 1;
    if ch<=0
        ch=1;
    end

end