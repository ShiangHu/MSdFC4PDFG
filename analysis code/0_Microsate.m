tic
clear;  clc;
%% 3 Tutorial: EEG microstates analysis on spontaneous EEG Data
%
% This script executes the analysis steps of the Tutorial described in
% detail in section 3.3 to 3.8 of:
% Poulsen, A. T., Pedroni, A., Langer, N., & Hansen, L. K. (2018).
% Microstate EEGlab toolbox: An introductionary guide. bioRxiv.
%
% Authors:
% Andreas Trier Poulsen, atpo@dtu.dk
% Technical University of Denmark, DTU Compute, Cognitive systems.
%
% Andreas Pedroni, andreas.pedroni@uzh.ch
% University of Zurich, Psychologisches Institut, Methoden der
% Plastizitaetsforschung.
x=n;
% start EEGLAB to load all dependent paths
eeglab
%% set the path to the directory with the EEG files
% change this path to the folder where the EEG files are saved
%最重要

% EEGdir = ['C:\Users\guohu\Desktop\1 allocation data\S00' num2str(n) '\fg'];
% % EEGdir1 = ['C:\Users\guohu\Desktop\1 allocation data\S00' num2str(n) '\ng'];
% % retrieve a list of all EEG Files in EEGdir
% EEGFiles = dir(fullfile(EEGdir, '*.set'));
% EEGFiles1 = dir(fullfEEGdir1, '*.set'));ile(
%% 3.3 Data selection and aggregation
%% 3.3.1 Loading datasets in EEGLAB
EEG1 = pop_loadset(''); 
% EEG1 = pop_loadset('C:\Users\admin\Desktop\task_10\ng\task_2.set'); 
for l1=1:x
Times = EEG1.xmax/x;
start_time =l1*Times-Times;
end_time = l1*Times;
EEG_segment = pop_select(EEG1, 'time', [start_time end_time]);
EEG_segment.xmax=end_time-start_time;
EEG_segment.times=EEG_segment.times(1:EEG_segment.pnts); 

% EEG_M_theta = pop_eegfilt(EEG_segment,4,8,[],[],1);
% EEG=EEG_M_theta;
EEG=EEG_segment;
EEG.filename=['task_' num2str(l1)];
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
eeglab redraw % updates EEGLAB datasets
end


% EEG2 = pop_loadset('filename',EEGFiles1(1).name,'filepath',EEGdir1);  
% for l1=1:x
% start_time =l1*2-2;
% end_time = l1*2;
% EEG_segment = pop_select(EEG2, 'time', [start_time end_time]);
% EEG_segment.xmax=end_time-start_time;
% EEG_segment.times=EEG_segment.times(1:EEG_segment.pnts); 
% 
% 
% EEG_M_theta = pop_eegfilt(EEG_segment,0.5,4,[],[],1);
% %EEG=EEG_M_theta;
% EEG=EEG_segment;
% EEG.filename=['task_' num2str(40+l1)];
% [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% eeglab redraw % updates EEGLAB datasets
% end

%% 3.3.2 Select data for microstate analysis  计算GFP
[EEG, ALLEEG] = pop_micro_selectdata( EEG, ALLEEG, 'datatype', 'spontaneous',...
'avgref', 1, ...
'normalise', 1, ...
'MinPeakDist', 10, ...
'Npeaks', 1000, ...
'GFPthresh', 1, ...
'dataset_idx', 1:length(ALLEEG) );
% store data in a new EEG structure
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
eeglab redraw % updates EEGLAB datasets
%% 3.4 Microstate segmentation  对GFP进行聚类
% select the "GFPpeak" dataset and make it the active set
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, length(ALLEEG)-1,'retrieve',length(ALLEEG),'study',0);
eeglab redraw
% Perform the microstate segmentation 执行微状态分割 
EEG = pop_micro_segment( EEG, 'algorithm', 'modkmeans', ...
'sorting', 'Global explained variance', ...
'Nmicrostates', 5:5, ...
'verbose', 1, ...
'normalise', 0, ...
'Nrepetitions', 50, ...
'max_iterations', 1000, ...
'threshold', 1e-06, ...
'fitmeas', 'CV',...
'optimised',1);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%% 3.5 Review and select microstate segmentation
%% 3.5.1 Plot microstate prototype topographies
figure;MicroPlotTopo( EEG, 'plot_range', [] );
%% 3.5.2 Select active number of microstates,
EEG = pop_micro_selectNmicro(EEG,'do_subplots',1,'Nmicro',5);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%% Import microstate prototypes from other dataset to the datasets that should be back-fitted
% 将其他数据集的微状态原型导入到需要进行回配的数据集  
% note that dataset number 5 is the GFPpeaks dataset with the microstate
% prototypes
occurence = cell(length(ALLEEG)-1,1);
duration = cell(length(ALLEEG)-1,1);
coverage = cell(length(ALLEEG)-1,1);
MGfp = cell(length(ALLEEG)-1,1);
data = cell(length(ALLEEG)-1,1);
TP_all = cell(length(ALLEEG)-1,1);
fit = cell(length(ALLEEG)-1,1);
prototypes = EEG.microstate.prototypes;
for i = 1:length(ALLEEG)-1
    fprintf('Importing prototypes and backfitting for dataset %i\n',i)
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',i,'study',0);
    EEG = pop_micro_import_proto( EEG, ALLEEG, length(ALLEEG));
%% 3.6 Back-fit microstates on EEG
    EEG = pop_micro_fit( EEG, 'polarity', 0 );
%% 3.7 Temporally smooth microstates labels
    EEG = pop_micro_smooth( EEG, 'label_type', 'backfit', ...
    'smooth_type', 'reject segments', ...
    'minTime', 30, ...
    'polarity', 0 );
%% 3.9 Calculate microstate statistics
    EEG = pop_micro_stats( EEG, 'label_type', 'backfit', ...
    'polarity', 0 );
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    occurence{i,1} = EEG.microstate.stats.Occurence;
    
    duration{i,1} = EEG.microstate.stats.Duration;
    coverage{i,1} = EEG.microstate.stats.Coverage;
    fitlabels = EEG.microstate.fit.labels;
    MGfp{i,1} =EEG.microstate.stats.Gfp;
    TP = EEG.microstate.stats.TP;
    GEVall(i,:) = EEG.microstate.stats.GEV;
    
    TP_all{i,1} = TP; % 按列排序
%     data{i,1} = [occurence, duration, coverage];
    fit{i,1} = fitlabels;
end
toc
 disp(['程序运行时间', num2str(toc)]) ;
%存fg的特征
TP_all1=cell(x,1);
for i=1:x
TP_all1{i}=TP_all{i};
end

coverage1=cell(x,1);
for i=1:x
coverage1{i}=coverage{i};
end

occurence1=cell(x,1);
for i=1:x
occurence1{i}=occurence{i};
end

duration1=cell(x,1);
for i=1:x
duration1{i}=duration{i};
end

% path2=['C:\Users\guohu\Desktop\δfg_microstate_feature\' num2str(n) '\'];
% filename=('TP_all.mat');
% save([path2,filename],"TP_all1");
% % filename=('GEVall.mat');
% % save([path2,filename],"GEVall");
% % filename=('MGfp.mat');
% % save([path2,filename],"MGfp");
%  filename=('coverage.mat');
% save([path2,filename],"coverage1");
% filename=('occurence.mat');
% save([path2,filename],"occurence1");
% filename=('duration.mat');
% save([path2,filename],"duration1");
% %存ng的特征
% TP_all2=cell(x,1);
% for i=1:x
% TP_all2{i}=TP_all{i+x};
% end
% 
% coverage2=cell(x,1);
% for i=1:x
% coverage2{i}=coverage{i+x};
% end
% 
% occurence2=cell(x,1);
% for i=1:x
% occurence2{i}=occurence{i+x};
% end
% 
% duration2=cell(x,1);
% for i=1:x
% duration2{i}=duration{i+x};
% end
% % path2=['C:\Users\guohu\Desktop\δng_microstate_feature\' num2str(n) '\'];
% % filename=('TP_all.mat');
% % save([path2,filename],"TP_all2");
% % % filename=('GEVall.mat');
% % % save([path2,filename],"GEVall");
% % % filename=('MGfp.mat');
% % % save([path2,filename],"MGfp");
% % filename=('coverage.mat');
% % save([path2,filename],"coverage2");
% % filename=('occurence.mat');
% % save([path2,filename],"occurence2");
% % filename=('duration.mat');
% % save([path2,filename],"duration2");
% 3.8 Illustrating microstate segmentation
%Plotting GFP of active microstates for the first 1500 ms for subject 1.
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',1,'study',0);
figure;MicroPlotSegments( EEG, 'label_type', 'backfit', ...
'plotsegnos', 'first', 'plot_time', [0 1800], 'plottopos', 1 );
eeglab redraw