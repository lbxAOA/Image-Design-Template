clear; clc; close all;

%% 1. 生成多目标随机数据 (5个目标)
rng(42); % 设置随机种子以保证可重复性

n_points = 200; % 总数据点数
n_objectives = 5; % 目标函数数量

% 生成随机数据
objectives = zeros(n_points, n_objectives);

for i = 1:n_objectives
    % 使用不同的随机模式生成数据
    t = rand(n_points, 1);
    objectives(:, i) = (1 - t.^(i*0.5)) + 0.05 * randn(n_points, 1);
    objectives(:, i) = abs(objectives(:, i)); % 确保非负
end

%% 2. 计算帕累托前沿
is_pareto = true(n_points, 1);

for i = 1:n_points
    for j = 1:n_points
        if i ~= j
            % 如果j支配i
            if all(objectives(j,:) <= objectives(i,:)) && any(objectives(j,:) < objectives(i,:))
                is_pareto(i) = false;
                break;
            end
        end
    end
end

% 提取帕累托最优解
pareto_objectives = objectives(is_pareto, :);
non_pareto_objectives = objectives(~is_pareto, :);

%% 3. 归一化数据到[0, 1]范围（用于可视化）
obj_min = min(objectives, [], 1);
obj_max = max(objectives, [], 1);
obj_range = obj_max - obj_min;
obj_range(obj_range == 0) = 1; % 避免除以0

objectives_norm = (objectives - obj_min) ./ obj_range;
pareto_norm = (pareto_objectives - obj_min) ./ obj_range;
non_pareto_norm = (non_pareto_objectives - obj_min) ./ obj_range;

%% 4. 绘制平行坐标图
figure('Position', [100, 100, 1400, 700], 'Color', 'w');

% 定义颜色
color_pareto = [0.85, 0.33, 0.1]; % 橙红色 - 帕累托最优解
color_non_pareto = [0.7, 0.7, 0.7]; % 灰色 - 非帕累托最优解

% 绘制非帕累托最优解 (灰色线条，在后面)
for i = 1:size(non_pareto_norm, 1)
    plot(1:n_objectives, non_pareto_norm(i, :), '-', ...
        'Color', [color_non_pareto, 0.15], ...
        'LineWidth', 0.8, ...
        'HandleVisibility', 'off');
    hold on;
end

% 绘制帕累托最优解 (彩色线条，在前面)
% 根据第一个目标值着色
pareto_colors = jet(size(pareto_norm, 1));
[~, sort_idx] = sort(pareto_norm(:, 1));

for idx = 1:size(pareto_norm, 1)
    i = sort_idx(idx);
    plot(1:n_objectives, pareto_norm(i, :), '-', ...
        'Color', [pareto_colors(idx, :), 0.7], ...
        'LineWidth', 2, ...
        'HandleVisibility', 'off');
end

% 在数据点处绘制散点
for obj_idx = 1:n_objectives
    % 非帕累托点
    scatter(obj_idx * ones(size(non_pareto_norm, 1), 1), ...
        non_pareto_norm(:, obj_idx), 50, ...
        'MarkerFaceColor', color_non_pareto, ...
        'MarkerEdgeColor', [0.5, 0.5, 0.5], ...
        'MarkerFaceAlpha', 0.4, ...
        'LineWidth', 0.5, ...
        'HandleVisibility', 'off');
    
    % 帕累托点
    scatter(obj_idx * ones(size(pareto_norm, 1), 1), ...
        pareto_norm(:, obj_idx), 80, ...
        pareto_colors, ...
        'filled', ...
        'MarkerEdgeColor', [0.3, 0.3, 0.3], ...
        'LineWidth', 1.2, ...
        'HandleVisibility', 'off');
end

%% 5. 添加图例元素
% 手动创建图例项
h1 = plot(NaN, NaN, '-', 'Color', [color_non_pareto, 0.5], ...
    'LineWidth', 2, 'DisplayName', '非帕累托最优解');
h2 = plot(NaN, NaN, '-', 'Color', color_pareto, ...
    'LineWidth', 2.5, 'DisplayName', '帕累托最优解');

hold off;

%% 6. 图形美化
title('平行坐标帕累托前沿图 (Parallel Coordinates Pareto Front)', ...
    'FontSize', 16, 'FontWeight', 'bold');
xlabel('目标函数', 'FontSize', 14);
ylabel('归一化目标值 (0 = 最小, 1 = 最大)', 'FontSize', 14);

% 设置x轴刻度标签
xticks(1:n_objectives);
xticklabels(arrayfun(@(x) sprintf('目标 %d', x), 1:n_objectives, 'UniformOutput', false));

% 设置y轴
ylim([-0.05, 1.05]);
yticks(0:0.2:1);

% 网格
grid on;
set(gca, 'GridAlpha', 0.3, 'GridLineStyle', '--');
set(gca, 'FontSize', 12, 'LineWidth', 1.2);
set(gca, 'Box', 'on');

% 图例
legend([h2, h1], 'Location', 'best', 'FontSize', 11);

% 为每个轴添加竖线
for i = 1:n_objectives
    line([i, i], [0, 1], 'Color', [0.3, 0.3, 0.3], ...
        'LineWidth', 2, 'LineStyle', '-', 'HandleVisibility', 'off');
end

%% 7. 添加第二个子图：显示目标值的统计信息
figure('Position', [100, 100, 1400, 900], 'Color', 'w');

% 子图1: 平行坐标图 (与上面相同)
subplot(2, 1, 1);

% 重复绘制代码
for i = 1:size(non_pareto_norm, 1)
    plot(1:n_objectives, non_pareto_norm(i, :), '-', ...
        'Color', [color_non_pareto, 0.15], ...
        'LineWidth', 0.8, ...
        'HandleVisibility', 'off');
    hold on;
end

for idx = 1:size(pareto_norm, 1)
    i = sort_idx(idx);
    plot(1:n_objectives, pareto_norm(i, :), '-', ...
        'Color', [pareto_colors(idx, :), 0.7], ...
        'LineWidth', 2, ...
        'HandleVisibility', 'off');
end

for obj_idx = 1:n_objectives
    scatter(obj_idx * ones(size(non_pareto_norm, 1), 1), ...
        non_pareto_norm(:, obj_idx), 50, ...
        'MarkerFaceColor', color_non_pareto, ...
        'MarkerEdgeColor', [0.5, 0.5, 0.5], ...
        'MarkerFaceAlpha', 0.4, ...
        'LineWidth', 0.5, ...
        'HandleVisibility', 'off');
    
    scatter(obj_idx * ones(size(pareto_norm, 1), 1), ...
        pareto_norm(:, obj_idx), 80, ...
        pareto_colors, ...
        'filled', ...
        'MarkerEdgeColor', [0.3, 0.3, 0.3], ...
        'LineWidth', 1.2, ...
        'HandleVisibility', 'off');
end

h1 = plot(NaN, NaN, '-', 'Color', [color_non_pareto, 0.5], ...
    'LineWidth', 2, 'DisplayName', '非帕累托最优解');
h2 = plot(NaN, NaN, '-', 'Color', color_pareto, ...
    'LineWidth', 2.5, 'DisplayName', '帕累托最优解');

hold off;

title('平行坐标帕累托前沿图', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('目标函数', 'FontSize', 13);
ylabel('归一化目标值', 'FontSize', 13);
xticks(1:n_objectives);
xticklabels(arrayfun(@(x) sprintf('目标 %d', x), 1:n_objectives, 'UniformOutput', false));
ylim([-0.05, 1.05]);
grid on;
set(gca, 'GridAlpha', 0.3, 'GridLineStyle', '--');
set(gca, 'FontSize', 11, 'LineWidth', 1);
legend([h2, h1], 'Location', 'best', 'FontSize', 10);

for i = 1:n_objectives
    line([i, i], [0, 1], 'Color', [0.3, 0.3, 0.3], ...
        'LineWidth', 2, 'LineStyle', '-', 'HandleVisibility', 'off');
end

% 子图2: 箱线图 - 显示每个目标的分布
subplot(2, 1, 2);

% 准备箱线图数据
boxplot_data = [];
boxplot_groups = [];
boxplot_colors = [];

for obj_idx = 1:n_objectives
    % 帕累托数据
    boxplot_data = [boxplot_data; pareto_objectives(:, obj_idx)];
    boxplot_groups = [boxplot_groups; obj_idx * ones(size(pareto_objectives, 1), 1)];
end

% 绘制箱线图
boxplot(boxplot_data, boxplot_groups, ...
    'Colors', color_pareto, ...
    'Symbol', 'o', ...
    'Widths', 0.6);

hold on;

% 添加实际值范围的标注
for obj_idx = 1:n_objectives
    % 理想点和最差点
    ideal_val = min(pareto_objectives(:, obj_idx));
    nadir_val = max(pareto_objectives(:, obj_idx));
    
    text(obj_idx, ideal_val, sprintf('%.3f', ideal_val), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'top', ...
        'FontSize', 9, ...
        'Color', [0.0, 0.6, 0.0], ...
        'FontWeight', 'bold');
    
    text(obj_idx, nadir_val, sprintf('%.3f', nadir_val), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 9, ...
        'Color', [0.8, 0.0, 0.0], ...
        'FontWeight', 'bold');
end

hold off;

title('帕累托最优解的目标值分布', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('目标函数', 'FontSize', 13);
ylabel('目标值', 'FontSize', 13);
xticklabels(arrayfun(@(x) sprintf('目标 %d', x), 1:n_objectives, 'UniformOutput', false));
grid on;
set(gca, 'GridAlpha', 0.3, 'GridLineStyle', '--');
set(gca, 'FontSize', 11, 'LineWidth', 1);

%% 8. 输出统计信息
fprintf('========== 平行坐标帕累托前沿统计 ==========\n');
fprintf('目标函数数量: %d\n', n_objectives);
fprintf('总数据点数: %d\n', n_points);
fprintf('帕累托最优解数: %d\n', sum(is_pareto));
fprintf('帕累托最优解比例: %.2f%%\n', 100*sum(is_pareto)/n_points);
fprintf('--------------------------------------------\n');

for obj_idx = 1:n_objectives
    fprintf('目标 %d:\n', obj_idx);
    fprintf('  理想值: %.4f\n', min(pareto_objectives(:, obj_idx)));
    fprintf('  最差值: %.4f\n', max(pareto_objectives(:, obj_idx)));
    fprintf('  平均值: %.4f\n', mean(pareto_objectives(:, obj_idx)));
    fprintf('  标准差: %.4f\n', std(pareto_objectives(:, obj_idx)));
end

fprintf('==========================================\n');

%% 9. 保存图像 (可选)
% saveas(gcf, 'ParetoFront_ParallelCoordinates.png');
% saveas(gcf, 'ParetoFront_ParallelCoordinates.fig');
