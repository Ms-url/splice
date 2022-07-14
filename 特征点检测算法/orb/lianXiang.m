function lianXiang(img1,KeyPoints1,discriptors1,img2,KeyPoints2,discriptors2)

    [imgr1,imgc1]=size(img1);
    [imgr2,imgc2]=size(img2);
    
    if imgr1<imgr2
        
        lianXiang(img2,KeyPoints2,discriptors2,img1,KeyPoints1,discriptors1)
        
    else
    
        KeyPoints22 =[ KeyPoints2(:,1), KeyPoints2(:,2) + imgc1, KeyPoints2(:,3:5)];
        tic;
        img2 = [img2;zeros(imgr1-imgr2,imgc2)];
        img = [img1,img2];
        toc;
        
        tic;
        imshow(img);
        hold on;
        toc;
        
        scatter(KeyPoints1(:,2),KeyPoints1(:,1),'ob');
        scatter(KeyPoints22(:,2),KeyPoints22(:,1),'ob');
        
        tic;
        [matchBox,rate] = matchMingHanDestion(discriptors1,discriptors2,0.6);
        rate
        toc;
        
        [k,~]=size(matchBox);
        for i=1:k
            
            X=[KeyPoints1(matchBox(i,1),2),KeyPoints22(matchBox(i,2),2)];
            Y=[KeyPoints1(matchBox(i,1),1),KeyPoints22(matchBox(i,2),1)];
            plot(X,Y);
            
        end
       
        
    end
end