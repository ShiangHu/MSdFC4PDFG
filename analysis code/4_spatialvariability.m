function sr=spatialvariability(r_pp)
net=[];
for i=1:length(r_pp)
    net(:,:,i)=r_pp{i};
end

if isempty(net)
    disp('数组为空');
    sr=0;
end

numtime=size(net,3);
numchannel=size(net,1);
for i=1:numchannel
    a=[];
    for j=1:numchannel
        if i~=j
            a=[a,net(i,j,:)];              
        end
    end
    x(:,:)=a;
    corr=corrcoef(x');
    sr(i)=1-(sum(sum(corr)))/((numchannel-1)*(numchannel-2)+0.00001);
end
