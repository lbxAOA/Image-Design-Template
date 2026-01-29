%% 堆叠风玫瑰图 (Stacked Wind Rose)
% 使用 polarhistogram 实现标准的堆叠风玫瑰图
clear; clc; close all;

%% 随机生成风向风速数据
rng(42); % 固定随机种子，保证可复现
n = 1000; % 数据点数量

% 生成风向数据 (0-360度)，模拟主导风向为北风和西南风
directions = [randn(n/2,1)*30 + 0; randn(n/2,1)*40 + 225]; % 度
directions = mod(directions, 360); % 限制在 0-360 范围
directions_rad = deg2rad(directions); % 转换为弧度

% 生成风速数据 (m/s)
speeds = abs(randn(n,1)*3 + 5); % 平均5m/s

%% 定义风速等级
speed_bins = [0, 2, 4, 6, 8, 10, Inf]; % 风速区间边界
speed_labels = {'0-2', '2-4', '4-6', '6-8', '8-10', '>10'};
num_speed_bins = length(speed_bins) - 1;

% 定义方向分区数量
num_dir_bins = 16; % 16个方向分区
dir_edges = linspace(0, 2*pi, num_dir_bins + 1);

%% 统计每个方向区间内各风速等级的频率
counts = zeros(num_dir_bins, num_speed_bins);

for i = 1:num_speed_bins
    % 筛选当前风速等级的数据
    mask = (speeds >= speed_bins(i)) & (speeds < speed_bins(i+1));
    dir_subset = directions_rad(mask);
    
    % 统计各方向区间的数量
    counts(:, i) = histcounts(dir_subset, dir_edges)';
end

% 转换为百分比
counts_pct = counts / n * 100;

%% 绘制堆叠风玫瑰图
figure('Color', 'w', 'Position', [100, 100, 700, 600]);

% 设置颜色 (从浅到深表示风速从低到高)
colors = [
    0.7, 0.85, 1.0;   % 浅蓝
    0.4, 0.7, 0.9;    % 蓝
    0.2, 0.5, 0.8;    % 深蓝
    1.0, 0.8, 0.4;    % 浅橙
    1.0, 0.5, 0.2;    % 橙
    0.8, 0.2, 0.2;    % 红
];

% 使用极坐标绘图
ax = polaraxes;
hold(ax, 'on');

% 方向区间中心点
dir_centers = (dir_edges(1:end-1) + dir_edges(2:end)) / 2;
bar_width = 2*pi / num_dir_bins * 0.9; % 柱子宽度

% 计算累积值用于堆叠（从外到内绘制）
cumulative_total = sum(counts_pct, 2)'; % 转为行向量

% 从最高风速等级开始绘制（从外到内）
for i = num_speed_bins:-1:1
    polarhistogram(ax, 'BinEdges', dir_edges, ...
        'BinCounts', cumulative_total, ...
        'FaceColor', colors(i,:), ...
        'EdgeColor', 'w', ...
        'LineWidth', 0.5, ...
        'FaceAlpha', 1);
    cumulative_total = cumulative_total - counts_pct(:,i)';
end

%% 设置极坐标轴属性
ax.ThetaZeroLocation = 'top';      % 0度在顶部(北)
ax.ThetaDir = 'clockwise';         % 顺时针方向
ax.ThetaTick = 0:22.5:337.5;       % 方向刻度
ax.ThetaTickLabel = {'N','NNE','NE','ENE','E','ESE','SE','SSE',...
                     'S','SSW','SW','WSW','W','WNW','NW','NNW'};
ax.RAxisLocation = 80;             % 径向轴位置
ax.FontSize = 10;
ax.GridAlpha = 0.3;

% 设置径向标签
rlim([0, max(sum(counts_pct,2))*1.1]);

%% 添加图例
legend_entries = gobjects(num_speed_bins, 1);
for i = 1:num_speed_bins
    legend_entries(i) = patch(ax, NaN, NaN, colors(i,:), ...
        'EdgeColor', 'none', 'DisplayName', [speed_labels{i}, ' m/s']);
end
lgd = legend(legend_entries, 'Location', 'southoutside', ...
    'Orientation', 'horizontal', 'FontSize', 9);
lgd.Title.String = '风速等级';

%% 添加标题
title('堆叠风玫瑰图 (Wind Rose)', 'FontSize', 14, 'FontWeight', 'bold');

hold(ax, 'off');
