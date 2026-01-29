%% 热力图 + 聚类树状图 (Clustered Heatmap)
clear; clc; close all;

%% 1. 生成随机数据
rng(42);  % 设置随机种子，保证可重复性
nRows = 20;  % 行数（样本数）
nCols = 10;  % 列数（特征数）

% 生成随机数据矩阵
data = randn(nRows, nCols);

% 生成行标签和列标签
rowLabels = strcat('Sample', string(1:nRows));
colLabels = strcat('Gene', string(1:nCols));

%% 2. 使用 clustergram 绘制热力图 + 聚类树状图
% clustergram 是 Bioinformatics Toolbox 中的函数
% 自动完成层次聚类并绘制树状图

try
    % 方法1：使用 clustergram（需要 Bioinformatics Toolbox）
    cg = clustergram(data, ...
        'RowLabels', rowLabels, ...
        'ColumnLabels', colLabels, ...
        'Colormap', redbluecmap, ...      % 红蓝配色
        'Standardize', 'row', ...          % 按行标准化
        'Cluster', 'all', ...              % 对行和列都进行聚类
        'Linkage', 'average', ...          % 平均链接法
        'ColumnLabelsRotate', 45, ...      % 列标签旋转45度
        'DisplayRange', 3);                % 显示范围 [-3, 3]
    
    % 添加标题
    addTitle(cg, '热力图 + 聚类树状图 (Clustered Heatmap)');
    
    disp('使用 clustergram 成功绘制！');
    
catch ME
    % 方法2：如果没有 Bioinformatics Toolbox，手动实现
    disp('Bioinformatics Toolbox 不可用，使用手动方法...');
    disp(['错误信息: ', ME.message]);
    
    %% 手动实现聚类热力图
    figure('Position', [100, 100, 900, 700], 'Color', 'w');
    
    % 标准化数据（按行）
    dataZ = zscore(data, 0, 2);
    
    % 层次聚类
    distRow = pdist(dataZ, 'euclidean');      % 行距离
    distCol = pdist(dataZ', 'euclidean');     % 列距离
    linkRow = linkage(distRow, 'average');    % 行聚类
    linkCol = linkage(distCol, 'average');    % 列聚类
    
    % 获取聚类排序
    orderRow = optimalleaforder(linkRow, distRow);
    orderCol = optimalleaforder(linkCol, distCol);
    
    % 重排数据
    dataReordered = dataZ(orderRow, orderCol);
    
    % 设置子图布局
    % 左侧树状图
    ax1 = axes('Position', [0.05, 0.15, 0.12, 0.7]);
    [~, ~, outperm] = dendrogram(linkRow, 0, 'Orientation', 'left', 'Reorder', orderRow);
    set(ax1, 'YTickLabel', [], 'XTickLabel', [], 'Box', 'off');
    title('样本聚类');
    
    % 顶部树状图
    ax2 = axes('Position', [0.22, 0.87, 0.65, 0.1]);
    dendrogram(linkCol, 0, 'Reorder', orderCol);
    set(ax2, 'XTickLabel', [], 'YTickLabel', [], 'Box', 'off');
    title('特征聚类');
    
    % 热力图
    ax3 = axes('Position', [0.22, 0.15, 0.65, 0.7]);
    imagesc(dataReordered);
    colormap(ax3, redbluecmap(256));  % 红蓝配色
    colorbar('Position', [0.9, 0.15, 0.02, 0.7]);
    caxis([-3, 3]);
    
    % 设置标签
    set(ax3, 'XTick', 1:nCols, 'XTickLabel', colLabels(orderCol), ...
             'YTick', 1:nRows, 'YTickLabel', rowLabels(orderRow));
    xtickangle(45);
    xlabel('特征 (Genes)');
    ylabel('样本 (Samples)');
    
    % 总标题
    sgtitle('热力图 + 聚类树状图 (Clustered Heatmap)', 'FontSize', 14, 'FontWeight', 'bold');
    
    disp('手动方法绘制完成！');
end

%% 辅助函数：红蓝配色图
function cmap = redbluecmap(n)
    if nargin < 1
        n = 64;
    end
    % 创建红-白-蓝渐变色
    r = [linspace(0, 1, n/2), ones(1, n/2)];
    g = [linspace(0, 1, n/2), linspace(1, 0, n/2)];
    b = [ones(1, n/2), linspace(1, 0, n/2)];
    cmap = [r', g', b'];
end
