clear; clc; close all;

%% 1. 生成随机数据和定义分组
rng(42); % 设置随机种子以确保可重复性

% 定义三个阶段的类别和分组
stage1_labels = {'A1', 'A2', 'A3', 'A4', 'A5', 'A6'};
stage2_labels = {'B1', 'B2', 'B3', 'B4'};
stage3_labels = {'C1', 'C2', 'C3', 'C4', 'C5'};

% 定义每个阶段的分组信息
% 每个元素是一个结构体，包含组名和该组包含的节点索引
stage1_groups = struct('name', {'组A', '组B'}, ...
                       'indices', {[1, 2, 3], [4, 5, 6]});

stage2_groups = struct('name', {'组C', '组D'}, ...
                       'indices', {[1, 2], [3, 4]});

stage3_groups = struct('name', {'组E', '组F'}, ...
                       'indices', {[1, 2, 3], [4, 5]});

n1 = length(stage1_labels);
n2 = length(stage2_labels);
n3 = length(stage3_labels);

% 生成流量矩阵 (stage1 -> stage2)
flow12 = randi([10, 100], n1, n2);

% 生成流量矩阵 (stage2 -> stage3)
flow23 = randi([10, 100], n2, n3);

% 调整flow23使其与flow12的列和匹配（保持流量守恒）
for i = 1:n2
    total_in = sum(flow12(:, i));
    total_out = sum(flow23(i, :));
    if total_out > 0
        flow23(i, :) = flow23(i, :) * (total_in / total_out);
    end
end
flow23 = round(flow23);

%% 2. 计算节点位置参数
node_width = 0.06;      % 节点宽度
node_gap = 0.005;       % 节点之间的垂直间隙
group_gap = 0.03;       % 组之间的垂直间隙
inner_gap = 0.003;      % 节点内部流动带之间的间隙
x_positions = [0.12, 0.47, 0.82]; % 三个阶段的x位置

% 计算每个阶段的总流量（包含内部间隙）
stage1_flow_counts = sum(flow12 > 0, 2);
stage2_flow_counts_left = sum(flow12 > 0, 1)';
stage2_flow_counts_right = sum(flow23 > 0, 2);
stage3_flow_counts = sum(flow23 > 0, 1)';

stage1_totals = sum(flow12, 2);
stage2_totals = sum(flow12, 1)';
stage3_totals = sum(flow23, 1)';

% 归一化高度（考虑内部间隙和组间隙）
max_total = max([sum(stage1_totals), sum(stage2_totals), sum(stage3_totals)]);
max_inner_gaps = max([sum(stage1_flow_counts-1), sum(max(stage2_flow_counts_left, stage2_flow_counts_right)-1), sum(stage3_flow_counts-1)]);
n_groups = max([length(stage1_groups), length(stage2_groups), length(stage3_groups)]);
scale_factor = (0.75 - max_inner_gaps * inner_gap / 1 - (n_groups - 1) * group_gap) / max_total;

% 计算分组节点位置
[y1_starts, y1_ends, y1_group_bounds] = calc_grouped_positions(stage1_totals, stage1_flow_counts, stage1_groups, scale_factor, node_gap, group_gap, inner_gap);
[y2_starts, y2_ends, y2_group_bounds] = calc_grouped_positions(stage2_totals, max(stage2_flow_counts_left, stage2_flow_counts_right), stage2_groups, scale_factor, node_gap, group_gap, inner_gap);
[y3_starts, y3_ends, y3_group_bounds] = calc_grouped_positions(stage3_totals, stage3_flow_counts, stage3_groups, scale_factor, node_gap, group_gap, inner_gap);

%% 3. 定义颜色方案（按组分配）
% 为每个组分配基础颜色，组内节点使用该颜色的不同深浅
group_base_colors = [
    0.894 0.102 0.110;   % 红色系
    0.216 0.494 0.722;   % 蓝色系
    0.302 0.686 0.290;   % 绿色系
    0.596 0.306 0.639;   % 紫色系
    1.000 0.498 0.000;   % 橙色系
    0.651 0.337 0.157;   % 棕色系
];

colors1 = generate_group_colors(stage1_groups, group_base_colors);
colors2 = generate_group_colors(stage2_groups, group_base_colors);
colors3 = generate_group_colors(stage3_groups, group_base_colors);

%% 4. 绘制分组冲击图
figure('Position', [100, 100, 1400, 700], 'Color', 'white');
hold on;

% 先绘制组背景框
draw_group_backgrounds(x_positions(1), y1_group_bounds, node_width, stage1_groups, 1);
draw_group_backgrounds(x_positions(2), y2_group_bounds, node_width, stage2_groups, 2);
draw_group_backgrounds(x_positions(3), y3_group_bounds, node_width, stage3_groups, 3);

% 绘制所有流动带（在节点下层）
% 绘制流动带 (Stage 1 -> Stage 2)
y1_current = y1_starts;
y2_current_left = y2_starts;

for i = 1:n1
    for j = 1:n2
        if flow12(i, j) > 0
            flow_height = flow12(i, j) * scale_factor;
            
            draw_band(x_positions(1) + node_width, y1_current(i), ...
                     x_positions(2), y2_current_left(j), flow_height, colors1(i, :), 0.5);
            
            y1_current(i) = y1_current(i) + flow_height + inner_gap;
            y2_current_left(j) = y2_current_left(j) + flow_height + inner_gap;
        end
    end
end

% 绘制流动带 (Stage 2 -> Stage 3)
y2_current_right = y2_starts;
y3_current = y3_starts;

for i = 1:n2
    for j = 1:n3
        if flow23(i, j) > 0
            flow_height = flow23(i, j) * scale_factor;
            
            draw_band(x_positions(2) + node_width, y2_current_right(i), ...
                     x_positions(3), y3_current(j), flow_height, colors2(i, :), 0.5);
            
            y2_current_right(i) = y2_current_right(i) + flow_height + inner_gap;
            y3_current(j) = y3_current(j) + flow_height + inner_gap;
        end
    end
end

% 绘制节点 (Stage 1)
for i = 1:n1
    h = y1_ends(i) - y1_starts(i);
    x = x_positions(1);
    y = y1_starts(i);
    patch([x, x+node_width, x+node_width, x], [y, y, y+h, y+h], ...
          colors1(i,:), 'EdgeColor', [0.3 0.3 0.3], 'LineWidth', 1.5);
    text(x - 0.01, y + h/2, sprintf('%s (%d)', stage1_labels{i}, stage1_totals(i)), ...
         'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', ...
         'FontSize', 9, 'FontWeight', 'bold');
end

% 绘制节点 (Stage 2)
for i = 1:n2
    h = y2_ends(i) - y2_starts(i);
    x = x_positions(2);
    y = y2_starts(i);
    patch([x, x+node_width, x+node_width, x], [y, y, y+h, y+h], ...
          colors2(i,:), 'EdgeColor', [0.3 0.3 0.3], 'LineWidth', 1.5);
    text(x + node_width/2, y + h + 0.01, sprintf('%s (%d)', stage2_labels{i}, stage2_totals(i)), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
         'FontSize', 9, 'FontWeight', 'bold');
end

% 绘制节点 (Stage 3)
for i = 1:n3
    h = y3_ends(i) - y3_starts(i);
    x = x_positions(3);
    y = y3_starts(i);
    patch([x, x+node_width, x+node_width, x], [y, y, y+h, y+h], ...
          colors3(i,:), 'EdgeColor', [0.3 0.3 0.3], 'LineWidth', 1.5);
    text(x + node_width + 0.01, y + h/2, sprintf('%s (%d)', stage3_labels{i}, stage3_totals(i)), ...
         'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
         'FontSize', 9, 'FontWeight', 'bold');
end

% 添加阶段标题
text(x_positions(1) + node_width/2, 0.96, '阶段 1', ...
     'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold');
text(x_positions(2) + node_width/2, 0.96, '阶段 2', ...
     'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold');
text(x_positions(3) + node_width/2, 0.96, '阶段 3', ...
     'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold');

% 设置坐标轴
axis([0 1 0 1]);
axis off;
title('分组冲击图 (Grouped Alluvial Diagram)', 'FontSize', 16, 'FontWeight', 'bold');

hold off;

% 保存图片
% saveas(gcf, '分组冲击图示例.png');
% fprintf('图片已保存为: 分组冲击图示例.png\n');

%% 辅助函数: 计算分组节点位置
function [y_starts, y_ends, group_bounds] = calc_grouped_positions(totals, flow_counts, groups, scale_factor, node_gap, group_gap, inner_gap)
    n = length(totals);
    heights = totals * scale_factor;
    inner_gaps = (flow_counts - 1) * inner_gap;
    inner_gaps(inner_gaps < 0) = 0;
    total_heights = heights + inner_gaps;
    
    % 计算每组的总高度
    n_groups = length(groups);
    group_heights = zeros(n_groups, 1);
    for g = 1:n_groups
        group_indices = groups(g).indices;
        group_heights(g) = sum(total_heights(group_indices)) + (length(group_indices) - 1) * node_gap;
    end
    
    % 计算总高度（包含组间隙）
    total_height = sum(group_heights) + (n_groups - 1) * group_gap;
    y_start = (1 - total_height) / 2;
    
    % 分配节点位置
    y_starts = zeros(n, 1);
    y_ends = zeros(n, 1);
    group_bounds = zeros(n_groups, 2);
    
    current_y = y_start;
    for g = 1:n_groups
        group_indices = groups(g).indices;
        group_bounds(g, 1) = current_y;
        
        for idx = group_indices
            y_starts(idx) = current_y;
            y_ends(idx) = current_y + total_heights(idx);
            current_y = y_ends(idx) + node_gap;
        end
        
        group_bounds(g, 2) = y_ends(group_indices(end));
        current_y = group_bounds(g, 2) + group_gap;
    end
end

%% 辅助函数: 为分组生成颜色
function colors = generate_group_colors(groups, base_colors)
    n_total = sum(arrayfun(@(g) length(g.indices), groups));
    colors = zeros(n_total, 3);
    
    for g = 1:length(groups)
        group_indices = groups(g).indices;
        base_color = base_colors(mod(g-1, size(base_colors, 1)) + 1, :);
        
        % 为组内节点生成颜色梯度
        n_in_group = length(group_indices);
        if n_in_group == 1
            colors(group_indices, :) = base_color;
        else
            % 生成从深到浅的颜色变化
            factors = linspace(0.7, 1.0, n_in_group)';
            for i = 1:n_in_group
                colors(group_indices(i), :) = base_color * factors(i);
                % 确保颜色值不超过1
                colors(group_indices(i), :) = min(colors(group_indices(i), :), 1);
            end
        end
    end
end

%% 辅助函数: 绘制组背景框
function draw_group_backgrounds(x, group_bounds, node_width, groups, stage_idx)
    n_groups = size(group_bounds, 1);
    
    % 背景颜色（浅灰色，半透明）
    bg_colors = [
        0.95 0.95 0.95;
        0.90 0.95 1.00;
        0.95 1.00 0.90;
        1.00 0.95 0.90;
    ];
    
    for g = 1:n_groups
        y_min = group_bounds(g, 1) - 0.008;
        y_max = group_bounds(g, 2) + 0.008;
        
        % 绘制背景矩形
        bg_color = bg_colors(mod(g-1, size(bg_colors, 1)) + 1, :);
        patch([x-0.01, x+node_width+0.01, x+node_width+0.01, x-0.01], ...
              [y_min, y_min, y_max, y_max], ...
              bg_color, 'EdgeColor', [0.7 0.7 0.7], 'LineWidth', 1, ...
              'FaceAlpha', 0.3, 'EdgeAlpha', 0.5);
        
        % 添加组标签
        group_name = groups(g).name;
        y_mid = (y_min + y_max) / 2;
        
        if stage_idx == 1
            % 左侧阶段：标签在左侧
            text(x - 0.03, y_mid, group_name, ...
                 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', ...
                 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.4 0.4 0.4], ...
                 'BackgroundColor', [1 1 1 0.7], 'EdgeColor', [0.6 0.6 0.6], ...
                 'LineWidth', 0.5, 'Margin', 3);
        elseif stage_idx == 3
            % 右侧阶段：标签在右侧
            text(x + node_width + 0.03, y_mid, group_name, ...
                 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
                 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.4 0.4 0.4], ...
                 'BackgroundColor', [1 1 1 0.7], 'EdgeColor', [0.6 0.6 0.6], ...
                 'LineWidth', 0.5, 'Margin', 3);
        else
            % 中间阶段：标签在下方
            text(x + node_width/2, y_min - 0.015, group_name, ...
                 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', ...
                 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.4 0.4 0.4], ...
                 'BackgroundColor', [1 1 1 0.7], 'EdgeColor', [0.6 0.6 0.6], ...
                 'LineWidth', 0.5, 'Margin', 3);
        end
    end
end

%% 辅助函数: 绘制流动带
function draw_band(x1, y1, x2, y2, h, color, alpha)
    % 使用sigmoid曲线绘制平滑的流动带
    n_pts = 50;
    t = linspace(0, 1, n_pts);
    
    % 使用sigmoid函数生成平滑过渡
    s = 1 ./ (1 + exp(-10*(t - 0.5)));
    
    % x坐标线性插值
    x_curve = x1 + (x2 - x1) * t;
    
    % y坐标使用sigmoid插值
    y_bottom = y1 + (y2 - y1) * s;
    y_top = (y1 + h) + ((y2 + h) - (y1 + h)) * s;
    
    % 创建封闭多边形
    x_poly = [x_curve, fliplr(x_curve)];
    y_poly = [y_bottom, fliplr(y_top)];
    
    % 绘制
    fill(x_poly, y_poly, color, 'FaceAlpha', alpha, 'EdgeColor', 'none');
end
