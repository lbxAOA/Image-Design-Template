%% 清空环境
clear; clc; close all;

%% 生成随机数据
% 生成两组服从不同正态分布的随机数据
rng(42);  % 设置随机种子，保证可重复性
data1 = randn(800, 1) * 10 + 45;  % 第一组：均值45，标准差10
data2 = randn(800, 1) * 12 + 55;  % 第二组：均值55，标准差12

%% 绘制并列直方图
figure('Position', [100, 100, 900, 500]);

% 定义统一的bins边界
binEdges = 10:5:90;

% 计算每组数据的频数
counts1 = histcounts(data1, binEdges);
counts2 = histcounts(data2, binEdges);

% 计算bin的中心位置
binCenters = (binEdges(1:end-1) + binEdges(2:end)) / 2;
binWidth = binEdges(2) - binEdges(1);

% 绘制并列柱状图
barWidth = 0.4;
hold on;
bar(binCenters - binWidth/2, counts1, barWidth, 'FaceColor', [0.2 0.6 0.8], ...
    'EdgeColor', 'white', 'FaceAlpha', 0.8);
bar(binCenters + binWidth/2, counts2, barWidth, 'FaceColor', [0.8 0.4 0.2], ...
    'EdgeColor', 'white', 'FaceAlpha', 0.8);
hold off;

title('并列直方图示例', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('数值', 'FontSize', 12);
ylabel('频数', 'FontSize', 12);
legend('组别 1', '组别 2', 'Location', 'northwest', 'FontSize', 10);
grid on;
box on;

%% 保存图片
% saveas(gcf, 'side_by_side_histogram.png');
% print(gcf, 'side_by_side_histogram', '-dpng', '-r300');

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
