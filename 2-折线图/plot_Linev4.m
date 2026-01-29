%% 堆叠面积图 - Stacked Area Chart
% 使用MATLAB内置area()函数实现
% 数据随机生成

clear; clc; close all;

%% 生成随机数据
x = 1:10;                          % X轴数据
Y = randi([5, 20], 10, 4);         % 随机生成10行4列的数据（4个类别）

%% 绘制堆叠面积图
figure('Position', [100, 100, 800, 500]);
h = area(x, Y);

%% 设置颜色
colors = [0.2 0.6 0.8;    % 蓝色
          0.9 0.4 0.3;    % 红色
          0.4 0.8 0.4;    % 绿色
          0.9 0.7 0.2];   % 黄色
for i = 1:length(h)
    h(i).FaceColor = colors(i, :);
    h(i).FaceAlpha = 0.7;         % 设置透明度
    h(i).EdgeColor = 'w';         % 白色边框
    h(i).LineWidth = 1.5;
end

%% 图表美化
xlabel('时间', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('数值', 'FontSize', 12, 'FontWeight', 'bold');
title('堆叠面积图示例', 'FontSize', 14, 'FontWeight', 'bold');
legend({'类别A', '类别B', '类别C', '类别D'}, 'Location', 'northwest');
grid on;
set(gca, 'FontSize', 11);

%% 保存图片（可选）
% saveas(gcf, 'stacked_area_chart.png');
