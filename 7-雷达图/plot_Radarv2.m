clear; clc; close all;

%% ===================== 多系列雷达图 (使用polarplot) =====================
% 指标名称
labels = {'速度', '力量', '敏捷', '智力', '耐力', '防御'};

% 图例名称
legend_names = {'战士', '法师', '刺客', '坦克'};

% 随机生成数据 (4个系列 x 6个指标, 范围30-100)
rng('shuffle');  % 随机种子
num_series = length(legend_names);
num_dims = length(labels);
data = randi([30, 100], num_series, num_dims);

% 计算角度 (均匀分布在圆周上，首尾闭合)
theta = linspace(0, 2*pi, num_dims + 1);

% 数据闭合 (首尾相连形成封闭多边形)
data_closed = [data, data(:,1)];

% 创建图形
figure('Position', [100, 100, 800, 600], 'Color', 'w');
pax = polaraxes;  % 创建极坐标轴
hold(pax, 'on');

% 定义颜色
colors = lines(num_series);  % 使用MATLAB内置配色

% 绘制每个系列
h = gobjects(num_series, 1);
for i = 1:num_series
    % 绘制填充区域
    polarplot(theta, data_closed(i,:), 'Color', colors(i,:), 'LineWidth', 2);
    
    % 添加填充 (使用patch在极坐标下)
    [x, y] = pol2cart(theta, data_closed(i,:));
    fill(x, y, colors(i,:), 'FaceAlpha', 0.15, 'EdgeColor', 'none', 'Parent', pax);
    
    % 绘制数据点
    h(i) = polarplot(theta, data_closed(i,:), '-o', ...
        'Color', colors(i,:), 'LineWidth', 2, ...
        'MarkerSize', 8, 'MarkerFaceColor', colors(i,:));
end

% 设置极坐标轴属性
pax.ThetaZeroLocation = 'top';           % 0度在顶部
pax.ThetaDir = 'clockwise';              % 顺时针方向
pax.ThetaTick = rad2deg(theta(1:end-1)); % 设置角度刻度
pax.ThetaTickLabel = labels;             % 设置指标标签
pax.RLim = [0, 110];                     % 径向范围
pax.FontSize = 11;
pax.GridAlpha = 0.3;

% 添加图例和标题
legend(h, legend_names, 'Location', 'northeastoutside', 'FontSize', 11);
title('多系列雷达图对比', 'FontSize', 14, 'FontWeight', 'bold');

hold(pax, 'off');

% 保存图像（取消注释即可使用）
% saveas(gcf, '雷达图_示例.png');
% print(gcf, '雷达图_示例_高清', '-dpng', '-r300');
