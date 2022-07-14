function [G,gabout] = gaborfilter1(I,Sx,Sy,f,theta)
%Describtion :
% :param I : Input image
% :param Sx & Sy : Variances along x and y-axes respectively 方差
% :param f : The frequency of the sinusoidal function
% :param theta : The orientation of Gabor filter
% :param G : The output filter as described above
% :param gabout : The output filtered image
% %%isa判断输入参量是否为指定类型的对象
if isa(I,'double')~=1 
    I = double(I);
end
%%%%Sx,Sy在公式里分别表示Guass函数沿着x,y轴的标准差，相当于其他的gabor函数中的sigma. 
%%同时也用Sx,Sy指定了gabor滤波器的大小。（滤波器矩阵的大小）
%%这里没有考虑到相位偏移.fix(n)是取小于n的整数（往零的方向靠）
for x = -fix(Sx):fix(Sx)
    for y = -fix(Sy):fix(Sy)
        xPrime = x * cos(theta) + y * sin(theta);
        yPrime = y * cos(theta) - x * sin(theta);
        G(fix(Sx)+x+1,fix(Sy)+y+1) = exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2))*cos(2*pi*f*xPrime);
    end
end
Imgabout = conv2(I,double(imag(G)),'same');
Regabout = conv2(I,double(real(G)),'same');
gabout = sqrt(Imgabout.*Imgabout + Regabout.*Regabout);
end
