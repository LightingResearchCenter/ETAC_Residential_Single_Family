function LampStateReport(reportPath,data,reportTitle)
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
ax.YTick = [0,1];
ax.YTickLabel = {'OFF','ON'};
axis tight
ax.YLabel.String = 'Lamp State';

yyaxis right
c = plot(data.DateTime,data.MaxIntensity);
hold on
cutoff = 0.1*max(data.MaxIntensity);
d = plot([data.DateTime(1),data.DateTime(end)],[cutoff,cutoff]);
d.Color = 'black';
hold off
ax.YLabel.String = 'lum/ft^{2}';
ax.XLabel.String = 'Date Time';

ax.Box = 'off';
ax.XTickLabelRotation = 45;
ax.XTick = dateshift(data.DateTime(1),'end','day'):dateshift(data.DateTime(end),'start','day');

l = legend('Lamp State','Away','Max Light Intensity','State Cutoff');
l.Orientation = 'horizontal';
l.Location = 'southoutside';

ax.Position = [0.1125,0.18,0.775,0.82];

% Save plot
saveas(r.Figure,reportPath)
end

