clear; 
close all;
clc;

load viald_result_40dB_bds_NEPLA.mat
load viald_result_40dB_BOC_NEPLA.mat
thrhold_IQ=[0.140,0.121,0.106,0.093,0.082,0.073,0.065,0.057,0.051,0.046,0.041,0.036,0.029,0.025,0.023,0.02,0.018];
CN0=29:1:45;
for i =1:1:size(result_Area,1)
    for j =1:1:61
        
        index_IQ.L1=find(fix(CN0MP{i,j}.L1)==CN0);
        index_IQ.L2=find(fix(CN0MP{i,j}.L2)==CN0);
        index_IQ.L5=find(fix(CN0MP{i,j}.L5)==CN0);
        index_IQ.BOC=find(fix(CN0MP_BOC{i,j}.L2)==CN0);
        IQ_mp.L1=find(result_Area{i,j}.L1_Multipath>thrhold_IQ(index_IQ.L1));
        IQ_mp.L2=find(result_Area{i,j}.L2_Multipath>thrhold_IQ(index_IQ.L2));
        IQ_mp.L5=find(result_Area{i,j}.L5_Multipath>thrhold_IQ(index_IQ.L5));
        IQ_mp.BOC=find(result_Area_BOC{i,j}.L2_Multipath>thrhold_IQ(index_IQ.BOC));
        IQ_mp.all=find((result_Area_BOC{i,j}.L2_Multipath+result_Area{i,j}.L2_Multipath+result_Area{i,j}.L5_Multipath)>thrhold_IQ(index_IQ.BOC)+thrhold_IQ(index_IQ.L2)+thrhold_IQ(index_IQ.L5));
        IQ_mp_detection_L1(i,j)=size(IQ_mp.L1,1)./100;
        IQ_mp_detection_L2(i,j)=size(IQ_mp.L2,1)./100;
        IQ_mp_detection_L5(i,j)=size(IQ_mp.L5,1)./100;
        IQ_mp_detection_BOC(i,j)=size(IQ_mp.BOC,1)./100;
        IQ_mp_detection_all(i,j)=size(IQ_mp.all,1)./100;
    end
end

IQ_mp_detection=IQ_mp_detection_all;

x=0:2:502;

y=0:0.005:0.3;

z3=IQ_mp_detection';

[X,Y]=meshgrid(x,y);
Z=z3;

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



% 2. 设置等高线层级
z_min = min(Z(:));
z_max = max(Z(:));
levels = linspace(0, z_max, numColors+1);

% 3. 绘图
figure('Position', [200, 100, 1200, 500], 'Color', 'white');
% contourf(X, Y, Z, levels, 'LineStyle', 'none'); % 填充等高线，无边框
hold on;
[C, h] = contour(Z, 10, 'LineColor', [0.6 0.6 0.6], 'LineWidth', 1.5, 'LineStyle', '--','LabelSpacing',3000);
h.LevelList = [0,0.2,0.3,0.4,0.5,0.6,0.7,0.8,1]; 
% 设置坐标轴
set(gca, 'YDir', 'normal');
set(gca, 'Box', 'off');
set(gca, 'TickDir', 'out');
set(gca, 'LineWidth', 1);
set(gca, 'FontName', 'Helvetica', 'FontSize', 25);


colormap(custom_map); % 应用自定义colormap
caxis([z_min, z_max]); % 固定颜色映射范围
colorbar % 添加colorbar


%% 4. 添加精致的颜色条
cbar = colorbar('eastoutside', 'Ticks', 0:0.2:1, ...
                'TickDirection', 'out', ...
                'Box', 'off', ...
                'LineWidth', 1);
cbar.Label.String = 'Detection Rate';
cbar.Label.FontSize = 25;
cbar.Label.FontName = 'Helvetica';

% 4. 调整colorbar刻度
% cbar = colorbar;
tick_positions = (levels(1:end-1) + levels(2:end)) / 2;
set(cbar, 'Ticks', tick_positions);
% cbar.TickLabels = {'0', '0.2', '0.4', '0.6', '0.8', '1.0'};
cbar.TickLabels = {'0','0.1', '0.2', '0.3', '0.4', '0.5','0.6','0.7','0.8','0.9','1'};

set(gca,'FontName','Helvetica','FontSize', 25,'XTick',[1,25,50,75,100,125,150,175,200,225,250],'XTickLabel',{'0','50','100','150','200','250','300','350','400','450','500'},'YTick',...
    [1 11 21 31 41 51 61],'YTickLabel',...
    {'0','5','10','15','20','25','30'}); % 修改坐标轴字体大小





