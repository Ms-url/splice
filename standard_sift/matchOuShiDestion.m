function [matchBox,rate] = matchOuShiDestion(discriptors1,discriptors2,rate)

% function : ����ŷʽ����ƥ������������ƥ������Ϊ 0ʱ�����ű�ÿ������0.05
% :param discriptors1,discriptors2: ��������
% :param rate: ���űȣ�Ĭ��0.6
% return : matchBox n*2 ����ƥ���������
    
    matchBox=[];
    [len,~] = size(discriptors1);
    [len2,~] = size(discriptors2);
    for i=1:len
        
        N=discriptors1(i,:);
        NM=N-discriptors2; % [(x1-x2),(y1-y2)...]
        
        min=1000;
        min2=1000;
        flag=0;
        
        for ii=1:len2-1
            if norm(NM(ii,:),2) < min2 && norm(NM(ii,:),2) ~=min
                min2 = norm(NM(ii,:),2);
                if norm(NM(ii,:),2) < min
                    if ii~=1
                        min2 = min;
                    end
                    min = norm(NM(ii,:),2);
                    flag = ii;
                   
                end
                
            end
        end
       
        if min/min2 > rate
            continue
        end

        matchBox=[matchBox;i ,flag];

    end
    % �������űȣ��ݹ�
    if size(matchBox) <= 4
        [matchBox,rate] = matchOuShiDestion(discriptors1,discriptors2,rate+0.05);
    end

end