%% 基础小提琴图 - Violin Plot
% 使用核密度估计绘制小提琴图
clear; clc; close all;

%% 1. 生成随机数据
rng(42); % 设置随机种子，保证可重复性
data = {randn(100,1)*2+5, randn(150,1)*1.5+8, randn(120,1)*3+6, randn(80,1)*2+7};
groupNames = {'组A', '组B', '组C', '组D'};
nGroups = length(data);

%% 2. 设置颜色
colors = [0.2 0.6 0.8;   % 蓝色
          0.9 0.4 0.3;   % 红色
          0.3 0.8 0.5;   % 绿色
          0.8 0.6 0.2];  % 橙色

%% 3. 绘制小提琴图
figure('Position', [100, 100, 800, 500]);
hold on;

for i = 1:nGroups
    x = data{i};
    
    % 核密度估计
    [f, xi] = ksdensity(x);
    
    % 归一化宽度
    f = f / max(f) * 0.35;
    
    % 绘制小提琴形状（左右对称）
    fill([i - f, fliplr(i + f)], [xi, fliplr(xi)], colors(i,:), ...
        'FaceAlpha', 0.6, 'EdgeColor', colors(i,:)*0.7, 'LineWidth', 1.5);
    
    % 绘制箱线图元素
    q1 = quantile(x, 0.25);
    q3 = quantile(x, 0.75);
    med = median(x);
    
    % 四分位数范围（黑色粗线）
    plot([i i], [q1 q3], 'k-', 'LineWidth', 4);
    
    % 中位数（白点）
    plot(i, med, 'wo', 'MarkerSize', 8, 'MarkerFaceColor', 'w', 'LineWidth', 1.5);
end

%% 4. 美化图表
set(gca, 'XTick', 1:nGroups, 'XTickLabel', groupNames);
xlim([0.3, nGroups + 0.7]);
xlabel('分组', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('数值', 'FontSize', 12, 'FontWeight', 'bold');
title('小提琴图示例', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'FontSize', 11, 'LineWidth', 1.2, 'Box', 'on');
grid on;
grid minor;

hold off;

%% 5. 保存图片（可选）
% saveas(gcf, 'violin_plot.png');
% print(gcf, 'violin_plot', '-dpng', '-r300');
