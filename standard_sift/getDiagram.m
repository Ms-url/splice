function a = getDiagram(E,L,NumLabels)

% function : ������Ȩͼ a
%:param E: ������۾��� 
%:param L: �����طָ����
%:param NumLabels: �����ظ���
%:return : ϡ����󣬱�Ȩͼa

    % [L,NumLabels]=superpixels(I,248);
    x=[];y=[];margin=[];
    for i=1:NumLabels
        [a,b]=find(L==i);
        L2 = L(min(a):max(a),min(b):max(b));
        lis = unique(L2(L(min(a):max(a),min(b):max(b))~=i));
        % lis = lis(lis > i);
        le = size(lis);
        
        for k=1:le
            % fprintf('%d->%d  E(L==%d)-E(L==lis(%d))\n',i,lis(k),i,k);
            x = [x,i];
            y = [y,lis(k)];
            margin = [margin, abs(sum(E(L==i))-sum(E(L==lis(k))))];
        end
    end
    
    a = sparse(x,y,margin); % ϡ����󣬱�Ȩͼ

end