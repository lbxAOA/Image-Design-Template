%% 多系列折线图
% 清空环境
clear; clc; close all;

%% 生成随机数据
x = 1:10;                          % x轴数据
y = rand(4, 10) * 100;             % 4个系列，每个10个点

%% 绘制多系列折线图
figure;
plot(x, y, '-o', 'LineWidth', 1.5, 'MarkerSize', 6);

%% 图表美化
xlabel('X轴');
ylabel('Y轴');
title('多系列折线图');
legend({'系列1', '系列2', '系列3', '系列4'}, 'Location', 'best');
grid on;
