%% 柱状图 + 参考线/阈值线
% 清空环境
clear; clc; close all;

%% 随机生成数据
categories = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};
values = randi([20, 100], 1, 8);  % 随机生成8个20-100之间的整数

%% 绘制柱状图
figure('Position', [100, 100, 800, 500]);
b = bar(values, 'FaceColor', [0.3, 0.6, 0.9], 'EdgeColor', 'none');

% 设置X轴标签
set(gca, 'XTickLabel', categories);

%% 添加参考线/阈值线
threshold = 60;  % 阈值
yline(threshold, '--r', '阈值线 = 60', 'LineWidth', 2, 'FontSize', 12, 'LabelHorizontalAlignment', 'left');

% 添加平均值参考线
avg_value = mean(values);
yline(avg_value, '-.g', sprintf('平均值 = %.1f', avg_value), 'LineWidth', 1.5, 'FontSize', 11, 'LabelHorizontalAlignment', 'right');

%% 图表美化
xlabel('类别', 'FontSize', 14);
ylabel('数值', 'FontSize', 14);
title('柱状图 + 参考线/阈值线', 'FontSize', 16);
grid on;
box off;

% 设置Y轴范围
ylim([0, max(values) * 1.2]);

%% 添加数据标签
xtips = b.XEndPoints;
ytips = b.YEndPoints;
labels = string(values);
text(xtips, ytips + 2, labels, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10);
