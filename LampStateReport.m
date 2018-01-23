function LampStateReport(reportPath,data,cutoff,reportTitle)
%LAMPSTATEREPORT Summary of this function goes here
%   Detailed explanation goes here

r = d12pack.report;
r.Orientation = 'landscape';
r.Title = reportTitle;
r.Type = 'Lamp State Report';

ax = axes(r.Body);
ax.TickDir = 'out';

yyaxis left
a = area(data.DateTime,data.LampState);
hold on
a.FaceColor = ax.YColor;
a.EdgeColor = 'none';
b = area(data.DateTime,data.AwayState);
b.FaceColor = [0.4 0.4 0.4];
b.EdgeColor = 'none';
axis tight
ax.YLim = [0,1];
ax.YTick = [0,1];
ax.YTickLabel = {'OFF','ON'};
ax.YLabel.String = 'Lamp State';

yyaxis right
c = plot(data.DateTime,data.MaxIntensity);
hold on
cutoff = cutoff*max(data.MaxIntensity);
d = plot([data.DateTime(1),data.DateTime(end)],[cutoff,cutoff]);
d.Color = 'black';
hold off
ax.YLim = [0,1.1*max(data.MaxIntensity)];
ax.YLabel.String = 'lum/ft^{2}';
ax.XLabel.String = 'Date Time';

ax.Box = 'off';
ax.XTickLabelRotation = 45;
ax.XTick = dateshift(data.DateTime(1),'end','day'):dateshift(data.DateTime(end),'start','day');

l = legend('Lamp State','Away','Max Light Intensity','State Cutoff');
l.Orientation = 'horizontal';
l.Location = 'southoutside';

ax.Position = [0.1125,0.18,0.77,0.81];

% Save plot
saveas(r.Figure,reportPath)
end

