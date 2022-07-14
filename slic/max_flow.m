function [r,totalflow] = max_flow( r , n )

% function: sap+gap�㷨 ��ȡ��ʼ����r����������Լ���������
% param r; ϡ����󣬳�ʼ��Ȩͼ
% param n: �����ظ���
% return : ��������r�������totalflow

    r = full(r); 
    num = zeros(1,n+1); % num[i]��ʾ���Ϊi-1�Ķ������ж���  
    dis = zeros(1,n); % ��ž���
    pre = zeros(1,n); % ����·����¼ 
    
    [dis,num] = rev_bfs(dis,num,n);  
  
    totalflow=0;
    src = 1; % Դ��
    endp = n; % ���
    i=src;    
  
    pre(src) = -1;  
    while dis(src)<n   %Դ����  
        j=findArc(i);  %���ſ��л� i��j �ƶ�
        if j>=0  %���� i �� j 
            pre(j) = i;  % previous j֮ǰ�Ķ��㣬��¼·��
            i=j;  
            if(i==endp)  % �ж� i �Ƿ�Ϊ��� 
                d=inf;  % ���͵����ֵ
                %%% ����
                k=des;  
                while k~=src 
                    if d > r(pre(k),k)
                        d = r(pre(k),k);% Ѱ��·����Сͨ��
                    end
                    k=pre(k);
                end
                %%%
                %%% ����
                k=des; 
                while k~=src      
                    r( pre(k),k) = r( pre(k),k)- d ;  % ����·������
                    r(k, pre(k) ) = r(k, pre(k) )+d ;  % ����
                    k=pre(k);
                end
                %%%
                totalflow = totalflow + d;  
                i=src;  
            end
        else  
            num(dis(i)+1) = num(dis(i)+1)-1;  
            if(0==num(dis(i)+1)) % ���ֶϵ�ʱ����
                 break
            end
            x=reLable(i);  % �ҵ�i�ܵ���ĸ�������j����С���
            dis(i)=x+1;  % �� i �ı����Ϊ x+1
            num(dis(i)+1)=num(dis(i)+1)+1;  
            if i~=src
                i=pre(i);  % ����
            end
        end  
    end    

end

function [dis,num] = rev_bfs(dis,num,n)   

% functiom : ����bfs������,���des���Ϊ0
% param dis : ��ž���
% param mun : num[i]��ʾ���Ϊi-1�Ķ������ж���  
% param n : �����ظ���
% return : �������ı�ž���dis����num

    endp = n;
    for i=1:n  
        dis(i)=n;  % n �������
        num(i+1)=0;  % num[i]��ʾ���Ϊi-1�Ķ������ж���  
    end
    q=[];
    q =[q,endp];  % endp���
    dis(endp)=0;   % ����ţ�endp���
    num(1)=1;     % ��ʾ���Ϊ 0 �Ķ�����Ϊ 1  
    while min(size(q))~=0
        k=q(1);  % ���ʶ���Ԫ�أ������类ѹ����е�Ԫ��.front()������ queue �е�һ��Ԫ�ص����á���� queue �ǳ������ͷ���һ�������ã���� queue Ϊ�գ�����ֵ��δ����ġ�
        q(1)=[];  %  �������еĵ�һ��Ԫ��
        for i=1:n   
            if dis(i)==n && r(i,k)>0  
                dis(i)=dis(k)+1;  % ���
                q = [q,i] ;  % �� i �ӵ����е�ĩ�ˡ�
                num(dis(i)+1) = num(dis(i)+1)+1;  
            end
        end
    end
end

function  ret = findArc(i,r,dis)  

% function : ���ſ��л�������·
% param i: ��ǰ����
% param r: 
% param dis:  
% return : ���л� i �� j �����ض���j ,�޿��л�ʱ���� -1 

    ret = -1;
    for j=1:n  
        if(r(i,j)>0 && dis(i)==dis(j)+1)  %�������ſ��л�������·�����л��Ķ���Ϊ{( i , j ) , level[i]==level[j]+1}
            ret = j;
            break
        end
    end
end

function mindis = reLable(i,r,dis,n)  

% function : �ҵ�i�ܵ������С��ŵĶ���j
% param r: 
% param dis: 
% param i: ��ǰ����
% param n: ���
% return ��i�ܵ������С��ŵĶ���j  

    mindis = n;  % n ������
    for j=1:n  
        if r(i,j)>0 
            if mindis > dis(j)
                mindis = dis(j); % �ҵ�i�ܵ������С��ŵĶ���j     
            end
        end
    end
end
      
