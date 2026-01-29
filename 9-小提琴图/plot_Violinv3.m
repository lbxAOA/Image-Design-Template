%% 带数据点的小提琴图

clear; clc; close all;

%% 随机生成数据
rng(42);  % 设置随机种子，保证可重复
nGroups = 4;
nPoints = 50;

% 生成4组不同分布的数据
data = {randn(nPoints,1)*1.5 + 5, ...      % 组1: 正态分布
        randn(nPoints,1)*0.8 + 8, ...      % 组2: 窄分布
        randn(nPoints,1)*2.0 + 6, ...      % 组3: 宽分布
        randn(nPoints,1)*1.2 + 7};         % 组4: 正态分布

groupNames = categorical({'Group A', 'Group B', 'Group C', 'Group D'});

%% 使用 MATLAB 内置 violinplot (R2024a+) + swarmchart 叠加数据点
figure('Position', [100, 100, 800, 500]);

% 合并数据为向量格式
allData = vertcat(data{:});
groupLabels = repelem(groupNames, cellfun(@length, data));

% 绘制小提琴图
violinplot(groupLabels, allData);

% 叠加数据点 (swarmchart)
hold on;
swarmchart(groupLabels, allData, 20, 'filled', ...
    'MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', 'none', ...
    'XJitterWidth', 0.3);
hold off;

ylabel('Value');
title('带数据点的小提琴图');
set(gca, 'FontSize', 12);
grid on;

%% 美化图表
set(gcf, 'Color', 'w');
