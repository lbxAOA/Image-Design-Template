clear; clc; close all;

%% 参数设置
numGroups = 8;          % 组数（山脊数量）
numPoints = 1000;       % 每组数据点数
overlap = 0.6;          % 重叠系数 (0-1, 越大重叠越多)
smoothPoints = 200;     % 平滑曲线的点数

%% 生成随机数据
rng(42);  % 设置随机种子，保证可重复性

% 生成不同分布的数据，模拟真实场景
data = cell(numGroups, 1);
groupNames = {'一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月'};

% 为每组生成不同特征的数据
for i = 1:numGroups
    % 混合正态分布，每组有不同的均值和方差
    n1 = round(numPoints * (0.4 + 0.3*rand()));
    n2 = numPoints - n1;
    
    mu1 = 2 + i*0.5 + randn()*0.5;
    mu2 = mu1 + 2 + rand()*2;
    sigma1 = 0.8 + rand()*0.4;
    sigma2 = 1.0 + rand()*0.5;
    
    data{i} = [normrnd(mu1, sigma1, n1, 1); normrnd(mu2, sigma2, n2, 1)];
end

%% 计算核密度估计
xMin = min(cellfun(@min, data)) - 2;
xMax = max(cellfun(@max, data)) + 2;
xGrid = linspace(xMin, xMax, smoothPoints);

densities = zeros(numGroups, smoothPoints);
for i = 1:numGroups
    [f, xi] = ksdensity(data{i}, xGrid);
    densities(i, :) = f;
end

% 归一化密度，使最大值为1
maxDensity = max(densities(:));
densities = densities / maxDensity;

%% 绘制山脊图
figure('Position', [100, 100, 900, 700], 'Color', 'white');

% 定义颜色映射 - 使用渐变色
colors = [
    0.2000, 0.4000, 0.8000;   % 深蓝
    0.2500, 0.5000, 0.8500;
    0.3000, 0.6000, 0.9000;
    0.4000, 0.7000, 0.9000;
    0.5000, 0.7500, 0.8500;
    0.6000, 0.8000, 0.8000;
    0.7000, 0.8500, 0.7500;
    0.8000, 0.9000, 0.7000;   % 浅绿
];

% 从下往上绘制，确保正确的遮挡关系
hold on;

for i = numGroups:-1:1
    % 计算当前组的基线位置
    baseline = (numGroups - i) * (1 - overlap);
    
    % 获取当前密度曲线
    yUpper = densities(i, :) + baseline;
    yLower = baseline - densities(i, :);
    
    % 创建上半部分填充区域
    xFill = [xGrid, fliplr(xGrid)];
    yFillUpper = [yUpper, ones(1, smoothPoints) * baseline];
    
    % 填充上半部分
    fill(xFill, yFillUpper, colors(i, :), ...
        'EdgeColor', 'none', ...
        'FaceAlpha', 0.7);
    
    % 创建下半部分填充区域
    yFillLower = [ones(1, smoothPoints) * baseline, fliplr(yLower)];
    
    % 填充下半部分
    fill(xFill, yFillLower, colors(i, :), ...
        'EdgeColor', 'none', ...
        'FaceAlpha', 0.7);
    
    % 绘制上轮廓线
    plot(xGrid, yUpper, 'Color', colors(i, :) * 0.6, 'LineWidth', 1.5);
    
    % 绘制下轮廓线
    plot(xGrid, yLower, 'Color', colors(i, :) * 0.6, 'LineWidth', 1.5);
    
    % 绘制基线
    plot([xMin, xMax], [baseline, baseline], ...
        'Color', [0.8, 0.8, 0.8], 'LineWidth', 0.5);
end

%% 设置坐标轴和标签
% Y轴刻度和标签
yTicks = (0:numGroups-1) * (1 - overlap);
set(gca, 'YTick', yTicks, 'YTickLabel', flipud(groupNames(:)));

% 设置坐标轴范围
xlim([xMin, xMax]);
ylim([-1.2, (numGroups - 1) * (1 - overlap) + 1.2]);

% 标签和标题
xlabel('数值', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('月份', 'FontSize', 12, 'FontWeight', 'bold');
title('双向山脊图 - 各月数据分布对比', 'FontSize', 14, 'FontWeight', 'bold');

% 美化坐标轴
set(gca, 'FontSize', 11, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'XColor', [0.3, 0.3, 0.3], ...
    'YColor', [0.3, 0.3, 0.3], ...
    'LineWidth', 1);

% 移除上边框和右边框
ax = gca;
ax.YAxis.TickLength = [0, 0];

hold off;

%% 保存图片
% saveas(gcf, 'ridge_plot.png');
% saveas(gcf, 'ridge_plot.pdf');

fprintf('山脊图绘制完成！\n');
fprintf('数据组数: %d\n', numGroups);
fprintf('每组数据点数: %d\n', numPoints);
