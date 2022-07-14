function [KeyPoints,discriptors]=ORB(img)

% :param img: the original img
% :return : KeyPoints and discriptors

    SIFT_SIGMA = 1.6;
    SIFT_INIT_SIGMA = 0.5;   % ÉãÏñÍ·µÄ³ß¶È
    sigma0 = sqrt(SIFT_SIGMA^2 - SIFT_INIT_SIGMA^2);

    n = 3;

    GuassianPyramid = getGuassianPyramid(img, n, sigma0 ,0 );
    [regoin , KeyPoints] = orb_LocateKeyPoint(sigma0 , GuassianPyramid, n);
    discriptors = orb_calcORBDescriptor( regoin );
    
end