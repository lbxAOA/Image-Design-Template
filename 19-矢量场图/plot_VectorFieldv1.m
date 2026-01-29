clear; clc; close all;

%% 1. 基础箭头图 (Quiver Plot)
% 最直观的矢量场表示，用箭头表示矢量方向和大小

%% 2. 生成网格数据
x_range = linspace(-3, 3, 20);  % X轴范围
y_range = linspace(-3, 3, 20);  % Y轴范围
[X, Y] = meshgrid(x_range, y_range);  % 创建网格

%% 3. 计算矢量场分量（旋涡场）
rng(42);  % 设置随机种子，保证可重复性

% 旋涡场 + 源场组合
U1 = -Y;  % 旋涡场 X 分量
V1 = X;   % 旋涡场 Y 分量

R = sqrt(X.^2 + Y.^2) + 0.1;  % 避免除以零
U2 = X ./ R;  % 源场 X 分量
V2 = Y ./ R;  % 源场 Y 分量

% 组合矢量场（添加随机扰动）
noise_scale = 0.3;
U = 0.5 * U1 + 0.5 * U2 + noise_scale * randn(size(X));
V = 0.5 * V1 + 0.5 * V2 + noise_scale * randn(size(Y));

%% 4. 创建图形窗口
figure('Name', '基础箭头图 (Quiver Plot)', 'Position', [100, 100, 900, 700], 'Color', 'white');

%% 5. 绘制基础箭头图
quiver(X, Y, U, V, 1.5, 'LineWidth', 1.5, 'Color', [0.2, 0.4, 0.8]);

%% 6. 设置图形属性
xlabel('X 轴', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Y 轴', 'FontSize', 14, 'FontWeight', 'bold');
title('基础箭头图 - 矢量场可视化', 'FontSize', 16, 'FontWeight', 'bold');
axis equal tight;
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.4);
set(gca, 'FontSize', 12, 'LineWidth', 1.5, 'Box', 'on');

%% 7. 添加图例说明
text(-2.5, 2.7, '箭头方向：矢量方向', 'FontSize', 11, 'FontWeight', 'bold', ...
    'BackgroundColor', 'white', 'EdgeColor', 'black');
text(-2.5, 2.3, '箭头长度：矢量大小', 'FontSize', 11, 'FontWeight', 'bold', ...
    'BackgroundColor', 'white', 'EdgeColor', 'black');

%% 8. 输出信息
fprintf('===== 基础箭头图绘制完成 =====\n');
fprintf('网格大小: %d x %d\n', size(X, 1), size(X, 2));
fprintf('X轴范围: [%.1f, %.1f]\n', min(x_range), max(x_range));
fprintf('Y轴范围: [%.1f, %.1f]\n', min(y_range), max(y_range));
magnitude = sqrt(U.^2 + V.^2);
fprintf('矢量大小范围: [%.2f, %.2f]\n', min(magnitude(:)), max(magnitude(:)));
