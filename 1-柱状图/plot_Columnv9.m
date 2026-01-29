%% 柱状图 + 数据标签/注释
% 清空环境
clear; clc; close all;

%% 随机生成数据
categories = {'A', 'B', 'C', 'D', 'E'};
data = randi([10, 100], 1, 5);  % 生成5个10-100之间的随机整数

%% 绑图
figure;
b = bar(data, 'FaceColor', [0.3, 0.6, 0.9], 'EdgeColor', 'none');

%% 添加数据标签
text(1:length(data), data, num2str(data'), ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'bottom', ...
    'FontSize', 12, 'FontWeight', 'bold');

%% 美化图表
set(gca, 'XTickLabel', categories);
xlabel('类别');
ylabel('数值');
title('柱状图 + 数据标签');
grid on;
box off;
