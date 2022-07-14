OutPictu = splitJoint_second_one(img2,H);
% OutPictu = splitJoint_second_change(img2,H);

[KeyPoints3,discriptors3]=SIFT(OutPictu);

[matchBox2,rate] = matchOuShiDestion(discriptors1,discriptors3,0.85);

% [H2,min_error]=ransac_homography2(KeyPoints1,KeyPoints3,matchBox2,4000,100000);
% OutPicture2 = splitJoint_up(img1,OutPictu,H2);

[H2,~,min_error]=ransac_homography3(KeyPoints1,KeyPoints3,matchBox2,6000);
OutPicture2 = splitJoint_up(img1,OutPictu,H2);
imshow(OutPicture2);
