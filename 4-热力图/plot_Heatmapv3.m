%% 带注释的热力图 (Annotated Heatmap)
% 使用 MATLAB 内置 heatmap 函数，简洁高效

clear; clc; close all;

%% 1. 生成随机数据
rng(42);  % 设置随机种子，保证可重复性
data = randi([0, 100], 6, 8);  % 6行8列的随机整数矩阵

%% 2. 定义行列标签
rowLabels = {'行1', '行2', '行3', '行4', '行5', '行6'};
colLabels = {'列A', '列B', '列C', '列D', '列E', '列F', '列G', '列H'};

%% 3. 绘制带注释的热力图
figure('Position', [100, 100, 800, 500]);
h = heatmap(colLabels, rowLabels, data);

%% 4. 设置热力图属性
h.Title = '带注释的热力图示例';
h.XLabel = 'X 轴标签';
h.YLabel = 'Y 轴标签';
h.Colormap = parula;           % 配色方案：parula / jet / hot / cool
h.ColorbarVisible = 'on';      % 显示颜色条
h.CellLabelFormat = '%d';      % 单元格数值格式（整数）
h.FontSize = 10;               % 字体大小

%% 5. 可选：自定义配色
% h.Colormap = turbo;          % 其他配色选项
% h.ColorLimits = [0 100];     % 固定颜色范围
