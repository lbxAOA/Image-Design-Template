clear; clc; close all;

%% 生成随机数据
rng(42);  % 设置随机种子，保证可重复性

% 定义热力图的行列数
numRows = 10;  % 行数
numCols = 12;  % 列数

% 生成随机矩阵数据 (范围0-100)
data = randi([0, 100], numRows, numCols);

% 定义行标签和列标签
rowLabels = arrayfun(@(x) sprintf('样本 %d', x), 1:numRows, 'UniformOutput', false);
colLabels = arrayfun(@(x) sprintf('指标 %d', x), 1:numCols, 'UniformOutput', false);

%% 绑定热力图
figure('Name', '标准热力图', 'Position', [100, 100, 900, 600]);

h = heatmap(colLabels, rowLabels, data);

% 设置热力图属性
h.Title = '标准热力图示例';
h.XLabel = '指标';
h.YLabel = '样本';
h.Colormap = parula;  % 可选: jet, hot, cool, spring, summer, autumn, winter
h.ColorbarVisible = 'on';
h.CellLabelColor = 'auto';
h.FontSize = 10;
h.ColorLimits = [0, 100];

%% 保存图形
% saveas(gcf, 'heatmap_plot.png');
% saveas(gcf, 'heatmap_plot.fig');

%% 输出信息
fprintf('热力图绑定完成!\n');
fprintf('数据矩阵大小: %d x %d\n', numRows, numCols);
fprintf('数据范围: [%d, %d]\n', min(data(:)), max(data(:)));
fprintf('数据均值: %.2f\n', mean(data(:)));
