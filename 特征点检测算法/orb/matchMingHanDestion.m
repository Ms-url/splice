function [matchBox,rate] = matchMingHanDestion(discriptors1,discriptors2,rate)

% function : 根据欧式距离匹配特征描述，匹配数量为 0时，置信比每次增加0.05
% :param discriptors1,discriptors2: 特征描述
% :param rate: 置信比，默认0.6
% return : matchBox n*2 矩阵，匹配点物理序
    
    matchBox=[];
    [len,~] = size(discriptors1);
    for i=1:len
        N=discriptors1(i,:);
        if N(1)~=-1
            NM = N==discriptors2; % [(x1-x2),(y1-y2)...]
            [a,b] = sort(sum(NM'));
            
            if a(1) < 20  % && a(1)/a(2) > 0.8
                matchBox=[matchBox;i, b(1)];
            end
        end
    end
    % 增加置信比，递归
    if size(matchBox) <= 4
        [matchBox,rate] = matchMingHanDestion(discriptors1,discriptors2,rate+0.05);
    end

end