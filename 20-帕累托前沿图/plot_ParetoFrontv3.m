clear; clc; close all;

%% 1. 生成3D随机数据
rng(42); % 设置随机种子以保证可重复性

n_points = 400; % 总数据点数

% 生成三目标数据 (DTLZ2问题的变体)
theta = 2 * pi * rand(n_points, 1);
phi = acos(2 * rand(n_points, 1) - 1);

f1_3d = cos(theta) .* sin(phi) + 0.03 * randn(n_points, 1);
f2_3d = sin(theta) .* sin(phi) + 0.03 * randn(n_points, 1);
f3_3d = cos(phi) + 0.03 * randn(n_points, 1);

% 确保数据非负并归一化到[0, 1]
f1_3d = abs(f1_3d);
f2_3d = abs(f2_3d);
f3_3d = abs(f3_3d);

%% 2. 计算3D帕累托前沿
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

%% 3. 绘制带曲面的帕累托前沿图
figure('Position', [100, 100, 1200, 900], 'Color', 'w');

% 绘制非帕累托最优解 (半透明灰色点)
scatter3(f1_3d(~is_pareto_3d), f2_3d(~is_pareto_3d), f3_3d(~is_pareto_3d), 35, ...
    'MarkerFaceColor', [0.8, 0.8, 0.8], ...
    'MarkerEdgeColor', [0.6, 0.6, 0.6], ...
    'MarkerFaceAlpha', 0.25, ...
    'DisplayName', '非帕累托最优解');
hold on;

%% 4. 使用曲面拟合帕累托前沿

% 方法1: 使用Delaunay三角剖分创建曲面
if sum(is_pareto_3d) >= 4
    try
        % 对帕累托前沿点进行三角剖分
        tri = delaunay(pareto_f1, pareto_f2);
        
        % 绘制拟合曲面 (半透明橙色)
        h_surf = trisurf(tri, pareto_f1, pareto_f2, pareto_f3, ...
            'FaceColor', [0.9, 0.6, 0.2], ...
            'FaceAlpha', 0.5, ...
            'EdgeColor', [0.7, 0.4, 0.1], ...
            'EdgeAlpha', 0.4, ...
            'LineWidth', 0.5, ...
            'DisplayName', '帕累托前沿曲面');
        
    catch
        warning('三角剖分失败，使用备选方法');
    end
end

% 方法2: 使用散点插值生成平滑曲面
if sum(is_pareto_3d) >= 10
    try
        % 创建网格
        [F1_grid, F2_grid] = meshgrid(...
            linspace(min(pareto_f1), max(pareto_f1), 40), ...
            linspace(min(pareto_f2), max(pareto_f2), 40));
        
        % 使用散点插值
        F3_grid = griddata(pareto_f1, pareto_f2, pareto_f3, F1_grid, F2_grid, 'natural');
        
        % 绘制平滑曲面 (半透明蓝色)
        surf(F1_grid, F2_grid, F3_grid, ...
            'FaceColor', [0.3, 0.6, 0.9], ...
            'FaceAlpha', 0.35, ...
            'EdgeColor', 'none', ...
            'DisplayName', '平滑拟合曲面');
        
    catch
        warning('曲面插值失败');
    end
end

%% 5. 绘制帕累托最优解点
scatter3(pareto_f1, pareto_f2, pareto_f3, 100, ...
    'MarkerFaceColor', [0.85, 0.33, 0.1], ...
    'MarkerEdgeColor', [0.6, 0.2, 0.05], ...
    'LineWidth', 1.8, ...
    'DisplayName', '帕累托最优解');

%% 6. 绘制前沿边界投影

% XY平面投影 (z=0)
k_xy = convhull(pareto_f1, pareto_f2);
z_base = zeros(size(pareto_f1(k_xy)));
plot3(pareto_f1(k_xy), pareto_f2(k_xy), z_base, '--', ...
    'Color', [0.5, 0.5, 0.5], ...
    'LineWidth', 1.5, ...
    'DisplayName', 'XY平面投影');

% 从投影连线到前沿点
for i = 1:length(k_xy)
    idx = k_xy(i);
    plot3([pareto_f1(idx), pareto_f1(idx)], ...
          [pareto_f2(idx), pareto_f2(idx)], ...
          [0, pareto_f3(idx)], ':', ...
          'Color', [0.7, 0.7, 0.7], ...
          'LineWidth', 0.8, ...
          'HandleVisibility', 'off');
end

%% 7. 标注关键点

% 理想点
ideal_point = [min(pareto_f1), min(pareto_f2), min(pareto_f3)];
plot3(ideal_point(1), ideal_point(2), ideal_point(3), 'p', ...
    'MarkerSize', 20, ...
    'MarkerFaceColor', [0.0, 0.7, 0.0], ...
    'MarkerEdgeColor', [0.0, 0.4, 0.0], ...
    'LineWidth', 2.5, ...
    'DisplayName', '理想点');

% 最差点
nadir_point = [max(pareto_f1), max(pareto_f2), max(pareto_f3)];
plot3(nadir_point(1), nadir_point(2), nadir_point(3), 'h', ...
    'MarkerSize', 18, ...
    'MarkerFaceColor', [0.8, 0.0, 0.0], ...
    'MarkerEdgeColor', [0.5, 0.0, 0.0], ...
    'LineWidth', 2.5, ...
    'DisplayName', '最差点');

%% 8. 添加等值线 (在z方向)
if sum(is_pareto_3d) >= 10
    try
        % 在不同z值处绘制等值线
        z_levels = linspace(min(pareto_f3), max(pareto_f3), 5);
        for z_level = z_levels(2:end-1) % 跳过最小和最大值
            % 找到接近该z值的点
            tolerance = (max(pareto_f3) - min(pareto_f3)) / 10;
            idx_level = abs(pareto_f3 - z_level) < tolerance;
            
            if sum(idx_level) >= 3
                k_level = convhull(pareto_f1(idx_level), pareto_f2(idx_level));
                plot3(pareto_f1(idx_level(k_level)), ...
                      pareto_f2(idx_level(k_level)), ...
                      z_level * ones(size(k_level)), '-', ...
                      'Color', [0.6, 0.3, 0.8], ...
                      'LineWidth', 1.2, ...
                      'HandleVisibility', 'off');
            end
        end
    catch
        % 如果等值线绘制失败，继续
    end
end

hold off;

%% 9. 图形美化
title('带曲面的3D帕累托前沿图 (3D Pareto Front with Surface)', ...
    'FontSize', 16, 'FontWeight', 'bold');
xlabel('目标函数 1 (最小化)', 'FontSize', 13);
ylabel('目标函数 2 (最小化)', 'FontSize', 13);
zlabel('目标函数 3 (最小化)', 'FontSize', 13);

% 图例
legend('Location', 'best', 'FontSize', 10);

% 网格和坐标轴
grid on;
set(gca, 'GridAlpha', 0.25, 'GridLineStyle', '--');
set(gca, 'FontSize', 11, 'LineWidth', 1);
set(gca, 'Box', 'on');

% 设置视角
view(125, 25);

% 添加光照效果
camlight('left');
camlight('right');
lighting gouraud;
material shiny;

% 坐标轴范围
axis tight;

%% 10. 输出统计信息
fprintf('========== 带曲面的帕累托前沿统计 ==========\n');
fprintf('总数据点数: %d\n', n_points);
fprintf('帕累托最优解数: %d\n', sum(is_pareto_3d));
fprintf('帕累托最优解比例: %.2f%%\n', 100*sum(is_pareto_3d)/n_points);
fprintf('--------------------------------------------\n');
fprintf('理想点: (%.4f, %.4f, %.4f)\n', ideal_point(1), ideal_point(2), ideal_point(3));
fprintf('最差点: (%.4f, %.4f, %.4f)\n', nadir_point(1), nadir_point(2), nadir_point(3));
fprintf('--------------------------------------------\n');
fprintf('目标1范围: [%.4f, %.4f]\n', min(pareto_f1), max(pareto_f1));
fprintf('目标2范围: [%.4f, %.4f]\n', min(pareto_f2), max(pareto_f2));
fprintf('目标3范围: [%.4f, %.4f]\n', min(pareto_f3), max(pareto_f3));
fprintf('==========================================\n');

%% 11. 保存图像 (可选)
% saveas(gcf, 'ParetoFront3D_withSurface.png');
% saveas(gcf, 'ParetoFront3D_withSurface.fig');
