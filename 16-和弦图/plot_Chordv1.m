% ========================================================================
% 注意：需要先安装 chordChart 工具包
% Note: chordChart toolbox needs to be installed first
% 下载地址 / Download from: 
% https://github.com/slandarer/chordChart
% 或 MATLAB File Exchange 搜索 "chord chart"
% ========================================================================

% ========== 随机数据生成选项 / Random Data Generation Options ==========
USE_RANDOM_DATA = true;  % 设置为 true 使用完全随机数据 / Set to true for fully random data

if USE_RANDOM_DATA
    % 生成随机数据矩阵 / Generate random data matrix
    numRows = 3;  % 行数 / Number of rows
    numCols = 7;  % 列数 / Number of columns
    dataMat = randi([0, 10], numRows, numCols) + rand(numRows, numCols) * 3;
    dataMat(dataMat < 1) = 0;  % 将小于1的值设为0 / Set values less than 1 to 0
else
    % 使用预设数据 / Use preset data
    dataMat = [2 0 1 2 5 1 2;
               3 5 1 4 2 0 1;
               4 0 5 5 2 4 3];
    dataMat = dataMat + rand(3, 7);
    dataMat(dataMat < 1) = 0;
end

colName = {'G1','G2','G3','G4','G5','G6','G7'};
rowName = {'S1','S2','S3'};

% ========== 绘制和弦图 / Draw Chord Chart ==========
CC = chordChart(dataMat, 'rowName', rowName, 'colName', colName);
CC = CC.draw();
CC.setFont('FontSize', 17, 'FontName', 'Cambria')

% 显示刻度和数值 / Display scales and numeric values
CC.tickState('on')
CC.tickLabelState('on')

% 调节标签半径 / Adjust label radius
CC.setLabelRadius(1.4);

% 显示数据信息 / Display data info
disp('数据矩阵 / Data Matrix:');
disp(dataMat);