% ========================================================================
% 分组和弦图 / Grouped Chord Chart
% 注意：需要先安装 chordChart 工具包
% Note: chordChart toolbox needs to be installed first
% 下载地址 / Download from: 
% https://github.com/slandarer/chordChart
% 或 MATLAB File Exchange 搜索 "chord chart"
% ========================================================================

% ========== 随机数据生成选项 / Random Data Generation Options ==========
USE_RANDOM_DATA = true;  % 设置为 true 使用完全随机数据 / Set to true for fully random data

if USE_RANDOM_DATA
    % 生成随机数据矩阵（分组数据）/ Generate random grouped data matrix
    % 第一组：3个节点，第二组：4个节点，第三组：3个节点
    % Group 1: 3 nodes, Group 2: 4 nodes, Group 3: 3 nodes
    numRows = 3;  % 行分组数 / Number of row groups
    numCols = 3;  % 列分组数 / Number of column groups
    
    % 为每个分组生成数据
    dataMat = zeros(3, 3);
    dataMat(1, 1) = randi([3, 8]) + rand() * 2;  % 组1内部连接
    dataMat(2, 2) = randi([3, 8]) + rand() * 2;  % 组2内部连接
    dataMat(3, 3) = randi([3, 8]) + rand() * 2;  % 组3内部连接
    dataMat(1, 2) = randi([2, 6]) + rand() * 2;  % 组1到组2
    dataMat(1, 3) = randi([2, 6]) + rand() * 2;  % 组1到组3
    dataMat(2, 1) = randi([2, 6]) + rand() * 2;  % 组2到组1
    dataMat(2, 3) = randi([2, 6]) + rand() * 2;  % 组2到组3
    dataMat(3, 1) = randi([2, 6]) + rand() * 2;  % 组3到组1
    dataMat(3, 2) = randi([2, 6]) + rand() * 2;  % 组3到组2
else
    % 使用预设分组数据 / Use preset grouped data
    dataMat = [5.2, 2.3, 1.8;  % 从组1到各组的流量
               3.1, 6.7, 2.5;  % 从组2到各组的流量
               2.0, 3.2, 4.5]; % 从组3到各组的流量
end

% 定义分组名称 / Define group names
colName = {'技术部门\nTech Dept', '销售部门\nSales Dept', '管理部门\nManagement'};
rowName = {'技术部门\nTech Dept', '销售部门\nSales Dept', '管理部门\nManagement'};

% ========== 方案一：使用 chordChart 绘制分组和弦图 ==========
figure('Position', [100, 100, 900, 800], 'Color', 'w');

% 绘制和弦图
CC = chordChart(dataMat, 'rowName', rowName, 'colName', colName);
CC = CC.draw();

% 设置字体
CC.setFont('FontSize', 13, 'FontName', 'Arial', 'FontWeight', 'bold')

% 显示刻度和数值
CC.tickState('on')
CC.tickLabelState('on')

% 调节标签半径（增大以显示多行文本）
CC.setLabelRadius(1.45);

% 设置颜色方案（为不同组设置不同颜色）
% 科技蓝、商务橙、管理绿的配色方案
groupColors = [
    0.2, 0.4, 0.8;   % 深蓝色 - 技术部门
    0.9, 0.5, 0.2;   % 橙色 - 销售部门
    0.3, 0.7, 0.4;   % 绿色 - 管理部门
];

% 设置行和列的颜色
try
    CC.setRowColor(groupColors);
    CC.setColColor(groupColors);
catch
    % 如果不支持颜色设置，跳过
    warning('当前版本可能不支持颜色设置');
end

% 添加标题
title('部门间协作流量分组和弦图', 'FontSize', 16, 'FontWeight', 'bold', 'FontName', '微软雅黑');

% 显示数据信息
disp('===========================================');
disp('分组数据矩阵 / Grouped Data Matrix:');
disp(dataMat);
disp('-------------------------------------------');
disp('说明: 矩阵(i,j)表示从行组i到列组j的流量');
disp('Note: Matrix(i,j) represents flow from row group i to column group j');
disp('===========================================');
