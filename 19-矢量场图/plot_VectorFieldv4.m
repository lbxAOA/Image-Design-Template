clear; clc; close all;

%% 1. 带颜色映射的箭头图 - 方法二
% 使用散点颜色映射
% 箭头颜色表示矢量大小，同时展示方向和强度

%% 2. 生成网格数据
x_range = linspace(-3, 3, 20);  % X轴范围
y_range = linspace(-3, 3, 20);  % Y轴范围
[X, Y] = meshgrid(x_range, y_range);  % 创建网格

%% 3. 计算矢量场分量（旋涡场 + 源场）
rng(42);  % 设置随机种子

% 旋涡场
U1 = -Y;
V1 = X;

% 源场
R = sqrt(X.^2 + Y.^2) + 0.1;  % 避免除以零
U2 = X ./ R;
V2 = Y ./ R;

% 组合矢量场（添加随机扰动）
noise_scale = 0.3;
U = 0.5 * U1 + 0.5 * U2 + noise_scale * randn(size(X));
V = 0.5 * V1 + 0.5 * V2 + noise_scale * randn(size(Y));

% 计算矢量大小（用于着色）
magnitude = sqrt(U.^2 + V.^2);

%% 4. 创建图形窗口
figure('Name', '带颜色映射的箭头图 - 散点法', 'Position', [200, 200, 900, 700], 'Color', 'white');

%% 5. 使用散点颜色映射
% 绘制箭头
quiver(X, Y, U, V, 1.5, 'k', 'LineWidth', 1);
hold on;

% 用散点表示矢量大小的颜色
scatter(X(:), Y(:), 50, magnitude(:), 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold off;

%% 6. 设置颜色映射
colormap(jet);
c = colorbar;
c.Label.String = '矢量大小';
c.Label.FontSize = 12;
c.Label.FontWeight = 'bold';

%% 7. 设置图形属性
xlabel('X 轴', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Y 轴', 'FontSize', 14, 'FontWeight', 'bold');
title('带颜色映射的矢量场图 - 散点法', 'FontSize', 16, 'FontWeight', 'bold');
axis equal tight;
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.4);
set(gca, 'FontSize', 12, 'LineWidth', 1.5, 'Box', 'on');

%% 8. 输出信息
fprintf('===== 带颜色映射的箭头图绘制完成（方法二：散点法）=====\n');
fprintf('网格大小: %d x %d\n', size(X, 1), size(X, 2));
fprintf('矢量大小范围: [%.2f, %.2f]\n', min(magnitude(:)), max(magnitude(:)));
fprintf('平均矢量大小: %.2f\n', mean(magnitude(:)));
