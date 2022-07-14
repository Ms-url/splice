function [dst,E,A] = splitJoint_s(img1 ,img2 ,H)
% function : ��λ��ֵ ,���÷�����ں�inosculate_sutureLine
% param img1 & img2:
% param H : ��Ӧ�Ծ���
% return : 

    [r,c,~] = size(img1);
    [h,w,~] = size(img2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  �ع�����
    H=H';
    offset=[1 1 1;1 w 1;h 1 1;h w 1]*H;
  % set = max(offset)-min(offset);
    set = max(offset);
    size_r=floor(max(r,set(1)));
    size_c=floor(max(c,set(2)));
    change_picture_pad = zeros(size_r,size_c); %����r��c��0����ƽ�ƽ�����󣩣���ʼ��Ϊ�㣨��ɫ��
    change_picture = zeros(size_r,size_c);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:r
        for j=1:c
            change_picture_pad(i,j)=img1(i,j);
        end
    end
    
    % OutPicture = zeros(h,w,3);
    % OutPicture = cast(OutPicture,'uint8');

    tic;
    [coordinate_x,coordinate_y] = find(img2); %������е�����λ��
    coordinate = [coordinate_x,coordinate_y,ones(length(coordinate_y),1)];% ���� z=1
    
    change = coordinate * H ;%��������仯
    change(:,1) = change(:,1)./change(:,3);
    change(:,2) = change(:,2)./change(:,3); %��ñ仯��ͼ���϶�Ӧ��x��yֵ
    change = floor( change + eps );
    
    change(change(:,1:2)==0) = 1; %�߽�Ϊ��ĵ��Ϊ1��
    change_coordinate = change(:,1:2); %��ñ任�������λ��
    toc;
    
    % for k=1:3
    %     img = imgo(:,:,k);
    img = img2;
    for i=1:length(coordinate)
        if change_coordinate(i,1)<1||change_coordinate(i,2)<1||change_coordinate(i,1)>size_r||change_coordinate(i,2)>size_c
            continue
        end
        change_picture(change_coordinate(i,1),change_coordinate(i,2))=img(coordinate(i,1),coordinate(i,2));
    end % ����Ӧ��������ض�Ӧ
    change_picture=cast(change_picture,'uint8');
    
    tic;
    D = padarray(change_picture,[3 3],'replicate','both');%�������
    for i=4:size_r+3
        for j=floor(offset(1,2))+4:size_c+3
            if D(i,j)==0
                no_zero=find(D(i-1:i+1,j-1:j+1)~=0);
                [m,~]=size(no_zero);
                if m~=0
                    B = D(i-1:i+1,j-1:j+1);
                else
                    no_zero=find(D(i-2:i+2,j-2:j+2)~=0);
                    [m,~]=size(no_zero);
                    if m~=0
                        B = D(i-2:i+2,j-2:j+2);
                    else
                        no_zero = find(D(i-3:i+3,j-3:j+3)~=0);
                        B = D(i-3:i+3,j-3:j+3);
                    end
                    % ��û�б����ĵ���д���
                end
                
                medi = median(B(no_zero));
                if isnan(medi)
                    change_picture(i-3,j-3) = 0;
                else
                    change_picture(i-3,j-3) = medi;
                end
                % ԭû�б���ֵ�ɹ������ص㣬����Χ�������ص���λ������
            end
        end
    end
    %     OutPicture(:,:,k)=change_picture_pad;
    % end % ��ͨ�������õ���ɫͼ��
    toc;
    
    dst = inosculate_sutureLine(change_picture_pad,change_picture,offset,c);
    [E,A] = inosculate_get_E(change_picture_pad,change_picture,offset,c);
    [dst,P,L] = inosculate_E_cut(change_picture_pad,change_picture,offset,c);
    figure(1);
    imshow(E,[]);
    figure(2);
    imshow(P,[]);
    figure(3)
    imshow(dst,[]);
    kl=90;

end