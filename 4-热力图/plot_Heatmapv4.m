%% 分块热力图 (Clustered/Block Heatmap)
% 使用 MATLAB 内置 heatmap 函数 + clustergram 实现分块效果
clear; clc; close all;

%% 1. 生成随机数据（模拟3个分块，每块5行4列）
rng(42); % 固定随机种子便于复现

% 生成分块数据
block1 = randn(5, 4) + 2;   % 第一块：均值偏高
block2 = randn(5, 4);       % 第二块：均值为0
block3 = randn(5, 4) - 2;   % 第三块：均值偏低

% 组合成完整数据矩阵
data = [block1; block2; block3];  % 15行 x 4列

%% 2. 设置行列标签
rowLabels = arrayfun(@(x) sprintf('样本%d', x), 1:15, 'UniformOutput', false);
colLabels = {'特征A', '特征B', '特征C', '特征D'};

% 分块标签（用于标注每个块的归属）
blockLabels = [repmat({'组1'}, 1, 5), repmat({'组2'}, 1, 5), repmat({'组3'}, 1, 5)];

%% 3. 绘制分块热力图
figure('Position', [100, 100, 800, 600], 'Color', 'w');

% 使用 heatmap 函数
h = heatmap(colLabels, rowLabels, data);

% 设置热力图属性
h.Title = '分块热力图示例';
h.XLabel = '特征';
h.YLabel = '样本';
h.Colormap = parula;           % 颜色映射
h.ColorbarVisible = 'on';      % 显示颜色条
h.CellLabelColor = 'none';     % 不显示单元格数值（可改为'auto'显示）
h.FontSize = 10;

%% 4. 添加分块分隔线（通过annotation实现）
% 获取当前坐标轴位置
ax = gca;
axPos = ax.Position;

% 在热力图上叠加分隔线
annotation('line', [axPos(1), axPos(1)+axPos(3)], ...
    [axPos(2)+axPos(4)*2/3, axPos(2)+axPos(4)*2/3], ...
    'LineWidth', 3, 'Color', 'k');
annotation('line', [axPos(1), axPos(1)+axPos(3)], ...
    [axPos(2)+axPos(4)*1/3, axPos(2)+axPos(4)*1/3], ...
    'LineWidth', 3, 'Color', 'k');

% 添加分块标注
annotation('textbox', [axPos(1)-0.08, axPos(2)+axPos(4)*5/6, 0.05, 0.05], ...
    'String', '组1', 'FontSize', 12, 'FontWeight', 'bold', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center');
annotation('textbox', [axPos(1)-0.08, axPos(2)+axPos(4)*3/6, 0.05, 0.05], ...
    'String', '组2', 'FontSize', 12, 'FontWeight', 'bold', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center');
annotation('textbox', [axPos(1)-0.08, axPos(2)+axPos(4)*1/6, 0.05, 0.05], ...
    'String', '组3', 'FontSize', 12, 'FontWeight', 'bold', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center');

%% 5. 保存图像
% saveas(gcf, 'BlockHeatmap.png');
% print(gcf, 'BlockHeatmap', '-dpng', '-r300');

disp('分块热力图绘制完成！');
