clear; clc; close all;

%% 1. 生成随机数据
rng(42); % 设置随机种子，保证结果可复现

% 生成5组不同分布的随机数据
n = 100; % 每组样本数量
group1 = randn(n, 1) * 10 + 50;        % 均值50，标准差10
group2 = randn(n, 1) * 15 + 60;        % 均值60，标准差15
group3 = randn(n, 1) * 8 + 45;         % 均值45，标准差8
group4 = randn(n, 1) * 12 + 70;        % 均值70，标准差12
group5 = randn(n, 1) * 20 + 55;        % 均值55，标准差20

% 合并数据
data = [group1, group2, group3, group4, group5];

%% 2. 绘制带数据点的箱线图
figure('Position', [100, 100, 800, 600], 'Color', 'white');

% 绘制箱线图（不显示离群点，后续手动添加所有数据点）
h = boxplot(data, 'Labels', {'组别A', '组别B', '组别C', '组别D', '组别E'}, ...
    'Colors', [0.2 0.4 0.8], ...
    'Widths', 0.5, ...
    'Symbol', '', ...  % 不显示离群点
    'OutlierSize', 6);

%% 3. 美化图形
% 设置标题和坐标轴标签
title('带数据点的箱线图示例', 'FontSize', 16, 'FontWeight', 'bold');
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

% 设置Y轴范围（可根据数据自动调整）
ylim([min(data(:)) - 10, max(data(:)) + 10]);

%% 4. 自定义箱线图颜色（可选）
% 获取箱线图的各个组件并设置颜色
colors = [
    0.894 0.102 0.110;  % 红色
    0.216 0.494 0.722;  % 蓝色
    0.302 0.686 0.290;  % 绿色
    0.596 0.306 0.639;  % 紫色
    1.000 0.498 0.000;  % 橙色
];

% 获取箱体并填充颜色
boxes = findobj(gca, 'Tag', 'Box');
for j = 1:length(boxes)
    patch(get(boxes(j), 'XData'), get(boxes(j), 'YData'), ...
        colors(length(boxes) - j + 1, :), 'FaceAlpha', 0.6);
end

% 将箱线图置于顶层
set(gca, 'Children', flipud(get(gca, 'Children')));

% 在箱线图上叠加数据点
hold on;
for i = 1:5
    % 为每个数据点添加随机的X轴偏移，使其分散显示
    xOffset = (rand(n, 1) - 0.5) * 0.3; % 随机偏移范围 [-0.15, 0.15]
    scatter(i + xOffset, data(:, i), 25, colors(i, :), 'filled', ...
        'MarkerFaceAlpha', 0.4, 'MarkerEdgeAlpha', 0.6);
end
hold off;

%% 5. 添加图例说明
% 创建虚拟对象用于图例
hold on;
legendHandles = zeros(5, 1);
groupNames = {'组别A', '组别B', '组别C', '组别D', '组别E'};
for i = 1:5
    legendHandles(i) = fill(nan, nan, colors(i, :), 'FaceAlpha', 0.6, 'EdgeColor', 'none');
end
legend(legendHandles, groupNames, 'Location', 'northeast', 'FontSize', 10);
hold off;

%% 6. 保存图形
% saveas(gcf, 'boxplot_example.png');
% saveas(gcf, 'boxplot_example.fig');
% print(gcf, 'boxplot_example', '-dpng', '-r300');

%% 7. 显示统计信息
fprintf('\n===== 各组数据统计信息 =====\n');
for i = 1:5
    fprintf('组别%c: 中位数=%.2f, 均值=%.2f, 标准差=%.2f, 最小值=%.2f, 最大值=%.2f\n', ...
        char('A' + i - 1), median(data(:, i)), mean(data(:, i)), std(data(:, i)), ...
        min(data(:, i)), max(data(:, i)));
end

fprintf('\n说明: 散点表示原始数据点，通过添加随机抖动使重叠数据点可见\n');
disp('带数据点的箱线图绘制完成！');
