clear; clc; close all;

%% 生成随机数据
categories = {'A', 'B', 'C', 'D', 'E'};  % 5个类别
data = randi([10, 50], 5, 3);            % 5个类别，3个堆叠层

%% 绘制堆叠柱状图
figure;
b = bar(data, 'stacked');

%% 美化图表
% 设置颜色
colors = [0.2 0.6 0.8; 0.9 0.5 0.2; 0.4 0.8 0.4];
for i = 1:length(b)
    b(i).FaceColor = colors(i, :);
end

% 设置坐标轴
set(gca, 'XTickLabel', categories, 'FontSize', 12);
xlabel('类别', 'FontSize', 14);
ylabel('数值', 'FontSize', 14);
title('堆叠柱状图示例', 'FontSize', 16);

% 添加图例
legend({'系列1', '系列2', '系列3'}, 'Location', 'northeast');

% 添加网格
grid on;
box on;
