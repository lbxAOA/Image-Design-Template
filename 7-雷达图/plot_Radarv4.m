%% 玫瑰雷达图 (Rose Radar Chart)
% 使用极坐标柱状图实现
clear; clc; close all;

%% 随机生成数据
numCategories = 8;                          % 类别数量
data = randi([20, 100], 1, numCategories);  % 随机数据 (20-100)
labels = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};  % 类别标签

%% 计算角度
theta = linspace(0, 2*pi, numCategories+1); % 每个扇形的角度
theta = theta(1:end-1) + pi/numCategories;  % 居中对齐

%% 绘制玫瑰雷达图
figure('Color', 'w', 'Position', [100, 100, 600, 600]);
pax = polaraxes;  % 创建极坐标轴

% 使用 polarhistogram 的方式绘制柱状图
barWidth = 2*pi/numCategories * 0.9;  % 柱宽度

% 定义颜色
colors = parula(numCategories);

hold on;
for i = 1:numCategories
    % 绘制每个扇形
    polarplot([theta(i)-barWidth/2, theta(i)-barWidth/2, theta(i)+barWidth/2, theta(i)+barWidth/2, theta(i)-barWidth/2], ...
              [0, data(i), data(i), 0, 0], 'LineWidth', 1.5, 'Color', colors(i,:));
    
    % 填充扇形
    th = linspace(theta(i)-barWidth/2, theta(i)+barWidth/2, 50);
    r = data(i) * ones(size(th));
    polarplot(th, r, 'LineWidth', 2, 'Color', colors(i,:));
end
hold off;

% 使用更简单的方法 - 直接用 polarhistogram
figure('Color', 'w', 'Position', [100, 100, 600, 600]);

% 构造数据用于 polarhistogram
edges = linspace(0, 2*pi, numCategories+1);
binCenters = (edges(1:end-1) + edges(2:end)) / 2;

% 使用极坐标柱状图
pax = polaraxes;
hold(pax, 'on');

for i = 1:numCategories
    % 绘制填充扇形
    th_fill = linspace(edges(i), edges(i+1), 50);
    r_fill = [0, repmat(data(i), 1, 48), 0];
    polarplot(pax, th_fill, r_fill, 'Color', colors(i,:), 'LineWidth', 2);
    
    % 手动填充 - 使用 patch 在极坐标中
    [x, y] = pol2cart([edges(i), linspace(edges(i), edges(i+1), 50), edges(i+1)], ...
                      [0, repmat(data(i), 1, 50), 0]);
    patch(x, y, colors(i,:), 'FaceAlpha', 0.7, 'EdgeColor', colors(i,:), 'LineWidth', 1.5);
end

% 添加标签
for i = 1:numCategories
    [x, y] = pol2cart(binCenters(i), max(data)*1.15);
    text(x, y, labels{i}, 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
end

% 添加同心圆网格
maxR = ceil(max(data)/20)*20;
for r = 20:20:maxR
    th_circle = linspace(0, 2*pi, 100);
    [x_circle, y_circle] = pol2cart(th_circle, r*ones(size(th_circle)));
    plot(x_circle, y_circle, '--', 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5);
end

% 添加辐射线
for i = 1:numCategories
    [x_line, y_line] = pol2cart([edges(i), edges(i)], [0, maxR]);
    plot(x_line, y_line, '-', 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5);
end

axis equal;
axis off;
title('玫瑰雷达图 (Rose Radar Chart)', 'FontSize', 14, 'FontWeight', 'bold');

hold off;

%% 显示数据值
disp('各类别数据值:');
for i = 1:numCategories
    fprintf('%s: %d\n', labels{i}, data(i));
end
