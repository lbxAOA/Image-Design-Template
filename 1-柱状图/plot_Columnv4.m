clear; clc; close all;

%% 1. 生成随机数据
rng(42); % 固定随机种子，便于复现
categories = {'A', 'B', 'C', 'D', 'E'}; % 类别
numCategories = length(categories);
numGroups = 4; % 堆叠组数

data = randi([10, 100], numCategories, numGroups); % 随机整数数据

%% 2. 计算百分比
dataPercent = data ./ sum(data, 2) * 100; % 每行归一化为100%

%% 3. 绘制百分比堆叠柱状图
figure('Position', [100, 100, 800, 500]);
b = bar(dataPercent, 'stacked');

% 设置颜色
colors = [0.2 0.6 0.8; 0.9 0.4 0.3; 0.5 0.8 0.5; 0.9 0.7 0.3];
for i = 1:numGroups
    b(i).FaceColor = colors(i, :);
end

%% 4. 美化图表
set(gca, 'XTickLabel', categories, 'FontSize', 12);
xlabel('类别', 'FontSize', 14);
ylabel('百分比 (%)', 'FontSize', 14);
title('百分比堆叠柱状图', 'FontSize', 16, 'FontWeight', 'bold');
legend({'组1', '组2', '组3', '组4'}, 'Location', 'eastoutside');
ylim([0 100]);
grid on;
box on;

%% 5. 在柱子上添加百分比标签（可选）
for i = 1:numCategories
    cumHeight = 0;
    for j = 1:numGroups
        if dataPercent(i, j) > 5 % 只显示大于5%的标签
            text(i, cumHeight + dataPercent(i, j)/2, ...
                sprintf('%.1f%%', dataPercent(i, j)), ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', ...
                'FontSize', 9, 'Color', 'white', 'FontWeight', 'bold');
        end
        cumHeight = cumHeight + dataPercent(i, j);
    end
end

disp('百分比堆叠柱状图绘制完成！');
