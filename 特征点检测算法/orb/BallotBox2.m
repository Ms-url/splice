function binBox = BallotBox2( Box, binNum)

% function: 按直方图数量生成投票范围，并根据范围进行一次投票
% param mold: 幅度
% param angle：幅角 , 幅度制
% param binBox: 投票箱
% param binNum: 直方图数量
% return：binBox
    
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