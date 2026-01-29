clear; clc; close all;

%% 1. 流线图 (Streamline Plot)
% 沿矢量方向的曲线，展示流动路径

%% 2. 生成密集网格数据（流线需要更密集的网格）
x_range = linspace(-3, 3, 50);  % X轴范围
y_range = linspace(-3, 3, 50);  % Y轴范围
[X, Y] = meshgrid(x_range, y_range);  % 创建网格

%% 3. 计算矢量场分量（旋涡场 + 源场）
% 旋涡场
U1 = -Y;
V1 = X;

% 源场
R = sqrt(X.^2 + Y.^2) + 0.1;  % 避免除以零
U2 = X ./ R;
V2 = Y ./ R;

% 组合矢量场
U = 0.6 * U1 + 0.4 * U2;
V = 0.6 * V1 + 0.4 * V2;

%% 4. 设置流线起点
% 方法一：网格起点
startx = linspace(-2.8, 2.8, 10);
starty = linspace(-2.8, 2.8, 10);
[startX, startY] = meshgrid(startx, starty);

%% 5. 创建图形窗口
figure('Name', '流线图 (Streamline Plot)', 'Position', [100, 100, 900, 700], 'Color', 'white');

%% 6. 绘制流线图
h = streamline(X, Y, U, V, startX, startY);
set(h, 'LineWidth', 1.2, 'Color', [0.1, 0.5, 0.8]);

%% 7. 设置图形属性
xlabel('X 轴', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Y 轴', 'FontSize', 14, 'FontWeight', 'bold');
title('流线图 - 矢量场流动路径', 'FontSize', 16, 'FontWeight', 'bold');
axis equal tight;
xlim([-3, 3]);
ylim([-3, 3]);
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.4);
set(gca, 'FontSize', 12, 'LineWidth', 1.5, 'Box', 'on');

%% 8. 添加流线起点标记（可选）
hold on;
scatter(startX(:), startY(:), 30, 'r', 'filled', 'MarkerEdgeColor', 'k', ...
    'LineWidth', 0.5);
hold off;

%% 9. 添加图例
legend('流线', '起点', 'Location', 'northeast', 'FontSize', 11);

%% 10. 添加说明文本
text(-2.5, 2.7, '流线展示矢量场流动方向', 'FontSize', 11, 'FontWeight', 'bold', ...
    'BackgroundColor', 'white', 'EdgeColor', 'black');

%% 11. 输出信息
fprintf('===== 流线图绘制完成 =====\n');
fprintf('网格大小: %d x %d\n', size(X, 1), size(X, 2));
fprintf('流线起点数量: %d\n', numel(startX));
fprintf('X轴范围: [%.1f, %.1f]\n', min(x_range), max(x_range));
fprintf('Y轴范围: [%.1f, %.1f]\n', min(y_range), max(y_range));
