clear; clc; close all;

%% 随机生成数据
rng(42);  % 设置随机种子，保证可复现
categories = 5;   % 5个类别
groups = 3;       % 每个类别3组数据

data = randi([10, 100], categories, groups);  % 随机生成10-100之间的整数

%% 绘制分组柱状图
figure('Position', [100, 100, 800, 500]);

b = bar(data);  % 直接传入矩阵，自动生成分组柱状图

%% 设置颜色
colors = [0.2 0.6 0.8;   % 蓝色
          0.9 0.4 0.3;   % 红色
          0.4 0.8 0.4];  % 绿色
for i = 1:groups
    b(i).FaceColor = colors(i, :);
end

%% 添加标签和标题
xlabel('类别', 'FontSize', 12);
ylabel('数值', 'FontSize', 12);
title('分组柱状图示例', 'FontSize', 14, 'FontWeight', 'bold');

%% 设置X轴刻度标签
xticklabels({'A', 'B', 'C', 'D', 'E'});

%% 添加图例
legend({'组1', '组2', '组3'}, 'Location', 'northeast');

%% 添加网格线
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);

%% 美化
set(gca, 'FontSize', 11, 'Box', 'off');

%% 在柱子上方显示数值（可选）
for i = 1:groups
    xtips = b(i).XEndPoints;
    ytips = b(i).YEndPoints;
    labels = string(b(i).YData);
    text(xtips, ytips, labels, 'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', 'FontSize', 9);
end
