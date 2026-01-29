clear; clc; close all;

%% 1. 等高线 + 流线叠加
% 标量场等高线 + 流线，展示势函数和流动方向

%% 2. 生成网格数据
x_range = linspace(-3, 3, 25);  % X轴范围
y_range = linspace(-3, 3, 25);  % Y轴范围
[X, Y] = meshgrid(x_range, y_range);  % 创建网格

%% 3. 创建标量场（势函数）
% 方法：组合多项式和三角函数
potential = 0.5 * (X.^2 + Y.^2) + 0.3 * sin(2*X) .* cos(2*Y);

%% 4. 计算势函数的梯度（矢量场）
[U, V] = gradient(potential, x_range(2)-x_range(1), y_range(2)-y_range(1));
% 梯度方向相反（向下梯度）
U = -U;
V = -V;

%% 5. 创建图形窗口
figure('Name', '等高线 + 流线叠加', 'Position', [100, 100, 900, 700], 'Color', 'white');

%% 6. 绘制等高线
contour(X, Y, potential, 15, 'LineWidth', 1.2);
hold on;

%% 7. 创建更密集的网格用于流线
[X_fine, Y_fine] = meshgrid(linspace(-3, 3, 50), linspace(-3, 3, 50));
potential_fine = 0.5 * (X_fine.^2 + Y_fine.^2) + 0.3 * sin(2*X_fine) .* cos(2*Y_fine);
[U_fine, V_fine] = gradient(potential_fine, ...
    (X_fine(1,2)-X_fine(1,1)), (Y_fine(2,1)-Y_fine(1,1)));
U_fine = -U_fine;
V_fine = -V_fine;

%% 8. 设置流线起点
startx = linspace(-2.5, 2.5, 8);
starty = linspace(-2.5, 2.5, 8);
[startX, startY] = meshgrid(startx, starty);

%% 9. 绘制流线
h = streamline(X_fine, Y_fine, U_fine, V_fine, startX, startY);
set(h, 'LineWidth', 1.5, 'Color', [0.8, 0.2, 0.2]);

hold off;

%% 10. 设置颜色映射
colormap(cool);
c = colorbar;
c.Label.String = '势函数值';
c.Label.FontSize = 12;
c.Label.FontWeight = 'bold';

%% 11. 设置图形属性
xlabel('X 轴', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Y 轴', 'FontSize', 14, 'FontWeight', 'bold');
title('等高线 + 流线叠加图', 'FontSize', 16, 'FontWeight', 'bold');
axis equal tight;
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
set(gca, 'FontSize', 12, 'LineWidth', 1.5, 'Box', 'on');

%% 12. 输出信息
fprintf('===== 等高线 + 流线叠加图绘制完成 =====\n');
fprintf('网格大小: %d x %d\n', size(X, 1), size(X, 2));
fprintf('势函数值范围: [%.2f, %.2f]\n', min(potential(:)), max(potential(:)));
fprintf('梯度大小范围: [%.2f, %.2f]\n', ...
    min(sqrt(U(:).^2 + V(:).^2)), max(sqrt(U(:).^2 + V(:).^2)));
