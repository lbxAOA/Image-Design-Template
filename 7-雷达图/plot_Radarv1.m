%% 标准雷达图
% 使用 polarplot 实现标准雷达图

clear; clc; close all;

%% 数据准备
categories = {'指标A', '指标B', '指标C', '指标D', '指标E', '指标F'};
n = length(categories);
values = randi([40, 100], 1, n);  % 随机生成6个40-100的数据

%% 计算角度（均匀分布）
theta = linspace(0, 2*pi, n+1);  % 首尾相连

%% 数据闭合（首尾相连）
values_closed = [values, values(1)];

%% 绘制雷达图
figure('Color', 'w', 'Position', [100, 100, 600, 500]);
polarplot(theta, values_closed, '-o', ...
    'LineWidth', 2, ...
    'MarkerSize', 8, ...
    'MarkerFaceColor', [0.2, 0.6, 0.8]);

%% 设置极坐标轴
ax = gca;
ax.ThetaZeroLocation = 'top';      % 0度在顶部
ax.ThetaDir = 'clockwise';         % 顺时针方向
ax.ThetaTick = rad2deg(theta(1:end-1));  % 设置角度刻度
ax.ThetaTickLabel = categories;    % 设置标签
ax.RLim = [0, 100];                % 径向范围
ax.RTick = [20, 40, 60, 80, 100];  % 径向刻度
ax.FontSize = 11;
ax.GridAlpha = 0.3;

%% 添加标题
title('单系列雷达图示例', 'FontSize', 14, 'FontWeight', 'bold');
