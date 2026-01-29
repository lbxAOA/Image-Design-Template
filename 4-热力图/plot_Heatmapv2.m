clear; clc; close all;

%% 1. 生成随机数据
rng(42);  % 设置随机种子，保证可重复
nRows = 30;  % 样本数
nCols = 10;  % 特征数

% 生成随机数据矩阵
data = randn(nRows, nCols);

% 添加一些聚类结构（让某些行/列有相似的模式）
data(1:10, 1:4) = data(1:10, 1:4) + 2;
data(11:20, 5:7) = data(11:20, 5:7) - 2;
data(21:30, 8:10) = data(21:30, 8:10) + 1.5;

%% 2. 创建行列标签
rowLabels = arrayfun(@(x) sprintf('Sample%d', x), 1:nRows, 'UniformOutput', false);
colLabels = arrayfun(@(x) sprintf('Gene%d', x), 1:nCols, 'UniformOutput', false);

%% 3. 绘制聚类热力图
% 使用 clustergram 函数（最简单的方法）
cg = clustergram(data, ...
    'RowLabels', rowLabels, ...
    'ColumnLabels', colLabels, ...
    'Colormap', redbluecmap, ...       % 红蓝配色
    'Standardize', 'row', ...          % 按行标准化
    'Cluster', 'all', ...              % 对行和列都进行聚类
    'Linkage', 'average', ...          % 使用平均连接法
    'ColumnLabelsRotate', 45);         % 列标签旋转45度

% 添加标题
addTitle(cg, '聚类热力图 (Clustered Heatmap)');

%% 如果没有 Bioinformatics Toolbox，可以使用以下替代方案：
% =========================================================================
% % 手动实现简易版聚类热力图
% 
% % 层次聚类
% rowDist = pdist(data);
% rowLink = linkage(rowDist, 'average');
% rowOrder = optimalleaforder(rowLink, rowDist);
% 
% colDist = pdist(data');
% colLink = linkage(colDist, 'average');
% colOrder = optimalleaforder(colLink, colDist);
% 
% % 重排数据
% dataReordered = data(rowOrder, colOrder);
% 
% % 绘制热力图
% figure('Position', [100, 100, 800, 600]);
% heatmap(colLabels(colOrder), rowLabels(rowOrder), dataReordered, ...
%     'Colormap', parula, ...
%     'ColorbarVisible', 'on');
% title('聚类热力图 (Clustered Heatmap)');
% =========================================================================
