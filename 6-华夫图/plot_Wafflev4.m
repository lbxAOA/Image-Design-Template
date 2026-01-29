%% 多行华夫图 (Multi-row Waffle Chart)
% 使用简单方法实现多组数据的华夫图展示

clear; clc; close all;

%% 随机生成数据
numRows = 4;                          % 华夫图行数（组数）
numCategories = 5;                    % 每行类别数
data = randi([5, 25], numRows, numCategories);  % 随机数据

% 类别名称和行标签
categories = {'A类', 'B类', 'C类', 'D类', 'E类'};
rowLabels = {'2023年', '2024年', '2025年', '2026年'};

%% 华夫图参数
gridCols = 10;                        % 每行格子列数
gridRows = 10;                        % 每行格子行数
totalCells = gridCols * gridRows;     % 每个华夫图的总格子数

% 颜色方案
colors = [0.89 0.10 0.11;   % 红
          0.22 0.49 0.72;   % 蓝
          0.30 0.69 0.29;   % 绿
          1.00 0.50 0.00;   % 橙
          0.60 0.31 0.64];  % 紫

%% 绑定图
figure('Position', [100, 100, 1200, 800], 'Color', 'w');

for r = 1:numRows
    % 归一化数据到100格
    rowData = data(r, :);
    normalized = round(rowData / sum(rowData) * totalCells);
    
    % 修正舍入误差
    diff = totalCells - sum(normalized);
    [~, maxIdx] = max(normalized);
    normalized(maxIdx) = normalized(maxIdx) + diff;
    
    % 生成格子颜色矩阵
    cellColors = zeros(gridRows, gridCols, 3);
    cellIdx = 1;
    
    for c = 1:numCategories
        for k = 1:normalized(c)
            [row, col] = ind2sub([gridRows, gridCols], cellIdx);
            cellColors(gridRows - row + 1, col, :) = colors(c, :);  % 从下往上填充
            cellIdx = cellIdx + 1;
        end
    end
    
    % 绘制子图
    subplot(numRows, 1, r);
    
    % 使用 image 绘制
    image(cellColors);
    axis equal tight;
    
    % 添加网格线
    hold on;
    for i = 0.5:1:gridCols+0.5
        plot([i, i], [0.5, gridRows+0.5], 'w', 'LineWidth', 1);
    end
    for j = 0.5:1:gridRows+0.5
        plot([0.5, gridCols+0.5], [j, j], 'w', 'LineWidth', 1);
    end
    hold off;
    
    % 设置标签
    ylabel(rowLabels{r}, 'FontSize', 12, 'FontWeight', 'bold');
    set(gca, 'XTick', [], 'YTick', [], 'Box', 'off');
end

%% 添加图例
legendStr = cell(1, numCategories);
for c = 1:numCategories
    legendStr{c} = sprintf('%s', categories{c});
end

% 创建隐藏的散点用于图例
axes('Position', [0.1, 0.02, 0.8, 0.05], 'Visible', 'off');
hold on;
h = gobjects(numCategories, 1);
for c = 1:numCategories
    h(c) = scatter(nan, nan, 100, colors(c,:), 's', 'filled');
end
legend(h, legendStr, 'Orientation', 'horizontal', 'Location', 'south', ...
       'FontSize', 11, 'Box', 'off');

%% 标题
sgtitle('多行华夫图 - 各年度类别占比', 'FontSize', 16, 'FontWeight', 'bold');
