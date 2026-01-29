%% 清空工作区
clear; clc; close all;

%% 生成随机散点数据
rng(42);  % 设置随机种子

% 生成多个聚类的散点数据
n1 = 300; n2 = 200; n3 = 250;

% 第一个聚类（中心在(1, 1)）
x1 = 1 + randn(n1, 1) * 0.8;
y1 = 1 + randn(n1, 1) * 0.6;

% 第二个聚类（中心在(-1.5, 1)）
x2 = -1.5 + randn(n2, 1) * 0.6;
y2 = 1 + randn(n2, 1) * 0.8;

% 第三个聚类（中心在(0, -1.5)）
x3 = 0 + randn(n3, 1) * 0.7;
y3 = -1.5 + randn(n3, 1) * 0.5;

% 合并所有点
xData = [x1; x2; x3];
yData = [y1; y2; y3];

% 创建网格用于密度估计
[X, Y] = meshgrid(linspace(min(xData)-1, max(xData)+1, 100), ...
                  linspace(min(yData)-1, max(yData)+1, 100));

% 计算二维核密度估计
Z = zeros(size(X));
bandwidth = 0.3;  % 带宽参数
totalPoints = n1 + n2 + n3;

for i = 1:numel(X)
    % 计算每个网格点的密度
    distances = sqrt((xData - X(i)).^2 + (yData - Y(i)).^2);
    Z(i) = sum(exp(-distances.^2 / (2 * bandwidth^2))) / totalPoints;
end

%% 绘制密度等高线图
figure('Position', [200, 200, 700, 600]);

% 绘制3D密度等高线
[C, h] = contour3(X, Y, Z, 15, 'LineWidth', 1.5);  % 15个等高线层级

% 添加等高线数值标签
clabel(C, h, 'FontSize', 9, 'Color', 'k', 'FontWeight', 'bold');

% 计算每个散点位置的密度值
zData = zeros(size(xData));
for i = 1:length(xData)
    distances = sqrt((xData - xData(i)).^2 + (yData - yData(i)).^2);
    zData(i) = sum(exp(-distances.^2 / (2 * bandwidth^2))) / totalPoints;
end

% 叠加3D散点数据
hold on;
scatter3(xData, yData, zData, 10, 'k', 'filled', 'MarkerFaceAlpha', 0.3);
hold off;

% 设置颜色条
cb = colorbar;
cb.Label.String = '密度值';
cb.Label.FontSize = 12;

% 设置颜色映射
colormap(jet);

% 设置坐标轴
xlabel('X轴', 'FontSize', 12);
ylabel('Y轴', 'FontSize', 12);
zlabel('密度值', 'FontSize', 12);
title('3D密度等高线图', 'FontSize', 14, 'FontWeight', 'bold');

% 调整图形
grid on;
view(3);  % 设置3D视角
set(gca, 'FontSize', 11);
rotate3d on;  % 启用3D旋转

%% 保存图片 (可选)
% saveas(gcf, 'contour_plot.png');
% prin3Dt('-dpng', '-r300', 'contour_plot_hd.png');  % 高分辨率保存

disp('密度等高线图绘制完成！');
fprintf('总数据点数: %d\n', length(xData));
