%% 图标华夫图（象形图 Pictogram Chart）
% 使用图标/符号代替方格展示数据比例
clear; clc; close all;

%% 1. 随机生成数据
rng(123); % 固定随机种子
categories = {'产品A', '产品B', '产品C'};
values = randi([10, 40], 1, 3); % 随机生成3个类别的值

%% 2. 设置参数
gridRows = 10;    % 网格行数
gridCols = 10;    % 网格列数
totalCells = gridRows * gridCols;

% 将数值转换为格子数
proportions = round(values / sum(values) * totalCells);
proportions(end) = totalCells - sum(proportions(1:end-1)); % 修正舍入误差

%% 3. 定义图标（使用Unicode符号）
% 可选图标: ● ■ ★ ♦ ▲ ♥ ✦ ◆ ⬤
icons = {'●', '■', '★'};  % 每个类别的图标

%% 4. 定义颜色
colors = [
    0.2, 0.5, 0.9;   % 蓝色
    0.9, 0.3, 0.3;   % 红色
    0.3, 0.8, 0.4;   % 绿色
];

%% 5. 创建网格矩阵（记录每格的类别）
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

%% 6. 绘制图标华夫图
figure('Position', [100, 100, 600, 650], 'Color', 'w');
hold on;

% 绘制每个图标
for row = 1:gridRows
    for col = 1:gridCols
        catIdx = grid(row, col);
        if catIdx > 0
            x = col;
            y = gridRows - row + 1; % 从上到下填充
            text(x, y, icons{catIdx}, ...
                'FontSize', 20, ...
                'Color', colors(catIdx, :), ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', ...
                'FontName', 'Microsoft YaHei'); % 使用支持符号的字体
        end
    end
end

%% 7. 设置坐标轴
axis equal;
xlim([0.5, gridCols + 0.5]);
ylim([0, gridRows + 1.5]);
axis off;

%% 8. 添加图例
legendY = gridRows + 1;
xPos = linspace(2, gridCols - 1, length(categories));
for i = 1:length(categories)
    % 图标
    text(xPos(i) - 0.8, legendY, icons{i}, ...
        'FontSize', 18, ...
        'Color', colors(i, :), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', ...
        'FontName', 'Microsoft YaHei');
    % 标签
    percent = values(i) / sum(values) * 100;
    text(xPos(i), legendY, sprintf('%s: %.1f%%', categories{i}, percent), ...
        'FontSize', 11, ...
        'Color', colors(i, :), ...
        'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'middle', ...
        'FontWeight', 'bold');
end

%% 9. 添加标题
title('图标华夫图（象形图）', 'FontSize', 14, 'FontWeight', 'bold');

hold off;

%% 10. 显示数据摘要
fprintf('\n=== 图标华夫图数据摘要 ===\n');
fprintf('网格大小: %d × %d = %d 个图标\n', gridRows, gridCols, totalCells);
fprintf('\n类别分布:\n');
for i = 1:length(categories)
    fprintf('  %s %s: 原值=%d, 图标数=%d (%.1f%%)\n', ...
        icons{i}, categories{i}, values(i), proportions(i), proportions(i)/totalCells*100);
end
