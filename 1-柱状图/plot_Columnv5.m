%% 柱状图 + 折线图 组合图
% 清空环境
clear; clc; close all;

%% 1. 生成随机数据
x = 1:6;                          % X轴类别
barData = randi([20, 100], 1, 6); % 柱状图数据（随机整数）
lineData = randi([30, 90], 1, 6); % 折线图数据（随机整数）

%% 2. 创建图形和双Y轴
figure('Position', [100, 100, 800, 500]);
yyaxis left                       % 左Y轴 - 柱状图
bar(x, barData, 0.6, 'FaceColor', [0.3, 0.6, 0.9]);
ylabel('柱状图数值');
ylim([0, max(barData)*1.2]);

yyaxis right                      % 右Y轴 - 折线图
plot(x, lineData, '-o', 'LineWidth', 2, 'MarkerSize', 8, ...
    'Color', [0.9, 0.3, 0.3], 'MarkerFaceColor', [0.9, 0.3, 0.3]);
ylabel('折线图数值');
ylim([0, max(lineData)*1.2]);

%% 3. 设置图形属性
xlabel('类别');
title('柱状图 + 折线图 组合示例');
xticklabels({'A', 'B', 'C', 'D', 'E', 'F'});
legend({'柱状图', '折线图'}, 'Location', 'northwest');
grid on;
box on;
