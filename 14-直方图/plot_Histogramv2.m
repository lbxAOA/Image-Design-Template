%% 清空环境
clear; clc; close all;

%% 生成随机数据
% 生成三组服从不同正态分布的随机数据
rng(42);  % 设置随机种子，保证可重复性
data1 = randn(500, 1) * 10 + 45;  % 第一组：均值45，标准差10
data2 = randn(500, 1) * 12 + 55;  % 第二组：均值55，标准差12
data3 = randn(500, 1) * 8 + 50;   % 第三组：均值50，标准差8

%% 绘制堆叠直方图
figure('Position', [100, 100, 800, 500]);

% 使用 hold on 和透明度来创建堆叠效果
h1 = histogram(data1, 'BinWidth', 5, 'FaceColor', [0.2 0.6 0.8], ...
               'EdgeColor', 'white', 'FaceAlpha', 0.7);
hold on;
h2 = histogram(data2, 'BinWidth', 5, 'FaceColor', [0.8 0.4 0.2], ...
               'EdgeColor', 'white', 'FaceAlpha', 0.7);
h3 = histogram(data3, 'BinWidth', 5, 'FaceColor', [0.4 0.8 0.2], ...
               'EdgeColor', 'white', 'FaceAlpha', 0.7);
hold off;

title('堆叠直方图示例', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('数值', 'FontSize', 12);
ylabel('频数', 'FontSize', 12);
legend('组别 1', '组别 2', '组别 3', 'Location', 'northwest', 'FontSize', 10);
grid on;

%% 保存图片
% saveas(gcf, 'stacked_histogram_example.png');
% print(gcf, 'stacked_histogram_example', '-dpng', '-r300');

%% 显示数据统计信息
fprintf('===== 数据统计信息 =====\n');
fprintf('\n组别 1:\n');
fprintf('  样本数量: %d\n', length(data1));
fprintf('  均值: %.2f\n', mean(data1));
fprintf('  标准差: %.2f\n', std(data1));
fprintf('  最小值: %.2f\n', min(data1));
fprintf('  最大值: %.2f\n', max(data1));

fprintf('\n组别 2:\n');
fprintf('  样本数量: %d\n', length(data2));
fprintf('  均值: %.2f\n', mean(data2));
fprintf('  标准差: %.2f\n', std(data2));
fprintf('  最小值: %.2f\n', min(data2));
fprintf('  最大值: %.2f\n', max(data2));

fprintf('\n组别 3:\n');
fprintf('  样本数量: %d\n', length(data3));
fprintf('  均值: %.2f\n', mean(data3));
fprintf('  标准差: %.2f\n', std(data3));
fprintf('  最小值: %.2f\n', min(data3));
fprintf('  最大值: %.2f\n', max(data3));
