clear; clc; close all;

%% 1. 生成随机数据
rng(42); % 设置随机种子以保证可重复性

n_points = 300; % 总数据点数

% 生成三目标数据
t1 = rand(n_points, 1);
t2 = rand(n_points, 1);

f1_3d = t1 + 0.05 * randn(n_points, 1);
f2_3d = t2 + 0.05 * randn(n_points, 1);
f3_3d = (1 - sqrt(t1.*t2)) + 0.05 * randn(n_points, 1);

f1_3d = abs(f1_3d);
f2_3d = abs(f2_3d);
f3_3d = abs(f3_3d);

%% 2. 计算3D帕累托前沿
% 帕累托最优: 不存在其他解在所有目标上都不差，且至少一个目标上更好
data_3d = [f1_3d, f2_3d, f3_3d];
is_pareto_3d = true(n_points, 1);

for i = 1:n_points
    for j = 1:n_points
        if i ~= j
            if all(data_3d(j,:) <= data_3d(i,:)) && any(data_3d(j,:) < data_3d(i,:))
                is_pareto_3d(i) = false;
                break;
            end
        end
    end
end

% 提取帕累托前沿点
pareto_f1 = f1_3d(is_pareto_3d);
pareto_f2 = f2_3d(is_pareto_3d);
pareto_f3 = f3_3d(is_pareto_3d);

%% 3. 绘制3D帕累托前沿图
figure('Position', [100, 100, 1000, 800], 'Color', 'w');

% 绘制非帕累托最优解 (灰色点)
scatter3(f1_3d(~is_pareto_3d), f2_3d(~is_pareto_3d), f3_3d(~is_pareto_3d), 40, ...
    'MarkerFaceColor', [0.7, 0.7, 0.7], ...
    'MarkerEdgeColor', [0.5, 0.5, 0.5], ...
    'MarkerFaceAlpha', 0.3, ...
    'DisplayName', '非帕累托最优解');
hold on;

% 绘制帕累托最优解 (蓝色点)
scatter3(pareto_f1, pareto_f2, pareto_f3, 100, ...
    'MarkerFaceColor', [0.0, 0.45, 0.74], ...
    'MarkerEdgeColor', [0.0, 0.3, 0.5], ...
    'LineWidth', 1.5, ...
    'DisplayName', '帕累托最优解');

%% 4. 绘制帕累托前沿边界曲面
% 使用Delaunay三角剖分构建帕累托前沿曲面
if sum(is_pareto_3d) >= 3
    % 对帕累托前沿点进行三角剖分
    try
        % 使用前两个目标作为剖分依据
        tri = delaunay(pareto_f1, pareto_f2);
        
        % 绘制帕累托前沿曲面
        trisurf(tri, pareto_f1, pareto_f2, pareto_f3, ...
            'FaceColor', [0.85, 0.33, 0.1], ...
            'FaceAlpha', 0.4, ...
            'EdgeColor', [0.6, 0.2, 0.05], ...
            'EdgeAlpha', 0.6, ...
            'LineWidth', 0.5, ...
            'DisplayName', '帕累托前沿边界');
        
        % 绘制帕累托前沿边界线 (凸包边界)
        k = convhull(pareto_f1, pareto_f2);
        plot3(pareto_f1(k), pareto_f2(k), pareto_f3(k), '-', ...
            'Color', [0.85, 0.33, 0.1], ...
            'LineWidth', 2.5, ...
            'DisplayName', '前沿边界线');
    catch
        warning('三角剖分失败，跳过曲面绘制');
    end
end

%% 5. 标注理想点和最差点
% 理想点 (各目标的最小值)
ideal_point = [min(pareto_f1), min(pareto_f2), min(pareto_f3)];
plot3(ideal_point(1), ideal_point(2), ideal_point(3), 'p', ...
    'MarkerSize', 18, ...
    'MarkerFaceColor', [0.0, 0.7, 0.0], ...
    'MarkerEdgeColor', [0.0, 0.4, 0.0], ...
    'LineWidth', 2, ...
    'DisplayName', '理想点 (Ideal Point)');

% 最差点 (Nadir Point - 各目标的最大值)
nadir_point = [max(pareto_f1), max(pareto_f2), max(pareto_f3)];
plot3(nadir_point(1), nadir_point(2), nadir_point(3), 'h', ...
    'MarkerSize', 15, ...
    'MarkerFaceColor', [0.8, 0.0, 0.0], ...
    'MarkerEdgeColor', [0.5, 0.0, 0.0], ...
    'LineWidth', 2, ...
    'DisplayName', '最差点 (Nadir Point)');

hold off;

%% 6. 图形美化
title('3D帕累托前沿图 (3D Pareto Front)', 'FontSize', 16, 'FontWeight', 'bold');
xlabel('目标函数 1 (最小化)', 'FontSize', 13);
ylabel('目标函数 2 (最小化)', 'FontSize', 13);
zlabel('目标函数 3 (最小化)', 'FontSize', 13);

% 图例
legend('Location', 'best', 'FontSize', 11);

% 网格和坐标轴
grid on;
set(gca, 'GridAlpha', 0.3, 'GridLineStyle', '--');
set(gca, 'FontSize', 11, 'LineWidth', 1);
set(gca, 'Box', 'on');

% 设置视角
view(45, 30);

% 添加光照效果
camlight('headlight');
lighting gouraud;

%% 7. 输出统计信息
fprintf('========== 3D帕累托前沿统计 ==========\n');
fprintf('总数据点数: %d\n', n_points);
fprintf('帕累托最优解数: %d\n', sum(is_pareto_3d));
fprintf('帕累托最优解比例: %.2f%%\n', 100*sum(is_pareto_3d)/n_points);
fprintf('--------------------------------------\n');
fprintf('理想点: (%.4f, %.4f, %.4f)\n', ideal_point(1), ideal_point(2), ideal_point(3));
fprintf('最差点: (%.4f, %.4f, %.4f)\n', nadir_point(1), nadir_point(2), nadir_point(3));
fprintf('======================================\n');

%% 8. 保存图像 (可选)
% saveas(gcf, 'ParetoFront3D.png');
% saveas(gcf, 'ParetoFront3D.fig');
