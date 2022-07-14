function drawFanXiang(KeyPoints1)

[kr1,~,~]=size(KeyPoints1);
for i=1:kr1
    xo = KeyPoints1(i,1);
    yo = KeyPoints1(i,2);
    s_sigma = KeyPoints1(i,5);
    siat = KeyPoints1(i,6);
    R = round(3*1.5*s_sigma);
    
    x1 = xo + R*sind(siat);
    y1 = yo + R*cosd(siat);
    
    plot([xo,x1],[yo,y1],'r'); hold on;
    
    si = 0:pi/100:2*pi;
    x2=xo + R*sin(si);
    y2=yo + R*cos(si);
    plot(x2,y2,'r');
end


end