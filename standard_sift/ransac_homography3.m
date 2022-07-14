function [right_to,newBox,max_num]=ransac_homography3(KeyPoints1,KeyPoints2,matchBox,num)
% function : ransca 滤除误匹配 ,并返回包含最多内点的单应性矩阵
% param matchBox : 粗匹配的匹配点
% param num ：随机抽样次数
% return ： right_to 包含最多内点的单应性矩阵，newBox 滤除后的匹配点，max_num 内点数量
% =======================%

    max_num = 4 ;
    [r,~]=size(matchBox);
    
    for i=1:num
        randpoint = randperm(r,4);
        pst1=KeyPoints1(matchBox(randpoint,1),1:2);
        pst2=KeyPoints2(matchBox(randpoint,2),1:2);
        H = homography(pst2,pst1);
        
        num_sum = 0;
        key = [];
        for k=1:r
            rxo = [KeyPoints1((matchBox(k,1)),1:2),1];
            rx = [KeyPoints2((matchBox(k,2)),1:2),1];
            errors = norm(rxo'-H*rx',2); %误差
            if errors < 36 % 允许的误差范围
                num_sum = num_sum + 1;
                key = [key ,k];
            end
        end
        %%获得最符合的透视矩阵
        if num_sum > max_num
            max_num = num_sum;
            newBox = matchBox(key,:);
            right_to = H;
        end
        
    end

end