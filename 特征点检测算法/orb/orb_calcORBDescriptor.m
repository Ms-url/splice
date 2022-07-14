function figre = orb_calcSIFTDescriptor( regoin )
%:function :
%:param regoin : n*484
%:return £ºfigre
    [~,c]=size(regoin);
    figre = [];

    for i=1:fix(c/2)
        figre = [figre,regoin(:,i)>regoin(:,c-i+1)];  
    end

end