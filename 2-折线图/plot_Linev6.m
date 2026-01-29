clear; clc; close all;

%% 随机生成数据
x = 1:12;  % 12个月
barData = randi([50, 200], 1, 12);    % 柱状图数据（如销量）
lineData = randi([60, 100], 1, 12);   % 折线图数据（如百分比）

%% 创建双Y轴图
figure('Position', [100, 100, 800, 500]);
yyaxis left
bar(x, barData, 0.6, 'FaceColor', [0.2, 0.6, 0.8]);
ylabel('销量');
ylim([0, max(barData)*1.2]);

yyaxis right
plot(x, lineData, '-o', 'LineWidth', 2, 'MarkerSize', 8, ...
    'Color', [0.85, 0.33, 0.1], 'MarkerFaceColor', [0.85, 0.33, 0.1]);
ylabel('完成率 (%)');
ylim([0, 120]);

%% 美化图表
xlabel('月份');
title('2025年月度销量与完成率');
xticks(1:12);
xticklabels({'1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'});
legend({'销量', '完成率'}, 'Location', 'northwest');
grid on;
set(gca, 'FontSize', 11);
