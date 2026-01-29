clear; clc; close all;

%% 1. 生成数据 
% 设置随机种子以保证可重复性
rng('shuffle'); % 使用'shuffle'每次运行产生不同结果，或用固定数字如rng(42)

% 随机生成网格参数
grid_size = randi([40, 80]);                    % 随机网格大小 (40-80)
x_range = sort(randn(1,2) * 2 + [-3, 3]);       % 随机X范围
y_range = sort(randn(1,2) * 2 + [-3, 3]);       % 随机Y范围

% 创建自定义网格
[X, Y] = meshgrid(linspace(x_range(1), x_range(2), grid_size), ...
                  linspace(y_range(1), y_range(2), grid_size));

% 使用peaks函数生成基础曲面数据
Z = peaks(X, Y);

% 随机缩放和偏移
scale_factor = 0.5 + rand() * 1.5;              % 随机缩放 (0.5-2.0)
offset = (rand() - 0.5) * 4;                    % 随机偏移 (-2 到 2)
Z = Z * scale_factor + offset;

% 添加随机噪声使数据更真实
noise_level = 0.1 + rand() * 0.3;               % 随机噪声强度 (0.1-0.4)
noise = noise_level * randn(size(Z));
Z = Z + noise;

% 显示随机参数信息
fprintf('随机参数: 网格=%d, X范围=[%.2f,%.2f], Y范围=[%.2f,%.2f]\n', ...
        grid_size, x_range(1), x_range(2), y_range(1), y_range(2));
fprintf('缩放=%.2f, 偏移=%.2f, 噪声强度=%.2f\n', scale_factor, offset, noise_level);

%% 2. 创建图形窗口
figure('Name', '3D瀑布图', 'Position', [100, 100, 900, 700], 'Color', 'w');

%% 3. 绘制3D瀑布图
waterfall(X, Y, Z);

%% 4. 设置颜色映射和外观
colormap(jet);              % 使用jet颜色映射
shading interp;             % 平滑着色
alpha(0.9);                 % 设置透明度

%% 5. 添加颜色条
cb = colorbar;
cb.Label.String = 'Z值';
cb.Label.FontSize = 12;
cb.Label.FontName = 'Microsoft YaHei';

%% 6. 设置坐标轴
xlabel('X轴', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Microsoft YaHei');
ylabel('Y轴', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Microsoft YaHei');
zlabel('Z轴', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Microsoft YaHei');

%% 7. 设置标题
title('3D瀑布图示例', 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Microsoft YaHei');

%% 8. 设置视角和其他属性
view(45, 30);               % 设置视角 (方位角, 仰角)
axis tight;                 % 紧凑坐标轴
grid on;                    % 显示网格
box on;                     % 显示边框

%% 9. 设置光照效果
light('Position', [1 0 1], 'Style', 'infinite');
lighting gouraud;           % 高洛德光照
material shiny;             % 材质属性

%% 10. 设置坐标轴属性
set(gca, 'FontSize', 11, 'LineWidth', 1.2);

%% 11. 保存图形
% saveas(gcf, '3D瀑布图.png');
% saveas(gcf, '3D瀑布图.fig');
% print(gcf, '3D瀑布图', '-dpng', '-r300'); % 高分辨率保存

disp('3D瀑布图绘制完成！');
