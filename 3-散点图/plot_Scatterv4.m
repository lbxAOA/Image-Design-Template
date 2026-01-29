%% 散点矩阵图 (Scatter Matrix Plot)
% 使用 MATLAB 内置 plotmatrix 函数
clc; clear; close all;

%% 生成随机数据
rng(42);  % 设置随机种子，保证可重复性
n = 100;  % 数据点数量

% 生成4个变量的随机数据
data = randn(n, 4);
varNames = {'X1', 'X2', 'X3', 'X4'};

%% 绘制散点矩阵图
figure('Position', [100, 100, 800, 800]);
[S, AX, BigAx, H, HAx] = plotmatrix(data);

% 设置对角线直方图颜色
set(H, 'FaceColor', [0.3, 0.6, 0.9], 'EdgeColor', 'w');

% 设置散点颜色
for i = 1:numel(S)
    if isgraphics(S(i), 'line')
        set(S(i), 'Color', [0.2, 0.5, 0.8], 'MarkerSize', 4);
    end
end

% 添加变量名称标签
for i = 1:length(varNames)
    ylabel(AX(i, 1), varNames{i}, 'FontSize', 12, 'FontWeight', 'bold');
    xlabel(AX(end, i), varNames{i}, 'FontSize', 12, 'FontWeight', 'bold');
end

% 设置标题
title(BigAx, '散点矩阵图 (Scatter Matrix Plot)', 'FontSize', 14, 'FontWeight', 'bold');

%% 调整图形外观
set(gcf, 'Color', 'w');
