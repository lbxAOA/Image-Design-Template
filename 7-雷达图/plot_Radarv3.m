%% 填充雷达图 - 使用 polarplot + fill
clear; clc; close all;

%% 随机生成数据
numVars = 6;                          % 维度数量
numGroups = 3;                        % 组数
data = randi([40, 100], numGroups, numVars);  % 随机数据 [40,100]
labels = {'指标A', '指标B', '指标C', '指标D', '指标E', '指标F'};
groupNames = {'组1', '组2', '组3'};

%% 计算角度
theta = linspace(0, 2*pi, numVars+1);  % 闭合需要 numVars+1 个点

%% 绑定首尾数据（闭合多边形）
dataPlot = [data, data(:,1)];

%% 绘制填充雷达图
figure('Color', 'w', 'Position', [100, 100, 600, 500]);
pax = polaraxes;
hold(pax, 'on');

colors = lines(numGroups);  % 使用内置配色

for i = 1:numGroups
    % 绘制填充区域
    polarplot(pax, theta, dataPlot(i,:), '-o', 'LineWidth', 2, 'Color', colors(i,:));
    % 使用 fill 填充（需转换为笛卡尔坐标）
    [x, y] = pol2cart(theta, dataPlot(i,:));
    fill(pax, x, y, colors(i,:), 'FaceAlpha', 0.2, 'EdgeColor', 'none');
end

%% 设置极坐标轴
pax.ThetaZeroLocation = 'top';        % 0度在顶部
pax.ThetaDir = 'clockwise';           % 顺时针方向
pax.ThetaTick = rad2deg(theta(1:end-1));
pax.ThetaTickLabel = labels;
pax.RLim = [0, 110];
pax.FontSize = 11;
pax.FontName = 'Microsoft YaHei';

%% 添加图例和标题
legend(groupNames, 'Location', 'southoutside', 'Orientation', 'horizontal');
title('填充雷达图示例', 'FontSize', 14, 'FontWeight', 'bold');

hold(pax, 'off');
