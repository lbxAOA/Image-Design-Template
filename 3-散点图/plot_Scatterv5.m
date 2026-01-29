%% 带回归线的散点图
% 清空环境
clear; clc; close all;

%% 生成随机数据
rng(42);  % 设置随机种子，保证可重复性
n = 50;   % 数据点数量
x = rand(n, 1) * 10;           % x: 0~10 的随机数
y = 2 * x + 3 + randn(n, 1) * 2;  % y = 2x + 3 + 噪声

%% 绑定散点图
figure;
scatter(x, y, 50, 'filled', 'MarkerFaceAlpha', 0.7);
hold on;

%% 线性回归拟合（使用 polyfit）
p = polyfit(x, y, 1);  % 一次多项式拟合
x_fit = linspace(min(x), max(x), 100);
y_fit = polyval(p, x_fit);

%% 绘制回归线
plot(x_fit, y_fit, 'r-', 'LineWidth', 2);

%% 图形美化
xlabel('X');
ylabel('Y');
title('带回归线的散点图');
legend('数据点', sprintf('回归线: y = %.2fx + %.2f', p(1), p(2)), 'Location', 'best');
grid on;
hold off;
