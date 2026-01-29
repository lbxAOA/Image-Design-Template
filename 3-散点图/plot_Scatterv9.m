%% 散点图 + 聚类结果可视化
% 使用 K-means 聚类算法对随机生成的数据进行聚类，并可视化结果
clear; clc; close all;

%% 1. 随机生成数据（3个簇）
rng(42); % 设置随机种子，保证可重复性
n = 150; % 每个簇的点数

% 生成3个簇的数据
data1 = randn(n, 2) + [2, 2];    % 簇1：中心在(2,2)
data2 = randn(n, 2) + [-2, -2];  % 簇2：中心在(-2,-2)
data3 = randn(n, 2) + [2, -2];   % 簇3：中心在(2,-2)

% 合并数据
X = [data1; data2; data3];

%% 2. K-means 聚类
k = 3; % 聚类数量
[idx, C] = kmeans(X, k, 'Replicates', 5);

%% 3. 绘制散点图 + 聚类结果
figure('Position', [100, 100, 800, 600]);

% 定义颜色
colors = lines(k);

% 绘制每个簇的散点
gscatter(X(:,1), X(:,2), idx, colors, 'o', 8);
hold on;

% 绘制聚类中心
scatter(C(:,1), C(:,2), 200, 'k', 'x', 'LineWidth', 3);

% 图形美化
xlabel('特征 X_1', 'FontSize', 12);
ylabel('特征 X_2', 'FontSize', 12);
title('K-means 聚类结果散点图', 'FontSize', 14, 'FontWeight', 'bold');
legend([arrayfun(@(i) sprintf('簇 %d', i), 1:k, 'UniformOutput', false), {'聚类中心'}], ...
    'Location', 'best');
grid on;
box on;
set(gca, 'FontSize', 11);

hold off;
