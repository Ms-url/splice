function tra = minCut(r,n)

% function : 由残余网络获取最小割
%:param r: 残余网络
%:param n: 残余网络大小 n * n
    
    tra = zeros(1,n) ; % tra(i) 标记是否走过顶点 i
    src = 1;
    endp = n;
    tra(1)=1;
tic
    tra = findPoint(src,r,tra,endp);
toc 
    tra(n)=0;
end

function tra = findPoint(i,r,tra,n)
    for j=i:n
        if r(i,j)~=0 && tra(j)==0
             tra(j)=1;
             tra = findPoint(j,r,tra,n);
        end
    end
end

