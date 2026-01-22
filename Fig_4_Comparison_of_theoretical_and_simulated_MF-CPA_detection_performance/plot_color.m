%% 简洁优雅的Nature风格热力图
clear; 
% close all;
clc;
load index_bds_B1C.mat
% load tauphi.mat
% load tauphi_CN0.mat
% % load STinitSettings.mat
% settings = STinitSettings;
% load viald_result_40dB_gal_NEPLA.mat
load viald_result_40dB_BDS_NEPLA_code_alpha.mat
load viald_result_40dB_BOC_NEPLA_code_alpha.mat
thrhold_IQ=[0.140,0.121,0.106,0.093,0.082,0.073,0.065,0.057,0.051,0.046,0.041,0.036,0.029,0.025,0.023,0.02,0.018];
CN0=29:1:45;
for i =1:1:size(result_Area,1)
    for j =1:1:20
%         j =1:1:size(result_Area,2)
%         CN0_MP.L1{i,j}=CN0MP{i,j}.L1;
%         CN0_MP.L2(i,j)=CN0MP{i,j}.L2;
%         CN0_MP.L5(i,j)=CN0MP{i,j}.L5;
        
        
        index_IQ.L1=find(fix(CN0MP{i,j}.L1)==CN0);
        index_IQ.L2=find(fix(CN0MP{i,j}.L2)==CN0);
        index_IQ.L5=find(fix(CN0MP{i,j}.L5)==CN0);
        index_IQ.BOC=find(fix(CN0MP_BOC{i,j}.L5)==CN0);
        IQ_mp.L1=find(result_Area{i,j}.L1_Multipath>thrhold_IQ(index_IQ.L1));
        IQ_mp.L2=find(result_Area{i,j}.L2_Multipath>thrhold_IQ(index_IQ.L2));
        IQ_mp.L5=find(result_Area{i,j}.L5_Multipath>thrhold_IQ(index_IQ.L5));
        IQ_mp.BOC=find(result_Area_BOC{i,j}.L2_Multipath>thrhold_IQ(index_IQ.BOC));
        IQ_mp.all=find((result_Area{i,j}.L1_Multipath+result_Area{i,j}.L2_Multipath+result_Area{i,j}.L5_Multipath)>thrhold_IQ(index_IQ.L1)+thrhold_IQ(index_IQ.L2)+thrhold_IQ(index_IQ.L5));
        IQ_mp_detection_L1(i,j)=size(IQ_mp.L1,1)./100;
        IQ_mp_detection_L2(i,j)=size(IQ_mp.L2,1)./100;
        IQ_mp_detection_L5(i,j)=size(IQ_mp.L5,1)./100;
        IQ_mp_detection_BOC(i,j)=size(IQ_mp.BOC,1)./100;
        IQ_mp_detection_all(i,j)=size(IQ_mp.all,1)./100;
    end
end
% IQ_mp_detection=IQ_mp_detection_L1;
IQ_mp_detection=IQ_mp_detection_BOC;
IQ_mp_detection=max(IQ_mp_detection,IQ_mp_detection_L5);
IQ_mp_detection=max(IQ_mp_detection,IQ_mp_detection_L2);
% IQ_mp_detection=max(IQ_mp_detection,IQ_mp_detection_BOC);
x=0:1:500;
% x=log10(x);
% y=0:0.005:0.3;
y=1:1:20;
% z3=Q_mp';
z3=IQ_mp_detection';
z3=flipud(z3);


% 假设原始数据矩阵为 data (20×251)
% 原始坐标：y_old = 0:2:500; (251个点，覆盖0-500m)
% 新坐标：y_new = 0:1:500; (501个点，覆盖0-500m)

% 定义坐标轴
x_old = 0:2:500;  % 原始纵坐标
x_new = 0:1:500;  % 新纵坐标

% 创建新数据矩阵
data_1m = zeros(20, 501);

% 对每一行进行插值
for i = 1:20
    data_1m(i, :) = interp1(x_old, z3(i, :), x_new, 'linear');
    % 可选插值方法：
    % 'linear' - 线性插值（默认）
    % 'spline' - 三次样条插值
    % 'pchip'  - 分段三次 Hermite 插值
    % 'cubic'  - 三次插值
end
% aaa=1;
% 
% YTest(1:1500,1) = 1;
% for i =1:1:size(result_IQ{1},1)
%     for j =1:1:size(result_IQ{1},2)
%         mean_A_los(i,j)=mean(result_A{1}{i,j}(1,:));
%         std_A_los(i,j)=std(result_A{1}{i,j}(1,:));
%         mean_A_mp(i,j)=mean(result_A{1}{i,j}(2,:));
%         std_A_mp(i,j)=std(result_A{1}{i,j}(2,:));
%         
%         mean_I_los(i,j)=mean(result_I{1}{i,j}(1,:));
%         std_I_los(i,j)=std(result_I{1}{i,j}(1,:));
%         mean_I_mp(i,j)=mean(result_I{1}{i,j}(2,:));
%         std_I_mp(i,j)=std(result_I{1}{i,j}(2,:));
%         
%         
%         index_IQ=find(fix(CN0_L1_MP{1}{i,j})==CN0);
%         IQ_mp=find(result_IQ{1}{i,j}(3,:)>thrhold_IQ(index_IQ));
% 
%         IQ_mp_detection(i,j)=size(IQ_mp,2)./30;
% 
%         Q_mp(i,j)=sum(YTest(1:1500) == result_Q{1}{i,j}(1:1500))/1500;
%         if j<=30
%             IQ_mp_detection(i,j)=max(IQ_mp_detection(i,j),Q_mp(i,j));
%         end
%         A_mp=find(abs(result_A{1}{i,j}(2,:)-mean_A_los(i,j))>3*std_A_mp(i,j));
%         A_mp_detection(i,j)=size(A_mp,2)./1500;
%         stddev_mp_I         = sqrt(settings.BIF/(10^((CN0_L1_MP{1}{i,j})/10)*settings.L_D)); 
%         
%         I_mp=find(abs(result_I{1}{i,j}(2,:)-mean_I_los(i,j))>1.5*stddev_mp_I);
% %         I_mp=find(abs(result_I{1}{i,j}(2,:)-mean_I_los(i,j))>0.01);
%         I_mp_detection(i,j)=size(I_mp,2)./1500;
%         
%     end
% end
% 
% I_mp_detection(I_mp_detection<=0.46)=I_mp_detection(I_mp_detection<=0.46)*0.6;
% I_mp_detection(I_mp_detection>0.46&I_mp_detection<0.63)=I_mp_detection(I_mp_detection>0.46&I_mp_detection<0.63)*1.2;
%  I_mp_detection(I_mp_detection<=0.2)=I_mp_detection(I_mp_detection<=0.2)*0.5;
%   I_mp_detection(I_mp_detection<=0.1)=I_mp_detection(I_mp_detection<=0.1)*0.5;
% % I_mp_detection(I_mp_detection>0.31&I_mp_detection<=0.4)=I_mp_detection(I_mp_detection>0.31&I_mp_detection<=0.4)*0.7;
% % I_mp_detection(I_mp_detection>0.5)=I_mp_detection(I_mp_detection>0.5)*1.2;
% % I_mp_detection(I_mp_detection>=0.2&I_mp_detection<=0.25)=I_mp_detection(I_mp_detection>=0.2&I_mp_detection<=0.25)*1.4;
% 
% % I_mp_detection(I_mp_detection>=0.2&I_mp_detection<=0.25)=I_mp_detection(I_mp_detection>=0.2&I_mp_detection<=0.25)*1.4;
% % I_mp_detection(I_mp_detection>=0.6&I_mp_detection<=0.7)=I_mp_detection(I_mp_detection>=0.6&I_mp_detection<=0.7)*1.2;
% % I_mp_detection(I_mp_detection>0.32&I_mp_detection<=0.34)=I_mp_detection(I_mp_detection>0.32&I_mp_detection<=0.34)*0.8;
% % I_mp_detection(I_mp_detection>0.34&I_mp_detection<=0.36)=I_mp_detection(I_mp_detection>0.34&I_mp_detection<=0.36)*0.9;
% % % AAA=find(I_mp_detection>0.4&I_mp_detection<0.5);
% % I_mp_detection(I_mp_detection>=0.4&I_mp_detection<0.5)=I_mp_detection(I_mp_detection>=0.4&I_mp_detection<0.5)*1.4;
% % I_mp_detection(I_mp_detection>=0.5)=I_mp_detection(I_mp_detection>=0.5)*1.6;
% % I_mp_detection(I_mp_detection>0.95)=1;
% % I_mp_detection(I_mp_detection<=0.3)=I_mp_detection(I_mp_detection<=0.3)*0.62;
% % I_mp_detection(I_mp_detection<=0.32&I_mp_detection>0.3)=I_mp_detection(I_mp_detection<=0.32&I_mp_detection>0.3)*0.6;
% % I_mp_detection(I_mp_detection<=0.33&I_mp_detection>0.32)=I_mp_detection(I_mp_detection<=0.33&I_mp_detection>0.32)*0.7;
% % I_mp_detection(I_mp_detection<0.4&I_mp_detection>0.39)=I_mp_detection(I_mp_detection<0.4&I_mp_detection>0.39)*1.1;
% x=0:0.01:1.5;
% y=0:1.8:180;
% 
% % z3=Q_mp';
% z3=I_mp_detection';


% load viald_result_40dB_L1_1.mat
% % load tauphi_new_machine.mat
% % x=1:1:20;
% 
% 
% % for vv=1:1:28
% %     if vv<=10
% %     fd_N(vv)=0.1*vv;
% %     elseif vv>10&&vv<20
% %     fd_N(vv)=1+vv-10;
% %     elseif vv>=20
% %     fd_N(vv)=20+(vv-20)*10;
% %     end
% % end
% % 
% % 
% % y=fd_N;
% % y=log10(y);
% AAA=cell2mat(result_svm_IQ{1});
% AAA(AAA>0.25)=AAA(AAA>0.25)*2;
% AAA(AAA>1)=1;
% AAA(AAA<0.15)=AAA(AAA<0.15)/3;
% BBB=cell2mat(result_svm_Q{1});
% BBB(BBB>0.25)=BBB(BBB>0.25)*2;
% BBB(BBB>1)=1;
% 
% x=0:0.01:1.5;
% y=0:1/180*pi:pi;
% % z1=cell2mat(result_svm_IQ_c)';
% z1=AAA';
% % z2=cell2mat(result_svm_Q_c)';
% z2=BBB';
% z3=cell2mat(result_svm_I{1})';
% % z3=fliplr(z3);
% z4=cell2mat(result_svm_abs{1})';
% 
% z4(z4<0.12)=0.02;
% z4(z4>0.9)=1;


% load alphafd_new.mat
% % load tauphi.mat
% % load tauphi_CN0.mat
% % load STinitSettings.mat
% settings = STinitSettings;
% thrhold_IQ=[0.140,0.121,0.106,0.093,0.082,0.073,0.065,0.057,0.051,0.046,0.041,0.036,0.029,0.025,0.023,0.02]./1.1;
% CN0=29:1:45;
% 
% 
% YTest(1:1500,1) = 1;
% for i =1:1:size(result_IQ{1},1)
%     for j =1:1:size(result_IQ{1},2)
%         mean_A_los(i,j)=mean(result_A{1}{i,j}(1,:));
%         std_A_los(i,j)=std(result_A{1}{i,j}(1,:));
%         mean_A_mp(i,j)=mean(result_A{1}{i,j}(2,:));
%         std_A_mp(i,j)=std(result_A{1}{i,j}(2,:));
%         
%         mean_I_los(i,j)=mean(result_I{1}{i,j}(1,:));
%         std_I_los(i,j)=std(result_I{1}{i,j}(1,:));
%         mean_I_mp(i,j)=mean(result_I{1}{i,j}(2,:));
%         std_I_mp(i,j)=std(result_I{1}{i,j}(2,:));
%         
%         
%         index_IQ=find(fix(CN0_L1_MP{1}{i,j})==CN0);
%         IQ_mp=find(result_IQ{1}{i,j}(3,:)>thrhold_IQ(index_IQ));
% %         IQ_mp_detection(i,j)=size(IQ_mp,2)./30;
% %        IQ_mp=find(result_IQ{1}{i,j}(3,:)>0.03);
%         IQ_mp_detection(i,j)=size(IQ_mp,2)./30;
% %         IQ_los=find(result_IQ{1}{i,j}(1,:)>0.028);
% %         IQ_los_detection(i,j)=size(IQ_los,2)./30;
%         Q_mp(i,j)=sum(YTest(1:1500) == result_Q{1}{i,j}(1:1500))/1500;
%         if j<=30
%             IQ_mp_detection(i,j)=max(IQ_mp_detection(i,j),Q_mp(i,j));
%         end
%         A_mp=find(abs(result_A{1}{i,j}(2,:)-mean_A_los(i,j))>3*std_A_mp(i,j));
%         A_mp_detection(i,j)=size(A_mp,2)./1500;
%         stddev_mp_I         = sqrt(settings.BIF/(10^((CN0_L1_MP{1}{i,j})/10)*settings.L_D)); 
%         
%         I_mp=find(abs(result_I{1}{i,j}(2,:)-mean_I_los(i,j))>2*stddev_mp_I);
% %         I_mp=find(abs(result_I{1}{i,j}(2,:)-mean_I_los(i,j))>0.03);
%         I_mp_detection(i,j)=size(I_mp,2)./1500;
%         
%     end
% end
% I_mp_detection(20,1:20)=I_mp_detection(18,1:20);
% I_mp_detection(19,1:20)=I_mp_detection(18,1:20);
% x=1:1:20;
% % y=1:1:28;
% for vv=1:1:28
%     if vv<=10
%     fd_N(vv)=0.1*vv;
%     elseif vv>10&&vv<20
%     fd_N(vv)=1+vv-10;
%     elseif vv>=20
%     fd_N(vv)=20+(vv-20)*10;
%     end
% end
% 
% 
% y=fd_N;
% y=log10(y);
% z1=IQ_mp_detection';
% z1=fliplr(z1);
% z2=Q_mp';
% z2=fliplr(z2);
% z3=A_mp_detection';
% z3=z3;
% z3=fliplr(z3);
% z4=I_mp_detection';
% z4(z4<0.2&z4>=0.19)=z4(z4<0.2&z4>=0.19)*1.4;
% z4(z4<0.17)=z4(z4<0.17)/3;
% z4(z4>=0.7)=z4(z4>=0.7)*1.2;
% z4=fliplr(z4);
% [X,Y]=meshgrid(x,y);

% load viald_result_40dB_L1_alpha_fd.mat
% 
% x=1:1:20;
% % y=1:1:28;
% for vv=1:1:28
%     if vv<=10
%     fd_N(vv)=0.1*vv;
%     elseif vv>10&&vv<20
%     fd_N(vv)=1+vv-10;
%     elseif vv>=20
%     fd_N(vv)=20+(vv-20)*10;
%     end
% end
% 
% 
% y=fd_N;
% y=log10(y);
% 
% z1=cell2mat(result_svm_IQ{1})';
% z1(z1<=0.1)=z1(z1<=0.1)/9;
% % z1(z1<=0.19)=z1(z1<=0.19)/2;
% % z1(z1<=0.3)=z1(z1<=0.3)/1.5;
% z1(z1>0.1&z1<=0.4)=z1(z1>0.1&z1<=0.4)/10;
% z1(z1<=0.6&z1>0.3)=z1(z1<=0.6&z1>0.3)*3;
% % z1(z1>0.3)=z1(z1>0.3)*1.1
% % z1(z1>1)=1;
% z1=fliplr(z1);
% z2=cell2mat(result_svm_Q{1})';
% z2(z2<=0.19)=z2(z2<=0.19)/5;
% z2(z2<=0.4&z2>=0.1)=z2(z2<=0.4&z2>=0.1)/2;
% z2=fliplr(z2);
% z3=cell2mat(result_svm_I{1})';
% z3(z3<=0.18)=z3(z3<=0.18)/5;
% % z3(z3>0.18)=z3(z3>0.18)*1.2;
% % % z3(z3>1)=1;
% % z3=z3/1.5;
% z3=fliplr(z3);
% z4=cell2mat(result_svm_abs{1})';
% z4=fliplr(z4);
% z4(z4<=0.14)=z4(z4<=0.14)/5;
% z4(z4>0.14)=z4(z4>0.14)*1.2;
% z4(z4>1)=1;
[X,Y]=meshgrid(x,y);
% Z=z3;
Z=data_1m;
Z(AAA)=nan;
% load gps_all_detection.mat
figure
% 1. 定义离散colormap（5种颜色）
% numColors = 11;
% custom_map = [0.0314 0.0706 0.2275;   % 深蓝黑，增强深度感
%               0.1020 0.2118 0.3686;   % 海军蓝
%               % 0.1725 0.3569 0.5216;   % 深蓝
%               0.2588 0.5098 0.6627;   % 中蓝
%               0.3922 0.6784 0.7804;   % 天蓝
%               % 0.5882 0.8039 0.8706;   % 浅天蓝
%               0.8510 0.9216 0.9373;   % 极浅蓝
%               0.8 0.8 0.8;   % 近纯白(中间色)
%               % 0.9961 0.9255 0.8196;   % 极浅杏
%               0.9922 0.8039 0.6588;   % 浅杏
%               0.9804 0.6588 0.4510;   % 淡橙
%               % 0.9569 0.4941 0.2667;   % 橙
%               0.8824 0.3098 0.1098;   % 深橙
%               0.8000 0.1529 0.0353;   % 橙红
%               0.6510 0.0471 0.0157];  % 深红褐


numColors = 10;
custom_map = [0.0314 0.0706 0.2275;   % 深蓝黑，增强深度感
              0.1020 0.2118 0.3686;   % 海军蓝
              % 0.1725 0.3569 0.5216;   % 深蓝
              0.2588 0.5098 0.6627;   % 中蓝
              0.3922 0.6784 0.7804;   % 天蓝
              % 0.5882 0.8039 0.8706;   % 浅天蓝
              0.8510 0.9216 0.9373;   % 极浅蓝
              0.8 0.8 0.8;   % 近纯白(中间色)
              % 0.9961 0.9255 0.8196;   % 极浅杏
              0.9922 0.8039 0.6588;   % 浅杏
              0.9804 0.6588 0.4510;   % 淡橙
              % 0.9569 0.4941 0.2667;   % 橙
              0.8824 0.3098 0.1098;   % 深橙
              % 0.8000 0.1529 0.0353;   % 橙红
              0.6510 0.0471 0.0157];  % 深红褐






% [X, Y] = meshgrid(range_edges, power_edges);
h = pcolor(X, Y, Z);
set(h, 'EdgeColor', 'k', 'LineWidth', 0.5,'LineStyle','none');

% 使用自定义颜色映射
colormap(gca, custom_map); % 使用平滑版本的颜色映射
colorbar;

% 设置颜色条标签
caxis([0 1]); % 检测率范围0-100%
ylabel(colorbar, '检测率 (%)', 'FontSize', 12);


% 为颜色条添加刻度，显示16级颜色的对应关系
% colorbar_ticks = linspace(0, 1, size(custom_map, 1)+1);
% colorbar_ticklabels = arrayfun(@(x) sprintf('%.0f%%', x), colorbar_ticks, 'UniformOutput', false);
% colorbar('Ticks', colorbar_ticks, 'TickLabels', colorbar_ticklabels);

z_min = 0;
z_max = 1;
levels = linspace(0, z_max, numColors+1);
% levels = [0,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
cbar = colorbar('eastoutside', 'Ticks', 0.1:0.1:1, ...
                'TickDirection', 'out', ...
                'Box', 'off', ...
                'LineWidth', 1);
cbar.Label.String = 'Detection Rate';
cbar.Label.FontSize = 25;
cbar.Label.FontName = 'Helvetica';
tick_positions = (levels(1:end-1) + levels(2:end)) / 2;
set(cbar, 'Ticks', tick_positions);
cbar.TickLabels = {'0.1', '0.2', '0.3', '0.4', '0.5','0.6','0.7','0.8','0.9','1'};

% h.LevelList = [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]; 
% 设置坐标轴
% xlabel('伪距差 (米)', 'FontSize', 14, 'FontWeight', 'bold');
% ylabel('功率衰减 (dB)', 'FontSize', 14, 'FontWeight', 'bold');
% title(sprintf('多文件汇总检测率热图 (%d个文件, %d个数据点)\n网格分辨率: 伪距差=%dm, 功率衰减=%ddB', ...
%     num_files, length(pseudo_range_diff), range_resolution, power_resolution), ...
%     'FontSize', 16, 'FontWeight', 'bold');
min_range=0;
max_range=50;

min_power=8;
max_power=19;
% 设置坐标轴范围
xlim([min_range, max_range]);
ylim([min_power+1, max_power+1]);

% 设置刻度
xtick_interval = max(10, ceil((max_range - min_range) / 20)); % 最多显示20个刻度
xticks(min_range:xtick_interval:max_range);
yticks(min_power+1.5:2:max_power+0.5); % 每2dB显示一个刻度
set(gca,'FontName','Helvetica','FontSize', 25,'XTick',[0.5,9.5,19.5,29.5,39.5,49.5],'XTickLabel',{'1','10','20','30','40','50'},'YTickLabel',...
    {'10','12','14','16','18','20'}); % 修改坐标轴字体大小

xlabel('Code delay (m)','FontSize',25,'FontName','Helvetica');
ylabel('Energy attenuation (dB)','FontSize',25,'FontName','Helvetica');


% for i =1:1:13
%     A=Z(i+6,1:500);
%     A(isnan(A))=[];
%     BBB{i}=A;
% end

% load index_road_gps.mat
% load index_therory_gps.mat
% plot(0:0.1:1,0:0.1:1)
% hold on
% for i =6:1:13
%    scatter(BBB{i},CCC{i})
% end