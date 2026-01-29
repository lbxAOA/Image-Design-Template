clear; clc; close all;

%% 1. 生成分组数据
rng(42); % 设置随机种子，保证结果可复现

% 定义参数
n = 50; % 每个子组的样本数量
numGroups = 3; % 主组数量（A、B、C）
numSubGroups = 2; % 子组数量（处理前、处理后）

% 生成分组数据
% 组A - 处理前后
groupA_before = randn(n, 1) * 8 + 50;
groupA_after = randn(n, 1) * 8 + 55;

% 组B - 处理前后
groupB_before = randn(n, 1) * 10 + 60;
groupB_after = randn(n, 1) * 10 + 68;

% 组C - 处理前后
groupC_before = randn(n, 1) * 12 + 45;
groupC_after = randn(n, 1) * 12 + 53;

% 整合所有数据为一列
allData = [groupA_before; groupA_after; ...
           groupB_before; groupB_after; ...
           groupC_before; groupC_after];

% 创建主分组变量（组别）
mainGroup = [repmat({'组别A'}, n*2, 1); ...
             repmat({'组别B'}, n*2, 1); ...
             repmat({'组别C'}, n*2, 1)];

% 创建子分组变量（处理状态）
subGroup = repmat([repmat({'处理前'}, n, 1); repmat({'处理后'}, n, 1)], 3, 1);

%% 2. 绘制分组箱线图
figure('Position', [100, 100, 1000, 600], 'Color', 'white');

% 绘制分组箱线图
% 使用两个分组变量：mainGroup（主分组）和 subGroup（子分组）
positions = [1 2 4 5 7 8]; % 自定义箱体位置，使分组更清晰
h = boxplot(allData, {mainGroup, subGroup}, ...
    'Colors', [0.2 0.4 0.8; 0.8 0.4 0.2], ...
    'Positions', positions, ...
    'Widths', 0.6, ...
    'Symbol', 'ro', ...
    'OutlierSize', 5, ...
    'FactorGap', [5 2], ...
    'LabelOrientation', 'inline');

%% 3. 美化图形
% 设置标题和坐标轴标签
title('分组箱线图示例', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('实验组别', 'FontSize', 14);
ylabel('测量值', 'FontSize', 14);

% 设置坐标轴属性
ax = gca;
ax.FontSize = 12;
ax.LineWidth = 1.2;
ax.Box = 'on';

% 添加网格线
grid on;
ax.GridLineStyle = '--';
ax.GridAlpha = 0.3;

% 设置Y轴范围
ylim([min(allData) - 10, max(allData) + 10]);

% 调整X轴刻度位置和标签
set(ax, 'XTick', [1.5 4.5 7.5]);
set(ax, 'XTickLabel', {'组别A', '组别B', '组别C'});

%% 4. 自定义箱线图颜色
% 定义两种颜色：处理前（蓝色）、处理后（橙色）
color1 = [0.2 0.4 0.8]; % 蓝色 - 处理前
color2 = [0.9 0.5 0.2]; % 橙色 - 处理后

% 获取箱体并填充颜色
boxes = findobj(gca, 'Tag', 'Box');
for j = 1:length(boxes)
    if mod(j, 2) == 1
        patch(get(boxes(j), 'XData'), get(boxes(j), 'YData'), ...
            color1, 'FaceAlpha', 0.6);
    else
        patch(get(boxes(j), 'XData'), get(boxes(j), 'YData'), ...
            color2, 'FaceAlpha', 0.6);
    end
end

% 将箱线图置于顶层
set(gca, 'Children', flipud(get(gca, 'Children')));

%% 5. 添加图例说明
% 创建图例
hold on;
h1 = fill(nan, nan, color1, 'FaceAlpha', 0.6, 'EdgeColor', 'none');
h2 = fill(nan, nan, color2, 'FaceAlpha', 0.6, 'EdgeColor', 'none');
legend([h1, h2], {'处理前', '处理后'}, 'Location', 'northeast', 'FontSize', 11);
hold off;

%% 6. 保存图形
% saveas(gcf, 'boxplot_example.png');
% saveas(gcf, 'boxplot_example.fig');
% print(gcf, 'boxplot_example', '-dpng', '-r300');

%% 7. 显示统计信息
fprintf('\n===== 分组数据统计信息 =====\n');
fprintf('说明：分组箱线图显示两个分类变量的数据分布\n\n');

groups = {'A', 'B', 'C'};
conditions = {'处理前', '处理后'};
dataMatrix = {groupA_before, groupA_after, groupB_before, groupB_after, groupC_before, groupC_after};

idx = 1;
for i = 1:3
    for j = 1:2
        currentData = dataMatrix{idx};
        fprintf('组别%s-%s: 中位数=%.2f, 均值=%.2f, 标准差=%.2f, 最小值=%.2f, 最大值=%.2f\n', ...
            groups{i}, conditions{j}, median(currentData), mean(currentData), ...
            std(currentData), min(currentData), max(currentData));
        idx = idx + 1;
    end
    fprintf('\n');
end

disp('分组箱线图绘制完成！');
