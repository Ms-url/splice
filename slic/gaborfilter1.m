function [G,gabout] = gaborfilter1(I,Sx,Sy,f,theta)
%Describtion :
% :param I : Input image
% :param Sx & Sy : Variances along x and y-axes respectively ����
% :param f : The frequency of the sinusoidal function
% :param theta : The orientation of Gabor filter
% :param G : The output filter as described above
% :param gabout : The output filtered image
% %%isa�ж���������Ƿ�Ϊָ�����͵Ķ���
if isa(I,'double')~=1 
    I = double(I);
end
%%%%Sx,Sy�ڹ�ʽ��ֱ��ʾGuass��������x,y��ı�׼��൱��������gabor�����е�sigma. 
%%ͬʱҲ��Sx,Syָ����gabor�˲����Ĵ�С�����˲�������Ĵ�С��
%%����û�п��ǵ���λƫ��.fix(n)��ȡС��n������������ķ��򿿣�
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
