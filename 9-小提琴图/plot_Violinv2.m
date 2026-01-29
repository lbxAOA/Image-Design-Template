%% 分割小提琴图 - Split Violin Plot
% 用于比较两组数据在各类别下的分布差异
clear; clc; close all;

%% 1. 生成随机数据
rng(42); % 设置随机种子，保证可重复性

% 4个类别，每个类别有两组数据进行对比
categories = {'类别A', '类别B', '类别C', '类别D'};
nCategories = length(categories);

% 组1数据（左半边）
dataGroup1 = {randn(100,1)*2+5, randn(150,1)*1.5+8, randn(120,1)*3+6, randn(80,1)*2+7};
% 组2数据（右半边）
dataGroup2 = {randn(100,1)*1.8+6, randn(150,1)*2+7, randn(120,1)*2.5+8, randn(80,1)*1.5+5};

groupNames = {'实验组', '对照组'};

%% 2. 设置颜色
color1 = [0.2 0.6 0.8];  % 蓝色 - 组1
color2 = [0.9 0.4 0.3];  % 红色 - 组2

%% 3. 绘制分割小提琴图
figure('Position', [100, 100, 900, 550]);
hold on;

for i = 1:nCategories
    x1 = dataGroup1{i};
    x2 = dataGroup2{i};
    
    % 核密度估计
    [f1, xi1] = ksdensity(x1);
    [f2, xi2] = ksdensity(x2);
    
    % 归一化宽度
    f1 = f1 / max([f1, f2]) * 0.4;
    f2 = f2 / max([f1, f2]) * 0.4;
    
    % 绘制左半边小提琴（组1）
    fill([i - f1, i*ones(1,length(xi1))], [xi1, fliplr(xi1)], color1, ...
        'FaceAlpha', 0.7, 'EdgeColor', color1*0.7, 'LineWidth', 1.5);
    
    % 绘制右半边小提琴（组2）
    fill([i + f2, i*ones(1,length(xi2))], [xi2, fliplr(xi2)], color2, ...
        'FaceAlpha', 0.7, 'EdgeColor', color2*0.7, 'LineWidth', 1.5);
    
    % 绘制组1的箱线图元素（左侧）
    q1_1 = quantile(x1, 0.25);
    q3_1 = quantile(x1, 0.75);
    med1 = median(x1);
    plot([i-0.02 i-0.02], [q1_1 q3_1], 'k-', 'LineWidth', 3);
    plot(i-0.02, med1, 'wo', 'MarkerSize', 6, 'MarkerFaceColor', 'w', 'LineWidth', 1);
    
    % 绘制组2的箱线图元素（右侧）
    q1_2 = quantile(x2, 0.25);
    q3_2 = quantile(x2, 0.75);
    med2 = median(x2);
    plot([i+0.02 i+0.02], [q1_2 q3_2], 'k-', 'LineWidth', 3);
    plot(i+0.02, med2, 'wo', 'MarkerSize', 6, 'MarkerFaceColor', 'w', 'LineWidth', 1);
end

%% 4. 添加图例
h1 = fill(NaN, NaN, color1, 'FaceAlpha', 0.7, 'EdgeColor', color1*0.7);
h2 = fill(NaN, NaN, color2, 'FaceAlpha', 0.7, 'EdgeColor', color2*0.7);
legend([h1, h2], groupNames, 'Location', 'northeast', 'FontSize', 11);

%% 5. 美化图表
set(gca, 'XTick', 1:nCategories, 'XTickLabel', categories);
xlim([0.3, nCategories + 0.7]);
xlabel('类别', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('数值', 'FontSize', 12, 'FontWeight', 'bold');
title('分割小提琴图 - Split Violin Plot', 'FontSize', 14, 'FontWeight', 'bold');
set(gca, 'FontSize', 11, 'LineWidth', 1.2, 'Box', 'on');
grid on;
grid minor;

hold off;

%% 6. 保存图片（可选）
% saveas(gcf, 'split_violin_plot.png');
% print(gcf, 'split_violin_plot', '-dpng', '-r300');
