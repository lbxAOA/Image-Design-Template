clear; clc; close all;

%% 1. 生成2D随机数据
rng(42); % 设置随机种子以保证可重复性

n_points = 300; % 总数据点数

% 生成两目标数据 (ZDT1问题的变体)
t = rand(n_points, 1);
f1_2d = t + 0.03 * randn(n_points, 1);
f2_2d = (1 - sqrt(t)) + 0.03 * randn(n_points, 1);

% 确保数据非负
f1_2d = abs(f1_2d);
f2_2d = abs(f2_2d);

%% 2. 计算2D帕累托前沿
% 帕累托最优: 不存在其他解在所有目标上都不差，且至少一个目标上更好
data_2d = [f1_2d, f2_2d];
is_pareto_2d = true(n_points, 1);

for i = 1:n_points
    for j = 1:n_points
        if i ~= j
            % 如果j支配i (j在所有目标上不差，且至少一个目标更好)
            if all(data_2d(j,:) <= data_2d(i,:)) && any(data_2d(j,:) < data_2d(i,:))
                is_pareto_2d(i) = false;
                break;
            end
        end
    end
end

% 提取帕累托前沿点
pareto_f1 = f1_2d(is_pareto_2d);
pareto_f2 = f2_2d(is_pareto_2d);

% 对帕累托点按f1排序（便于绘制连线）
[pareto_f1_sorted, sort_idx] = sort(pareto_f1);
pareto_f2_sorted = pareto_f2(sort_idx);

%% 3. 绘制2D帕累托前沿图
figure('Position', [100, 100, 1000, 700], 'Color', 'w');

% 绘制非帕累托最优解 (浅灰色点)
scatter(f1_2d(~is_pareto_2d), f2_2d(~is_pareto_2d), 60, ...
    'MarkerFaceColor', [0.85, 0.85, 0.85], ...
    'MarkerEdgeColor', [0.6, 0.6, 0.6], ...
    'MarkerFaceAlpha', 0.5, ...
    'LineWidth', 0.8, ...
    'DisplayName', '非帕累托最优解');
hold on;

% 绘制帕累托前沿连线
plot(pareto_f1_sorted, pareto_f2_sorted, '-', ...
    'Color', [0.85, 0.33, 0.1], ...
    'LineWidth', 3, ...
    'DisplayName', '帕累托前沿');

% 绘制帕累托最优解 (红色点)
scatter(pareto_f1, pareto_f2, 120, ...
    'MarkerFaceColor', [0.85, 0.33, 0.1], ...
    'MarkerEdgeColor', [0.6, 0.2, 0.05], ...
    'LineWidth', 2, ...
    'DisplayName', '帕累托最优解');

%% 4. 标注关键点

% 理想点 (各目标的最小值)
ideal_point = [min(pareto_f1), min(pareto_f2)];
plot(ideal_point(1), ideal_point(2), 'p', ...
    'MarkerSize', 20, ...
    'MarkerFaceColor', [0.0, 0.7, 0.0], ...
    'MarkerEdgeColor', [0.0, 0.4, 0.0], ...
    'LineWidth', 2.5, ...
    'DisplayName', '理想点 (Ideal Point)');

% 最差点 (Nadir Point - 各目标的最大值)
nadir_point = [max(pareto_f1), max(pareto_f2)];
plot(nadir_point(1), nadir_point(2), 'h', ...
    'MarkerSize', 18, ...
    'MarkerFaceColor', [0.8, 0.0, 0.0], ...
    'MarkerEdgeColor', [0.5, 0.0, 0.0], ...
    'LineWidth', 2.5, ...
    'DisplayName', '最差点 (Nadir Point)');

% 折衷解 (中间点 - 可选)
mid_idx = round(length(pareto_f1_sorted) / 2);
compromise_point = [pareto_f1_sorted(mid_idx), pareto_f2_sorted(mid_idx)];
plot(compromise_point(1), compromise_point(2), 'd', ...
    'MarkerSize', 15, ...
    'MarkerFaceColor', [0.0, 0.45, 0.74], ...
    'MarkerEdgeColor', [0.0, 0.3, 0.5], ...
    'LineWidth', 2, ...
    'DisplayName', '折衷解 (Compromise)');

%% 5. 绘制支配区域示例
% 选择一个帕累托点，绘制其支配区域
example_idx = round(length(pareto_f1_sorted) * 0.6);
example_point = [pareto_f1_sorted(example_idx), pareto_f2_sorted(example_idx)];

% 支配区域 (阴影区域)
x_lim = xlim;
y_lim = ylim;
patch([example_point(1), x_lim(2), x_lim(2), example_point(1)], ...
      [example_point(2), example_point(2), y_lim(2), y_lim(2)], ...
      [1, 0.9, 0.9], ...
      'FaceAlpha', 0.2, ...
      'EdgeColor', 'none', ...
      'DisplayName', '支配区域示例');

hold off;

%% 6. 图形美化
title('2D帕累托前沿图 (2D Pareto Front)', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('目标函数 1 (最小化)', 'FontSize', 14);
ylabel('目标函数 2 (最小化)', 'FontSize', 14);

% 图例
legend('Location', 'northeast', 'FontSize', 11, 'Box', 'on');

% 网格和坐标轴
grid on;
set(gca, 'GridAlpha', 0.3, 'GridLineStyle', '--');
set(gca, 'FontSize', 12, 'LineWidth', 1.2);
set(gca, 'Box', 'on');

% 设置坐标轴范围
axis tight;
xlim([min(f1_2d)-0.1, max(f1_2d)+0.1]);
ylim([min(f2_2d)-0.1, max(f2_2d)+0.1]);

%% 7. 输出统计信息
fprintf('========== 2D帕累托前沿统计 ==========\n');
fprintf('总数据点数: %d\n', n_points);
fprintf('帕累托最优解数: %d\n', sum(is_pareto_2d));
fprintf('帕累托最优解比例: %.2f%%\n', 100*sum(is_pareto_2d)/n_points);
fprintf('--------------------------------------\n');
fprintf('理想点: (%.4f, %.4f)\n', ideal_point(1), ideal_point(2));
fprintf('最差点: (%.4f, %.4f)\n', nadir_point(1), nadir_point(2));
fprintf('折衷解: (%.4f, %.4f)\n', compromise_point(1), compromise_point(2));
fprintf('--------------------------------------\n');
fprintf('目标1范围: [%.4f, %.4f]\n', min(pareto_f1), max(pareto_f1));
fprintf('目标2范围: [%.4f, %.4f]\n', min(pareto_f2), max(pareto_f2));
fprintf('======================================\n');

%% 8. 保存图像 (可选)
% saveas(gcf, 'ParetoFront2D.png');
% saveas(gcf, 'ParetoFront2D.fig');
