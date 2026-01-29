clear; clc; close all;

%% 1. 等高线 + 矢量场叠加
% 标量场等高线 + 矢量场箭头，展示势函数和梯度方向

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
figure('Name', '等高线 + 矢量场叠加', 'Position', [100, 100, 900, 700], 'Color', 'white');

%% 6. 绘制等高线填充图
contourf(X, Y, potential, 20, 'LineWidth', 0.8);
hold on;

%% 7. 叠加矢量场箭头
% 为了清晰，可以稀疏一些箭头
skip = 2;  % 每隔2个点绘制一个箭头
quiver(X(1:skip:end, 1:skip:end), Y(1:skip:end, 1:skip:end), ...
       U(1:skip:end, 1:skip:end), V(1:skip:end, 1:skip:end), ...
       1.5, 'k', 'LineWidth', 1.5);

hold off;

%% 8. 设置颜色映射
colormap(parula);
c = colorbar;
c.Label.String = '势函数值';
c.Label.FontSize = 12;
c.Label.FontWeight = 'bold';

%% 9. 设置图形属性
xlabel('X 轴', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Y 轴', 'FontSize', 14, 'FontWeight', 'bold');
title('等高线 + 矢量场叠加图', 'FontSize', 16, 'FontWeight', 'bold');
axis equal tight;
set(gca, 'FontSize', 12, 'LineWidth', 1.5, 'Box', 'on');

%% 10. 添加图例
text(-2.5, 2.7, '等高线：标量场（势函数）', 'FontSize', 11, 'FontWeight', 'bold', ...
    'BackgroundColor', 'white', 'EdgeColor', 'black');
text(-2.5, 2.3, '箭头：梯度方向', 'FontSize', 11, 'FontWeight', 'bold', ...
    'BackgroundColor', 'white', 'EdgeColor', 'black');

%% 11. 输出信息
fprintf('===== 等高线 + 矢量场叠加图绘制完成 =====\n');
fprintf('网格大小: %d x %d\n', size(X, 1), size(X, 2));
fprintf('势函数值范围: [%.2f, %.2f]\n', min(potential(:)), max(potential(:)));
fprintf('梯度大小范围: [%.2f, %.2f]\n', ...
    min(sqrt(U(:).^2 + V(:).^2)), max(sqrt(U(:).^2 + V(:).^2)));
