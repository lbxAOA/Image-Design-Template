%% 气泡图 (Bubble Chart) - 标准实现
% 使用 MATLAB 内置 bubblechart 函数

clear; clc; close all;

%% 随机生成数据
rng(42);  % 设置随机种子，保证可重复性
n = 30;   % 数据点数量

x = randn(n, 1) * 10;           % X坐标
y = randn(n, 1) * 10;           % Y坐标
sz = abs(randn(n, 1)) * 100 + 20;  % 气泡大小
c = randn(n, 1);                % 颜色值

%% 绘制气泡图
figure('Color', 'w', 'Position', [100, 100, 800, 600]);

bubblechart(x, y, sz, c, 'MarkerFaceAlpha', 0.6, 'MarkerEdgeColor', 'k');

%% 美化图表
colormap(turbo);
colorbar;
xlabel('X 轴', 'FontSize', 12);
ylabel('Y 轴', 'FontSize', 12);
title('气泡图示例', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
box on;

% 添加气泡大小图例
bubblelegend('气泡大小', 'Location', 'eastoutside');
