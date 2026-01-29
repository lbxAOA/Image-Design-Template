clear; clc; close all;

%% ==================== 参数设置 ====================
% 随机数种子（保证可重复性）
rng(42);

% 节点设置
sourceNodes = {'煤炭', '石油', '天然气', '核能', '可再生能源'};  % 源节点
targetNodes = {'工业', '交通', '居民', '商业', '农业'};          % 目标节点

numSources = length(sourceNodes);
numTargets = length(targetNodes);

%% ==================== 随机生成流量数据 ====================
% 生成源到目标的流量矩阵 (行: 源, 列: 目标)
flowMatrix = randi([10, 100], numSources, numTargets);

% 确保某些连接为0（更真实）
zeroMask = rand(numSources, numTargets) < 0.2;
flowMatrix(zeroMask) = 0;

% 显示流量矩阵
disp('流量矩阵 (源 -> 目标):');
disp(array2table(flowMatrix, 'VariableNames', targetNodes, 'RowNames', sourceNodes));

%% ==================== 计算节点位置 ====================
% 计算每个源节点的总流出量
sourceFlows = sum(flowMatrix, 2);
% 计算每个目标节点的总流入量
targetFlows = sum(flowMatrix, 1)';

% 总流量
totalFlow = sum(sourceFlows);

% 图形参数
figWidth = 1200;
figHeight = 800;
leftX = 0.15;      % 左侧节点X位置
rightX = 0.85;     % 右侧节点X位置
nodeWidth = 0.03;  % 节点宽度
nodeGap = 0.02;    % 节点间隙
yPadding = 0.05;   % 上下边距

% 计算Y方向的缩放因子
availableHeight = 1 - 2*yPadding - (numSources-1)*nodeGap;
scaleFactor = availableHeight / totalFlow;

%% ==================== 计算源节点位置 ====================
sourceY = zeros(numSources, 1);      % 节点底部Y坐标
sourceHeight = sourceFlows * scaleFactor;  % 节点高度

currentY = yPadding;
for i = 1:numSources
    sourceY(i) = currentY;
    currentY = currentY + sourceHeight(i) + nodeGap;
end

%% ==================== 计算目标节点位置 ====================
% 重新计算目标侧的缩放因子
availableHeightTarget = 1 - 2*yPadding - (numTargets-1)*nodeGap;
scaleFactorTarget = availableHeightTarget / sum(targetFlows);

targetY = zeros(numTargets, 1);
targetHeight = targetFlows * scaleFactorTarget;

currentY = yPadding;
for i = 1:numTargets
    targetY(i) = currentY;
    currentY = currentY + targetHeight(i) + nodeGap;
end

%% ==================== 创建图形 ====================
figure('Position', [100, 100, figWidth, figHeight], 'Color', 'w');
hold on;

% 颜色设置
sourceColors = [
    0.894, 0.102, 0.110;   % 红色 - 煤炭
    0.216, 0.494, 0.722;   % 蓝色 - 石油
    0.302, 0.686, 0.290;   % 绿色 - 天然气
    0.596, 0.306, 0.639;   % 紫色 - 核能
    1.000, 0.498, 0.000;   % 橙色 - 可再生能源
];

targetColors = [
    0.651, 0.337, 0.157;   % 棕色 - 工业
    0.968, 0.506, 0.749;   % 粉色 - 交通
    0.600, 0.600, 0.600;   % 灰色 - 居民
    0.400, 0.761, 0.647;   % 青色 - 商业
    0.988, 0.553, 0.384;   % 珊瑚色 - 农业
];

%% ==================== 绘制流量带 (Flows) ====================
% 追踪每个节点当前的流量位置
sourceCurrentY = sourceY;
targetCurrentY = targetY;

for i = 1:numSources
    for j = 1:numTargets
        flow = flowMatrix(i, j);
        if flow > 0
            % 计算流量带的高度
            flowHeightSource = flow * scaleFactor;
            flowHeightTarget = flow * scaleFactorTarget;
            
            % 起点和终点坐标
            x1 = leftX + nodeWidth;
            y1_bottom = sourceCurrentY(i);
            y1_top = y1_bottom + flowHeightSource;
            
            x2 = rightX;
            y2_bottom = targetCurrentY(j);
            y2_top = y2_bottom + flowHeightTarget;
            
            % 绘制贝塞尔曲线流量带
            numPoints = 50;
            t = linspace(0, 1, numPoints);
            
            % 控制点
            cx1 = (x1 + x2) / 2;
            cx2 = (x1 + x2) / 2;
            
            % 上边界曲线
            xTop = (1-t).^3*x1 + 3*(1-t).^2.*t*cx1 + 3*(1-t).*t.^2*cx2 + t.^3*x2;
            yTop = (1-t).^3*y1_top + 3*(1-t).^2.*t*y1_top + 3*(1-t).*t.^2*y2_top + t.^3*y2_top;
            
            % 下边界曲线
            xBottom = (1-t).^3*x1 + 3*(1-t).^2.*t*cx1 + 3*(1-t).*t.^2*cx2 + t.^3*x2;
            yBottom = (1-t).^3*y1_bottom + 3*(1-t).^2.*t*y1_bottom + 3*(1-t).*t.^2*y2_bottom + t.^3*y2_bottom;
            
            % 创建填充多边形
            xPoly = [xTop, fliplr(xBottom)];
            yPoly = [yTop, fliplr(yBottom)];
            
            % 使用源节点颜色，带透明度
            flowColor = sourceColors(i, :);
            fill(xPoly, yPoly, flowColor, 'EdgeColor', 'none', 'FaceAlpha', 0.5);
            
            % 更新当前位置
            sourceCurrentY(i) = sourceCurrentY(i) + flowHeightSource;
            targetCurrentY(j) = targetCurrentY(j) + flowHeightTarget;
        end
    end
end

%% ==================== 绘制源节点 ====================
for i = 1:numSources
    rectangle('Position', [leftX, sourceY(i), nodeWidth, sourceHeight(i)], ...
              'FaceColor', sourceColors(i, :), ...
              'EdgeColor', 'k', ...
              'LineWidth', 1.5);
    
    % 添加标签
    text(leftX - 0.02, sourceY(i) + sourceHeight(i)/2, sourceNodes{i}, ...
         'HorizontalAlignment', 'right', ...
         'VerticalAlignment', 'middle', ...
         'FontSize', 12, ...
         'FontWeight', 'bold', ...
         'FontName', 'Microsoft YaHei');
    
    % 添加数值
    text(leftX + nodeWidth/2, sourceY(i) + sourceHeight(i)/2, num2str(sourceFlows(i)), ...
         'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'middle', ...
         'FontSize', 10, ...
         'Color', 'w', ...
         'FontWeight', 'bold');
end

%% ==================== 绘制目标节点 ====================
for i = 1:numTargets
    rectangle('Position', [rightX, targetY(i), nodeWidth, targetHeight(i)], ...
              'FaceColor', targetColors(i, :), ...
              'EdgeColor', 'k', ...
              'LineWidth', 1.5);
    
    % 添加标签
    text(rightX + nodeWidth + 0.02, targetY(i) + targetHeight(i)/2, targetNodes{i}, ...
         'HorizontalAlignment', 'left', ...
         'VerticalAlignment', 'middle', ...
         'FontSize', 12, ...
         'FontWeight', 'bold', ...
         'FontName', 'Microsoft YaHei');
    
    % 添加数值
    text(rightX + nodeWidth/2, targetY(i) + targetHeight(i)/2, num2str(targetFlows(i)), ...
         'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'middle', ...
         'FontSize', 10, ...
         'Color', 'w', ...
         'FontWeight', 'bold');
end

%% ==================== 图形美化 ====================
% 设置坐标轴
axis([0, 1, 0, 1]);
axis off;

% 添加标题
title('能源流向桑基图', 'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Microsoft YaHei');

% 添加副标题
text(0.5, 0.02, '数据为随机生成 | 单位: 万吨标准煤', ...
     'HorizontalAlignment', 'center', ...
     'FontSize', 10, ...
     'Color', [0.5, 0.5, 0.5], ...
     'FontName', 'Microsoft YaHei');

% 添加列标签
text(leftX + nodeWidth/2, 0.98, '能源来源', ...
     'HorizontalAlignment', 'center', ...
     'FontSize', 14, ...
     'FontWeight', 'bold', ...
     'FontName', 'Microsoft YaHei');

text(rightX + nodeWidth/2, 0.98, '消费部门', ...
     'HorizontalAlignment', 'center', ...
     'FontSize', 14, ...
     'FontWeight', 'bold', ...
     'FontName', 'Microsoft YaHei');

hold off;

%% ==================== 保存图形 ====================
% 保存为PNG
% saveas(gcf, 'Sankey_Diagram.png');

% 保存为高分辨率图片
% print(gcf, 'Sankey_Diagram_HD', '-dpng', '-r300');

% 保存为PDF (矢量图)
% print(gcf, 'Sankey_Diagram', '-dpdf', '-bestfit');

% disp('图形已保存为: Sankey_Diagram.png, Sankey_Diagram_HD.png, Sankey_Diagram.pdf');

%% ==================== 输出统计信息 ====================
fprintf('\n========== 统计信息 ==========\n');
fprintf('总能源流量: %d 万吨标准煤\n', totalFlow);
fprintf('\n源节点流量:\n');
for i = 1:numSources
    fprintf('  %s: %d (%.1f%%)\n', sourceNodes{i}, sourceFlows(i), 100*sourceFlows(i)/totalFlow);
end
fprintf('\n目标节点流量:\n');
for i = 1:numTargets
    fprintf('  %s: %d (%.1f%%)\n', targetNodes{i}, targetFlows(i), 100*targetFlows(i)/totalFlow);
end
