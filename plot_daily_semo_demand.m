%% plot_daily_semo_demand.m
% PL 15.06.2009
%
n_vals_per_day=48;
ytl_tot=3000:1000:6000;
ytl_wind=200:200:800;
xnormlab=0.06;
ynormlab=0.9;

%% read the summer data
sum_filename=fullfile(DATA_ROOT,'energy','SEMO','Datapublication_Reports_05062009_RUN.xls');
[sum_datenums sum_demand]=read_semo_data(sum_filename,'EP2',1);
[sum_wind_dn sum_wind]   =read_semo_data(sum_filename,'EP2',3);

%% average the summer data
[sum_avg_hourly_load sum_min_hourly_load sum_max_hourly_load] = average_daily_load(sum_datenums,sum_demand,48);
[sum_avg_hourly_wind sum_min_hourly_wind sum_max_hourly_wind ...
    sum_std_hourly_wind] = average_daily_load(sum_wind_dn,sum_wind,48);

sum_avg_load=nanmean(sum_demand);

%% read the winter data
win_filename=fullfile(DATA_ROOT,'energy','SEMO','MASTER_Datapublication_Reports_23012009.xls');
[win_datenums win_demand]=read_semo_data(win_filename,'EP2',1);
[win_wind_dn win_wind]   =read_semo_data(win_filename,'EP2',3);

%% average the winter data
[win_avg_hourly_load win_min_hourly_load win_max_hourly_load] = average_daily_load(win_datenums,win_demand,48);
[win_avg_hourly_wind win_min_hourly_wind win_max_hourly_wind ...
    win_std_hourly_wind] = average_daily_load(win_wind_dn,win_wind,48);
win_avg_load=nanmean(win_demand);


%% plot results
%% winter
figure(1);
clf;
set(gcf,'name','semo system demand');

subplot(2,1,1);
% winter
x=(1:n_vals_per_day)./(n_vals_per_day./24);

[AX,H1,H2] = plotyy(x,win_avg_hourly_load,...
    x,win_avg_hourly_wind);
set(get(AX(1),'ylabel'),'string','Total load [MW]');
set(get(AX(2),'ylabel'),'string','Wind generation [MW]');
set(AX(1),'ylim',[2000 6000]);
set(AX(2),'ylim',[0 800]);
set(AX(1),'xtick',0:6:24);
set(AX(2),'xtick',0:6:24);
set(AX(1),'xticklabel',{'0:00','6:00','12:00','18:00','24:00'});
set(AX(2),'xticklabel',{'0:00','6:00','12:00','18:00','24:00'});
set(H1,'linewidth',2);set(H2,'linewidth',2);

set(H1,'linestyle','--');
set(H1,'color','k');
set(H2,'color','k');
set(AX(1),'ycolor',[0 0 0]);
set(AX(2),'ycolor',[ 0 0 0]);

hold on;
%plot((1:n_vals_per_day)./(n_vals_per_day./24),10.*win_avg_hourly_wind,'g');
plot([0 24],[win_avg_load win_avg_load],'k:');
norm_label_axes(xnormlab,ynormlab, '(a) winter');

set(AX(1),'ytick',ytl_tot);
set(AX(2),'ytick',ytl_wind);

% vertical lines
set(gcf,'currentaxes',AX(2));
for i_line=1:48
    line([x(i_line) x(i_line)],...
        win_avg_hourly_wind(i_line)+[-win_std_hourly_wind(i_line) win_std_hourly_wind(i_line)],...
        'color',[0.4 0.4 0.4]);
end


%% summer
subplot(2,1,2);

[AX2,H12,H22] = plotyy(x,sum_avg_hourly_load,...
    x,sum_avg_hourly_wind);
set(get(AX2(1),'ylabel'),'string','Total load [MW]');
set(get(AX2(2),'ylabel'),'string','Wind generation [MW]');
xlabel('time of day');
%set(gca,'xlim',[0 24]);
hold on;
set(AX2(1),'ylim',[2000 6000]);
set(AX2(2),'ylim',[0 800]);
set(AX2(1),'xtick',0:6:24);
set(AX2(2),'xtick',0:6:24);
set(AX2(1),'xticklabel',{'0:00','6:00','12:00','18:00','24:00'});
set(AX2(2),'xticklabel',{'0:00','6:00','12:00','18:00','24:00'});
set(H12,'linewidth',2);set(H22,'linewidth',2);
norm_label_axes(xnormlab,ynormlab, '(b) summer');

% colours
set(H12,'linestyle','--');
set(H12,'color','k');
set(H22,'color','k');
set(AX2(1),'ycolor',[0 0 0]);
set(AX2(2),'ycolor',[ 0 0 0]);

set(AX2(1),'ytick',ytl_tot);
set(AX2(2),'ytick',ytl_wind);

legend([H12 H22],{'Total load','Wind generation'},'location','northeast','orientation',...
    'horizontal');
legend('boxoff');

% horizontal line at average load
plot([0 24],[sum_avg_load sum_avg_load],'k:');

% vertical lines
set(gcf,'currentaxes',AX2(2));
for i_line=1:48
    line([x(i_line) x(i_line)],...
        sum_avg_hourly_wind(i_line)+[-sum_std_hourly_wind(i_line) sum_std_hourly_wind(i_line)],...
        'color',[0.4 0.4 0.4]);
end


%% finish
fig2tiff(13,10);
saveas(gcf,'semo.fig','fig');
mark;
