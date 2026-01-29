%% 频率风玫瑰图
% 使用MATLAB内置polarhistogram函数实现
clear; clc; close all;

%% 1. 随机生成风向数据（角度，单位：弧度）
rng(42);  % 设置随机种子保证可重复
n = 1000;  % 数据点数量

% 模拟风向数据：主要风向为东北和西南
wind_dir_deg = [normrnd(45, 30, n/2, 1); normrnd(225, 40, n/2, 1)];
wind_dir_deg = mod(wind_dir_deg, 360);  % 限制在0-360度
wind_dir_rad = deg2rad(wind_dir_deg);   % 转换为弧度

%% 2. 绘制频率风玫瑰图
figure('Color', 'w', 'Position', [100, 100, 600, 600]);

% 使用polarhistogram直接绘制（最简单的方法）
pax = polaraxes;
h = polarhistogram(wind_dir_rad, 16, 'Normalization', 'probability');

% 美化设置
h.FaceColor = [0.2 0.6 0.8];
h.FaceAlpha = 0.7;
h.EdgeColor = 'w';
h.LineWidth = 1.5;

% 设置极坐标轴
pax.ThetaZeroLocation = 'top';      % 0度在顶部（北）
pax.ThetaDir = 'clockwise';         % 顺时针方向
pax.FontSize = 12;
pax.FontWeight = 'bold';

% 添加方向标签
pax.ThetaTick = 0:45:315;
pax.ThetaTickLabel = {'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'};

% 标题
title('频率风玫瑰图 (Wind Rose)', 'FontSize', 14, 'FontWeight', 'bold');

%% 3. 显示统计信息
fprintf('数据统计:\n');
fprintf('  样本数量: %d\n', n);
fprintf('  主风向: %.1f°\n', rad2deg(circ_mean(wind_dir_rad)));

%% 辅助函数：计算圆形均值
function mu = circ_mean(alpha)
    mu = angle(mean(exp(1i*alpha)));
    if mu < 0
        mu = mu + 2*pi;
    end
end
