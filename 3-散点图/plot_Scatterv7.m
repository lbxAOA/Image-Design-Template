%% 散点图 + 密度图

clear; clc; close all;

%% 1. 生成随机数据
rng(42);  % 固定随机种子，便于复现
n = 500;  % 数据点数量

% 生成双峰分布数据
x = [randn(n/2, 1) * 1.5 + 2; randn(n/2, 1) * 1 - 2];
y = [randn(n/2, 1) * 1 + 1; randn(n/2, 1) * 1.5 - 1];

%% 2. 创建图形
figure('Position', [100, 100, 800, 800], 'Color', 'w');

%% 3. 使用 scatterhistogram（最简单的方法）
% MATLAB R2018b+ 内置函数，一行代码搞定
s = scatterhistogram(x, y);

% 设置属性
s.Title = '散点图 + 密度直方图';
s.XLabel = 'X 变量';
s.YLabel = 'Y 变量';
s.MarkerSize = 15;
s.MarkerAlpha = 0.5;
s.Color = [0.2 0.4 0.8];
s.HistogramDisplayStyle = 'smooth';  % 平滑密度曲线
s.LineWidth = 2;

% 设置字体
set(gca, 'FontSize', 12, 'FontName', 'Microsoft YaHei');
