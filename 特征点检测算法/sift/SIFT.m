function [KeyPoints,discriptors] = SIFT(img)

% :param img: the original img
% :return : KeyPoints and discriptors

    SIFT_SIGMA = 1.6;
    SIFT_INIT_SIGMA = 0.5;   % ÉãÏñÍ·µÄ³ß¶È
    sigma0 = sqrt(SIFT_SIGMA^2 - SIFT_INIT_SIGMA^2);

    n = 3;

    [DoG,GuassianPyramid] = getDoG(img, n, sigma0 ,0 ,0);

    KeyPoints = LocateKeyPoint4(DoG, sigma0 , GuassianPyramid, n);
    discriptors = getCalcDescriptors( GuassianPyramid ,KeyPoints);
    
end

