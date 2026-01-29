%% 堆叠蝴蝶图 (Stacked Butterfly Chart)
% 使用barh函数实现左右对称的堆叠水平条形图

clear; clc; close all;

%% 数据准备 - 随机生成
categories = {'类别A'; '类别B'; '类别C'; '类别D'; '类别E'; '类别F'};
nCategories = length(categories);
nStacks = 3;  % 堆叠层数

% 随机生成左右两侧数据 (每侧有多个堆叠组)
rng(42);  % 固定随机种子保证可重复
leftData = randi([10, 50], nCategories, nStacks);   % 左侧数据 (正值)
rightData = randi([10, 50], nCategories, nStacks);  % 右侧数据 (正值)

%% 绑定颜色
colors = [0.2 0.6 0.8;   % 蓝色系
          0.4 0.8 0.6;   % 绿色系  
          0.9 0.5 0.3];  % 橙色系

%% 绑定图形
figure('Position', [100, 100, 900, 500], 'Color', 'w');
hold on;

% 绘制左侧堆叠条形图 (负方向)
barh(1:nCategories, -leftData, 'stacked', 'FaceColor', 'flat', 'EdgeColor', 'none');
b1 = findobj(gca, 'Type', 'Bar');
for i = 1:nStacks
    b1(nStacks-i+1).CData = repmat(colors(i,:), nCategories, 1);
end

% 绘制右侧堆叠条形图 (正方向)
barh(1:nCategories, rightData, 'stacked', 'FaceColor', 'flat', 'EdgeColor', 'none');
b2 = findobj(gca, 'Type', 'Bar');
for i = 1:nStacks
    b2(nStacks-i+1).CData = repmat(colors(i,:), nCategories, 1);
end

%% 美化图形
% 设置Y轴
set(gca, 'YTick', 1:nCategories, 'YTickLabel', categories);
ylim([0.5, nCategories + 0.5]);

% 设置X轴对称
maxVal = max([sum(leftData, 2); sum(rightData, 2)]) * 1.1;
xlim([-maxVal, maxVal]);

% X轴标签显示绝对值
xticks_val = get(gca, 'XTick');
set(gca, 'XTickLabel', abs(xticks_val));

% 添加中心线
plot([0 0], ylim, 'k-', 'LineWidth', 1.5);

% 添加标题和标签
title('堆叠蝴蝶图示例', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('数值', 'FontSize', 12);

% 添加图例
legend({'组1', '组2', '组3'}, 'Location', 'northeast', 'FontSize', 10);

% 添加左右标注
text(-maxVal*0.5, nCategories+0.8, '← 左侧', 'FontSize', 12, 'HorizontalAlignment', 'center');
text(maxVal*0.5, nCategories+0.8, '右侧 →', 'FontSize', 12, 'HorizontalAlignment', 'center');

% 网格和样式
grid on;
set(gca, 'FontSize', 11, 'Box', 'off', 'LineWidth', 1);

hold off;
