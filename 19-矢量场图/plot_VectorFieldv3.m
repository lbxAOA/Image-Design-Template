clear; clc; close all;

%% 1. 带颜色映射的箭头图 - 方法一
% 使用 pcolor 作为背景 + quiver
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
figure('Name', '带颜色映射的箭头图 - pcolor方法', 'Position', [100, 100, 900, 700], 'Color', 'white');

%% 5. 使用 pcolor 作为背景 + quiver
% 绘制背景颜色场
pcolor(X, Y, magnitude);
shading interp;  % 平滑着色
hold on;

% 计算归一化矢量（统一箭头长度）
U_norm = U ./ magnitude;
V_norm = V ./ magnitude;

% 绘制白色箭头
quiver(X, Y, U_norm, V_norm, 0.6, 'w', 'LineWidth', 1.8);
hold off;

%% 6. 设置颜色映射
colormap(hot);  % 使用 hot 颜色映射
c = colorbar;
c.Label.String = '矢量大小（速度）';
c.Label.FontSize = 12;
c.Label.FontWeight = 'bold';

%% 7. 设置图形属性
xlabel('X 轴', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Y 轴', 'FontSize', 14, 'FontWeight', 'bold');
title('带颜色映射的矢量场图 - pcolor背景法', 'FontSize', 16, 'FontWeight', 'bold');
axis equal tight;
set(gca, 'FontSize', 12, 'LineWidth', 1.5, 'Box', 'on');

%% 8. 添加说明文本
text(-2.5, 2.7, '颜色：矢量大小', 'FontSize', 11, 'FontWeight', 'bold', ...
    'BackgroundColor', 'white', 'EdgeColor', 'black');
text(-2.5, 2.3, '箭头：矢量方向', 'FontSize', 11, 'FontWeight', 'bold', ...
    'BackgroundColor', 'white', 'EdgeColor', 'black');

%% 9. 输出信息
fprintf('===== 带颜色映射的箭头图绘制完成（方法一：pcolor背景）=====\n');
fprintf('网格大小: %d x %d\n', size(X, 1), size(X, 2));
fprintf('矢量大小范围: [%.2f, %.2f]\n', min(magnitude(:)), max(magnitude(:)));
fprintf('平均矢量大小: %.2f\n', mean(magnitude(:)));
