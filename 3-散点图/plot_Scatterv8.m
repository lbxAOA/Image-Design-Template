%% 散点图 + 回归分析
% 清空环境
clear; clc; close all;

%% 1. 随机生成数据
rng(42);  % 固定随机种子，便于复现
n = 50;   % 样本数量
x = linspace(1, 10, n)' + randn(n, 1) * 0.5;  % 自变量
y = 2.5 * x + 3 + randn(n, 1) * 3;            % 因变量（带噪声的线性关系）

%% 2. 线性回归（使用 fitlm 函数）
mdl = fitlm(x, y);  % 拟合线性模型

% 提取回归参数
b0 = mdl.Coefficients.Estimate(1);  % 截距
b1 = mdl.Coefficients.Estimate(2);  % 斜率
R2 = mdl.Rsquared.Ordinary;         % R²
pValue = mdl.Coefficients.pValue(2); % 斜率的p值

%% 3. 绘制散点图 + 回归线
figure('Position', [100, 100, 800, 600]);

% 绘制散点
scatter(x, y, 60, 'filled', 'MarkerFaceColor', [0.2 0.4 0.8], ...
    'MarkerFaceAlpha', 0.7, 'MarkerEdgeColor', 'k');
hold on;

% 绘制回归线（使用 plot 函数直接画拟合线）
x_fit = linspace(min(x), max(x), 100);
y_fit = b1 * x_fit + b0;
plot(x_fit, y_fit, 'r-', 'LineWidth', 2);

% 绘制95%置信区间
[y_pred, ci] = predict(mdl, x_fit');
fill([x_fit, fliplr(x_fit)], [ci(:,1)', fliplr(ci(:,2)')], ...
    'r', 'FaceAlpha', 0.15, 'EdgeColor', 'none');

hold off;

%% 4. 图形美化
xlabel('X', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Y', 'FontSize', 14, 'FontWeight', 'bold');
title('散点图与线性回归分析', 'FontSize', 16, 'FontWeight', 'bold');

% 添加回归方程和统计信息
eq_str = sprintf('y = %.2fx + %.2f', b1, b0);
stat_str = sprintf('R² = %.4f, p = %.2e', R2, pValue);
legend({'数据点', '回归线', '95%置信区间'}, 'Location', 'northwest', 'FontSize', 11);
text(0.65, 0.15, {eq_str, stat_str}, 'Units', 'normalized', ...
    'FontSize', 12, 'BackgroundColor', 'w', 'EdgeColor', 'k');

grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.2);

%% 5. 输出回归结果
disp('=== 回归分析结果 ===');
disp(mdl);
