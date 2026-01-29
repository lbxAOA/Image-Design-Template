%% 柱状图 + 散点图 组合图
% 清空环境
clc; clear; close all;

%% 随机生成数据
x = 1:6;                          % x轴类别
barData = randi([10, 50], 1, 6);  % 柱状图数据（随机整数）
scatterData = barData + randn(1, 6) * 5;  % 散点图数据（基于柱状图加噪声）

%% 绑定双Y轴
figure;
yyaxis left
bar(x, barData, 0.6, 'FaceColor', [0.2 0.6 0.8]);  % 柱状图
ylabel('柱状图数值');

yyaxis right
scatter(x, scatterData, 80, 'filled', 'MarkerFaceColor', [0.9 0.3 0.3]);  % 散点图
ylabel('散点图数值');

%% 图形美化
xlabel('类别');
title('柱状图 + 散点图 组合');
legend('柱状图', '散点图', 'Location', 'best');
grid on;
set(gca, 'FontSize', 12);
