%% 柱状图 + 误差线
% 清空环境
clear; clc; close all;

%% 随机生成数据
categories = {'A', 'B', 'C', 'D', 'E'};  % 类别
data = randi([20, 80], 1, 5);            % 随机柱高 (20-80)
err = randi([3, 10], 1, 5);              % 随机误差值 (3-10)

%% 绑定数据
x = 1:length(categories);

%% 绑定图表
figure('Position', [100, 100, 600, 450]);

% 绘制柱状图
b = bar(x, data, 'FaceColor', [0.3, 0.6, 0.9], 'EdgeColor', 'none');

hold on;

% 添加误差线
errorbar(x, data, err, 'k', 'LineStyle', 'none', 'LineWidth', 1.5, 'CapSize', 10);

hold off;

%% 设置样式
set(gca, 'XTickLabel', categories);
xlabel('类别');
ylabel('数值');
title('柱状图 + 误差线');
grid on;
box on;

%% 保存图片 (可选)
% saveas(gcf, 'bar_with_errorbar.png');
