%% 平均风速风玫瑰图
% 使用MATLAB内置polarplot函数实现
clear; clc; close all;

%% 随机生成数据
rng(42);  % 固定随机种子，便于复现
nDirections = 16;  % 16个风向

% 风向角度 (0-360度，北为0度，顺时针)
directions = linspace(0, 360 - 360/nDirections, nDirections);
theta = deg2rad(directions);  % 转换为弧度

% 随机生成每个风向的平均风速 (m/s)
avgWindSpeed = 3 + 4*rand(1, nDirections);  % 3-7 m/s范围

% 闭合数据（首尾相连）
theta_closed = [theta, theta(1)];
speed_closed = [avgWindSpeed, avgWindSpeed(1)];

%% 绘制风玫瑰图
figure('Color', 'white', 'Position', [100, 100, 600, 600]);

% 使用polarplot绑定填充
polarplot(theta_closed, speed_closed, '-o', ...
    'LineWidth', 2, ...
    'Color', [0.2, 0.4, 0.8], ...
    'MarkerFaceColor', [0.2, 0.4, 0.8], ...
    'MarkerSize', 8);

hold on;

% 填充区域
polarhistogram('BinEdges', [theta, theta(1)+2*pi], ...
    'BinCounts', avgWindSpeed, ...
    'FaceColor', [0.3, 0.6, 0.9], ...
    'FaceAlpha', 0.5, ...
    'EdgeColor', [0.1, 0.3, 0.7], ...
    'LineWidth', 1.5);

%% 设置极坐标轴
ax = gca;
ax.ThetaZeroLocation = 'top';      % 北方向在顶部
ax.ThetaDir = 'clockwise';          % 顺时针方向
ax.RLim = [0, max(avgWindSpeed)*1.2];  % 径向范围
ax.ThetaTick = 0:22.5:337.5;        % 每22.5度一个刻度
ax.ThetaTickLabel = {'N','','NE','','E','','SE','','S','','SW','','W','','NW',''};
ax.RAxis.Label.String = '风速 (m/s)';
ax.FontSize = 11;
ax.FontName = 'Microsoft YaHei';

%% 添加标题
title('平均风速风玫瑰图', 'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Microsoft YaHei');

%% 添加图例
legend('平均风速曲线', '风速分布', 'Location', 'southoutside', 'Orientation', 'horizontal');

%% 显示数据统计信息
fprintf('=== 风速统计 ===\n');
fprintf('最大平均风速: %.2f m/s (方向: %s)\n', max(avgWindSpeed), getDirection(directions(avgWindSpeed == max(avgWindSpeed))));
fprintf('最小平均风速: %.2f m/s (方向: %s)\n', min(avgWindSpeed), getDirection(directions(avgWindSpeed == min(avgWindSpeed))));
fprintf('总体平均风速: %.2f m/s\n', mean(avgWindSpeed));

%% 辅助函数：角度转风向
function dirStr = getDirection(angle)
    dirs = {'N','NNE','NE','ENE','E','ESE','SE','SSE','S','SSW','SW','WSW','W','WNW','NW','NNW'};
    idx = round(mod(angle, 360) / 22.5) + 1;
    idx(idx > 16) = idx(idx > 16) - 16;
    dirStr = dirs{idx(1)};
end
