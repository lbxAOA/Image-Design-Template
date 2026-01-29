clear; clc; close all;

%% 1. 配置阶段数量和生成随机数据
rng(42); % 设置随机种子以确保可重复性

% 定义阶段数量和每个阶段的类别
num_stages = 5; % 可以修改为任意数量的阶段

% 定义每个阶段的类别标签
stage_labels = {
    {'A1', 'A2', 'A3', 'A4'};           % 阶段1
    {'B1', 'B2', 'B3'};                  % 阶段2
    {'C1', 'C2', 'C3', 'C4'};           % 阶段3
    {'D1', 'D2', 'D3'};                  % 阶段4
    {'E1', 'E2', 'E3', 'E4', 'E5'}      % 阶段5
};

% 验证阶段数量
if length(stage_labels) ~= num_stages
    error('stage_labels的长度必须等于num_stages');
end

% 获取每个阶段的类别数量
stage_sizes = cellfun(@length, stage_labels);

% 生成流量矩阵（每两个相邻阶段之间）
flows = cell(num_stages - 1, 1);
for i = 1:(num_stages - 1)
    flows{i} = randi([10, 100], stage_sizes(i), stage_sizes(i+1));
end

% 调整流量矩阵以保持流量守恒
for i = 2:(num_stages - 1)
    % 确保阶段i的流入等于流出
    flow_in = flows{i-1};  % 前一个阶段到当前阶段的流量
    flow_out = flows{i};   % 当前阶段到下一个阶段的流量
    
    for j = 1:stage_sizes(i)
        total_in = sum(flow_in(:, j));
        total_out = sum(flow_out(j, :));
        if total_out > 0
            flows{i}(j, :) = flows{i}(j, :) * (total_in / total_out);
        end
    end
    flows{i} = round(flows{i});
end

%% 2. 计算节点位置参数
node_width = 0.06;      % 节点宽度
node_gap = 0.000;       % 节点之间的垂直间隙
inner_gap = 0.003;      % 节点内部流动带之间的间隙

% 计算x位置（平均分布）
margin = 0.12;
available_width = 1 - 2 * margin;
x_spacing = available_width / (num_stages - 1);
x_positions = margin + (0:(num_stages-1)) * x_spacing;

% 计算每个阶段的总流量和流动数量
stage_totals = cell(num_stages, 1);
stage_flow_counts_left = cell(num_stages, 1);
stage_flow_counts_right = cell(num_stages, 1);

% 第一个阶段（只有流出）
stage_totals{1} = sum(flows{1}, 2);
stage_flow_counts_left{1} = zeros(stage_sizes(1), 1);
stage_flow_counts_right{1} = sum(flows{1} > 0, 2);

% 中间阶段（有流入和流出）
for i = 2:(num_stages - 1)
    stage_totals{i} = sum(flows{i-1}, 1)';
    stage_flow_counts_left{i} = sum(flows{i-1} > 0, 1)';
    stage_flow_counts_right{i} = sum(flows{i} > 0, 2);
end

% 最后一个阶段（只有流入）
stage_totals{num_stages} = sum(flows{end}, 1)';
stage_flow_counts_left{num_stages} = sum(flows{end} > 0, 1)';
stage_flow_counts_right{num_stages} = zeros(stage_sizes(num_stages), 1);

% 计算最大流动数（用于内部间隙）
stage_flow_counts = cell(num_stages, 1);
stage_flow_counts{1} = stage_flow_counts_right{1};
for i = 2:(num_stages - 1)
    stage_flow_counts{i} = max(stage_flow_counts_left{i}, stage_flow_counts_right{i});
end
stage_flow_counts{num_stages} = stage_flow_counts_left{num_stages};

% 归一化高度（考虑内部间隙）
max_total = 0;
max_inner_gaps = 0;
for i = 1:num_stages
    max_total = max(max_total, sum(stage_totals{i}));
    max_inner_gaps = max(max_inner_gaps, sum(stage_flow_counts{i} - 1));
end
scale_factor = (0.75 - max_inner_gaps * inner_gap / 1) / max_total;

% 计算节点位置（考虑内部间隙）
y_starts = cell(num_stages, 1);
y_ends = cell(num_stages, 1);
for i = 1:num_stages
    [y_starts{i}, y_ends{i}] = calc_positions_with_inner_gap(...
        stage_totals{i}, stage_flow_counts{i}, scale_factor, node_gap, inner_gap);
end

%% 3. 定义颜色方案
colors = cell(num_stages, 1);
for i = 1:num_stages
    colors{i} = generate_colors(stage_sizes(i), i);
end

%% 4. 绘制冲击图
figure('Position', [100, 100, 1400, 600], 'Color', 'white');
hold on;

% 先绘制所有流动带（在节点下层）
for stage_idx = 1:(num_stages - 1)
    y_current_left = y_starts{stage_idx};
    y_current_right = y_starts{stage_idx + 1};
    
    n_left = stage_sizes(stage_idx);
    n_right = stage_sizes(stage_idx + 1);
    
    for i = 1:n_left
        for j = 1:n_right
            if flows{stage_idx}(i, j) > 0
                flow_height = flows{stage_idx}(i, j) * scale_factor;
                
                draw_band(x_positions(stage_idx) + node_width, y_current_left(i), ...
                         x_positions(stage_idx + 1), y_current_right(j), ...
                         flow_height, colors{stage_idx}(i, :), 0.5);
                
                y_current_left(i) = y_current_left(i) + flow_height + inner_gap;
                y_current_right(j) = y_current_right(j) + flow_height + inner_gap;
            end
        end
    end
end

% 绘制所有阶段的节点
for stage_idx = 1:num_stages
    n = stage_sizes(stage_idx);
    
    for i = 1:n
        h = y_ends{stage_idx}(i) - y_starts{stage_idx}(i);
        x = x_positions(stage_idx);
        y = y_starts{stage_idx}(i);
        
        % 绘制节点
        patch([x, x+node_width, x+node_width, x], [y, y, y+h, y+h], ...
              colors{stage_idx}(i,:), 'EdgeColor', [0.3 0.3 0.3], 'LineWidth', 1.5);
        
        % 添加标签（根据位置调整标签方向）
        if stage_idx == 1
            % 第一个阶段：标签在左侧
            text(x - 0.01, y + h/2, sprintf('%s (%d)', stage_labels{stage_idx}{i}, stage_totals{stage_idx}(i)), ...
                 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', ...
                 'FontSize', 10, 'FontWeight', 'bold');
        elseif stage_idx == num_stages
            % 最后一个阶段：标签在右侧
            text(x + node_width + 0.01, y + h/2, sprintf('%s (%d)', stage_labels{stage_idx}{i}, stage_totals{stage_idx}(i)), ...
                 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
                 'FontSize', 10, 'FontWeight', 'bold');
        else
            % 中间阶段：标签在上方
            text(x + node_width/2, y + h + 0.02, sprintf('%s (%d)', stage_labels{stage_idx}{i}, stage_totals{stage_idx}(i)), ...
                 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
                 'FontSize', 10, 'FontWeight', 'bold');
        end
    end
    
    % 添加阶段标题
    text(x_positions(stage_idx) + node_width/2, 0.95, sprintf('阶段 %d', stage_idx), ...
         'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold');
end

% 设置坐标轴
axis([0 1 0 1]);
axis off;
title('多阶段冲击图 (Multi-Stage Alluvial Diagram)', 'FontSize', 16, 'FontWeight', 'bold');

hold off;

% 保存图片
% saveas(gcf, '多阶段冲击图示例.png');
% fprintf('图片已保存为: 多阶段冲击图示例.png\n');

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

%% 辅助函数: 生成颜色方案
function colors = generate_colors(n, seed)
    % 根据阶段索引和类别数量生成不同的颜色方案
    
    % 预定义的颜色方案
    color_schemes = {
        [0.894 0.102 0.110;   % 红色系
         0.216 0.494 0.722;   % 蓝色系
         0.302 0.686 0.290;   % 绿色系
         0.596 0.306 0.639;   % 紫色系
         0.651 0.337 0.157];  % 棕色系
        
        [1.000 0.498 0.000;   % 橙色系
         0.651 0.337 0.157;   % 棕色系
         0.968 0.506 0.749;   % 粉色系
         0.553 0.627 0.796;   % 淡蓝色系
         0.400 0.761 0.647];  % 青色系
        
        [0.400 0.761 0.647;   % 青色系
         0.988 0.553 0.384;   % 珊瑚色系
         0.553 0.627 0.796;   % 淡蓝色系
         0.906 0.541 0.765;   % 淡紫色系
         0.890 0.467 0.761];  % 紫红色系
    };
    
    % 选择颜色方案
    scheme_idx = mod(seed - 1, length(color_schemes)) + 1;
    base_colors = color_schemes{scheme_idx};
    
    % 如果需要更多颜色，使用插值生成
    if n <= size(base_colors, 1)
        colors = base_colors(1:n, :);
    else
        % 使用HSV色彩空间插值
        hsv_base = rgb2hsv(base_colors);
        t = linspace(1, size(base_colors, 1), n);
        hsv_interp = interp1(1:size(base_colors, 1), hsv_base, t);
        colors = hsv2rgb(hsv_interp);
    end
end
