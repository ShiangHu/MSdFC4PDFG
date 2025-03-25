clear;
cg=cell(1,10);
a1=load('C:\Users\admin\Desktop\DFC\DFC_ng_ppc.mat');
a=a1.dfnppc;
%创建功能连接数组
for p=1:10
sg=cell(1,length(a{1,p}));
for q=1:length(a{1,p})
b=a{1,p}{1,q};

n=length(b);

%%获取动态功能连接举证的上三角展开
%n为窗口的个数
A=zeros(625,n);
for i=1:n
    t=1;
    for j=1:25
        for k=1:25
        A(t,i)=b{1,i}(j,k);
        t=t+1;
        end
    end
end
B=A';



%%进行K均值聚类，并进行1000次迭代
k=3;
[idx,C] = kmeans(B,k,'Distance','cityblock','MaxIter',1000,'Start','plus');

%%得到的k种状态的功能连接矩阵
KF=cell(1,k);
for i=1:k
    KF{i}=zeros(25,25);
end

for l=1:k
    t=0;
    for i=1:25
        for j=i:25
            t=t+1;
            KF{l}(i,j)=C(l,t);
            KF{l}(j,i)=C(l,t);
        end
    end
end

jishu=zeros(2,3);
zuihou=zeros(2,3);
%%聚类系数
julei=zeros(25,k);
for i=1:k
    julei(:,i)=clustering_coef_bu(KF{i});
end

jishu(2,:)=1:3;
jishu(1,:)=julei(1,:);

sa=find(julei(1,:)==min(julei(1,:)));
sb=find(julei(1,:)==median(julei(1,:)));
sc=find(julei(1,:)==max(jishu(1,:)));
zuihou(:,1)=jishu(:,sa);
zuihou(:,2)=jishu(:,sb);
zuihou(:,3)=jishu(:,sc);




%%%计算动态脑网络
%%状态发生概率
s1=0;
s2=0;
s3=0;
SOP=zeros(1,3);
for i=1:length(idx)
    if idx(i)==1
        s1=s1+1;
    end
    if idx(i)==2
        s2=s2+1;
    end
    if idx(i)==3
        s3=s3+1;
    end
end


SOP(1)=s1/length(idx);
SOP(2)=s2/length(idx);
SOP(3)=s3/length(idx);



%%状态转换百分比
SOPij=zeros(3,3);
%内部状态转换比
for i=1:length(idx)-1
    if idx(i)==1 && idx(i+1)==1
        SOPij(1,1)=SOPij(1,1)+1;
    end
    if idx(i)==2 && idx(i+1)==2
        SOPij(2,2)=SOPij(2,2)+1;
    end
    if idx(i)==3 && idx(i+1)==3
        SOPij(3,3)=SOPij(3,3)+1;
    end
end
%外部转换比
for i=1:length(idx)-1
    %1,:
    if idx(i)==1 && idx(i+1)==2
        SOPij(1,2)=SOPij(1,2)+1;
    end
    if idx(i)==1 && idx(i+1)==3
        SOPij(1,3)=SOPij(1,3)+1;
    end
    %2,:
    if idx(i)==2 && idx(i+1)==1
        SOPij(2,1)=SOPij(2,1)+1;
    end
    if idx(i)==2 && idx(i+1)==3
        SOPij(2,3)=SOPij(2,3)+1;
    end
    %3,:
    if idx(i)==3 && idx(i+1)==1
        SOPij(3,1)=SOPij(3,1)+1;
    end
    if idx(i)==3 && idx(i+1)==2
        SOPij(3,2)=SOPij(3,2)+1;
    end
end
%计算概率
% for i=1:3
%     for j=1:3
%     SOPij(i,j)=SOPij(i,j)/(length(idx)-1);
%     end
% end
% t=0;
% for i=1:3
%     for j=1:3
%     t=SOPP(i,j)+t;
%     end
% end


SOPP=[];
for i=1:3
    for j=1:3
    SOPP(i,j)=SOPij(zuihou(2,i),zuihou(2,j))/(length(idx)-1);
    end
end
% 调整顺序
as=zeros(3,3);
ds=zeros(3,3);
as(:,zuihou(2,1))=SOPP(:,1);
as(:,zuihou(2,2))=SOPP(:,2);
as(:,zuihou(2,3))=SOPP(:,3);
ds(zuihou(2,1),:)=as(1,:);
ds(zuihou(2,2),:)=as(2,:);
ds(zuihou(2,3),:)=as(3,:);


sg{1,q}=ds;

end
cg{1,p}=sg;
end