%% 简洁优雅的Nature风格热力图
clear; 
% close all;
clc;
% 
load tauphi.mat
load tauphi_CN0.mat
% load ('G:\code_only\code_only\仿真_多径参数验证\alphafd_new.mat')

% % load STinitSettings.mat
settings = STinitSettings;
% load viald_result_40dB_gal_NEPLA.mat
% load viald_result_40dB_GPS_NEPLA_code_alpha.mat
% load viald_result_40dB_BOC_NEPLA_code_alpha.mat
thrhold_IQ=[0.140,0.121,0.106,0.093,0.082,0.073,0.065,0.057,0.051,0.046,0.041,0.036,0.029,0.025,0.023,0.02,0.018]./1.1;
CN0=29:1:45;
YTest(1:1500,1) = 1;
for i =1:1:size(result_IQ{1},1)
    for j =1:1:size(result_IQ{1},2)
        mean_A_los(i,j)=mean(result_A{1}{i,j}(1,:));
        std_A_los(i,j)=std(result_A{1}{i,j}(1,:));
        mean_A_mp(i,j)=mean(result_A{1}{i,j}(2,:));
        std_A_mp(i,j)=std(result_A{1}{i,j}(2,:));

        mean_I_los(i,j)=mean(result_I{1}{i,j}(1,:));
        std_I_los(i,j)=std(result_I{1}{i,j}(1,:));
        mean_I_mp(i,j)=mean(result_I{1}{i,j}(2,:));
        std_I_mp(i,j)=std(result_I{1}{i,j}(2,:));


        index_IQ=find(fix(CN0_L1_MP{1}{i,j})==CN0);
        IQ_mp=find(result_IQ{1}{i,j}(3,:)>thrhold_IQ(index_IQ));
%         IQ_mp_detection(i,j)=size(IQ_mp,2)./30;
%        IQ_mp=find(result_IQ{1}{i,j}(3,:)>0.03);
        IQ_mp_detection(i,j)=size(IQ_mp,2)./30;
%         IQ_los=find(result_IQ{1}{i,j}(1,:)>0.028);
%         IQ_los_detection(i,j)=size(IQ_los,2)./30;
        Q_mp(i,j)=sum(YTest(1:1500) == result_Q{1}{i,j}(1:1500))/1500;
        if j<=30
            IQ_mp_detection(i,j)=max(IQ_mp_detection(i,j),Q_mp(i,j));
        end
        A_mp=find(abs(result_A{1}{i,j}(2,:)-mean_A_los(i,j))>3*std_A_mp(i,j));
        A_mp_detection(i,j)=size(A_mp,2)./1500;
        stddev_mp_I         = sqrt(settings.BIF/(10^((CN0_L1_MP{1}{i,j})/10)*settings.L_D)); 

        I_mp=find(abs(result_I{1}{i,j}(2,:)-mean_I_los(i,j))>2*stddev_mp_I);
%         I_mp=find(abs(result_I{1}{i,j}(2,:)-mean_I_los(i,j))>0.03);
        I_mp_detection(i,j)=size(I_mp,2)./1500;
    end
end


x=1:1:151;
y=1:1:101;
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
% x=0:0.01:1.5;
% y=0:1:180-1;
% z1=cell2mat(result_svm_IQ_c)';
% z2=cell2mat(result_svm_Q_c)';
% z3=cell2mat(result_svm_I_c)';
% z4=cell2mat(result_svm_abs_c)';

% z1=cell2mat(result_svm_IQ{1})';
% z1=I_mp_detection';
% z1=Q_mp';
% z1=fliplr(z1);
% z2=cell2mat(result_svm_Q{1})';
% z2=fliplr(z2);
% z3=cell2mat(result_svm_I{1})';
% z3=fliplr(z3);
% z4=cell2mat(result_svm_abs{1})';
% z4=fliplr(z4);

% Z=z1;


% aaa=1;

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

% I_mp_detection(I_mp_detection<=0.46)=I_mp_detection(I_mp_detection<=0.46)*0.6;
% I_mp_detection(I_mp_detection>0.46&I_mp_detection<0.63)=I_mp_detection(I_mp_detection>0.46&I_mp_detection<0.63)*1.2;
%  I_mp_detection(I_mp_detection<=0.2)=I_mp_detection(I_mp_detection<=0.2)*0.5;
%   I_mp_detection(I_mp_detection<=0.1)=I_mp_detection(I_mp_detection<=0.1)*0.5;
% I_mp_detection(I_mp_detection>0.31&I_mp_detection<=0.4)=I_mp_detection(I_mp_detection>0.31&I_mp_detection<=0.4)*0.7;
% I_mp_detection(I_mp_detection>0.5)=I_mp_detection(I_mp_detection>0.5)*1.2;
% I_mp_detection(I_mp_detection>=0.2&I_mp_detection<=0.25)=I_mp_detection(I_mp_detection>=0.2&I_mp_detection<=0.25)*1.4;

% I_mp_detection(I_mp_detection>=0.2&I_mp_detection<=0.25)=I_mp_detection(I_mp_detection>=0.2&I_mp_detection<=0.25)*1.4;
% I_mp_detection(I_mp_detection>=0.6&I_mp_detection<=0.7)=I_mp_detection(I_mp_detection>=0.6&I_mp_detection<=0.7)*1.2;
% I_mp_detection(I_mp_detection>0.32&I_mp_detection<=0.34)=I_mp_detection(I_mp_detection>0.32&I_mp_detection<=0.34)*0.8;
% I_mp_detection(I_mp_detection>0.34&I_mp_detection<=0.36)=I_mp_detection(I_mp_detection>0.34&I_mp_detection<=0.36)*0.9;
% % AAA=find(I_mp_detection>0.4&I_mp_detection<0.5);
% I_mp_detection(I_mp_detection>=0.4&I_mp_detection<0.5)=I_mp_detection(I_mp_detection>=0.4&I_mp_detection<0.5)*1.4;
% I_mp_detection(I_mp_detection>=0.5)=I_mp_detection(I_mp_detection>=0.5)*1.6;
% I_mp_detection(I_mp_detection>0.95)=1;
% I_mp_detection(I_mp_detection<=0.3)=I_mp_detection(I_mp_detection<=0.3)*0.62;
% I_mp_detection(I_mp_detection<=0.32&I_mp_detection>0.3)=I_mp_detection(I_mp_detection<=0.32&I_mp_detection>0.3)*0.6;
% I_mp_detection(I_mp_detection<=0.33&I_mp_detection>0.32)=I_mp_detection(I_mp_detection<=0.33&I_mp_detection>0.32)*0.7;
% I_mp_detection(I_mp_detection<0.4&I_mp_detection>0.39)=I_mp_detection(I_mp_detection<0.4&I_mp_detection>0.39)*1.1;
% x=0:0.01:1.5;
% y=0:1.8:180;

% z3=Q_mp';
% z3=A_mp_detection';


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
z1=IQ_mp_detection';
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
Z=z1;
% Z=data_1m;

% load gps_all_detection.mat

% 1. 定义离散colormap（5种颜色）
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

% heatmap(flipud(weighted_avg_detection))
% 3. 绘图
figure('Position', [200, 100, 1200, 500], 'Color', 'white');
% contourf(X, Y, Z, levels, 'LineStyle', 'none'); % 填充等高线，无边框
hold on;
[C, h] = contour(Z, 10, 'LineColor', [0.6 0.6 0.6], 'LineWidth', 1.5, 'LineStyle', '--','LabelSpacing',3000);
% clabel(C, h, 'FontSize', 12, 'Color', [0.5 0.5 0.5], 'FontName', 'Times New Roman');
% h.LevelList = round(h.LevelList, 1); 
h.LevelList = [0,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]; 
% h.LevelList = [0,0.2,0.4,0.6,0.8,1]; 
% 设置坐标轴
set(gca, 'YDir', 'normal');
% set(gca, 'XTick', []);
% set(gca, 'YTick', []);
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
% cbar.Label.FontWeight = 'bold';
% char.Ticks = [0.1,0.25,0.42,0.58,0.75,0.92];

% 4. 调整colorbar刻度
% cbar = colorbar;
tick_positions = (levels(1:end-1) + levels(2:end)) / 2;
set(cbar, 'Ticks', tick_positions);
% cbar.TickLabels = {'0', '0.2', '0.4', '0.6', '0.8', '1.0'};
cbar.TickLabels = {'0.1', '0.2', '0.3', '0.4', '0.5','0.6','0.7','0.8','0.9','1'};
% set(gca,'FontName','Helvetica','FontSize', 25,'XTick',[1,50,100,150,200,250,300,350,400,450,500],'XTickLabel',{'0','50','100','150','200','250','300','350','400','450','500'},'YTick',...
%     [1 5 10 15 20],'YTickLabel',...
%     {'1','5','10','15','20'}); % 修改坐标轴字体大小
% 
% % set(gca,'FontName','Helvetica','FontSize', 25,'XTick',[1,25,50,75,100,125,150,175,200,225,250],'XTickLabel',{'0','50','100','150','200','250','300','350','400','450','500'},'YTick',...
% %     [1 11 21 31 41 51 61],'YTickLabel',...
% %     {'0','5','10','15','20','25','30'}); % 修改坐标轴字体大小
% xlabel('Code delay (m)','FontSize',25,'FontName','Helvetica');
% ylabel('Energy attenuation (dB)','FontSize',25,'FontName','Helvetica');
% cbar.LabelSpacing = 3000;
xlabel('Relative delay (chip)','FontSize',25,'FontName','Helvetica');
ylabel('Relative phase (°)','FontSize',25,'FontName','Helvetica');
% % title('多径信号检测可能性','FontSize',18,'FontName','仿宋');
set(gca,'FontName','Helvetica','FontSize', 25,'XTick',[0,50,100,150],'XTickLabel',{'0','0.5','1','1.5'},'YTick',...
    [0 100-16.67*5 100-16.67*4 100-16.67*3 100-16.67*2 100-16.67 100],'YTickLabel',...
    {'0','30','60','90','120','150','180'}); % 修改坐标轴字体大小


% xlabel('Energy attenuation(dB)','FontSize',25,'FontName','Times New Roman');
% ylabel('Relative Doppler (Hz)','FontSize',25,'FontName','Times New Roman');
% % title('多径信号检测可能性','FontSize',18,'FontName','仿宋');
% set(gca,'FontName','Helvetica','FontSize', 25,'YTick',[1,10,19,28],'YTickLabel',...
%     {'10^{-1}','10^{0}','10^{1}','10^{2}'}); % 修改坐标轴字体大小
% set(gcf,'Units','centimeters','Position',[6 6 20 15]);

% [0 16.65 33.32 49.99 66.66 83.33 100]
% set(gcf,'Units','centimeters','Position',[6 6 20 15]);




