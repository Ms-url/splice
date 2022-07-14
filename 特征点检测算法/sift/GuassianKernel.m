function result=GuassianKernel(sigma , dim)
    
% :param sigma: Standard deviation
% :param dim: dimension(must be positive and also an odd number)
% :return: return the required Gaussian kernel.

    tump=zeros(1,dim);
    for t=0:dim-1
        tump(t+1) = t - fix(dim/2);
    end
    assistant = zeros(dim,dim);
    for i=1:dim
        assistant(i,:)=tump;
    end
    temp = 2*sigma*sigma;
    result = (1.0/(temp*pi))*exp(-(assistant.^2+(assistant').^2)./temp);
    result = result/sum(sum(result)); % πÈ“ªªØ 0.010~0.02s
    
end
   