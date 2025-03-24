% Sample data for demonstration
x = 1:11;
y1 =[0.95,1,0.625,0.9,0.855,0.95,0.945,0.665,0.905,0.65,0.844];
y2 =[0.9,1,0.81,0.95,0.95,1,0.955,0.525,0.915,0.575,0.858];

% 创建符合期刊尺寸的图形（宽度12cm适合双栏排版）
figure('Units', 'centimeters', 'Position', [10 10 12 8],... % 增大图形尺寸
    'Color', 'w', 'Name', 'Journal Figure');
hold on;

% 绘图设置（优化线宽和标记尺寸）
plot(x, y1, '-.d', 'Color', [0 0.45 0.74],... 
    'LineWidth', 1.2, 'MarkerSize', 6,... % 增大线宽和标记
    'MarkerFaceColor', [0 0.45 0.74],...
    'DisplayName', 'SV');

plot(x, y2, ':^', 'Color', [0.85 0.33 0.1],...
    'LineWidth', 1.2, 'MarkerSize', 6,... % 增大线宽和标记
    'MarkerFaceColor', [0.85 0.33 0.1],...
    'DisplayName', 'TV');

% 标题和坐标轴标签（增大字体）
title('MCNf\_PPC',...
    'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Arial'); % 添加标题
xlabel('Subject', 'FontSize', 11, 'FontName', 'Arial');
ylabel('Accuracy', 'FontSize', 11, 'FontName', 'Arial');

% 坐标轴定制
ax = gca;
ax.FontSize = 10; % 增大刻度标签字体
ax.FontName = 'Arial';
ax.LineWidth = 1;
ax.TickDir = 'out';
ax.XLim = [0.5 11.5];
ax.YLim = [0.4 1.1];
ax.YTick = 0.4:0.1:1.1;

% X轴标签设置
xticks(x);
xticklabels({'sub01','sub03','sub06','sub07','sub08',...
    'sub09','sub10','sub11','sub12','sub013','average'});
ax.XAxis.TickLabelRotation = 30; % 调整旋转角度

% 图例设置
legend('Location', 'southeast', 'FontSize', 10,... % 增大图例字体
    'Box', 'off', 'Color', 'none',...
    'NumColumns', 1);

% 设置图形输出比例
ax.PlotBoxAspectRatio = [3 2 1]; % 更协调的宽高比

% 添加辅助网格线（可选）
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridColor = [0.9 0.9 0.9];
ax.GridLineStyle = '--';

% 导出设置
exportgraphics(gcf, 'Journal_Style_Plot.pdf',...
    'ContentType', 'vector',...
    'Resolution', 600);

hold off;