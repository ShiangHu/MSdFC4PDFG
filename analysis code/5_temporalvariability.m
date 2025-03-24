function tr=temporalvariability(r_pp)
net=[];
for i=1:length(r_pp)
    net(:,:,i)=r_pp{i};
end

if isempty(net)
    disp('数组为空');
    tr=0;
end

numtime=size(net,3);
numchannel=size(net,1);
tr=[];
for i=1:numchannel
    x(:,:)=net(i,:,:);
    corr=corrcoef(x); 
    tr(i)=1-sum(sum(abs(corr)))/(numtime*(numtime-1)+0.00001);
    x=[];
end



