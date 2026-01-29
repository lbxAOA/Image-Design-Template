%% 分组散点图 - Grouped Scatter Plot
% 使用gscatter函数实现分组散点图

clear; clc; close all;

%% 生成随机数据
rng(42);  % 设置随机种子，保证可重复性
n = 150;  % 每组样本数

% 生成3组数据（模拟3个不同类别）
x1 = randn(n, 1) + 2;   y1 = randn(n, 1) + 3;
x2 = randn(n, 1) + 5;   y2 = randn(n, 1) + 6;
x3 = randn(n, 1) + 8;   y3 = randn(n, 1) + 2;

% 合并数据
x = [x1; x2; x3];
y = [y1; y2; y3];
group = [repmat({'组A'}, n, 1); repmat({'组B'}, n, 1); repmat({'组C'}, n, 1)];

%% 绘制分组散点图
figure('Position', [100, 100, 800, 600]);

% 使用gscatter函数（最简单的分组散点图方法）
h = gscatter(x, y, group, 'rbg', 'osd', 10);

% 设置图形属性
xlabel('X 变量', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Y 变量', 'FontSize', 12, 'FontWeight', 'bold');
title('分组散点图示例', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best');
grid on;
box on;

% 设置坐标轴字体
set(gca, 'FontSize', 11);
