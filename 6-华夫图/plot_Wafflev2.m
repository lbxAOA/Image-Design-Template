%% 自定义网格华夫图 (Waffle Chart)
% 使用随机数据生成华夫图
clear; clc; close all;

%% 1. 随机生成数据
rng(42); % 固定随机种子，便于复现
categories = {'类别A', '类别B', '类别C', '类别D', '类别E'};
values = randi([5, 30], 1, 5); % 随机生成5个类别的值

%% 2. 设置华夫图参数
gridRows = 10;    % 网格行数
gridCols = 10;    % 网格列数
totalCells = gridRows * gridCols;

% 将数值转换为比例（占总格子数的比例）
proportions = round(values / sum(values) * totalCells);

% 修正舍入误差，确保总数等于totalCells
diff = totalCells - sum(proportions);
[~, maxIdx] = max(proportions);
proportions(maxIdx) = proportions(maxIdx) + diff;

%% 3. 创建网格矩阵
grid = zeros(gridRows, gridCols);
cellIdx = 1;
for i = 1:length(proportions)
    for j = 1:proportions(i)
        row = ceil(cellIdx / gridCols);
        col = mod(cellIdx - 1, gridCols) + 1;
        grid(row, col) = i;
        cellIdx = cellIdx + 1;
    end
end

%% 4. 定义颜色
colors = [
    0.2, 0.6, 0.9;   % 蓝色
    0.9, 0.4, 0.3;   % 红色
    0.3, 0.8, 0.5;   % 绿色
    0.9, 0.7, 0.2;   % 黄色
    0.6, 0.4, 0.8;   % 紫色
];

%% 5. 绘制华夫图
figure('Position', [100, 100, 600, 600], 'Color', 'w');
hold on;

% 绘制每个小方格
gap = 0.1; % 格子间隙
for row = 1:gridRows
    for col = 1:gridCols
        catIdx = grid(row, col);
        if catIdx > 0
            x = col - 1;
            y = gridRows - row; % 从上到下填充
            rectangle('Position', [x + gap/2, y + gap/2, 1 - gap, 1 - gap], ...
                'FaceColor', colors(catIdx, :), ...
                'EdgeColor', 'w', ...
                'LineWidth', 1, ...
                'Curvature', 0.2); % 圆角效果
        end
    end
end

%% 6. 设置坐标轴
axis equal;
xlim([0, gridCols]);
ylim([0, gridRows]);
axis off;

%% 7. 添加图例
legendHandles = gobjects(length(categories), 1);
for i = 1:length(categories)
    legendHandles(i) = fill(nan, nan, colors(i, :), 'EdgeColor', 'none');
end

% 图例标签包含数量和百分比
legendLabels = cell(length(categories), 1);
for i = 1:length(categories)
    percent = values(i) / sum(values) * 100;
    legendLabels{i} = sprintf('%s: %d (%.1f%%)', categories{i}, values(i), percent);
end

legend(legendHandles, legendLabels, ...
    'Location', 'southoutside', ...
    'Orientation', 'horizontal', ...
    'FontSize', 10, ...
    'Box', 'off');

%% 8. 添加标题
title('自定义网格华夫图', 'FontSize', 14, 'FontWeight', 'bold');

hold off;

%% 9. 显示数据摘要
fprintf('\n=== 华夫图数据摘要 ===\n');
fprintf('网格大小: %d × %d = %d 格\n', gridRows, gridCols, totalCells);
fprintf('\n类别分布:\n');
for i = 1:length(categories)
    fprintf('  %s: %d (占 %d 格, %.1f%%)\n', ...
        categories{i}, values(i), proportions(i), proportions(i)/totalCells*100);
end
