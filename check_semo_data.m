%% check_semo_data.m
% PL 29.04.2010
% Check 1 year of assembled SEMO data for timebase errors.
% 
% 
[FileName,PathName,FilterIndex] = uigetfile('*.xls','Choose data file');
sheetname = inputdlg('Worksheet','Choose worksheet',1);
%[data txt]=xlsread(fullfile('E:\Users\Public\Documents\data\energy\SEMO\2009\','2009.xls'),'EP2');
[data txt]=xlsread(fullfile(PathName,FileName),sheetname{1});
dns=datenum(txt(2:end,2),'dd/mm/yyyy HH:MM:SS');

% data=csvread(fullfile('E:\Users\Public\Documents\data\energy\SEMO\2009\','SEMO.Aoife.data.2009.csv'));
% dns=datenum(data(:,[3 2 1 4 5 6]));
 
%% plot to visually check for time base errors
diffdns=diff(dns);
plot(diffdns,'k-+');
grid on;
ylim([-0.1 0.1]);

%check_gen=data(:,3)-data(:,4)-data(:,5); % sys demand minus wind gen minus non wind gen
%disp(['Maxmax(check_gen)
%min(check_gen)
%%
duplicate_ranges=find(diffdns==0);

disp('Possible timing errors at rows:')
find(abs(diffdns-0.02)>0.01)

disp('Possible duplicate values at rows:');
duplicate_ranges

disp('Finished.')