function result=GuassianKernel(sigma , dim)
    
% :param sigma: Standard deviation
% :param dim: dimension(must be positive and also an odd number)
% :return: return the required Gaussian kernel.

    tump=[];
    for t=0:dim-1
        tump = [tump , t - fix(dim/2)];
    end
    assistant = [];
    for i=1:dim
        assistant=[assistant;tump];
    end
    temp = 2*sigma*sigma;
    result = (1.0/(temp*pi))*exp(-(assistant.^2+(assistant').^2)./temp);
    result = result/sum(sum(result)); % ¹éÒ»»¯ 0.010~0.02s
    
end
   