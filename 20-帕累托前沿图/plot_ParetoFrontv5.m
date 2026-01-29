clear; clc; close all;

%% 1. 生成多目标随机数据 (6个目标)
rng(42); % 设置随机种子以保证可重复性

n_points = 150; % 总数据点数
n_objectives = 6; % 目标函数数量

% 生成随机数据
objectives = zeros(n_points, n_objectives);

for i = 1:n_objectives
    % 使用不同的随机模式生成数据
    t = rand(n_points, 1);
    objectives(:, i) = (1 - t.^(0.5 + i*0.1)) + 0.08 * randn(n_points, 1);
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
pareto_indices = find(is_pareto);

%% 3. 绘制热力图帕累托前沿图
figure('Position', [100, 100, 1400, 900], 'Color', 'w');

% 子图1: 帕累托最优解的热力图
subplot(2, 2, [1, 2]);

% 对帕累托解按第一个目标排序（便于可视化）
[~, sort_idx] = sort(pareto_objectives(:, 1));
pareto_sorted = pareto_objectives(sort_idx, :);

% 绘制热力图
h = imagesc(pareto_sorted');
colormap(jet);
c = colorbar;
c.Label.String = '目标函数值';
c.Label.FontSize = 12;
c.Label.FontWeight = 'bold';

% 在每个单元格中显示数值
hold on;
for i = 1:size(pareto_sorted, 1)
    for j = 1:n_objectives
        text(i, j, sprintf('%.2f', pareto_sorted(i, j)), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', ...
            'FontSize', 8, ...
            'Color', 'w', ...
            'FontWeight', 'bold');
    end
end
hold off;

title('帕累托最优解热力图 (Pareto Front Heatmap)', ...
    'FontSize', 15, 'FontWeight', 'bold');
xlabel('帕累托解编号 (按目标1排序)', 'FontSize', 12);
ylabel('目标函数', 'FontSize', 12);
yticks(1:n_objectives);
yticklabels(arrayfun(@(x) sprintf('目标 %d', x), 1:n_objectives, 'UniformOutput', false));
set(gca, 'FontSize', 11);

% 子图2: 归一化热力图
subplot(2, 2, 3);

% 归一化数据到[0, 1]
obj_min = min(pareto_sorted, [], 1);
obj_max = max(pareto_sorted, [], 1);
obj_range = obj_max - obj_min;
obj_range(obj_range == 0) = 1; % 避免除以0

pareto_norm = (pareto_sorted - obj_min) ./ obj_range;

% 绘制归一化热力图
imagesc(pareto_norm');
colormap(jet);
c2 = colorbar;
c2.Label.String = '归一化值 (0-1)';
c2.Label.FontSize = 11;

title('归一化帕累托前沿热力图', 'FontSize', 13, 'FontWeight', 'bold');
xlabel('帕累托解编号', 'FontSize', 11);
ylabel('目标函数', 'FontSize', 11);
yticks(1:n_objectives);
yticklabels(arrayfun(@(x) sprintf('目标 %d', x), 1:n_objectives, 'UniformOutput', false));
set(gca, 'FontSize', 10);

% 子图3: 目标间相关性热力图
subplot(2, 2, 4);

% 计算相关系数矩阵
corr_matrix = corr(pareto_sorted);

% 绘制相关性热力图
imagesc(corr_matrix);
colormap(jet);
caxis([-1, 1]);
c3 = colorbar;
c3.Label.String = '相关系数';
c3.Label.FontSize = 11;

% 在每个单元格中显示相关系数
hold on;
for i = 1:n_objectives
    for j = 1:n_objectives
        if abs(corr_matrix(i, j)) > 0.5 || i == j
            text_color = 'w';
        else
            text_color = 'k';
        end
        
        text(j, i, sprintf('%.2f', corr_matrix(i, j)), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', ...
            'FontSize', 9, ...
            'Color', text_color, ...
            'FontWeight', 'bold');
    end
end
hold off;

title('目标函数相关性矩阵', 'FontSize', 13, 'FontWeight', 'bold');
xlabel('目标函数', 'FontSize', 11);
ylabel('目标函数', 'FontSize', 11);
xticks(1:n_objectives);
yticks(1:n_objectives);
xticklabels(arrayfun(@(x) sprintf('目标%d', x), 1:n_objectives, 'UniformOutput', false));
yticklabels(arrayfun(@(x) sprintf('目标%d', x), 1:n_objectives, 'UniformOutput', false));
set(gca, 'FontSize', 10);
axis square;

%% 4. 第二个图：对比热力图（帕累托 vs 非帕累托）
figure('Position', [100, 100, 1600, 800], 'Color', 'w');

% 子图1: 所有解的热力图
subplot(1, 2, 1);

% 合并数据：先帕累托解，后非帕累托解
all_sorted = [pareto_sorted; non_pareto_objectives];
n_pareto = size(pareto_sorted, 1);
n_total = size(all_sorted, 1);

imagesc(all_sorted');
colormap(jet);
c4 = colorbar;
c4.Label.String = '目标函数值';
c4.Label.FontSize = 12;

% 绘制分界线
hold on;
line([n_pareto+0.5, n_pareto+0.5], [0.5, n_objectives+0.5], ...
    'Color', 'w', 'LineWidth', 3, 'LineStyle', '--');
hold off;

title('所有解的热力图对比', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('解编号 (左侧: 帕累托 | 右侧: 非帕累托)', 'FontSize', 12);
ylabel('目标函数', 'FontSize', 12);
yticks(1:n_objectives);
yticklabels(arrayfun(@(x) sprintf('目标 %d', x), 1:n_objectives, 'UniformOutput', false));
set(gca, 'FontSize', 11);

% 添加文字标注
text(n_pareto/2, -0.5, sprintf('帕累托解 (n=%d)', n_pareto), ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 11, ...
    'FontWeight', 'bold', ...
    'Color', [0.0, 0.6, 0.0]);

text(n_pareto + (n_total-n_pareto)/2, -0.5, ...
    sprintf('非帕累托解 (n=%d)', n_total-n_pareto), ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 11, ...
    'FontWeight', 'bold', ...
    'Color', [0.8, 0.0, 0.0]);

% 子图2: 帕累托解的雷达图式热力图
subplot(1, 2, 2);

% 选择几个代表性的帕累托解
n_samples = min(8, n_pareto);
sample_indices = round(linspace(1, n_pareto, n_samples));
samples = pareto_norm(sample_indices, :);

% 绘制雷达图式热力图
imagesc(samples');
colormap(jet);
c5 = colorbar;
c5.Label.String = '归一化值 (0-1)';
c5.Label.FontSize = 12;

% 在每个单元格中显示数值
hold on;
for i = 1:n_samples
    for j = 1:n_objectives
        % 根据值选择文字颜色
        if samples(i, j) < 0.5
            text_color = 'w';
        else
            text_color = 'k';
        end
        
        text(i, j, sprintf('%.2f', samples(i, j)), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', ...
            'FontSize', 9, ...
            'Color', text_color, ...
            'FontWeight', 'bold');
    end
end
hold off;

title('代表性帕累托解的归一化热力图', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('帕累托解样本', 'FontSize', 12);
ylabel('目标函数', 'FontSize', 12);
xticks(1:n_samples);
xticklabels(arrayfun(@(x) sprintf('#%d', x), 1:n_samples, 'UniformOutput', false));
yticks(1:n_objectives);
yticklabels(arrayfun(@(x) sprintf('目标 %d', x), 1:n_objectives, 'UniformOutput', false));
set(gca, 'FontSize', 11);

%% 5. 输出统计信息
fprintf('========== 热力图帕累托前沿统计 ==========\n');
fprintf('目标函数数量: %d\n', n_objectives);
fprintf('总数据点数: %d\n', n_points);
fprintf('帕累托最优解数: %d\n', sum(is_pareto));
fprintf('帕累托最优解比例: %.2f%%\n', 100*sum(is_pareto)/n_points);
fprintf('------------------------------------------\n');

fprintf('\n各目标函数统计 (帕累托最优解):\n');
fprintf('%-10s %10s %10s %10s %10s\n', '目标', '最小值', '最大值', '平均值', '标准差');
fprintf('------------------------------------------\n');
for obj_idx = 1:n_objectives
    fprintf('目标 %d:   %10.4f %10.4f %10.4f %10.4f\n', ...
        obj_idx, ...
        min(pareto_objectives(:, obj_idx)), ...
        max(pareto_objectives(:, obj_idx)), ...
        mean(pareto_objectives(:, obj_idx)), ...
        std(pareto_objectives(:, obj_idx)));
end
fprintf('==========================================\n');

fprintf('\n目标间相关性分析:\n');
fprintf('高度正相关 (r > 0.7):\n');
for i = 1:n_objectives
    for j = i+1:n_objectives
        if corr_matrix(i, j) > 0.7
            fprintf('  目标%d ↔ 目标%d: r = %.3f\n', i, j, corr_matrix(i, j));
        end
    end
end

fprintf('高度负相关 (r < -0.7):\n');
for i = 1:n_objectives
    for j = i+1:n_objectives
        if corr_matrix(i, j) < -0.7
            fprintf('  目标%d ↔ 目标%d: r = %.3f\n', i, j, corr_matrix(i, j));
        end
    end
end
fprintf('==========================================\n');

%% 6. 保存图像 (可选)
% saveas(gcf, 'ParetoFront_Heatmap.png');
% saveas(gcf, 'ParetoFront_Heatmap.fig');
