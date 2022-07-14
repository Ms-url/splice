function [matchBox,rate] = matchMingHanDestion(discriptors1,discriptors2,rate)

% function : ����ŷʽ����ƥ������������ƥ������Ϊ 0ʱ�����ű�ÿ������0.05
% :param discriptors1,discriptors2: ��������
% :param rate: ���űȣ�Ĭ��0.6
% return : matchBox n*2 ����ƥ���������
    
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
    % �������űȣ��ݹ�
    if size(matchBox) <= 4
        [matchBox,rate] = matchMingHanDestion(discriptors1,discriptors2,rate+0.05);
    end

end