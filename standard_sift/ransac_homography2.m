function [right_H,min_error]=ransac_homography2(KeyPoints1,KeyPoints2,matchBox,num,error_o)
% function : ransac 找到累计误差最小的单应性矩阵
% :param num : 随机抽取次数 
% :param error_o : 初始最小误差 
% return ：单应性矩阵 right_to ，最小累计误差min_error

min_error=error_o;
[r,~]=size(matchBox);

for i=1:num 
    randpoint = randperm(r,4);
    pst1=KeyPoints1(matchBox(randpoint,1),1:2);
    pst2=KeyPoints2(matchBox(randpoint,2),1:2);
    H = homography(pst2,pst1);
    
    errors = 0;
    for k=1:r
    rxo=[KeyPoints1((matchBox(k,1)),1:2),1];
    rx=[KeyPoints2((matchBox(k,2)),1:2),1];
    errors = errors+norm(rxo'-H*rx',2);%%误差累计
    end
    %%获得最符合的透视矩阵
    if errors<=min_error
        min_error=errors;
        right_H = H;
    end
    
end

end