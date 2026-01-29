%% 热力图 + 统计量（带边缘直方图/密度）
% 随机生成数据，展示热力图及其行列统计信息

clear; clc; close all;

%% 1. 生成随机数据
rng(42);  % 设置随机种子，保证可重复性
nRows = 8;
nCols = 10;
data = randn(nRows, nCols) * 2 + 5;  % 均值5，标准差2的正态分布

rowLabels = "R" + (1:nRows);
colLabels = "C" + (1:nCols);

%% 2. 计算统计量
rowMean = mean(data, 2);   % 每行均值
colMean = mean(data, 1);   % 每列均值

%% 3. 创建图形布局
figure('Position', [100, 100, 900, 700], 'Color', 'w');

% 使用 tiledlayout 创建布局
t = tiledlayout(5, 6, 'TileSpacing', 'compact', 'Padding', 'compact');

%% 4. 顶部：列均值柱状图
nexttile(1, [1, 5]);
bar(colMean, 'FaceColor', [0.2 0.6 0.8], 'EdgeColor', 'none');
set(gca, 'XTick', 1:nCols, 'XTickLabel', []);
ylabel('列均值');
xlim([0.5, nCols + 0.5]);
title('热力图 + 边缘统计量', 'FontSize', 14, 'FontWeight', 'bold');
grid on; box on;

%% 5. 主热力图
nexttile(7, [4, 5]);
imagesc(data);
colormap(parula);
cb = colorbar('Location', 'eastoutside');
cb.Label.String = '数值';
set(gca, 'XTick', 1:nCols, 'XTickLabel', colLabels, ...
         'YTick', 1:nRows, 'YTickLabel', rowLabels);
xlabel('列'); ylabel('行');

% 在热力图上显示数值
for i = 1:nRows
    for j = 1:nCols
        textColor = 'k';
        if data(i,j) > mean(data(:)) + std(data(:))
            textColor = 'w';
        end
        text(j, i, sprintf('%.1f', data(i,j)), ...
            'HorizontalAlignment', 'center', ...
            'FontSize', 8, 'Color', textColor);
    end
end

%% 6. 右侧：行均值条形图
nexttile(6, [1, 1]);
axis off;  % 占位

nexttile(12, [4, 1]);
barh(rowMean, 'FaceColor', [0.8 0.4 0.4], 'EdgeColor', 'none');
set(gca, 'YTick', 1:nRows, 'YTickLabel', []);
xlabel('行均值');
ylim([0.5, nRows + 0.5]);
set(gca, 'YDir', 'reverse');  % 与热力图方向一致
grid on; box on;

%% 7. 显示汇总统计信息
annotation('textbox', [0.02, 0.02, 0.3, 0.08], ...
    'String', sprintf('总体统计: 均值=%.2f, 标准差=%.2f, 最小=%.2f, 最大=%.2f', ...
    mean(data(:)), std(data(:)), min(data(:)), max(data(:))), ...
    'EdgeColor', 'none', 'FontSize', 9, 'FitBoxToText', 'on');

%% 8. 保存图形
% exportgraphics(gcf, 'heatmap_with_stats.png', 'Resolution', 300);
% saveas(gcf, 'heatmap_with_stats.fig');

disp('热力图 + 统计量绑定绘制完成！');
