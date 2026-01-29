%% 清空工作区
clear; clc; close all;

%% 生成随机数据
% 创建网格
[X, Y] = meshgrid(-3:0.1:3, -3:0.1:3);

% 生成高度数据 (使用多个高斯峰叠加模拟地形)
Z = 3 * exp(-((X-1).^2 + (Y-1).^2)) ...      % 第一个高斯峰
  + 2 * exp(-((X+1.5).^2 + (Y+1).^2)) ...    % 第二个高斯峰
  + 1.5 * exp(-((X).^2 + (Y-1.5).^2)) ...    % 第三个高斯峰
  + 0.5 * randn(size(X)) * 0.1;              % 添加少量随机噪声

%% 绘制带填充颜色的3D等高线图
figure('Position', [200, 200, 900, 700]);

% 绘制3D曲面（填充颜色）
surf(X, Y, Z, 'EdgeColor', 'none', 'FaceAlpha', 0.8);
hold on;

% 在曲面上叠加3D等高线
[C, h] = contour3(X, Y, Z, 15, 'LineWidth', 1.5, 'EdgeColor', 'k');

% 添加等高线数值标签
clabel(C, h, 'FontSize', 9, 'Color', 'k', 'FontWeight', 'bold');

% 在底部投影填充等高线
contourf(X, Y, Z, 15, 'ZData', ones(size(Z)) * min(Z(:)) - 1);

hold off;

% 设置颜色条
cb = colorbar;
cb.Label.String = '高度值';
cb.Label.FontSize = 12;

% 设置颜色映射
colormap(jet);

% 设置坐标轴
xlabel('X轴', 'FontSize', 12);
ylabel('Y轴', 'FontSize', 12);
zlabel('Z轴 (高度)', 'FontSize', 12);
title('带填充颜色的3D等高线图', 'FontSize', 14, 'FontWeight', 'bold');

% 调整图形和视角
grid on;
view(3);  % 设置3D视角
lighting gouraud;  % 添加光照效果
shading interp;    % 平滑着色
set(gca, 'FontSize', 11);
rotate3d on;  % 启用3D旋转

%% 保存图片 (可选)
% saveas(gcf, 'contour_plot.png');
% print('-dpng', '-r300', 'contour_plot_hd.png');  % 高分辨率保存

disp('带填充颜色的3D等高线图绘制完成！');
