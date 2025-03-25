%tdata(1:length(fmi{t}),2:626)=fpac;
%tdata((length(fmi{t})+1):(length(fmi{t})+length(nmi{t})),2:626)=npac;
%%任务一
%mode=load("C:\Users\guohu\Desktop\组会\2023.4.17\data\DFC_data.mat");
%tdata=DT;
%对标签，数据进行赋值
% data=zeros(32,4);
% data(:,1:2)=tdata(:,4:5);
% data(:,3:4)=tdata(:,8:9);
%tdata=[];
data=tdata(:,2:(length(tdata(1,:))));
label=tdata(:,1);
%k验证
n_acc=zeros(1,10);
%n_std=zeros(1,10);
for q=1:n
    cv = cvpartition(label, 'KFold', 10);
    accuracy = zeros(1, 10);
    %indices=crossvalind('Kfold',label,10);
    for i = 1:10
        Train = cv.training(i);
        test= cv.test(i);
        %训练模型
        model=svmtrain(label(Train), data(Train,:),'-s 0 -t 2 -c 20 -g 0.5');
        %c 10, g 30 80%
        %c 8,g 40 85%
        %预测模型
        %[predict_label,accuracy_i,dec_values]=svmpredict(test_label,test_data,model);
        %accuracy(i)=accuracy_i;
        
        [pred_Y, accuracy_i, decision_values] = svmpredict(label(test), data(test,:), model);
        accuracy(i) = accuracy_i(1)/100;
        b = model.rho;
    end
    n_acc(1,q) = mean(accuracy);
    %n_std(1,q) = std(accuracy);
end
mean_acc=mean(n_acc);
std_acc=std(n_acc);
[score, TPR, TNR] = f1_score(label(test), pred_Y); 
