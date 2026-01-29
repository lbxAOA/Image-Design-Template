clear; clc; close all;

%% 数据准备 - 随机生成
% 类别标签
categories = {'0-9岁'; '10-19岁'; '20-29岁'; '30-39岁'; '40-49岁'; ...
              '50-59岁'; '60-69岁'; '70-79岁'; '80岁以上'};

% 随机生成两组数据（例如：男性和女性人口）
rng(42); % 设置随机种子以保证可重复性
data_left = randi([50, 200], length(categories), 1);   % 左侧数据（如男性）
data_right = randi([50, 200], length(categories), 1);  % 右侧数据（如女性）

%% 绑定颜色
color_left = [0.2, 0.4, 0.8];   % 蓝色 - 左侧
color_right = [0.9, 0.3, 0.3]; % 红色 - 右侧

%% 绑定图形
figure('Position', [100, 100, 900, 600], 'Color', 'w');

% 计算Y轴位置
y_pos = 1:length(categories);
bar_height = 0.6;

% 绘制左侧条形（负方向）
barh(y_pos, -data_left, bar_height, 'FaceColor', color_left, 'EdgeColor', 'none');
hold on;

% 绘制右侧条形（正方向）
barh(y_pos, data_right, bar_height, 'FaceColor', color_right, 'EdgeColor', 'none');

%% 添加数据标签
for i = 1:length(categories)
    % 左侧标签
    text(-data_left(i) - 5, y_pos(i), num2str(data_left(i)), ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', ...
        'FontSize', 10, 'FontWeight', 'bold', 'Color', color_left);
    
    % 右侧标签
    text(data_right(i) + 5, y_pos(i), num2str(data_right(i)), ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
        'FontSize', 10, 'FontWeight', 'bold', 'Color', color_right);
end

%% 图形美化
% 设置Y轴
set(gca, 'YTick', y_pos, 'YTickLabel', categories);
ylim([0.5, length(categories) + 0.5]);

% 设置X轴对称
max_val = max([max(data_left), max(data_right)]) * 1.3;
xlim([-max_val, max_val]);

% 自定义X轴刻度标签（显示绝对值）
x_ticks = get(gca, 'XTick');
x_labels = arrayfun(@(x) num2str(abs(x)), x_ticks, 'UniformOutput', false);
set(gca, 'XTickLabel', x_labels);

% 添加中心线
plot([0, 0], [0, length(categories) + 1], 'k-', 'LineWidth', 1.5);

% 添加网格线
set(gca, 'XGrid', 'on', 'GridLineStyle', '--', 'GridAlpha', 0.3);

% 设置坐标轴属性
set(gca, 'FontSize', 11, 'FontName', 'Microsoft YaHei', ...
    'Box', 'off', 'TickDir', 'out', 'LineWidth', 1.2);

% 添加标题和标签
title('人口年龄结构蝴蝶图', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('人口数量（万人）', 'FontSize', 12);

% 添加图例
legend({'男性', '女性'}, 'Location', 'northeast', 'FontSize', 11);

%% 添加左右侧标题
text(-max_val * 0.5, length(categories) + 0.8, '← 男性', ...
    'HorizontalAlignment', 'center', 'FontSize', 13, ...
    'FontWeight', 'bold', 'Color', color_left);
text(max_val * 0.5, length(categories) + 0.8, '女性 →', ...
    'HorizontalAlignment', 'center', 'FontSize', 13, ...
    'FontWeight', 'bold', 'Color', color_right);

hold off;

%% 保存图片
% saveas(gcf, '蝴蝶图_人口金字塔.png');
% saveas(gcf, '蝴蝶图_人口金字塔.fig');

fprintf('蝴蝶图绑定完成！\n');
fprintf('左侧数据总和: %d\n', sum(data_left));
fprintf('右侧数据总和: %d\n', sum(data_right));
