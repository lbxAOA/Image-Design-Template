dataMat=randi([0,8],[6,6]);

% 添加标签名称
NameList={'CHORD','CHART','MADE','BY','SLANDARER','MATLAB'};
BCC=biChordChart(dataMat,'Label',NameList,'Arrow','on');
BCC=BCC.draw(); 
% 添加刻度
BCC.tickState('on')
% 修改字体，字号及颜色
BCC.setFont('FontName','Cambria','FontSize',17,'Color',[.2,.2,.2])

BCC.setLabelRadius(1.3);
BCC.tickLabelState('on')