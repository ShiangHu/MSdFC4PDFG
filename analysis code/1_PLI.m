tic 
toc 
%存放所有的数据
fs_ppc=cell(1,n);
for t=1:n
    %%计算fg的值
    %导入数据
    folderPath=('');
    files = dir(fullfile(folderPath, ['']));
    % 计算文件数量
    fileCount = numel(files);
    %s_ppc存放某个被试的所有片段的数据
    s_ppc=cell(1,fileCount);

    for q=1:fileCount
        filename1=[''];
        EEG=pop_loadset(filename1);
        EEG_M_theta = pop_eegfilt(EEG,21,30,[],[],1);
        EEG=EEG_M_theta;
        
        %对数据进行希尔伯特变换
        
        %qppc存放每个片段的6个状态的数据
        qppc=cell(1,5);

                for r=1:5
                    %计算对应分段的PPC
                    p=STT{1,q}{1,r}(length(STT{1,q}{1,r}));
                    r_pp=cell(1,p);
                    
                    
                    for k=1:p
                        X=EEG.data(:,STT{1,q}{1,r}(2*k-1):STT{1,q}{1,r}(2*k))';
                        r_pp{1,k}=zeros(25,25);
                    
                        % Given a multivariate data, returns phase lag index matrix
                        % Modified the mfile of 'phase synchronization'
                        ch=25; % column should be channel
                        %%%%%% Hilbert transform and computation of phases
                        % for i=1:ch
                        %     phi1(:,i)=angle(hilbert(X(:,i)));
                        % end

                        phi1=angle(hilbert(X));
                        PLI=zeros(25,25);
                        for ch1=1:ch-1
                            for ch2=ch1+1:ch
                                %%%%%% phase lage index
                                PDiff=phi1(:,ch1)-phi1(:,ch2); % phase difference
                                PLI(ch1,ch2)=abs(mean(sign(sin(PDiff)))); % only count the asymmetry
                                PLI(ch2,ch1)=PLI(ch1,ch2);
                            end
                        end
                         r_pp{1,k}= PLI;
              
                    end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                    qppc{1,r}=r_pp; 
                end
                s_ppc{1,q}=qppc;
    end
    fs_ppc{1,t}=s_ppc;
end