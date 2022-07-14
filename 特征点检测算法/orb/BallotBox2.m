function binBox = BallotBox2( Box, binNum)

% function: ��ֱ��ͼ��������ͶƱ��Χ�������ݷ�Χ����һ��ͶƱ
% param mold: ����
% param angle������ , ������
% param binBox: ͶƱ��
% param binNum: ֱ��ͼ����
% return��binBox
    
    binBox=zeros(1,binNum);
    mold = Box(:,1);
    angle = Box(:,2).*(180/pi);

    angle(angle<0) = 360 - abs(angle(angle<0));
    angle(angle==360) = angle(angle==360)-1;
    
    minRange = 360/binNum ;
    
    angle = fix( angle./ minRange );
    for i=1:binNum
        binBox(i)=sum(mold(angle==(i-1)));
    end
    
end