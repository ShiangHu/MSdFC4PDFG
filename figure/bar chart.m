% 数据
products = {'δ-θf', 'δ-αf', 'δ-γf', 'θ-αf', 'θ-γ1f', 'θ-γ2f', 'α-γ1f', 'α-γ2f'};
spat = [0.43,0.725,0.82,0.525,0.765,0.33,0.49,0.405];
time = [0.855,0.81,0.62,0.535,0.81,0.515,0.53,0.54];

% 误差数据（假设标准误差或标准偏差）
spat_err = [0.048, 0.0264, 0.048, 0.0354, 0.0337, 0.025, 0.036, 0.0643];
time_err = [0.0158, 0.0211, 0.035, 0.0242, 0.021, 0.0242, 0.0422, 0.021];

% 创建图形窗口
figure;

% 绘制分组条形图
b = bar([spat; time]', 'grouped');
hold on;

% 设置条形图的颜色
b(1).FaceColor = '#8BACD1'; % 青色
b(2).FaceColor = '#C17F9E'; % 品红色

% 添加误差条
% 对于第一组数据
x_spat = b(1).XEndPoints; % 获取第一组数据条形的中心位置
errorbar(x_spat, spat, spat_err, 'k', 'linestyle', 'none'); % 添加误差条

% 对于第二组数据
x_time = b(2).XEndPoints; % 获取第二组数据条形的中心位置
errorbar(x_time, time, time_err, 'k', 'linestyle', 'none'); % 添加误差条

title('');
xlabel('High frequence band');
ylabel('Accuracy');

% 设置x轴刻度标签
set(gca, 'XTickLabel', products);

% 设置纵轴刻度
ylim([0 1.1]);

% 添加图例
legend({'SV', 'TV'}, 'Location', 'northeast');

% % 在条形图顶部显示数值
% numOffset = 0.03 * max([spat time]); % 设置数值显示的垂直偏移
% for i = 1:length(spat)
%     % 对于每组数据，计算条形的中心位置
%     xCenterSpat = b(1).XData(i) + b(1).XOffset;
%     xCenterTime = b(2).XData(i) + b(2).XOffset;
%     text(xCenterSpat, spat(i) + numOffset, num2str(spat(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
%     text(xCenterTime, time(i) + numOffset, num2str(time(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
% end

% 显示网格
grid on;
set(gca, 'XGrid', 'off', 'YGrid', 'off');

% 设置图表的视觉美观
set(gca, 'Box', 'off'); % 去除图表的边框
set(gca, 'Layer', 'top'); % 将轴层放在最上面以覆盖网格线
