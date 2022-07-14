function  [direction , n] = GetMainDirection2( img , x, y, sigma , binNum)

% :param img:
% :param x: row
% :param y: col
% :param binNum:
% return : ����MainDirection(�Ƕ�)������� ,�����߽�ʱ���� -1

    [r,c,~]=size(img);
   % binBox = zeros(1, binNum); 
    R = round(3*1.5*sigma);
    Box=[];
    
    % ��ȡ����������
    if x-R-1 <=0 || x+R+1>r || y-R-1<=0 || y+R+1>c
        direction = -1;
        n = 0;
    else
        imgor = img( x-R-1:x+R+1, y-R-1:y+R+1);
        % ��˹ģ��
        G_imgor = conv2( imgor, GuassianKernel(sigma*1.5 , 5),'same');
        % Բ�������ϰ벿��
        for i=R-1:-1:0
            chord = getChordLength( i, R) ;
            for j=0:chord-1
                postion_x = R-i+1;
                postion_y = R-(chord-1)/2 + 2 + j;
                % ��ֵ
                mold = ( (G_imgor(postion_x+1,postion_y)-G_imgor(postion_x-1,postion_y))^2 ...
                    + (G_imgor(postion_x,postion_y+1)-G_imgor(postion_x,postion_y-1))^2)^0.5;
                % ����
                angle = atan( ( G_imgor( postion_x+1 ,postion_y) - G_imgor( postion_x-1 ,postion_y)) / ...
                    ( G_imgor( postion_x ,postion_y+1) - G_imgor( postion_x ,postion_y-1)) );
                
                Box = [Box; mold , angle ];
                
            end
        end
        
        % Բ�������°벿��
        for i=R+2:2*R-1
            chord = getChordLength( i-R-1, R) ;
            for j=0:chord-1
                postion_x = i;
                postion_y = R-(chord-1)/2 + 2 + j;
                % ��ֵ
                mold = ( (G_imgor(postion_x+1,postion_y)-G_imgor(postion_x-1,postion_y))^2 ...
                    + (G_imgor(postion_x,postion_y+1)-G_imgor(postion_x,postion_y-1))^2)^0.5;
                % ����
                angle = atan( ( G_imgor( postion_x+1 ,postion_y) - G_imgor( postion_x-1 ,postion_y)) / ...
                    ( G_imgor( postion_x ,postion_y+1) - G_imgor( postion_x ,postion_y-1)) );
               
                 Box = [Box; mold , angle ];
                
            end
        end
        

        binBox = BallotBox2(Box,binNum);
        [value,index] = sort( binBox, 'descend');
        
        if value(2)/value(1) >= 0.8
            n = 2;
            direction = zeros(1,2);
            for k=1:n
                if index(k) == binNum
                    direction(k) = 0;
                else
                    direction(k) = index(k)*(360/binNum);
                end
            end
        else
            n = 1;
            if index(1) == binNum
                direction = 0;
            else
                direction = index(1)*(360/binNum);
            end
         end
    end
end