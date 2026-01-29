%% 日历热力图 (Calendar Heatmap)
% 简单实现，使用MATLAB内置函数
clc; clear; close all;

%% 生成随机数据
year = 2025;
startDate = datetime(year, 1, 1);
endDate = datetime(year, 12, 31);
dates = startDate:endDate;
numDays = length(dates);

% 随机生成每天的数据值 (0-100)
values = randi([0, 100], 1, numDays);

%% 计算日历布局
% 获取每天的周数和星期几
weekNum = week(dates, 'weekofyear');
dayOfWeek = weekday(dates);  % 1=周日, 2=周一, ..., 7=周六

% 创建热力图矩阵 (7行 x 53列，7天/周 x 最多53周)
calendarMatrix = NaN(7, 53);
for i = 1:numDays
    calendarMatrix(dayOfWeek(i), weekNum(i)) = values(i);
end

%% 绘制日历热力图
figure('Position', [100, 100, 1200, 300], 'Color', 'w');

% 使用imagesc绘制热力图
imagesc(calendarMatrix, 'AlphaData', ~isnan(calendarMatrix));
colormap(parula);  % 可选: hot, cool, jet, parula, turbo
colorbar;
clim([0, 100]);

% 设置坐标轴
ax = gca;
ax.Color = [0.95, 0.95, 0.95];  % 背景色
ax.YDir = 'reverse';
ax.XAxisLocation = 'top';

% Y轴标签 (星期)
yticks(1:7);
yticklabels({'日', '一', '二', '三', '四', '五', '六'});

% X轴标签 (月份)
monthStarts = [];
monthLabels = {};
for m = 1:12
    firstDayOfMonth = datetime(year, m, 1);
    monthStarts(end+1) = week(firstDayOfMonth, 'weekofyear');
    monthLabels{end+1} = datestr(firstDayOfMonth, 'mmm');
end
xticks(monthStarts);
xticklabels(monthLabels);

% 标题
title(sprintf('%d年 日历热力图', year), 'FontSize', 14, 'FontWeight', 'bold');

% 调整边距
set(gca, 'FontSize', 10, 'TickLength', [0, 0], 'Box', 'off');

%% 添加网格线（可选）
hold on;
for i = 0.5:1:7.5
    yline(i, 'Color', [0.8, 0.8, 0.8], 'LineWidth', 0.5);
end
for j = 0.5:1:53.5
    xline(j, 'Color', [0.8, 0.8, 0.8], 'LineWidth', 0.5);
end
hold off;

disp('日历热力图绑制完成！');
