%% 能量风玫瑰图 (Energy Wind Rose)
% 能量风玫瑰图展示风能密度在不同方向上的分布
% 风能与风速的三次方成正比: E ∝ v³

clear; clc; close all;

%% 1. 随机生成风速和风向数据
rng(42);  % 设置随机种子，保证可重复性
n_samples = 5000;  % 样本数量

% 生成风向数据 (0-360度)，主导风向设为西北方向(315°)
wind_direction = mod(315 + 60*randn(n_samples, 1), 360);

% 生成风速数据 (Weibull分布更接近真实风速分布)
shape_param = 2;    % 形状参数
scale_param = 8;    % 尺度参数 (平均风速约7m/s)
wind_speed = wblrnd(scale_param, shape_param, n_samples, 1);

%% 2. 定义方向区间
n_dirs = 16;  % 16个方向区间
dir_edges = linspace(0, 360, n_dirs + 1);
dir_centers = (dir_edges(1:end-1) + dir_edges(2:end)) / 2;

%% 3. 定义风速区间
speed_bins = [0 3 6 9 12 15 inf];  % 风速区间边界
n_speed_bins = length(speed_bins) - 1;

% 风速区间标签
speed_labels = {'0-3 m/s', '3-6 m/s', '6-9 m/s', '9-12 m/s', '12-15 m/s', '>15 m/s'};

%% 4. 计算每个方向和风速区间的能量贡献
% 风能密度 E = 0.5 * ρ * v³ (简化为 v³)
energy = wind_speed.^3;

% 统计各方向各风速区间的能量
energy_matrix = zeros(n_dirs, n_speed_bins);

for i = 1:n_dirs
    % 找出该方向区间内的数据
    if i == n_dirs
        dir_mask = (wind_direction >= dir_edges(i)) | (wind_direction < dir_edges(1));
    else
        dir_mask = (wind_direction >= dir_edges(i)) & (wind_direction < dir_edges(i+1));
    end
    
    for j = 1:n_speed_bins
        % 找出该风速区间内的数据
        speed_mask = (wind_speed >= speed_bins(j)) & (wind_speed < speed_bins(j+1));
        
        % 计算能量贡献占总能量的百分比
        energy_matrix(i, j) = sum(energy(dir_mask & speed_mask)) / sum(energy) * 100;
    end
end

%% 5. 绘制能量风玫瑰图
figure('Position', [100, 100, 800, 700], 'Color', 'w');

% 使用 polaraxes 创建极坐标轴
pax = polaraxes;
hold(pax, 'on');

% 颜色方案
colors = [
    0.2 0.4 0.8;    % 蓝色 - 低风速
    0.2 0.7 0.9;    % 青色
    0.3 0.8 0.4;    % 绿色
    1.0 0.8 0.2;    % 黄色
    1.0 0.5 0.2;    % 橙色
    0.9 0.2 0.2     % 红色 - 高风速
];

% 角度转换 (将方位角转为数学角度，北为上)
theta_rad = deg2rad(90 - dir_centers);
bar_width = deg2rad(360 / n_dirs) * 0.9;

% 堆叠绘制每个风速区间
for i = 1:n_dirs
    cumulative = 0;
    for j = 1:n_speed_bins
        if energy_matrix(i, j) > 0
            % 绘制极坐标柱状图
            polarhistogram(pax, 'BinEdges', [theta_rad(i) - bar_width/2, theta_rad(i) + bar_width/2], ...
                'BinCounts', energy_matrix(i, j) + cumulative, ...
                'FaceColor', colors(j, :), 'EdgeColor', 'w', 'FaceAlpha', 0.9);
        end
        cumulative = cumulative + energy_matrix(i, j);
    end
end

% 重新绘制（从内到外，实现堆叠效果）
cla(pax);
for j = n_speed_bins:-1:1
    for i = 1:n_dirs
        cumulative = sum(energy_matrix(i, 1:j));
        if cumulative > 0
            theta_patch = [theta_rad(i) - bar_width/2, theta_rad(i) + bar_width/2, ...
                          theta_rad(i) + bar_width/2, theta_rad(i) - bar_width/2];
            rho_patch = [0, 0, cumulative, cumulative];
            [x, y] = pol2cart(theta_patch, rho_patch);
            patch(pax, x, y, colors(j, :), 'EdgeColor', 'w', 'LineWidth', 0.5, 'FaceAlpha', 0.9);
        end
    end
end

% 设置极坐标属性
pax.ThetaZeroLocation = 'top';     % 北在上方
pax.ThetaDir = 'clockwise';        % 顺时针方向
pax.ThetaTick = 0:45:315;
pax.ThetaTickLabel = {'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'};
pax.RAxisLocation = 67.5;
pax.FontSize = 11;
pax.GridAlpha = 0.3;

% 添加标题
title('能量风玫瑰图 (Energy Wind Rose)', 'FontSize', 14, 'FontWeight', 'bold');

% 添加图例
legend_handles = gobjects(n_speed_bins, 1);
for j = 1:n_speed_bins
    legend_handles(j) = patch(nan, nan, colors(j, :), 'EdgeColor', 'w');
end
legend(legend_handles, speed_labels, 'Location', 'southoutside', ...
    'Orientation', 'horizontal', 'FontSize', 10);

% 添加注释
annotation('textbox', [0.02, 0.02, 0.3, 0.05], 'String', ...
    sprintf('样本数: %d | 平均风速: %.1f m/s', n_samples, mean(wind_speed)), ...
    'EdgeColor', 'none', 'FontSize', 9, 'Color', [0.5 0.5 0.5]);

hold(pax, 'off');

%% 6. 输出统计信息
fprintf('=== 能量风玫瑰图统计 ===\n');
fprintf('总样本数: %d\n', n_samples);
fprintf('平均风速: %.2f m/s\n', mean(wind_speed));
fprintf('最大风速: %.2f m/s\n', max(wind_speed));
fprintf('主导风向能量占比: %.1f%%\n', max(sum(energy_matrix, 2)));

% 找出能量贡献最大的方向
[~, max_dir_idx] = max(sum(energy_matrix, 2));
dir_names = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', ...
             'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'};
fprintf('主导风向: %s (%.1f°)\n', dir_names{max_dir_idx}, dir_centers(max_dir_idx));
