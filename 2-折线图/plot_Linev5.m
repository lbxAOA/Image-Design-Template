%% 阶梯折线图 - Stair Step Chart
% 使用MATLAB内置stairs()函数实现
% 数据随机生成

clear; clc; close all;

%% 生成随机数据
x = 0:10;                          % X轴数据
y1 = randi([10, 50], 1, 11);       % 随机生成数据系列1
y2 = randi([20, 60], 1, 11);       % 随机生成数据系列2
y3 = randi([5, 40], 1, 11);        % 随机生成数据系列3

%% 绘制阶梯折线图
figure('Position', [100, 100, 800, 500]);

stairs(x, y1, '-o', 'LineWidth', 2, 'MarkerSize', 6, 'DisplayName', '系列A');
hold on;
stairs(x, y2, '-s', 'LineWidth', 2, 'MarkerSize', 6, 'DisplayName', '系列B');
stairs(x, y3, '-^', 'LineWidth', 2, 'MarkerSize', 6, 'DisplayName', '系列C');
hold off;

%% 图表美化
xlabel('时间', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('数值', 'FontSize', 12, 'FontWeight', 'bold');
title('阶梯折线图示例', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'best');
grid on;
set(gca, 'FontSize', 11);
xlim([min(x)-0.5, max(x)+0.5]);

%% 保存图片（可选）
% saveas(gcf, 'stair_step_chart.png');
