%% 折线图 + 参考线/阈值线
% 清空环境
clear; clc; close all;

%% 随机生成数据
x = 1:20;
y = cumsum(randn(1, 20)) + 50;  % 随机游走数据

%% 定义阈值
upperThreshold = 55;  % 上限阈值
lowerThreshold = 45;  % 下限阈值
meanValue = mean(y);  % 均值参考线

%% 绑定图窗
figure('Color', 'w', 'Position', [100 100 800 500]);
hold on;

%% 绘制主折线
plot(x, y, '-o', 'LineWidth', 2, 'MarkerFaceColor', 'auto', 'DisplayName', '数据曲线');

%% 绘制参考线/阈值线（使用yline函数，最简单）
yline(upperThreshold, '--r', '上限阈值', 'LineWidth', 1.5, 'LabelHorizontalAlignment', 'left');
yline(lowerThreshold, '--b', '下限阈值', 'LineWidth', 1.5, 'LabelHorizontalAlignment', 'left');
yline(meanValue, ':k', sprintf('均值=%.2f', meanValue), 'LineWidth', 1.5, 'LabelHorizontalAlignment', 'right');

%% 美化图形
hold off;
xlabel('X轴', 'FontSize', 12);
ylabel('Y轴', 'FontSize', 12);
title('折线图 + 参考线/阈值线', 'FontSize', 14);
legend('数据曲线', 'Location', 'best');
grid on;
box on;

%% 设置坐标轴范围
xlim([0 21]);
