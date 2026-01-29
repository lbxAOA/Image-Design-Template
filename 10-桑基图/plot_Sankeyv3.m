%% 循环桑基图 (Circular Sankey Diagram)
% 使用随机数据生成循环桑基图

clear; clc; close all;

%% ==================== 参数设置 ====================
numNodes = 6;                    % 节点数量
nodeNames = {'A', 'B', 'C', 'D', 'E', 'F'};  % 节点名称

% 随机生成流量矩阵 (节点间的连接权重)
rng(42);  % 设置随机种子保证可重复
flowMatrix = randi([5, 50], numNodes, numNodes);  % 随机流量值
flowMatrix = flowMatrix - diag(diag(flowMatrix)); % 去除自环

%% ==================== 计算节点位置 (圆形布局) ====================
theta = linspace(0, 2*pi, numNodes + 1);
theta = theta(1:end-1);  % 去掉最后一个重复点
radius = 1;              % 圆的半径

nodeX = radius * cos(theta);
nodeY = radius * sin(theta);

%% ==================== 计算每个节点的总流量 ====================
outFlow = sum(flowMatrix, 2);   % 流出量
inFlow = sum(flowMatrix, 1)';   % 流入量
totalFlow = outFlow + inFlow;   % 总流量

%% ==================== 颜色设置 ====================
colors = lines(numNodes);  % 使用MATLAB内置颜色方案

%% ==================== 绑定figure ====================
figure('Position', [100, 100, 800, 800], 'Color', 'w');
hold on;
axis equal;
axis off;

%% ==================== 绘制流线 (贝塞尔曲线) ====================
for i = 1:numNodes
    for j = 1:numNodes
        if flowMatrix(i, j) > 0
            % 起点和终点
            x1 = nodeX(i); y1 = nodeY(i);
            x2 = nodeX(j); y2 = nodeY(j);
            
            % 贝塞尔曲线控制点 (通过圆心方向弯曲)
            cx = 0; cy = 0;  % 控制点在圆心
            
            % 生成贝塞尔曲线点
            t = linspace(0, 1, 100);
            bx = (1-t).^2 * x1 + 2*(1-t).*t * cx + t.^2 * x2;
            by = (1-t).^2 * y1 + 2*(1-t).*t * cy + t.^2 * y2;
            
            % 线宽根据流量调整
            lineWidth = flowMatrix(i, j) / max(flowMatrix(:)) * 10 + 1;
            
            % 绘制流线 (带透明度)
            plot(bx, by, 'Color', [colors(i,:), 0.4], 'LineWidth', lineWidth);
        end
    end
end

%% ==================== 绘制节点 ====================
nodeSize = totalFlow / max(totalFlow) * 500 + 200;  % 节点大小与流量成正比

for i = 1:numNodes
    scatter(nodeX(i), nodeY(i), nodeSize(i), colors(i,:), 'filled', ...
        'MarkerEdgeColor', 'k', 'LineWidth', 1.5);
end

%% ==================== 添加节点标签 ====================
labelRadius = radius * 1.25;  % 标签位置稍微外移
for i = 1:numNodes
    labelX = labelRadius * cos(theta(i));
    labelY = labelRadius * sin(theta(i));
    
    text(labelX, labelY, sprintf('%s\n(%.0f)', nodeNames{i}, totalFlow(i)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', ...
        'FontSize', 12, ...
        'FontWeight', 'bold');
end

%% ==================== 添加标题和图例 ====================
title('循环桑基图 (Circular Sankey Diagram)', 'FontSize', 16, 'FontWeight', 'bold');

% 添加简单图例说明
text(0, -1.6, '节点大小 ∝ 总流量，线宽 ∝ 流量值', ...
    'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', [0.5, 0.5, 0.5]);

hold off;

%% ==================== 显示流量矩阵 ====================
fprintf('\n===== 流量矩阵 =====\n');
disp(array2table(flowMatrix, 'VariableNames', nodeNames, 'RowNames', nodeNames));

%% ==================== 保存图片 (可选) ====================
% saveas(gcf, 'Circular_Sankey.png');
% exportgraphics(gcf, 'Circular_Sankey.pdf', 'ContentType', 'vector');
