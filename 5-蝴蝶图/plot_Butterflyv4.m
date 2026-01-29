%% 彩色分段蝴蝶图 (Colorful Segmented Butterfly Chart)
% 每个类别使用不同的颜色，简单实现

clear; clc; close all;

%% 数据准备 - 随机生成
categories = {'0-9岁'; '10-19岁'; '20-29岁'; '30-39岁'; '40-49岁'; ...
              '50-59岁'; '60-69岁'; '70-79岁'; '80岁以上'};
n = length(categories);

% 随机生成数据
rng('shuffle');  % 使用随机种子
leftData = randi([30, 150], n, 1);   % 左侧数据
rightData = randi([30, 150], n, 1);  % 右侧数据

%% 定义彩色调色板 (每个类别一个颜色)
colors = lines(n);  % 使用MATLAB内置lines配色方案

%% 绑定图形
figure('Position', [100, 100, 900, 550], 'Color', 'w');
hold on;

y = 1:n;
barWidth = 0.7;

% 逐个绑定每个条形（实现彩色分段）
for i = 1:n
    % 左侧条形 (负方向)
    barh(y(i), -leftData(i), barWidth, 'FaceColor', colors(i,:), 'EdgeColor', 'w', 'LineWidth', 0.5);
    % 右侧条形 (正方向)
    barh(y(i), rightData(i), barWidth, 'FaceColor', colors(i,:), 'EdgeColor', 'w', 'LineWidth', 0.5);
end

%% 添加数据标签
for i = 1:n
    text(-leftData(i) - 3, y(i), num2str(leftData(i)), ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', ...
        'FontSize', 9, 'FontWeight', 'bold', 'Color', colors(i,:) * 0.7);
    text(rightData(i) + 3, y(i), num2str(rightData(i)), ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
        'FontSize', 9, 'FontWeight', 'bold', 'Color', colors(i,:) * 0.7);
end

%% 图形美化
% Y轴设置
set(gca, 'YTick', y, 'YTickLabel', categories);
ylim([0.3, n + 0.7]);

% X轴对称设置
maxVal = max([leftData; rightData]) * 1.25;
xlim([-maxVal, maxVal]);

% X轴标签显示绝对值
xticks_val = get(gca, 'XTick');
set(gca, 'XTickLabel', abs(xticks_val));

% 添加中心线
xline(0, 'k-', 'LineWidth', 1.5);

% 标题
title('彩色分段蝴蝶图', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('数值', 'FontSize', 12);

% 添加左右侧标注
text(-maxVal * 0.5, n + 0.5, '← 组A', 'FontSize', 12, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', 'Color', [0.3, 0.3, 0.3]);
text(maxVal * 0.5, n + 0.5, '组B →', 'FontSize', 12, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', 'Color', [0.3, 0.3, 0.3]);

% 网格和样式
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3, 'XGrid', 'on', 'YGrid', 'off');
set(gca, 'FontSize', 11, 'FontName', 'Microsoft YaHei', 'Box', 'off', 'LineWidth', 1);

hold off;

%% 输出信息
fprintf('彩色分段蝴蝶图绑定完成！\n');
fprintf('左侧数据: %s\n', mat2str(leftData'));
fprintf('右侧数据: %s\n', mat2str(rightData'));
