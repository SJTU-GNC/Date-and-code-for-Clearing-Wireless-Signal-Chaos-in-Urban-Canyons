clear;
close all;
clc;

load all_round1_gps_reference_10.mat
load all_round1_gps_reference_18.mat
load all_round1_gps_reference_23.mat
load all_round1_gps_reference_24.mat
load all_round1_gps_reference_32.mat
load all_round1_bds_reference_24.mat
load all_round1_bds_reference_25.mat
load all_round1_bds_reference_26.mat
load all_round1_bds_reference_33.mat
load all_round1_bds_reference_38.mat
load all_round1_bds_reference_39.mat
GPS_second=547606:1:547606+348;
GPS_week=2225;


total_gps_seconds = GPS_week * 7 * 24 * 3600 + GPS_second;

gps_time = datetime(1980, 1, 6, 0, 0, total_gps_seconds, 'TimeZone', 'UTC','Format','yyyy-MM-dd HH:mm:ss');


utc_time = gps_time - seconds(18);

prn_all=[10,18,23,24,32,24,25,26,33,38,39,42];

index=201:549;

for j = 1:11
    current_satellite = prn_all(j);
    if j==1||(j>=1&&j<=5)
        eval(['XX=', 'x_ref_',num2str(current_satellite),'{5};']);
    elseif j>=6&&j<=11
        eval(['XX=', 'x_ref_bds_',num2str(current_satellite),'{5};']);
    end

    for i = 1:1:size(XX,2)
        if XX(2,i)==1&&XX(1,i)==0
            color_select{j,:}(:,i)=[0;1;0];
        elseif XX(1,i)==1&&XX(2,i)==0
            color_select{j,:}(:,i)=[1; 0; 0];
        elseif XX(1,i)==0&&XX(2,i)==0&&XX(3,i)==0
            color_select{j,:}(:,i)=[0;0;0];
        elseif XX(1,i)==1&&XX(2,i)==1&&XX(3,i)==1
            color_select{j,:}(:,i)=[0;0;1];
        end
    end
end
for k = 1:1:11
    if k<=5
        p1 = scatter(utc_time, k*ones(1,length(utc_time)),50,color_select{k}','filled');
    else
        p1 = scatter(utc_time, k*ones(1,length(utc_time)),50,color_select{k}(:,index)','filled');
    end
    hold on
end


ax = gca;
ax.XAxis.TickLabelFormat = 'HH:mm:ss'; 
startTime = datetime('2022-09-03 08:06:00', 'TimeZone', 'UTC','Format','yyyy-MM-dd HH:mm:ss');
endTime = datetime('2022-09-03 08:13:00', 'TimeZone', 'UTC','Format','yyyy-MM-dd HH:mm:ss');
xlim([startTime, endTime]);
ylim([0.5 12.5])


set(ax,'YTick',...
    [0 1 2 3 4 5 6 7 8 9 10 11],'YTickLabel',...
    {'','G10','G18','G23','G24','G32','C24' ,'C25','C26','C33','C38','C39'});