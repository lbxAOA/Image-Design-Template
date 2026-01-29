%% 热力图 + 注释 (Heatmap with Annotations)
% 使用 MATLAB 内置 heatmap 函数，简洁高效

clc; clear; close all;

%% 生成随机数据
rng(42);  % 设置随机种子，保证可重复性
data = randi([0, 100], 6, 8);  % 6行8列的随机整数矩阵

% 定义行列标签
rowLabels = {'Row 1', 'Row 2', 'Row 3', 'Row 4', 'Row 5', 'Row 6'};
colLabels = {'Col A', 'Col B', 'Col C', 'Col D', 'Col E', 'Col F', 'Col G', 'Col H'};

%% 绘制热力图（自带注释功能）
figure('Position', [100, 100, 800, 500]);

h = heatmap(colLabels, rowLabels, data);

% 设置热力图属性
h.Title = '热力图示例 (Heatmap with Annotations)';
h.XLabel = 'X 轴标签';
h.YLabel = 'Y 轴标签';
h.Colormap = parula;  % 颜色映射：parula, jet, hot, cool, etc.
h.ColorbarVisible = 'on';
h.CellLabelColor = 'black';  % 注释文字颜色
h.CellLabelFormat = '%d';    % 注释格式：整数
h.FontSize = 10;

% 设置缺失数据显示（可选）
% h.MissingDataLabel = 'N/A';
% h.MissingDataColor = [0.8 0.8 0.8];

%% 保存图片（可选）
% exportgraphics(gcf, 'heatmap_with_annotations.png', 'Resolution', 300);
