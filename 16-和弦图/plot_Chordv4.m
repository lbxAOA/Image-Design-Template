% ========================================================================
% 层次和弦图 / Hierarchical Chord Chart
% 注意：需要先安装 chordChart 工具包
% Note: chordChart toolbox needs to be installed first
% 下载地址 / Download from: 
% https://github.com/slandarer/chordChart
% 或 MATLAB File Exchange 搜索 "chord chart"
% ========================================================================

% ========== 随机数据生成选项 / Random Data Generation Options ==========
USE_RANDOM_DATA = true;  % 设置为 true 使用完全随机数据 / Set to true for fully random data

if USE_RANDOM_DATA
    % 生成层次化数据矩阵 / Generate hierarchical data matrix
    % 三个主要部门，每个部门包含多个子部门
    % Three main departments, each containing multiple sub-departments
    
    % 层次结构：部门A(3个子部门) -> 部门B(4个子部门) -> 部门C(3个子部门)
    % Hierarchy: Dept A (3 sub-depts) -> Dept B (4 sub-depts) -> Dept C (3 sub-depts)
    numNodes = 10;  % 总节点数 (3+4+3)
    dataMat = zeros(numNodes, numNodes);
    
    % 部门A内部连接 (节点1-3)
    dataMat(1:3, 1:3) = randi([1, 3], 3, 3) + rand(3, 3) * 1.5;
    % 部门B内部连接 (节点4-7)
    dataMat(4:7, 4:7) = randi([1, 3], 4, 4) + rand(4, 4) * 1.5;
    % 部门C内部连接 (节点8-10)
    dataMat(8:10, 8:10) = randi([1, 3], 3, 3) + rand(3, 3) * 1.5;
    
    % 部门A -> 部门B 的连接
    dataMat(1:3, 4:7) = randi([0, 2], 3, 4) + rand(3, 4) * 1.2;
    % 部门B -> 部门A 的连接
    dataMat(4:7, 1:3) = randi([0, 2], 4, 3) + rand(4, 3) * 1.2;
    
    % 部门A -> 部门C 的连接
    dataMat(1:3, 8:10) = randi([0, 2], 3, 3) + rand(3, 3) * 1.0;
    % 部门C -> 部门A 的连接
    dataMat(8:10, 1:3) = randi([0, 2], 3, 3) + rand(3, 3) * 1.0;
    
    % 部门B -> 部门C 的连接
    dataMat(4:7, 8:10) = randi([0, 2], 4, 3) + rand(4, 3) * 1.2;
    % 部门C -> 部门B 的连接
    dataMat(8:10, 4:7) = randi([0, 2], 3, 4) + rand(3, 4) * 1.2;
    
    % 对角线设为0（避免自环）
    dataMat(logical(eye(numNodes))) = 0;
else
    % 使用预设层次数据 / Use preset hierarchical data
    dataMat = [
        % A1    A2    A3    B1    B2    B3    B4    C1    C2    C3
        0.0,  2.1,  1.5,  1.8,  2.2,  1.5,  1.0,  1.2,  0.8,  0.5;  % A1
        1.8,  0.0,  2.3,  2.0,  1.8,  1.2,  0.9,  1.0,  0.7,  0.4;  % A2
        1.6,  2.0,  0.0,  1.5,  1.6,  1.8,  1.1,  0.8,  0.9,  0.6;  % A3
        2.2,  1.9,  1.4,  0.0,  2.5,  2.0,  1.5,  1.8,  1.5,  1.2;  % B1
        2.0,  1.7,  1.5,  2.3,  0.0,  2.2,  1.8,  1.6,  1.3,  1.0;  % B2
        1.5,  1.3,  1.6,  1.8,  2.1,  0.0,  2.0,  1.4,  1.2,  0.9;  % B3
        1.0,  0.9,  1.2,  1.5,  1.7,  1.9,  0.0,  1.2,  1.0,  0.8;  % B4
        1.3,  1.0,  0.9,  1.6,  1.5,  1.3,  1.1,  0.0,  2.0,  1.5;  % C1
        0.9,  0.7,  0.8,  1.4,  1.2,  1.1,  0.9,  1.8,  0.0,  1.8;  % C2
        0.6,  0.5,  0.7,  1.1,  0.9,  0.8,  0.7,  1.5,  1.7,  0.0;  % C3
    ];
end

% 定义层次化节点名称 / Define hierarchical node names
% 使用分隔符表示层次关系
nodeName = {'A-研发', 'A-测试', 'A-运维', 'B-前端', 'B-后端', 'B-数据', 'B-算法', 'C-人力', 'C-财务', 'C-行政'};

% ========== 绘制层次和弦图 / Draw Hierarchical Chord Chart ==========
figure('Position', [100, 100, 1000, 900], 'Color', 'w');

% 使用 biChordChart 绘制双向层次和弦图
CC = biChordChart(dataMat, 'Label', nodeName, 'Arrow', 'on');
CC = CC.draw();

% 设置字体
CC.setFont('FontName', 'Microsoft YaHei', 'FontSize', 11, 'Color', [.1, .1, .1])

% 显示刻度和数值
CC.tickState('on')
CC.tickLabelState('on')

% 调节标签半径
CC.setLabelRadius(1.38);

% 设置层次化颜色方案（按部门层次着色）
% Hierarchical color scheme (colored by department hierarchy)
hierarchicalColors = [
    % 部门A - 蓝色系（技术部门）
    0.2, 0.4, 0.8;   % A-研发 深蓝
    0.3, 0.5, 0.9;   % A-测试 中蓝
    0.4, 0.6, 1.0;   % A-运维 浅蓝
    % 部门B - 橙色系（业务部门）
    0.9, 0.4, 0.1;   % B-前端 深橙
    1.0, 0.5, 0.2;   % B-后端 中橙
    1.0, 0.6, 0.3;   % B-数据 浅橙
    1.0, 0.7, 0.4;   % B-算法 淡橙
    % 部门C - 绿色系（支持部门）
    0.2, 0.7, 0.3;   % C-人力 深绿
    0.3, 0.8, 0.4;   % C-财务 中绿
    0.4, 0.9, 0.5;   % C-行政 浅绿
];

% 应用层次颜色
try
    CC.setColor(hierarchicalColors);
catch
    warning('当前版本可能不支持颜色设置');
end

% 添加标题和说明
title('层次和弦图 - 三级部门协作关系', 'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Microsoft YaHei');

% 添加层次说明文本框
annotation('textbox', [0.02, 0.96, 0.35, 0.03], ...
    'String', '层次结构: 部门A(蓝色系) | 部门B(橙色系) | 部门C(绿色系)', ...
    'FontSize', 10, 'EdgeColor', 'none', 'FontName', 'Microsoft YaHei', ...
    'BackgroundColor', [1 1 1 0.8]);

% 添加图例说明各部门的子节点
annotation('textbox', [0.02, 0.05, 0.25, 0.08], ...
    'String', sprintf(['部门A: 研发-测试-运维\n' ...
                       '部门B: 前端-后端-数据-算法\n' ...
                       '部门C: 人力-财务-行政']), ...
    'FontSize', 9, 'EdgeColor', [0.3 0.3 0.3], 'FontName', 'Microsoft YaHei', ...
    'BackgroundColor', [1 1 1 0.9], 'LineWidth', 1);

% 显示数据信息
disp('===========================================');
disp('层次和弦图数据矩阵 / Hierarchical Chord Chart Data Matrix:');
disp('节点顺序 / Node Order:');
for i = 1:length(nodeName)
    fprintf('%d. %s\n', i, nodeName{i});
end
disp('-------------------------------------------');
disp('数据矩阵 (前5行示例) / Data Matrix (first 5 rows):');
disp(dataMat(1:min(5,size(dataMat,1)), :));
disp('-------------------------------------------');
disp('说明: 矩阵展示了三级层次结构下的部门间协作流量');
disp('Note: Matrix shows inter-departmental collaboration flow in 3-level hierarchy');
disp('===========================================');
