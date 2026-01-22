clear
close all
clc

load all_round1_gps_real_10.mat
load all_round1_gps_real_18.mat
load all_round1_gps_real_23.mat
load all_round1_gps_real_24.mat
load all_round1_gps_real_32.mat
load all_round1_bds_real_24.mat
load all_round1_bds_real_25.mat
load all_round1_bds_real_26.mat
load all_round1_bds_real_33.mat
load all_round1_bds_real_38.mat
load all_round1_bds_real_39.mat


% load all_round1_gps_reference_10.mat
% load all_round1_gps_reference_18.mat
% load all_round1_gps_reference_23.mat
% load all_round1_gps_reference_24.mat
% load all_round1_gps_reference_32.mat
% load all_round1_bds_reference_24.mat
% load all_round1_bds_reference_25.mat
% load all_round1_bds_reference_26.mat
% load all_round1_bds_reference_33.mat
% load all_round1_bds_reference_38.mat
% load all_round1_bds_reference_39.mat


% load all_round1_gps_final_10.mat
% load all_round1_gps_final_18.mat
% load all_round1_gps_final_23.mat
% load all_round1_gps_final_24.mat
% load all_round1_gps_final_32.mat
% load all_round1_bds_final_24.mat
% load all_round1_bds_final_25.mat
% load all_round1_bds_final_26.mat
% load all_round1_bds_final_33.mat
% load all_round1_bds_final_38.mat
% load all_round1_bds_final_39.mat



GPS_second=547606-108:1:547606+348;
GPS_week=2225;


% prn_all=[10,12,15,18,23,24,32,1,3,6,8,13,14,16,24,25,26,33,38,39,42];
prn_all=[10,18,23,24,32,24,25,26,33,38,39,42];

index=109:109+348;
% index=201:549;

% for j = 1:21
%     current_satellite = prn_all(j);
%     if j==1||(j>=4&&j<=7)
%     % XX=x{5}(:,index);
%     eval(['XX=', 'x_',num2str(current_satellite),'{5};']);
%     elseif j>=2&&j<=3
%     eval(['XX=', 'x_',num2str(current_satellite),'{4};']);
%     elseif j>=8&&j<=14
%     eval(['XX=', 'x_bds_',num2str(current_satellite),'{2};']);
%     elseif j>14
%     eval(['XX=', 'x_bds_',num2str(current_satellite),'{5};']);
%     end
%
%     for i = 1:1:size(XX,2)
%         if XX(2,i)==1&&XX(1,i)==0
%             color_select{j,:}(:,i)=[0;1;0];
%         elseif XX(1,i)==1&&XX(2,i)==0
%             color_select{j,:}(:,i)=[1; 0; 0];
%         elseif XX(1,i)==0&&XX(2,i)==0&&XX(3,i)==0
%             color_select{j,:}(:,i)=[0;0;0];
%         elseif XX(1,i)==1&&XX(2,i)==1&&XX(3,i)==1
%             color_select{j,:}(:,i)=[112/255;48/255;160/255];
%         end
%     end
% end


for j = 1:11
    current_satellite = prn_all(j);
    if j==1||(j>=1&&j<=5)
        % XX=x{5}(:,index);
        eval(['XX=', 'x_',num2str(current_satellite),'{5};']);
    elseif j>=6&&j<=11
        eval(['XX=', 'x_bds_',num2str(current_satellite),'{5};']);
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




% 假设输入是GPS周内秒（Seconds of Week）和GPS周数（Week Number）
% gps_seconds = 302400; % 示例：1980年1月6日00:00:18（UTC）
% gps_week = 0;

% 1. 计算自GPS起始时刻以来的总秒数
total_gps_seconds = GPS_week * 7 * 24 * 3600 + GPS_second;

% 2. 创建以GPS起始点为基准的datetime对象
gps_time = datetime(1980, 1, 6, 0, 0, total_gps_seconds, 'TimeZone', 'UTC','Format','yyyy-MM-dd HH:mm:ss');

% 3. 减去闰秒差（当前为18秒）得到UTC时间
utc_time = gps_time - seconds(18);

% 显示结果
% disp('UTC时间:');
% disp(utc_time);

% eval(['x_', num2str(current_satellite), ' = x;']);


% save_filename = sprintf('all_round1_gps_real_%d.mat', current_satellite);
% save_valuename= sprintf('x_%d', current_satellite);
% save(save_filename, save_valuename);

for k =1:1:11
p1 = scatter(utc_time(index), k*ones(1,length(utc_time(index))),50,color_select{k}(:,index)','filled');
hold on
end

% for k = 1:1:11
%     if k<=5
%         p1 = scatter(utc_time, k*ones(1,length(utc_time)),50,color_select{k}','filled');
%     else
%         p1 = scatter(utc_time, k*ones(1,length(utc_time)),50,color_select{k}(:,index)','filled');
%     end
%     hold on
% end
ax = gca;
ax.XAxis.TickLabelFormat = 'HH:mm:ss'; 
startTime = datetime('2022-09-03 08:06:00', 'TimeZone', 'UTC','Format','yyyy-MM-dd HH:mm:ss');
endTime = datetime('2022-09-03 08:13:00', 'TimeZone', 'UTC','Format','yyyy-MM-dd HH:mm:ss');
xlim([startTime, endTime]);
ylim([0.5 12.5])


set(ax,'YTick',...
    [0 1 2 3 4 5 6 7 8 9 10 11],'YTickLabel',...
    {'','G10','G18','G23','G24','G32','C24' ,'C25','C26','C33','C38','C39'});


