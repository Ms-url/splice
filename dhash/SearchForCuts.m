function [r_x,c_y,img22]=SearchForCuts(hash1,img2)

% function : �ҵ���hash1��ƥ���img2�е�1/6��С������
% :param hash1: hashָ��
% :param img2: ͼ��
% return : ��hash1��ƥ���img2�е�1/6��С������img22��r_x c_y Ϊimg22���Ͻ���img2������

    [r1,c1]=size(img2);
    flag=0;
    for i=1:200:r1-200 % ���в���200
        x=round(c1/3);
        y=round(r1/2);
        for j=1:100:c1-100 % ���в���100
            hash2 = getdHash( img2(i:x,j:y));
            minghang = sum(hash1~=hash2); % ��������
            
            if minghang > 5
                x = x + min(200,r1-x);
                y = y + min(100,c1-y);
            else
                r_x = i;
                c_y = j;
                img22 = img2(i:y,j:x);
                flag=1;
                break;
            end
        end
        
        if flag==1
            break;
        end
    end


end