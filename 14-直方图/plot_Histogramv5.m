%% 清空环境
clear; clc; close all;

%% 生成随机数据
% 生成1000个服从正态分布的随机数据
rng(42);  % 设置随机种子，保证可重复性
data = randn(1000, 1) * 15 + 50;  % 均值50，标准差15

%% 绘制累积直方图
figure('Position', [100, 100, 600, 450]);

% 使用 'Normalization', 'cdf' 绘制累积分布
histogram(data, 'Normalization', 'cdf', 'FaceColor', [0.2 0.6 0.8], 'EdgeColor', 'white');

% 叠加理论累积分布函数曲线
hold on;
x = linspace(min(data), max(data), 200);
y = normcdf(x, mean(data), std(data));
plot(x, y, 'r-', 'LineWidth', 2);
hold off;

title('累积直方图示例', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('数值', 'FontSize', 12);
ylabel('累积概率', 'FontSize', 12);
legend('数据累积分布', '理论累积分布', 'Location', 'southeast', 'FontSize', 10);
grid on;

%% 保存图片
% saveas(gcf, 'cumulative_histogram_example.png');
% print(gcf, 'cumulative_histogram_example', '-dpng', '-r300');

%% 显示数据统计信息
fprintf('===== 数据统计信息 =====\n');
fprintf('样本数量: %d\n', length(data));
fprintf('均值: %.2f\n', mean(data));
fprintf('标准差: %.2f\n', std(data));
fprintf('最小值: %.2f\n', min(data));
fprintf('最大值: %.2f\n', max(data));
fprintf('中位数: %.2f\n', median(data));
