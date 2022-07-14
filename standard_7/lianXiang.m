function lianXiang(img1,KeyPoints1,discriptors1,img2,KeyPoints2,discriptors2,limitRate)

% :param limitRate :匹配限制比率 默认0.6  

    [imgr1,imgc1,~]=size(img1);
    [imgr2,imgc2,~]=size(img2);
    
    if imgr1<imgr2
        
        lianXiang(img2,KeyPoints2,discriptors2,img1,KeyPoints1,discriptors1)
        
    else
    
        KeyPoints22 =[ KeyPoints2(:,1), KeyPoints2(:,2) + imgc1,KeyPoints2(:,3:6)];
        
        img2 = [img2;zeros(imgr1-imgr2,imgc2,3)];
        img = [img1,img2];
        
        imshow(img);
        hold on;
        
%         scatter(KeyPoints1(:,2),KeyPoints1(:,1),'ob');
%         scatter(KeyPoints22(:,2),KeyPoints22(:,1),'ob');
        
        [matchBox,~] = matchOuShiDestion(discriptors1,discriptors2,limitRate);
        [~,newBox,~] = ransac_homography3(KeyPoints1,KeyPoints2,matchBox,6000);
%         [newBox,rate] = matchOuShiDestion(discriptors1,discriptors2 ,limitRate);
%         while size(newBox)<80
%             limitRate = rate + 0.02;
%             [newBox,rate] = matchOuShiDestion(discriptors1,discriptors2 ,limitRate);
%         end
        
        [k,~]=size(newBox);
        for i=1:k
            
            X=[KeyPoints1(newBox(i,1),2),KeyPoints22(newBox(i,2),2)];
            Y=[KeyPoints1(newBox(i,1),1),KeyPoints22(newBox(i,2),1)];
            plot(X,Y);
            
        end
       
    end
end