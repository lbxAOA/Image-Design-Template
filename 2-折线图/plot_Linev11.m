%% 折线图 + 标注/注释
% 清空环境
clear; clc; close all;

%% 随机生成数据
x = 1:10;
y = cumsum(randn(1, 10));  % 随机游走数据

%% 绘制折线图
figure('Color', 'w');
plot(x, y, '-o', 'LineWidth', 2, 'MarkerSize', 8);
hold on;

%% 找到最大值和最小值点进行标注
[ymax, idx_max] = max(y);
[ymin, idx_min] = min(y);

% 标注最大值点
plot(x(idx_max), ymax, 'r*', 'MarkerSize', 15, 'LineWidth', 2);
text(x(idx_max), ymax, sprintf('  最大值: %.2f', ymax), ...
    'FontSize', 12, 'Color', 'r', 'FontWeight', 'bold');

% 标注最小值点
plot(x(idx_min), ymin, 'g*', 'MarkerSize', 15, 'LineWidth', 2);
text(x(idx_min), ymin, sprintf('  最小值: %.2f', ymin), ...
    'FontSize', 12, 'Color', 'g', 'FontWeight', 'bold');

%% 添加箭头注释（指向中间某点）
mid_idx = 5;
annotation('textarrow', [0.5, 0.45], [0.8, 0.6], ...
    'String', '关注此趋势', 'FontSize', 11);

%% 图形美化
xlabel('X轴', 'FontSize', 14);
ylabel('Y轴', 'FontSize', 14);
title('折线图 + 标注示例', 'FontSize', 16);
grid on;
legend('数据曲线', '最大值', '最小值', 'Location', 'best');
hold off;
