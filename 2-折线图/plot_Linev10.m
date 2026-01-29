%% 折线图 + 面积填充
% 清空环境
clear; clc; close all;

%% 生成随机数据
x = 1:10;
y = cumsum(rand(1, 10));  % 累计随机数，使曲线更平滑

%% 绘制面积填充 + 折线图
figure;
area(x, y, 'FaceColor', [0.3 0.6 0.9], 'FaceAlpha', 0.3, 'EdgeColor', 'b', 'LineWidth', 2);

%% 图形美化
xlabel('X轴');
ylabel('Y轴');
title('折线图 + 面积填充');
grid on;
