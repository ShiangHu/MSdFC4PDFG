tic 
toc 
%存放所有的数据
fs_ppc=cell(1,n);
for t=1:n
    %%计算fg的值
    %导入数据
    folderPath=[''];
    files = dir( );
    % 计算文件数量
    fileCount = numel(files);
    %s_ppc存放某个被试的所有片段的数据
    s_ppc=cell(1,fileCount);

    for q=1:fileCount
        filename1=[''];
        EEG=pop_loadset(filename1);
        phasel1=[];
        phasel2=[];
        lowEEG=[];
        highEEG=[];
        
        %对数据进行带通滤波
        low_band=[4,7];
        high_band=[30,35];
        low_EEG=pop_eegfilt(EEG,low_band(1),low_band(2),[],[],1);
        high_EEG=pop_eegfilt(EEG,high_band(1),high_band(2),[],[],1);
        
        %对数据进行希尔伯特变换
        lowEEG=low_EEG.data;
        highEEG=high_EEG.data;
        
        %qppc存放每个片段的5个状态的数据
        qppc=cell(1,5);

                for r=1:5
                    %计算对应分段的PPC
                    p=STT{1,q}{1,r}(length(STT{1,q}{1,r}));
                    r_pp=cell(1,p);
                    
                    
                    for k=1:p
                    r_pp{1,k}=zeros(25,25);
                    
                        for i=1:25
                            for j=1:25
                                phase1=angle(hilbert(lowEEG(i,STT{1,q}{1,r}(2*k-1):STT{1,q}{1,r}(2*k))));
                                phase2=angle(hilbert(highEEG(j,STT{1,q}{1,r}(2*k-1):STT{1,q}{1,r}(2*k))));
                                
                                %%计算PPC
                                    %fprintf('Progress: %d%%; Animal %d; Channel %d\n',round(100*(sample/Data.par.total_samples)),ses,ch)
                                %  if l1*500*2-(l1*2-2)*500>=500
                                %      %fprintf('Progress: %d%%; Animal %d; Channel %d\n',round(100*(sample/Data.par.total_samples)),ses,ch)
                                %      
                                %      upper_range = length(phase1) - 500;
                                %      lower_range = 1;
                                %     
                                %      I_rand = (upper_range-lower_range).*rand(1,1) + lower_range;
                                %      timewindow = round(I_rand):round(I_rand+500);
                                % else
                                timewindow=[];
                                    for l=1:length(phase1)
                                        timewindow(l)=l;
                                    end
                                % end
                                r_sample = mean(exp(1i*(5*(unwrap(phase1(timewindow))) - unwrap(phase2(timewindow)))));
                                
                                r_pp{1,k}(i,j)= abs(r_sample);
                            end
                        end
                    end
                    qppc{1,r}=r_pp; 
                end
                s_ppc{1,q}=qppc;
    end
    fs_ppc{1,t}=s_ppc;
end