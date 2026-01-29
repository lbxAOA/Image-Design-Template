clear; clc; close all;

%% 生成随机数据
% 设置随机数种子（可选，用于结果可重复）
rng(42);

% 生成5个类别的随机数据
categories = {'类别A', '类别B', '类别C', '类别D', '类别E'};
data = rand(1, 5) * 100;  % 生成5个0-100之间的随机数

%% 绘制柱状图
figure('Position', [100, 100, 800, 600]);
b = bar(data, 'FaceColor', [0.2, 0.6, 0.8], 'EdgeColor', 'k', 'LineWidth', 1.5);

%% 图表美化
% 设置坐标轴
set(gca, 'XTickLabel', categories, 'FontSize', 12, 'FontWeight', 'bold');
xlabel('类别', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('数值', 'FontSize', 14, 'FontWeight', 'bold');
title('标准柱状图 - 随机数据', 'FontSize', 16, 'FontWeight', 'bold');

% 添加网格线
grid on;
grid minor;
set(gca, 'GridAlpha', 0.3, 'MinorGridAlpha', 0.1);

% 在柱子顶部显示数值
for i = 1:length(data)
    text(i, data(i) + max(data)*0.02, sprintf('%.2f', data(i)), ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
        'FontSize', 11, 'FontWeight', 'bold');
end

% 设置Y轴范围
ylim([0, max(data)*1.15]);

% 设置图例（如果需要）
% legend('数据系列1', 'Location', 'best', 'FontSize', 11);

% 美化背景
set(gcf, 'Color', 'w');
box on;

%% 保存图形（可选）
% saveas(gcf, 'standard_bar_chart.png');
% saveas(gcf, 'standard_bar_chart.fig');

fprintf('柱状图绘制完成！\n');
fprintf('随机生成的数据值：\n');
for i = 1:length(data)
    fprintf('%s: %.2f\n', categories{i}, data(i));
end
