clear; clc; close all;

%% 随机生成数据
x = 1:20;  % x轴数据点
y = cumsum(randn(1, 20)) + 10;  % 主折线数据（随机游走）
err = abs(randn(1, 20)) + 1;    % 误差/标准差

%% 计算置信区间上下界
y_upper = y + err;  % 上界
y_lower = y - err;  % 下界

%% 绘制置信区间（误差带）+ 折线图
figure('Position', [100, 100, 800, 500]);

% 使用fill绘制误差带（关键：x正向+x反向拼接，形成闭合多边形）
fill([x, fliplr(x)], [y_upper, fliplr(y_lower)], ...
    [0.7, 0.85, 1], ...          % 浅蓝色填充
    'EdgeColor', 'none', ...     % 无边框
    'FaceAlpha', 0.5);           % 半透明
hold on;

% 绘制主折线
plot(x, y, '-o', 'LineWidth', 2, 'Color', [0.2, 0.4, 0.8], ...
    'MarkerFaceColor', [0.2, 0.4, 0.8], 'MarkerSize', 6);

%% 美化图表
xlabel('X');
ylabel('Y');
title('折线图 + 置信区间/误差带');
legend({'95% 置信区间', '均值'}, 'Location', 'best');
grid on;
set(gca, 'FontSize', 11);
