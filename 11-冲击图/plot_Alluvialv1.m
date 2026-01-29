clear; clc; close all;

%% 1. 生成随机数据
rng(42); % 设置随机种子以确保可重复性

% 定义三个阶段的类别
stage1_labels = {'A1', 'A2', 'A3', 'A4'};
stage2_labels = {'B1', 'B2', 'B3'};
stage3_labels = {'C1', 'C2', 'C3', 'C4'};

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
    flow23(i, :) = flow23(i, :) * (total_in / total_out);
end
flow23 = round(flow23);

%% 2. 计算节点位置参数
node_width = 0.06;      % 节点宽度
node_gap = 0.000;       % 节点之间的垂直间隙
inner_gap = 0.003;      % 节点内部流动带之间的间隙
x_positions = [0.12, 0.47, 0.82]; % 三个阶段的x位置

% 计算每个阶段的总流量（包含内部间隙）
stage1_flow_counts = sum(flow12 > 0, 2);  % 每个Stage1节点的非零流出数
stage2_flow_counts_left = sum(flow12 > 0, 1)';  % 每个Stage2节点的非零流入数
stage2_flow_counts_right = sum(flow23 > 0, 2);  % 每个Stage2节点的非零流出数
stage3_flow_counts = sum(flow23 > 0, 1)';  % 每个Stage3节点的非零流入数

stage1_totals = sum(flow12, 2);
stage2_totals = sum(flow12, 1)';
stage3_totals = sum(flow23, 1)';  % 按列求和得到Stage3的流入量

% 归一化高度（考虑内部间隙）
max_total = max([sum(stage1_totals), sum(stage2_totals), sum(stage3_totals)]);
max_inner_gaps = max([sum(stage1_flow_counts-1), sum(max(stage2_flow_counts_left, stage2_flow_counts_right)-1), sum(stage3_flow_counts-1)]);
scale_factor = (0.75 - max_inner_gaps * inner_gap / 1) / max_total;

% 计算节点位置（考虑内部间隙）
[y1_starts, y1_ends] = calc_positions_with_inner_gap(stage1_totals, stage1_flow_counts, scale_factor, node_gap, inner_gap);
[y2_starts, y2_ends] = calc_positions_with_inner_gap(stage2_totals, max(stage2_flow_counts_left, stage2_flow_counts_right), scale_factor, node_gap, inner_gap);
[y3_starts, y3_ends] = calc_positions_with_inner_gap(stage3_totals, stage3_flow_counts, scale_factor, node_gap, inner_gap);

%% 3. 定义颜色方案
colors1 = [0.894 0.102 0.110;   % 红色
           0.216 0.494 0.722;   % 蓝色
           0.302 0.686 0.290;   % 绿色
           0.596 0.306 0.639];  % 紫色

colors2 = [1.000 0.498 0.000;   % 橙色
           0.651 0.337 0.157;   % 棕色
           0.968 0.506 0.749];  % 粉色

colors3 = [0.400 0.761 0.647;   % 青色
           0.988 0.553 0.384;   % 珊瑚色
           0.553 0.627 0.796;   % 淡蓝色
           0.906 0.541 0.765];  % 淡紫色

%% 4. 绘制冲击图
figure('Position', [100, 100, 1200, 600], 'Color', 'white');
hold on;

% 先绘制所有流动带（在节点下层）
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
         'FontSize', 10, 'FontWeight', 'bold');
end

% 绘制节点 (Stage 2)
for i = 1:n2
    h = y2_ends(i) - y2_starts(i);
    x = x_positions(2);
    y = y2_starts(i);
    patch([x, x+node_width, x+node_width, x], [y, y, y+h, y+h], ...
          colors2(i,:), 'EdgeColor', [0.3 0.3 0.3], 'LineWidth', 1.5);
    text(x + node_width/2, y + h + 0.02, sprintf('%s (%d)', stage2_labels{i}, stage2_totals(i)), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
         'FontSize', 10, 'FontWeight', 'bold');
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
         'FontSize', 10, 'FontWeight', 'bold');
end

% 添加阶段标题
text(x_positions(1) + node_width/2, 0.95, '阶段 1', ...
     'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold');
text(x_positions(2) + node_width/2, 0.95, '阶段 2', ...
     'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold');
text(x_positions(3) + node_width/2, 0.95, '阶段 3', ...
     'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold');

% 设置坐标轴
axis([0 1 0 1]);
axis off;
title('冲击图 (Alluvial Diagram)', 'FontSize', 16, 'FontWeight', 'bold');

hold off;

% 保存图片
% saveas(gcf, '冲击图示例.png');
% fprintf('图片已保存为: 冲击图示例.png\n');

%% 辅助函数: 计算节点位置（包含内部间隙）
function [y_starts, y_ends] = calc_positions_with_inner_gap(totals, flow_counts, scale_factor, gap, inner_gap)
    n = length(totals);
    heights = totals * scale_factor;
    inner_gaps = (flow_counts - 1) * inner_gap;  % 每个节点内部的总间隙
    inner_gaps(inner_gaps < 0) = 0;
    total_heights = heights + inner_gaps;  % 每个节点的总高度（包含内部间隙）
    total_height = sum(total_heights) + (n-1) * gap;
    y_start = (1 - total_height) / 2;
    
    y_starts = zeros(n, 1);
    y_ends = zeros(n, 1);
    current_y = y_start;
    
    for i = 1:n
        y_starts(i) = current_y;
        y_ends(i) = current_y + total_heights(i);
        current_y = y_ends(i) + gap;
    end
end

%% 辅助函数: 计算节点位置（原始版本，保留兼容性）
function [y_starts, y_ends] = calc_positions(totals, scale_factor, gap)
    n = length(totals);
    heights = totals * scale_factor;
    total_height = sum(heights) + (n-1) * gap;
    y_start = (1 - total_height) / 2;
    
    y_starts = zeros(n, 1);
    y_ends = zeros(n, 1);
    current_y = y_start;
    
    for i = 1:n
        y_starts(i) = current_y;
        y_ends(i) = current_y + heights(i);
        current_y = y_ends(i) + gap;
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
