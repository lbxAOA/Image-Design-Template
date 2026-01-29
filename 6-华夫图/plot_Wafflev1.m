clear; clc; close all;

%% 1. 随机生成数据
% 生成4个类别的随机数据
rng(42); % 设置随机种子以保证可重复性
raw_data = randi([5, 35], 1, 4); % 生成4个5-35之间的随机数
data = round(raw_data / sum(raw_data) * 100); % 转换为百分比（总和100）

% 确保总和为100
data(end) = 100 - sum(data(1:end-1));

% 类别名称
categories = {'类别A', '类别B', '类别C', '类别D'};

% 颜色方案（使用美观的配色）
colors = [
    0.298, 0.447, 0.690;  % 蓝色
    0.867, 0.518, 0.322;  % 橙色
    0.333, 0.659, 0.408;  % 绿色
    0.769, 0.306, 0.322;  % 红色
];

%% 2. 创建华夫图网格
grid_size = 10; % 10x10网格
total_cells = grid_size * grid_size; % 总共100个格子

% 创建网格矩阵，存储每个格子属于哪个类别
waffle_grid = zeros(grid_size, grid_size);

% 填充网格
cell_index = 1;
for cat = 1:length(data)
    num_cells = data(cat);
    for i = 1:num_cells
        if cell_index <= total_cells
            % 计算行列位置（从左下角开始，从左到右，从下到上）
            col = mod(cell_index - 1, grid_size) + 1;
            row = grid_size - floor((cell_index - 1) / grid_size);
            waffle_grid(row, col) = cat;
            cell_index = cell_index + 1;
        end
    end
end

%% 3. 绘制华夫图
figure('Position', [100, 100, 800, 700], 'Color', 'w');

% 绘制每个小方块
hold on;
cell_size = 1; % 每个格子的大小
gap = 0.08;    % 格子间隙

for row = 1:grid_size
    for col = 1:grid_size
        cat = waffle_grid(row, col);
        if cat > 0
            % 计算格子位置
            x = (col - 1) * (cell_size + gap);
            y = (row - 1) * (cell_size + gap);
            
            % 绘制圆角矩形
            rectangle('Position', [x, y, cell_size, cell_size], ...
                      'FaceColor', colors(cat, :), ...
                      'EdgeColor', 'w', ...
                      'LineWidth', 1.5, ...
                      'Curvature', [0.2, 0.2]);
        end
    end
end

% 设置坐标轴
axis equal;
axis off;
xlim([-0.5, grid_size * (cell_size + gap)]);
ylim([-0.5, grid_size * (cell_size + gap)]);

%% 4. 添加图例
legend_x = grid_size * (cell_size + gap) + 1;
legend_y = grid_size * (cell_size + gap) - 1;

for i = 1:length(categories)
    % 绘制图例色块
    rectangle('Position', [legend_x, legend_y - (i-1)*1.5, 0.8, 0.8], ...
              'FaceColor', colors(i, :), ...
              'EdgeColor', 'none', ...
              'Curvature', [0.2, 0.2]);
    
    % 添加图例文字
    text(legend_x + 1.2, legend_y - (i-1)*1.5 + 0.4, ...
         sprintf('%s: %d%%', categories{i}, data(i)), ...
         'FontSize', 12, 'FontWeight', 'bold', ...
         'VerticalAlignment', 'middle', ...
         'FontName', 'Microsoft YaHei');
end

%% 5. 添加标题
title('华夫图 (Waffle Chart)', 'FontSize', 18, 'FontWeight', 'bold', ...
      'FontName', 'Microsoft YaHei');

% 添加副标题说明
text(grid_size * (cell_size + gap) / 2, -1.5, ...
     '每个方格代表 1%', ...
     'HorizontalAlignment', 'center', ...
     'FontSize', 11, 'Color', [0.5, 0.5, 0.5], ...
     'FontName', 'Microsoft YaHei');

hold off;

%% 6. 显示数据信息
fprintf('\n========== 华夫图数据 ==========\n');
fprintf('%-10s %-10s\n', '类别', '百分比');
fprintf('--------------------------------\n');
for i = 1:length(categories)
    fprintf('%-10s %d%%\n', categories{i}, data(i));
end
fprintf('--------------------------------\n');
fprintf('%-10s %d%%\n', '总计', sum(data));
fprintf('================================\n');

%% 7. 保存图片（可选）
% saveas(gcf, 'waffle_chart.png');
% print(gcf, 'waffle_chart', '-dpng', '-r300');

fprintf('\n华夫图绘制完成！\n');
