function H=homography(pts1,pts2)
%
% 返回值 H 是3*3的矩阵 , pts2n = H * pts1n , 及 pst1 → pst2
% pts1 和 pts2是4*2的坐标矩阵对应特征点的(x,y)坐标
% 
n = size(pts1,1);
A = zeros(2*n,9);
pts1=pts1';
pts2=pts2';
A(1:2:2*n,1:2) = pts1';
A(1:2:2*n,3) = 1;
A(2:2:2*n,4:5) = pts1';
A(2:2:2*n,6) = 1;
x1 = pts1(1,:)';
y1 = pts1(2,:)';
x2 = pts2(1,:)';
y2 = pts2(2,:)';
A(1:2:2*n,7) = -x2.*x1;
A(2:2:2*n,7) = -y2.*x1;
A(1:2:2*n,8) = -x2.*y1;
A(2:2:2*n,8) = -y2.*y1;
A(1:2:2*n,9) = -x2;
A(2:2:2*n,9) = -y2;

[evec,~] = eig(A'*A);
H = reshape(evec(:,1),[3,3])';
H = H/H(end); % make H(3,3) = 1
end