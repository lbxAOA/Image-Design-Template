clear; clc; close all;

%% 随机生成数据
x = 1:10;
y1 = randi([5, 20], 1, 10);  % 第一组数据
y2 = randi([3, 18], 1, 10);  % 第二组数据

%% 绘制折线图 + 散点图
figure('Position', [100, 100, 800, 500]);

% 折线图 + 散点图（'-o' 参数直接实现两者组合）
plot(x, y1, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'auto');
hold on;
plot(x, y2, '-s', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'auto');

%% 美化图表
xlabel('X');
ylabel('Y');
title('折线图 + 散点图');
legend({'数据1', '数据2'}, 'Location', 'best');
grid on;
