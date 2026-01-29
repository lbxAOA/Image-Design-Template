%% 百分比蝴蝶图 (Percentage Butterfly Chart)
% 使用简单方法实现，随机生成数据

clear; clc; close all;

%% 数据生成
categories = {'0-9岁'; '10-19岁'; '20-29岁'; '30-39岁'; '40-49岁'; '50-59岁'; '60-69岁'; '70岁以上'};
n = length(categories);

% 随机生成人口数据
maleData = randi([500, 2000], n, 1);      % 男性人口
femaleData = randi([500, 2000], n, 1);    % 女性人口

% 转换为百分比
totalMale = sum(maleData);
totalFemale = sum(femaleData);
malePct = maleData / totalMale * 100;
femalePct = femaleData / totalFemale * 100;

%% 绑定作图
figure('Position', [100, 100, 800, 500], 'Color', 'w');

% 使用barh绑定水平条形图
y = 1:n;
barh(y, -malePct, 'FaceColor', [0.2, 0.6, 0.9], 'EdgeColor', 'none');  % 男性向左（负值）
hold on;
barh(y, femalePct, 'FaceColor', [0.95, 0.5, 0.5], 'EdgeColor', 'none'); % 女性向右

%% 图形美化
% 设置Y轴
set(gca, 'YTick', y, 'YTickLabel', categories);
ylim([0.5, n + 0.5]);

% 设置X轴（百分比显示）
maxPct = ceil(max([malePct; femalePct]) / 5) * 5;  % 取5的整数倍
xlim([-maxPct, maxPct]);
xticks(-maxPct:5:maxPct);
xticklabels(abs(-maxPct:5:maxPct) + "%");

% 添加中心线
xline(0, 'k-', 'LineWidth', 1);

% 添加数据标签
for i = 1:n
    text(-malePct(i) - 0.5, i, sprintf('%.1f%%', malePct(i)), ...
        'HorizontalAlignment', 'right', 'FontSize', 9);
    text(femalePct(i) + 0.5, i, sprintf('%.1f%%', femalePct(i)), ...
        'HorizontalAlignment', 'left', 'FontSize', 9);
end

% 标题和图例
title('人口年龄结构蝴蝶图（百分比）', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('占比 (%)');

legend({'男性', '女性'}, 'Location', 'southoutside', 'Orientation', 'horizontal');

% 添加分组标签
text(-maxPct/2, n + 0.8, '← 男性', 'HorizontalAlignment', 'center', 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.2, 0.6, 0.9]);
text(maxPct/2, n + 0.8, '女性 →', 'HorizontalAlignment', 'center', 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.95, 0.5, 0.5]);

% 网格线
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
set(gca, 'FontSize', 10, 'Box', 'off');

hold off;
