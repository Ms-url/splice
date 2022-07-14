function [right_to,max_num]=ransac_homography2(KeyPoints1,KeyPoints2,matchBox,num)
    max_num = 4 ;
    [r,~]=size(matchBox);
    
    for i=1:num
        randpoint = randperm(r,4);
        pst1=KeyPoints1(matchBox(randpoint,1),1:2);
        pst2=KeyPoints2(matchBox(randpoint,2),1:2);
        H = homography(pst2,pst1);
        
        num_sum = 0;
        for k=1:r
            rxo=[KeyPoints1((matchBox(k,1)),1:2),1];
            rx=[KeyPoints2((matchBox(k,2)),1:2),1];
            errors = norm(rxo'-H*rx',2);%%误差累计
            if errors < 1
                num_sum = num_sum + 1;
            end
        end
        %%获得最符合的透视矩阵
        if num_sum > max_num
            max_num = num_sum;
            right_to = H;
        end
        
    end

end