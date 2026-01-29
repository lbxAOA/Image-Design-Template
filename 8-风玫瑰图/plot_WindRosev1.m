clear; clc; close all;

%% ===================== 示例调用 =====================
% 风向分区数量 (通常为8、12或16)
num_directions = 16;

% 风速分级 (m/s)
speed_bins = [0, 2, 4, 6, 8, 10, Inf];
speed_labels = {'0-2', '2-4', '4-6', '6-8', '8-10', '>10'};

% 随机生成风向数据 (0-360度)
rng(42);
num_samples = 5000;
wind_direction = mod(randn(num_samples, 1) * 60 + 225, 360);  % 主导风向约225度(西南风)

% 随机生成风速数据 (Weibull分布更符合实际)
wind_speed = wblrnd(5, 2, num_samples, 1);  % Weibull分布, 尺度参数5, 形状参数2

% 颜色方案 (从浅到深)
colors = [
    0.7, 0.85, 1.0;   % 浅蓝
    0.4, 0.7, 0.9;    % 蓝色
    0.2, 0.5, 0.8;    % 深蓝
    1.0, 0.8, 0.4;    % 浅橙
    1.0, 0.5, 0.2;    % 橙色
    0.9, 0.2, 0.2;    % 红色
];

% 调用绘图函数
draw_wind_rose(wind_direction, wind_speed, num_directions, speed_bins, speed_labels, colors, '风玫瑰图 - 风向风速分布');

% 保存图像（取消注释即可使用）
% saveas(gcf, '风玫瑰图_示例.png');
% print(gcf, '风玫瑰图_示例_高清', '-dpng', '-r300');
% print(gcf, '风玫瑰图_示例', '-dpdf', '-bestfit');

%% ===================== 风玫瑰图绘制函数 =====================
function draw_wind_rose(direction, speed, num_dirs, speed_bins, speed_labels, colors, title_str)
    % draw_wind_rose - 绘制标准风玫瑰图
    %
    % 输入:
    %   direction    - 风向数据 (度, 0-360, 北为0度顺时针)
    %   speed        - 风速数据 (m/s)
    %   num_dirs     - 风向分区数量 (8, 12, 16等)
    %   speed_bins   - 风速分级边界
    %   speed_labels - 风速分级标签
    %   colors       - 颜色矩阵 (num_speed_bins x 3, RGB)
    %   title_str    - 图表标题
    
    num_speed_bins = length(speed_bins) - 1;
    dir_edges = linspace(0, 360, num_dirs + 1);
    dir_width = 360 / num_dirs;
    
    % 统计各风向和风速的频率
    freq_matrix = zeros(num_dirs, num_speed_bins);
    total_count = length(direction);
    
    for i = 1:num_dirs
        if i == 1
            % 第一个扇区包含接近360度的数据
            dir_mask = (direction >= dir_edges(i) & direction < dir_edges(i+1)) | ...
                       (direction >= 360 - dir_width/2);
        else
            dir_mask = direction >= dir_edges(i) & direction < dir_edges(i+1);
        end
        
        for j = 1:num_speed_bins
            speed_mask = speed >= speed_bins(j) & speed < speed_bins(j+1);
            freq_matrix(i, j) = sum(dir_mask & speed_mask) / total_count * 100;
        end
    end
    
    % 创建图形
    figure('Position', [100, 100, 900, 800], 'Color', 'w');
    ax = polaraxes;
    hold(ax, 'on');
    
    % 设置极坐标参数
    ax.ThetaZeroLocation = 'top';      % 北向为0度
    ax.ThetaDir = 'clockwise';         % 顺时针方向
    ax.FontSize = 10;
    ax.GridColor = [0.6, 0.6, 0.6];
    ax.GridAlpha = 0.5;
    
    % 计算每个扇区的角度 (转换为弧度)
    theta_centers = deg2rad(dir_edges(1:end-1) + dir_width/2);
    theta_width = deg2rad(dir_width * 0.9);  % 扇区宽度略小于实际，留出间隙
    
    % 绘制堆叠扇形
    h_bars = gobjects(num_speed_bins, 1);
    for i = 1:num_dirs
        cumulative_r = 0;
        for j = 1:num_speed_bins
            if freq_matrix(i, j) > 0
                % 绘制扇形
                r_inner = cumulative_r;
                r_outer = cumulative_r + freq_matrix(i, j);
                
                theta_start = theta_centers(i) - theta_width/2;
                theta_end = theta_centers(i) + theta_width/2;
                theta_arc = linspace(theta_start, theta_end, 30);
                
                % 构建扇形路径
                theta_patch = [theta_arc, fliplr(theta_arc)];
                r_patch = [r_outer * ones(1, 30), r_inner * ones(1, 30)];
                
                h = polarplot(ax, theta_patch, r_patch, 'LineWidth', 0.5);
                
                % 填充扇形
                [x, y] = pol2cart(theta_patch, r_patch);
                h_fill = fill(ax, x, y, colors(j, :), 'EdgeColor', [0.3, 0.3, 0.3], ...
                    'EdgeAlpha', 0.5, 'LineWidth', 0.5);
                
                if i == 1
                    h_bars(j) = h_fill;
                end
                
                cumulative_r = r_outer;
            end
        end
    end
    
    % 设置径向轴范围
    max_freq = max(sum(freq_matrix, 2));
    r_max = ceil(max_freq / 5) * 5;  % 向上取整到5的倍数
    ax.RLim = [0, r_max];
    ax.RTick = 0:5:r_max;
    ax.RTickLabel = arrayfun(@(x) sprintf('%d%%', x), ax.RTick, 'UniformOutput', false);
    
    % 设置方位标签
    direction_labels = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', ...
                        'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'};
    if num_dirs == 16
        ax.ThetaTick = 0:22.5:337.5;
        ax.ThetaTickLabel = direction_labels;
    elseif num_dirs == 8
        ax.ThetaTick = 0:45:315;
        ax.ThetaTickLabel = direction_labels(1:2:end);
    elseif num_dirs == 12
        ax.ThetaTick = 0:30:330;
        ax.ThetaTickLabel = {'N', '30°', 'E-30°', 'E', 'E+30°', '150°', ...
                             'S', '210°', 'W+30°', 'W', 'W-30°', '330°'};
    end
    
    % 添加图例
    legend(h_bars(h_bars ~= 0), speed_labels(1:sum(h_bars ~= 0)), ...
        'Location', 'northeastoutside', ...
        'FontSize', 11, 'Box', 'off', ...
        'Title', '风速 (m/s)');
    
    % 添加标题
    title(ax, title_str, 'FontSize', 16, 'FontWeight', 'bold');
    
    hold(ax, 'off');
    
    % 打印统计信息
    fprintf('\n========== 风向风速统计 ==========\n');
    fprintf('总样本数: %d\n', length(direction));
    fprintf('平均风速: %.2f m/s\n', mean(speed));
    fprintf('最大风速: %.2f m/s\n', max(speed));
    fprintf('主导风向: %s (%.1f%%)\n', ...
        get_direction_name(dir_edges(find(sum(freq_matrix, 2) == max(sum(freq_matrix, 2)), 1)) + dir_width/2, num_dirs), ...
        max(sum(freq_matrix, 2)));
    fprintf('===================================\n');
end

%% ===================== 辅助函数：获取风向名称 =====================
function name = get_direction_name(angle, num_dirs)
    % 获取风向名称
    direction_labels_16 = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', ...
                           'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'};
    direction_labels_8 = {'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'};
    
    if num_dirs == 16
        idx = round(mod(angle, 360) / 22.5) + 1;
        if idx > 16, idx = 1; end
        name = direction_labels_16{idx};
    elseif num_dirs == 8
        idx = round(mod(angle, 360) / 45) + 1;
        if idx > 8, idx = 1; end
        name = direction_labels_8{idx};
    else
        name = sprintf('%.1f°', angle);
    end
end
