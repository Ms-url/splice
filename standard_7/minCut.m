function tra = minCut(r,n)

% function : �ɲ��������ȡ��С��
%:param r: ��������
%:param n: ���������С n * n
    
    tra = zeros(1,n) ; % tra(i) ����Ƿ��߹����� i
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

