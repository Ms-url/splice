function [right_to,newBox,max_num]=ransac_homography3(KeyPoints1,KeyPoints2,matchBox,num)
% function : ransca �˳���ƥ�� ,�����ذ�������ڵ�ĵ�Ӧ�Ծ���
% param matchBox : ��ƥ���ƥ���
% param num �������������
% return �� right_to ��������ڵ�ĵ�Ӧ�Ծ���newBox �˳����ƥ��㣬max_num �ڵ�����
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
            errors = norm(rxo'-H*rx',2); %���
            if errors < 36 % �������Χ
                num_sum = num_sum + 1;
                key = [key ,k];
            end
        end
        %%�������ϵ�͸�Ӿ���
        if num_sum > max_num
            max_num = num_sum;
            newBox = matchBox(key,:);
            right_to = H;
        end
        
    end

end