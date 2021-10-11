%% read_semo_data.m
% PL 18/06/2009 modified 28.01.2010
% 
% Read a data column from SEMO spreadsheets.
% *NB* Use only for the EA, EP1 or EP2 worksheets
%
% INPUTS
% filename      SEMO excel file name
% sheetname     worksheet name within excel file
% dateheader    column header string to identify date
% dataheader    column header string to identify data
% 
% OUTPUTS
% datenums
% values
function [datenums values]=read_semo_data(filename,sheetname,dateheader,dataheader)
%skip_lines=4; 
[num txt raw]= xlsread(filename, sheetname);

%% locate columns containing the date & time info
date_position=strcmp(raw,dateheader);
data_position=strcmp(raw,dataheader);
[dmax date_row]=max(max(date_position'));
[dmax date_col]=max(max(date_position));
[amax data_row]=max(max(data_position'));
[amax data_col]=max(max(data_position));


%% convert the dates
datenums=datenum(raw((date_row+1):end,  date_col),'dd/mm/yyyy HH:MM:SS'); % DELIVERY period (day)
%datenums=datenums+(str2double(num(1:end, 1)))./24; % add hours
%% adjust for 00:00 being assigned to wrong (previous) day:
%datenums_0000=find(datenums==floor(datenums));
%datenums(datenums_0000)=datenums(datenums_0000)+1;

%% discard duplicates
[datenums m n]=unique(datenums);

% datenums=datenums+num(:,1)./24;
% datenums=datenums+num(:,2)./48; % 30 min interval
% datenums_combined=datenums(1:2:end);

% 
values=cell2mat(raw((data_row+1):end,data_col));
values=values(m); % discard duplicates