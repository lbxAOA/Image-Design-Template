% 使用 MATLAB 内置 area() 函数
clear; clc; close all;

%% 生成随机数据
x = 1:10;                      % X轴数据
y = randi([5, 20], 1, 10);     % 随机生成10个5-20之间的整数

%% 绘制面积图
figure('Color', 'w');
area(x, y, 'FaceColor', [0.3, 0.6, 0.9], 'FaceAlpha', 0.6, 'EdgeColor', [0.1, 0.3, 0.6], 'LineWidth', 1.5);

%% 图形美化
xlabel('X 轴');
ylabel('Y 轴');
title('标准面积图');
grid on;
xlim([1, 10]);
