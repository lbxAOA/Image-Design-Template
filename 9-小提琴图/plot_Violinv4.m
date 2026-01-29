%% 分组小提琴图 - Grouped Violin Plot
% 展示不同类别在多个组别下的数据分布对比
clear; clc; close all;

%% 1. 生成随机数据
rng(42); % 设置随机种子，保证可重复性

% 定义分组结构：3个组别 × 2个类别
groupNames = {'组A', '组B', '组C'};
categoryNames = {'类别1', '类别2'};
nGroups = length(groupNames);
nCategories = length(categoryNames);

% 生成随机数据 (每组每类别100个样本)
data = cell(nGroups, nCategories);
data{1,1} = randn(100,1)*1.5 + 5;   % 组A-类别1
data{1,2} = randn(100,1)*2.0 + 7;   % 组A-类别2
data{2,1} = randn(100,1)*1.2 + 6;   % 组B-类别1
data{2,2} = randn(100,1)*1.8 + 9;   % 组B-类别2
data{3,1} = randn(100,1)*2.5 + 4;   % 组C-类别1
data{3,2} = randn(100,1)*1.0 + 8;   % 组C-类别2

%% 2. 设置颜色
colors = [0.2 0.6 0.8;   % 类别1 - 蓝色
          0.9 0.4 0.3];  % 类别2 - 红色

%% 3. 绘制分组小提琴图
figure('Position', [100, 100, 900, 550]);
hold on;

violinWidth = 0.35;  % 小提琴宽度
groupSpacing = 1.0;  % 组间距
categoryOffset = 0.4; % 类别内偏移

for g = 1:nGroups
    for c = 1:nCategories
        x = data{g, c};
        
        % 计算位置：组位置 + 类别偏移
        pos = g * groupSpacing + (c - 1.5) * categoryOffset;
        
        % 核密度估计
        [f, xi] = ksdensity(x);
        
        % 归一化宽度
        f = f / max(f) * violinWidth;
        
        % 绘制小提琴形状（左右对称）
        fill([pos - f, fliplr(pos + f)], [xi, fliplr(xi)], colors(c,:), ...
            'FaceAlpha', 0.6, 'EdgeColor', colors(c,:)*0.7, 'LineWidth', 1.5);
        
        % 绘制箱线图元素
        q1 = quantile(x, 0.25);
        q3 = quantile(x, 0.75);
        med = median(x);
        
        % 四分位数范围（黑色粗线）
        plot([pos pos], [q1 q3], 'k-', 'LineWidth', 4);
        
        % 中位数（白点）
        plot(pos, med, 'wo', 'MarkerSize', 8, 'MarkerFaceColor', 'w', 'LineWidth', 1.5);
    end
end

%% 4. 美化图表
% 设置X轴刻度位置和标签
xPositions = (1:nGroups) * groupSpacing;
set(gca, 'XTick', xPositions, 'XTickLabel', groupNames);
xlim([0.3, nGroups * groupSpacing + 0.7]);

xlabel('组别', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('数值', 'FontSize', 12, 'FontWeight', 'bold');
title('分组小提琴图示例', 'FontSize', 14, 'FontWeight', 'bold');

% 添加图例
legendHandles = zeros(nCategories, 1);
for c = 1:nCategories
    legendHandles(c) = fill(nan, nan, colors(c,:), 'FaceAlpha', 0.6, ...
        'EdgeColor', colors(c,:)*0.7, 'LineWidth', 1.5);
end
legend(legendHandles, categoryNames, 'Location', 'northeast', 'FontSize', 10);

set(gca, 'FontSize', 11, 'LineWidth', 1.2, 'Box', 'on');
grid on;

hold off;

%% 5. 保存图片（可选）
% saveas(gcf, 'grouped_violin_plot.png');
% print(gcf, 'grouped_violin_plot', '-dpng', '-r300');
