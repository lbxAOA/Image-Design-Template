clear; clc; close all;

%% 1. 生成随机数据
x = 1:10;  % x轴数据点
y1 = rand(1, 10) * 50 + 20;  % 第一条折线数据 (20-70范围)
y2 = rand(1, 10) * 40 + 30;  % 第二条折线数据 (30-70范围)
y3 = rand(1, 10) * 30 + 40;  % 第三条折线数据 (40-70范围)

%% 2. 创建图形窗口
figure('Position', [100, 100, 800, 600], 'Color', 'white');

%% 3. 绑制折线图
hold on;

% 绑制三条折线，设置不同的颜色、标记和线型
plot(x, y1, '-o', 'LineWidth', 2, 'MarkerSize', 8, ...
    'Color', [0.2, 0.4, 0.8], 'MarkerFaceColor', [0.2, 0.4, 0.8], ...
    'DisplayName', '系列 A');

plot(x, y2, '-s', 'LineWidth', 2, 'MarkerSize', 8, ...
    'Color', [0.9, 0.3, 0.3], 'MarkerFaceColor', [0.9, 0.3, 0.3], ...
    'DisplayName', '系列 B');

plot(x, y3, '-^', 'LineWidth', 2, 'MarkerSize', 8, ...
    'Color', [0.3, 0.7, 0.4], 'MarkerFaceColor', [0.3, 0.7, 0.4], ...
    'DisplayName', '系列 C');

hold off;

%% 4. 设置坐标轴
xlabel('时间 (月)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('数值', 'FontSize', 12, 'FontWeight', 'bold');
title('标准折线图示例', 'FontSize', 14, 'FontWeight', 'bold');

% 设置坐标轴范围
xlim([0.5, 10.5]);
ylim([0, 100]);

% 设置刻度
set(gca, 'XTick', 1:10);
set(gca, 'FontSize', 11);

%% 5. 添加图例
legend('Location', 'best', 'FontSize', 10);

%% 6. 添加网格
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);

%% 7. 美化图形
box on;
set(gca, 'LineWidth', 1.2);

%% 8. 保存图片 (可选)
% saveas(gcf, 'line_chart.png');
% print(gcf, 'line_chart', '-dpng', '-r300');  % 高分辨率保存

disp('折线图绑制完成！');
