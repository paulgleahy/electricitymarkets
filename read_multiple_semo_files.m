%% read_multiple_semo_files.m
% PL 28.01.2010
% 
% Read SEMO data from all files in a location folder.
% using read_semo_data().
% 
% INPUTS
% path_semo         path to semo excel files folder
% sheet_name        worksheet to read within excel file(s)
% dateheader    	column header string to identify date
% dataheader    	column header string to identify data
% 
% OUTPUTS
% datenums          vector of datenums
% values            vector of values
% n_files           number of files read.
%
% NB : datenums, values vectors are not truncated to the start_datenum,
% end_datenum - just to nearest file beginning/end dates
% 
% 
function [datenums values n_files filenames]=read_multiple_semo_files(path_semo,sheet_name,date_header,data_header)

%% get the file list
d=dir(fullfile(path_semo,'*Reports*.xls'));
n_files=numel(d);
filenames=cell(1,n_files);


%% extract the dates to matlab datenumbers
% (last 8 characters before .xls)
file_datenums=NaN+ones(n_files,1);
for i_file=1:n_files
    curr_filename=d(i_file).name;
    curr_filename=strrep(curr_filename,'_RUN',''); % some filenames have _RUN inserted. remove tehse.
    k = strfind(curr_filename, '.xls');
    datestring=curr_filename((k-8):(k-1));
    yyyy=str2double(datestring(5:8));
    mm=str2double(datestring(3:4));
    dd=str2double(datestring(1:2));
    file_datenums(i_file)=datenum([yyyy mm dd  0 0 0]);
    filenames{i_file}=curr_filename;
end

%% sort the files in order of increasing date number:
[datenums_s i_datenums]=sort(file_datenums,'ascend');
filenames=filenames(i_datenums);
%% read the files in date order and append the data
datenums=[];values=[]; % (initialise)
for i_file=1:n_files
    curr_filename= d(i_datenums(i_file)).name;
    [curr_datenums curr_values] = read_semo_data(fullfile(path_semo,curr_filename),sheet_name,date_header,data_header);
    size(datenums)
    datenums=[datenums curr_datenums'];
    values=[values curr_values'];    
end

%% check for duplicates; if present, discard and use most recent
[datenums, i_datenums, n] = unique(datenums, 'last');
values=values(i_datenums);
if (numel(n)>numel(datenums))
    warning('Duplicate entries detected and discarded.');
end

mark;
