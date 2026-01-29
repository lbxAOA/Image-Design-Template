clear; clc; close all;

%% 1. 3D矢量场图 - 切片视图
% 三维空间中的矢量场，使用 quiver3() 函数

%% 2. 生成三维网格数据
x_range = linspace(-2, 2, 8);  % X轴范围（3D图需要较稀疏的网格）
y_range = linspace(-2, 2, 8);  % Y轴范围
z_range = linspace(-2, 2, 8);  % Z轴范围
[X, Y, Z] = meshgrid(x_range, y_range, z_range);  % 创建三维网格

%% 3. 计算三维矢量场分量
% 方法一：旋涡场 + 源场
rng(42);  % 设置随机种子

% 旋涡场分量（绕Z轴旋转）
U1 = -Y;
V1 = X;
W1 = zeros(size(X));

% 向心/离心场分量
R = sqrt(X.^2 + Y.^2 + Z.^2) + 0.1;  % 避免除以零
U2 = X ./ R;
V2 = Y ./ R;
W2 = Z ./ R;

% 螺旋场分量
U3 = -Y;
V3 = X;
W3 = 0.5 * ones(size(X));

% 组合矢量场
U = 0.4 * U1 + 0.3 * U2 + 0.3 * U3;
V = 0.4 * V1 + 0.3 * V2 + 0.3 * V3;
W = 0.4 * W1 + 0.3 * W2 + 0.3 * W3;

% 计算矢量大小
magnitude = sqrt(U.^2 + V.^2 + W.^2);

%% 4. 创建图形窗口 - 切片矢量场
figure('Name', '3D矢量场图 - 切片视图', 'Position', [300, 300, 900, 700], 'Color', 'white');

%% 5. 选择几个切片平面
slice_x = 0;
slice_y = 0;
slice_z = 0;

% 在切片平面上绘制矢量
hold on;

% XY平面 (Z=0)
z_idx = find(abs(z_range - slice_z) < 0.01, 1);
if ~isempty(z_idx)
    X_slice = squeeze(X(:, :, z_idx));
    Y_slice = squeeze(Y(:, :, z_idx));
    Z_slice = squeeze(Z(:, :, z_idx));
    U_slice = squeeze(U(:, :, z_idx));
    V_slice = squeeze(V(:, :, z_idx));
    W_slice = squeeze(W(:, :, z_idx));
    quiver3(X_slice, Y_slice, Z_slice, U_slice, V_slice, W_slice, 1.5, ...
        'Color', [0.8, 0.2, 0.2], 'LineWidth', 1.5);
end

% YZ平面 (X=0)
x_idx = find(abs(x_range - slice_x) < 0.01, 1);
if ~isempty(x_idx)
    X_slice = squeeze(X(:, x_idx, :));
    Y_slice = squeeze(Y(:, x_idx, :));
    Z_slice = squeeze(Z(:, x_idx, :));
    U_slice = squeeze(U(:, x_idx, :));
    V_slice = squeeze(V(:, x_idx, :));
    W_slice = squeeze(W(:, x_idx, :));
    quiver3(X_slice, Y_slice, Z_slice, U_slice, V_slice, W_slice, 1.5, ...
        'Color', [0.2, 0.8, 0.2], 'LineWidth', 1.5);
end

% XZ平面 (Y=0)
y_idx = find(abs(y_range - slice_y) < 0.01, 1);
if ~isempty(y_idx)
    X_slice = squeeze(X(y_idx, :, :));
    Y_slice = squeeze(Y(y_idx, :, :));
    Z_slice = squeeze(Z(y_idx, :, :));
    U_slice = squeeze(U(y_idx, :, :));
    V_slice = squeeze(V(y_idx, :, :));
    W_slice = squeeze(W(y_idx, :, :));
    quiver3(X_slice, Y_slice, Z_slice, U_slice, V_slice, W_slice, 1.5, ...
        'Color', [0.2, 0.2, 0.8], 'LineWidth', 1.5);
end

hold off;

%% 6. 设置图形属性
xlabel('X 轴', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Y 轴', 'FontSize', 14, 'FontWeight', 'bold');
zlabel('Z 轴', 'FontSize', 14, 'FontWeight', 'bold');
title('3D矢量场图 - 切片视图', 'FontSize', 16, 'FontWeight', 'bold');
grid on;
axis equal tight;
view(45, 30);
set(gca, 'FontSize', 12, 'LineWidth', 1.5, 'Box', 'on');
legend('Z=0 平面', 'X=0 平面', 'Y=0 平面', 'Location', 'northeast', 'FontSize', 11);

%% 7. 输出信息
fprintf('===== 3D矢量场图绘制完成 =====\n');
fprintf('网格大小: %d x %d x %d\n', size(X, 1), size(X, 2), size(X, 3));
fprintf('矢量数量: %d\n', numel(X));
fprintf('矢量大小范围: [%.2f, %.2f]\n', min(magnitude(:)), max(magnitude(:)));
fprintf('平均矢量大小: %.2f\n', mean(magnitude(:)));
