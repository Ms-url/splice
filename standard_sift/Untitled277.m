r=20;
theta=0:pi/100:2*pi;
x=40+r*cos(theta);
y=40+r*sin(theta);
plot(40-r:0.1:40+r,ones(1,401)*(40+r));
plot(40-r:0.1:40+r,ones(1,401)*(40-r));
plot(ones(1,401)*(40+r),40-r:0.1:40+r);
plot(ones(1,401)*(40-r),40-r:0.1:40+r);
figure(1);
plot(x,y);
hold on;
th=0:pi/3:2*pi;
xh=28*cos(th);
yh=28*sin(th);
for i=1:6
   plot(x+xh(i),y+yh(i)); 
   plot(40+xh(i)-r:0.1:40+xh(i)+r,ones(1,401)*(40+yh(i)+r));
   plot(40+xh(i)-r:0.1:40+xh(i)+r,ones(1,401)*(40+yh(i)-r));
   plot(ones(1,401)*(40+xh(i)+r),40+yh(i)-r:0.1:40+yh(i)+r);
   plot(ones(1,401)*(40+xh(i)-r),40+yh(i)-r:0.1:40+yh(i)+r);
end

