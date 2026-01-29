%% 多层桑基图 - 使用MATLAB内置sankey函数 (R2023b+)
% 作者: GitHub Copilot
% 日期: 2026-01-26
% 说明: 使用plotSankey绘制多层桑基图，数据随机生成

clear; clc; close all;

%% 随机生成多层桑基图数据
rng(42); % 固定随机种子以便复现

% 定义各层节点名称
layer1 = {'来源A', '来源B', '来源C'};           % 第1层: 3个节点
layer2 = {'过程1', '过程2', '过程3', '过程4'};  % 第2层: 4个节点
layer3 = {'产出X', '产出Y', '产出Z'};           % 第3层: 3个节点

% 随机生成第1层到第2层的流量 (3x4)
flow12 = randi([10, 100], length(layer1), length(layer2));

% 随机生成第2层到第3层的流量 (4x3)
flow23 = randi([10, 100], length(layer2), length(layer3));

%% 构建边列表 (Source, Target, Weight)
sourceNodes = {};
targetNodes = {};
weights = [];

% 第1层 -> 第2层
for i = 1:length(layer1)
    for j = 1:length(layer2)
        if flow12(i,j) > 0
            sourceNodes{end+1} = layer1{i};
            targetNodes{end+1} = layer2{j};
            weights(end+1) = flow12(i,j);
        end
    end
end

% 第2层 -> 第3层
for i = 1:length(layer2)
    for j = 1:length(layer3)
        if flow23(i,j) > 0
            sourceNodes{end+1} = layer2{i};
            targetNodes{end+1} = layer3{j};
            weights(end+1) = flow23(i,j);
        end
    end
end

%% 创建表格数据
edgeTable = table(sourceNodes', targetNodes', weights', ...
    'VariableNames', {'Source', 'Target', 'Weight'});

disp('=== 桑基图边数据 ===');
disp(edgeTable);

%% 绘制桑基图
figure('Position', [100, 100, 900, 600], 'Color', 'w');

% 使用MATLAB内置sankey函数 (R2023b及以上版本)
% 如果版本较低，使用备选方案
try
    % R2023b+ 内置sankey函数
    s = sankey(edgeTable.Source, edgeTable.Target, edgeTable.Weight);
    
    % 设置颜色
    colors = [
        0.2 0.4 0.8;   % 蓝色系
        0.8 0.3 0.3;   % 红色系
        0.3 0.7 0.4;   % 绿色系
        0.9 0.6 0.2;   % 橙色系
        0.6 0.3 0.7;   % 紫色系
        0.4 0.8 0.8;   % 青色系
        0.9 0.5 0.6;   % 粉色系
        0.5 0.5 0.5;   % 灰色系
        0.3 0.6 0.9;   % 浅蓝
        0.7 0.8 0.3;   % 黄绿
    ];
    
    % 为每条链接设置颜色
    numLinks = length(s.LinkColor);
    linkColors = colors(mod(0:numLinks-1, size(colors,1)) + 1, :);
    s.LinkColor = linkColors;
    s.LinkColorMode = 'Source'; % 按源节点着色
    
    title('多层桑基图 (Multi-layer Sankey Diagram)', 'FontSize', 14, 'FontWeight', 'bold');
    
catch ME
    % 备选方案: 使用有向图可视化
    warning('MATLAB版本不支持sankey函数，使用digraph替代方案');
    
    % 创建有向图
    G = digraph(edgeTable.Source, edgeTable.Target, edgeTable.Weight);
    
    % 绘制图
    h = plot(G, 'Layout', 'layered', 'Direction', 'right', ...
        'EdgeLabel', G.Edges.Weight, ...
        'LineWidth', G.Edges.Weight / max(G.Edges.Weight) * 5 + 0.5, ...
        'ArrowSize', 10, ...
        'NodeFontSize', 10, ...
        'EdgeFontSize', 8);
    
    % 设置节点颜色
    allNodes = G.Nodes.Name;
    nodeColors = zeros(length(allNodes), 3);
    for i = 1:length(allNodes)
        if ismember(allNodes{i}, layer1)
            nodeColors(i,:) = [0.2 0.4 0.8]; % 蓝色
        elseif ismember(allNodes{i}, layer2)
            nodeColors(i,:) = [0.8 0.3 0.3]; % 红色
        else
            nodeColors(i,:) = [0.3 0.7 0.4]; % 绿色
        end
    end
    h.NodeColor = nodeColors;
    h.MarkerSize = 20;
    
    title('多层桑基图 - digraph替代方案', 'FontSize', 14, 'FontWeight', 'bold');
end

%% 添加图例说明
annotation('textbox', [0.02, 0.02, 0.3, 0.1], ...
    'String', sprintf('层1: %s\n层2: %s\n层3: %s', ...
    strjoin(layer1, ', '), strjoin(layer2, ', '), strjoin(layer3, ', ')), ...
    'FontSize', 9, 'EdgeColor', 'none', 'BackgroundColor', [0.95 0.95 0.95]);

%% 保存图像
% saveas(gcf, 'Sankey_MultiLayer.png');
% saveas(gcf, 'Sankey_MultiLayer.pdf');

disp('=== 桑基图绘制完成 ===');
