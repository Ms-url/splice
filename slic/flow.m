function a = flow(E,L,NumLabels)
%
%:param E: ������۾��� 
%:param L: �����طָ����
%:param NumLabels: �����ظ���
%:

    % [L,NumLabels]=superpixels(I,248);
    x=[];y=[];margin=[];
    for i=1:NumLabels
        [a,b]=find(L==i);
        L2 = L(min(a):max(a),min(b):max(b));
        lis = unique(L2(L(min(a):max(a),min(b):max(b))~=i));
        lis = lis(lis > i);
        le = size(lis);
        
        for k=1:le
            % fprintf('%d->%d  E(L==%d)-E(L==lis(%d))\n',i,lis(k),i,k);
            x = [x,i];
            y = [y,lis(k)];
            margin = [margin, abs(E(L==i)-E(L==lis(k)))];
        end
    end
    
    a = sparse(x,y,margin); % ϡ����󣬱�Ȩͼ

end