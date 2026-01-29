clear; clc; close all;

%% 1. 3D流线图 - 矢量场流线可视化
% 使用 streamline() 函数绘制三维空间中的流线

%% 2. 生成三维网格数据
x_range = linspace(-3, 3, 20);  % X轴范围
y_range = linspace(-3, 3, 20);  % Y轴范围
z_range = linspace(-3, 3, 20);  % Z轴范围
[X, Y, Z] = meshgrid(x_range, y_range, z_range);  % 创建三维网格

%% 3. 定义复杂的三维矢量场
% 螺旋场 + 吸引子
U = -Y + 0.2 * X;
V = X + 0.2 * Y;
W = -0.3 * Z + 0.5;

%% 4. 定义流线起始点
% 方法一：在一个平面上均匀分布起始点
[sx1, sy1] = meshgrid(linspace(-2, 2, 5), linspace(-2, 2, 5));
sz1 = -2 * ones(size(sx1));  % Z = -2 平面

% 方法二：在空间中随机分布起始点
rng(42);
n_points = 30;
sx2 = 2.5 * (rand(1, n_points) - 0.5) * 2;
sy2 = 2.5 * (rand(1, n_points) - 0.5) * 2;
sz2 = 2.5 * (rand(1, n_points) - 0.5) * 2;

% 合并起始点
sx = [sx1(:); sx2(:)];
sy = [sy1(:); sy2(:)];
sz = [sz1(:); sz2(:)];

%% 5. 创建图形窗口
figure('Name', '3D流线图', 'Position', [300, 300, 1000, 800], 'Color', 'white');

%% 6. 绘制流线
streamline(X, Y, Z, U, V, W, sx, sy, sz);

%% 7. 美化流线
h = findobj(gca, 'Type', 'line');
set(h, 'LineWidth', 1.8);

% 为不同的流线设置渐变颜色
n_lines = length(h);
colors = jet(n_lines);
for i = 1:n_lines
    set(h(i), 'Color', colors(i, :), 'LineWidth', 1.5);
end

%% 8. 添加起始点标记
hold on;
scatter3(sx, sy, sz, 80, 'k', 'filled', 'MarkerEdgeColor', 'w', ...
    'LineWidth', 1.5, 'MarkerFaceAlpha', 0.8);
hold off;

%% 9. 设置图形属性
xlabel('X 轴', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Y 轴', 'FontSize', 14, 'FontWeight', 'bold');
zlabel('Z 轴', 'FontSize', 14, 'FontWeight', 'bold');
title('3D流线图 - 矢量场流动轨迹', 'FontSize', 16, 'FontWeight', 'bold');
grid on;
axis equal tight;
view(45, 30);
set(gca, 'FontSize', 12, 'LineWidth', 1.5, 'Box', 'on');

% 设置背景
set(gca, 'Color', [0.95, 0.95, 0.95]);

%% 10. 添加光照效果
lighting gouraud;
camlight('headlight');

%% 11. 输出信息
fprintf('===== 3D流线图绘制完成 =====\n');
fprintf('网格大小: %d x %d x %d\n', size(X, 1), size(X, 2), size(X, 3));
fprintf('流线数量: %d\n', length(h));
fprintf('起始点数量: %d\n', length(sx));
