function [r,totalflow] = max_flow( r , n )

% function: sap+gap算法 获取初始网络r的最大流，以及残留网络
% param r; 稀疏矩阵，初始边权图
% param n: 超像素个数
% return : 残留网络r，最大流totalflow

    r = full(r); 
    num = zeros(1,n+1); % num[i]表示标号为i-1的顶点数有多少  
    dis = zeros(1,n); % 标号矩阵
    pre = zeros(1,n); % 回溯路径记录 
    
    [dis,num] = rev_bfs(dis,num,n);  
  
    totalflow=0;
    src = 1; % 源点
    endp = n; % 汇点
    i=src;    
  
    pre(src) = -1;  
    while dis(src)<n   %源点标号  
        j=findArc(i);  %沿着可行弧 i→j 移动
        if j>=0  %存在 i → j 
            pre(j) = i;  % previous j之前的顶点，计录路径
            i=j;  
            if(i==endp)  % 判断 i 是否为汇点 
                d=inf;  % 整型的最大值
                %%% 回溯
                k=des;  
                while k~=src 
                    if d > r(pre(k),k)
                        d = r(pre(k),k);% 寻找路径最小通量
                    end
                    k=pre(k);
                end
                %%%
                %%% 回溯
                k=des; 
                while k~=src      
                    r( pre(k),k) = r( pre(k),k)- d ;  % 正向路径消减
                    r(k, pre(k) ) = r(k, pre(k) )+d ;  % 反向弧
                    k=pre(k);
                end
                %%%
                totalflow = totalflow + d;  
                i=src;  
            end
        else  
            num(dis(i)+1) = num(dis(i)+1)-1;  
            if(0==num(dis(i)+1)) % 出现断点时结束
                 break
            end
            x=reLable(i);  % 找到i能到达的各个顶点j的最小标号
            dis(i)=x+1;  % 将 i 的标号设为 x+1
            num(dis(i)+1)=num(dis(i)+1)+1;  
            if i~=src
                i=pre(i);  % 回溯
            end
        end  
    end    

end

function [dis,num] = rev_bfs(dis,num,n)   

% functiom : 反向bfs计算标号,汇点des标号为0
% param dis : 标号矩阵
% param mun : num[i]表示标号为i-1的顶点数有多少  
% param n : 超像素个数
% return : 计算过后的标号矩阵dis，和num

    endp = n;
    for i=1:n  
        dis(i)=n;  % n 顶点个数
        num(i+1)=0;  % num[i]表示标号为i-1的顶点数有多少  
    end
    q=[];
    q =[q,endp];  % endp汇点
    dis(endp)=0;   % 汇点标号，endp汇点
    num(1)=1;     % 表示标号为 0 的顶点数为 1  
    while min(size(q))~=0
        k=q(1);  % 访问队首元素，即最早被压入队列的元素.front()：返回 queue 中第一个元素的引用。如果 queue 是常量，就返回一个常引用；如果 queue 为空，返回值是未定义的。
        q(1)=[];  %  弹出队列的第一个元素
        for i=1:n   
            if dis(i)==n && r(i,k)>0  
                dis(i)=dis(k)+1;  % 标号
                q = [q,i] ;  % 将 i 接到队列的末端。
                num(dis(i)+1) = num(dis(i)+1)+1;  
            end
        end
    end
end

function  ret = findArc(i,r,dis)  

% function : 沿着可行弧找增广路
% param i: 当前顶点
% param r: 
% param dis:  
% return : 可行弧 i → j ，返回顶点j ,无可行弧时返回 -1 

    ret = -1;
    for j=1:n  
        if(r(i,j)>0 && dis(i)==dis(j)+1)  %不断沿着可行弧找增广路。可行弧的定义为{( i , j ) , level[i]==level[j]+1}
            ret = j;
            break
        end
    end
end

function mindis = reLable(i,r,dis,n)  

% function : 找到i能到达的最小标号的顶点j
% param r: 
% param dis: 
% param i: 当前顶点
% param n: 汇点
% return ：i能到达的最小标号的顶点j  

    mindis = n;  % n 顶点数
    for j=1:n  
        if r(i,j)>0 
            if mindis > dis(j)
                mindis = dis(j); % 找到i能到达的最小标号的顶点j     
            end
        end
    end
end
      
