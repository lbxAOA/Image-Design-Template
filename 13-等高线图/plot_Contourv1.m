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

%% 绘制填充等高线图（带数值标签）
figure('Position', [200, 200, 700, 600]);

% 绘制填充等高线
[C, h] = contourf(X, Y, Z, 15);  % 15个填充层级

% 添加等高线数值标签
clabel(C, h, 'FontSize', 9, 'Color', 'k', 'FontWeight', 'bold');

% 设置颜色条
cb = colorbar;
cb.Label.String = '高度值';
cb.Label.FontSize = 12;

% 设置颜色映射
colormap(jet);

% 设置坐标轴
xlabel('X轴', 'FontSize', 12);
ylabel('Y轴', 'FontSize', 12);
title('等高线图', 'FontSize', 14, 'FontWeight', 'bold');

% 调整图形
axis equal tight;
set(gca, 'FontSize', 11);

%% 保存图片 (可选)
% saveas(gcf, 'contour_plot.png');
% print('-dpng', '-r300', 'contour_plot_hd.png');  % 高分辨率保存

disp('等高线图绘制完成！');
