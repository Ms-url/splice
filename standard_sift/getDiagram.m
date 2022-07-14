function a = getDiagram(E,L,NumLabels)

% function : ¹¹½¨±ßÈ¨Í¼ a
%:param E: ²îÒì´ú¼Û¾ØÕó 
%:param L: ³¬ÏñËØ·Ö¸î¾ØÕó
%:param NumLabels: ³¬ÏñËØ¸öÊı
%:return : Ï¡Êè¾ØÕó£¬±ßÈ¨Í¼a

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
    
    a = sparse(x,y,margin); % Ï¡Êè¾ØÕó£¬±ßÈ¨Í¼

end