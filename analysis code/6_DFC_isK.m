%肘方法确定k的取值
data=B;
[n,p]=size(data);
K=8;D=zeros(K,2);
for k=2:K
    
[lable,c,sumd,d]=kmeans(data,k,'dist','sqeuclidean');
% data，n×p原始数据向量
% lable，n×1向量，聚类结果标签；
% c，k×p向量，k个聚类质心的位置
% sumd，k×1向量，类间所有点与该类质心点距离之和
% d，n×k向量，每个点与聚类质心的距离
sse1 = sum(sumd.^2);
D(k,1) = k;
D(k,2) = sse1;
end

plot(D(2:end,1),D(2:end,2))
hold on;
plot(D(2:end,1),D(2:end,2),'or');

title('不同K值聚类偏差图') 
xlabel('分类数(K值)') 
ylabel('簇内误差平方和') 
