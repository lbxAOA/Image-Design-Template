%% 水平小提琴图 - Horizontal Violin Plot
% 使用核密度估计绘制水平方向的小提琴图
clear; clc; close all;

%% 生成随机数据
rng(42); % 设置随机种子保证可重复性
nGroups = 4;
data = cell(1, nGroups);
data{1} = randn(100, 1) * 1.0 + 5;      % 组1: 正态分布
data{2} = randn(120, 1) * 1.5 + 8;      % 组2: 较大方差
data{3} = [randn(60,1)*0.8+3; randn(60,1)*0.8+7]; % 组3: 双峰分布
data{4} = randn(80, 1) * 0.6 + 6;       % 组4: 较小方差

groupNames = {'Group A', 'Group B', 'Group C', 'Group D'};
colors = lines(nGroups); % 使用MATLAB内置配色

%% 绑定小提琴图
figure('Position', [100, 100, 800, 500]);
hold on;

violinWidth = 0.35; % 小提琴宽度

for i = 1:nGroups
    x = data{i};
    
    % 使用ksdensity计算核密度估计
    [density, xi] = ksdensity(x, 'NumPoints', 100);
    
    % 归一化密度到指定宽度
    density = density / max(density) * violinWidth;
    
    % 绘制水平小提琴 (y轴为组别位置，x轴为数据值)
    % 上半部分
    fill([xi, fliplr(xi)], [i + density, i - fliplr(density)], ...
         colors(i,:), 'FaceAlpha', 0.6, 'EdgeColor', colors(i,:)*0.7, 'LineWidth', 1.2);
    
    % 绘制中位数线和四分位数
    q1 = quantile(x, 0.25);
    q2 = median(x);
    q3 = quantile(x, 0.75);
    
    % 四分位范围线 (粗线)
    plot([q1, q3], [i, i], 'Color', 'k', 'LineWidth', 4);
    
    % 中位数点
    scatter(q2, i, 60, 'w', 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1.5);
end

%% 图形美化
set(gca, 'YTick', 1:nGroups, 'YTickLabel', groupNames);
ylim([0.3, nGroups + 0.7]);
xlabel('Value', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Group', 'FontSize', 12, 'FontWeight', 'bold');
title('Horizontal Violin Plot', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
box on;
set(gca, 'FontSize', 11, 'LineWidth', 1);

hold off;
