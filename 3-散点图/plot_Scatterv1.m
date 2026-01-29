clear; clc; close all;

%% 生成随机数据
rng(42);  % 设置随机种子，保证可重复性

% 生成三组不同的散点数据
n1 = 50;  % 第一组数据点数量
n2 = 40;  % 第二组数据点数量
n3 = 45;  % 第三组数据点数量

% 第一组数据 - 聚集在左下区域
x1 = 2 + 1.5 * randn(n1, 1);
y1 = 3 + 1.5 * randn(n1, 1);

% 第二组数据 - 聚集在中间区域
x2 = 6 + 1.2 * randn(n2, 1);
y2 = 6 + 1.2 * randn(n2, 1);

% 第三组数据 - 聚集在右上区域
x3 = 9 + 1.0 * randn(n3, 1);
y3 = 8 + 1.0 * randn(n3, 1);

%% 绑定颜色
colors = [
    0.2, 0.4, 0.8;   % 蓝色
    0.9, 0.3, 0.3;   % 红色
    0.3, 0.7, 0.4;   % 绿色
];

%% 绑定图形窗口
figure('Name', '标准散点图', 'Position', [100, 100, 800, 600]);

%% 绑定散点
hold on;

% 绑定第一组散点
scatter(x1, y1, 80, colors(1,:), 'filled', 'MarkerEdgeColor', 'k', ...
    'LineWidth', 0.5, 'MarkerFaceAlpha', 0.7, 'DisplayName', '数据组 A');

% 绑定第二组散点
scatter(x2, y2, 80, colors(2,:), 'filled', 'MarkerEdgeColor', 'k', ...
    'LineWidth', 0.5, 'MarkerFaceAlpha', 0.7, 'DisplayName', '数据组 B');

% 绑定第三组散点
scatter(x3, y3, 80, colors(3,:), 'filled', 'MarkerEdgeColor', 'k', ...
    'LineWidth', 0.5, 'MarkerFaceAlpha', 0.7, 'DisplayName', '数据组 C');

hold off;

%% 设置坐标轴和标签
xlabel('X 轴', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Y 轴', 'FontSize', 14, 'FontWeight', 'bold');
title('标准散点图示例', 'FontSize', 16, 'FontWeight', 'bold');

%% 设置图例
legend('Location', 'northwest', 'FontSize', 12);

%% 设置网格
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);

%% 设置坐标轴范围
xlim([-2, 14]);
ylim([-1, 13]);

%% 美化图形
set(gca, 'FontSize', 12, 'LineWidth', 1.2, 'Box', 'on');

%% 保存图形
% saveas(gcf, 'scatter_plot.png');
% saveas(gcf, 'scatter_plot.fig');

fprintf('散点图绑定完成!\n');
fprintf('数据组 A: %d 个点\n', n1);
fprintf('数据组 B: %d 个点\n', n2);
fprintf('数据组 C: %d 个点\n', n3);
