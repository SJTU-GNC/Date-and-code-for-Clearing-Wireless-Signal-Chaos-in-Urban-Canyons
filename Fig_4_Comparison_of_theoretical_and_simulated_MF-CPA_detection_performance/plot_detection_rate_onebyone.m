clear; clc; 
% close all;

%% 1. 设置参数
data_folder = 'G:\code_organization\Fig_4_Comparison_of_theoretical_and_simulated_MF-CPA_detection_performance\GPS_windows'; % Excel文件所在文件夹路径，'.'表示当前文件夹
file_pattern = '多径*.xlsx'; % 文件命名模式
range_resolution = 1; % 伪距差网格分辨率：2米（每个格子2米宽）
power_resolution = 1; % 功率衰减网格分辨率：1 dB（每个格子1dB高）

%% 2. 自定义颜色映射（16级）
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



% 创建更平滑的颜色映射（可选，如果需要更多过渡色）
% custom_map_smooth = interp1(linspace(0,1,size(custom_map,1)), custom_map, linspace(0,1,256));

%% 3. 获取所有数据文件列表
excel_files = dir(fullfile(data_folder, file_pattern));
num_files = length(excel_files);

fprintf('找到 %d 个Excel文件:\n', num_files);
for i = 1:num_files
    fprintf('  %d. %s\n', i, excel_files(i).name);
end

if num_files == 0
    error('未找到任何匹配的Excel文件！请检查文件路径和命名模式。');
end

%% 4. 初始化存储所有数据的变量
all_pseudo_range_diff = [];
all_power_attenuation = [];
all_detection_rate = [];
all_false_rate = []; % 新增：误检率
all_weights = [];
all_false_weights = []; % 误检率的权重（LOS信号个数）
file_info = {}; % 存储每个数据点来自哪个文件

%% 5. 批量读取所有Excel文件并合并数据
fprintf('\n开始读取数据文件...\n');
for file_idx = 1:num_files
    filename = fullfile(data_folder, excel_files(file_idx).name);
    
    try
        fprintf('  正在处理文件: %s\n', excel_files(file_idx).name);
        
        % 方法1: 使用readtable直接读取，然后处理非数值数据
        opts = detectImportOptions(filename);
        opts.VariableTypes(:) = {'double'}; % 强制所有列都作为double类型读取
        opts.MissingRule = 'fill'; % 填充缺失值
        opts.ImportErrorRule = 'fill'; % 填充错误值
        
        try
            data = readtable(filename, opts);
        catch
            % 如果强制类型读取失败，使用默认方式读取然后转换
            data = readtable(filename);
            % 将相关列转换为数值
            column_names = data.Properties.VariableNames;
            
            % 定义需要转换的列
            numeric_columns = {'avg_pr_diff_multipath', 'avg_pr_diff_multipath2', ...
                              'avg_power_diff_multipath', 'avg_power_diff_multipath2', ...
                              'detection_rate', 'number_of_multipath'};
            
            for col_idx = 1:length(numeric_columns)
                col_name = numeric_columns{col_idx};
                if ismember(col_name, column_names)
                    if iscell(data.(col_name))
                        % 如果是cell数组，尝试转换为数值
                        temp_data = data.(col_name);
                        numeric_data = zeros(size(temp_data));
                        for i = 1:length(temp_data)
                            if ischar(temp_data{i}) || isstring(temp_data{i})
                                % 如果是字符串，尝试转换为数值
                                numeric_data(i) = str2double(temp_data{i});
                            elseif isnumeric(temp_data{i})
                                numeric_data(i) = temp_data{i};
                            else
                                numeric_data(i) = NaN;
                            end
                        end
                        data.(col_name) = numeric_data;
                    end
                end
            end
        end
        
        fprintf('    读取成功，共 %d 行数据\n', height(data));
        
        % 确保所有需要的列都存在
        if ~all(ismember({'avg_pr_diff_multipath', 'avg_power_diff_multipath', ...
                          'detection_rate', 'number_of_multipath'}, data.Properties.VariableNames))
            fprintf('    警告: 文件缺少必要的列，跳过此文件\n');
            continue;
        end
        
        % 提取第一条多径数据
        pseudo_range_diff1 = data.avg_pr_diff_multipath;
        power_attenuation1 = data.avg_power_diff_multipath;
        false_rate = data.false_rate; % 新增：误检率
        detection_rate = data.detection_rate;
        multipath_count = data.number_of_multipath;
        los_count = data.number_of_los; % LOS信号数量
        % 提取第二条多径数据（如果存在）
        if ismember('avg_pr_diff_multipath2', data.Properties.VariableNames)
            pseudo_range_diff2 = data.avg_pr_diff_multipath2;
        else
            pseudo_range_diff2 = NaN(size(pseudo_range_diff1));
        end
        
        if ismember('avg_power_diff_multipath2', data.Properties.VariableNames)
            power_attenuation2 = data.avg_power_diff_multipath2;
        else
            power_attenuation2 = NaN(size(power_attenuation1));
        end
        
        % 处理当前文件的数据
        file_data_points = 0;
        for i = 1:height(data)
            % 第一条多径
            if ~isnan(pseudo_range_diff1(i)) && ~isnan(power_attenuation1(i)) && ...
               ~isnan(detection_rate(i)) && ~isnan(multipath_count(i))
                
                all_pseudo_range_diff = [all_pseudo_range_diff; pseudo_range_diff1(i)];
                % 将功率衰减转换为正值：-20dB对应衰减20dB
                all_power_attenuation = [all_power_attenuation; abs(power_attenuation1(i))];
                all_detection_rate = [all_detection_rate; detection_rate(i)];
                all_false_rate = [all_false_rate; false_rate(i)]; % 新增：误检率
                all_weights = [all_weights; multipath_count(i)];
                all_false_weights = [all_false_weights; los_count(i)]; % 误检率权重为LOS信号数量
                file_info{end+1} = excel_files(file_idx).name;
                file_data_points = file_data_points + 1;
            end
            
            % 第二条多径（如果存在有效数据）
            if ~isnan(pseudo_range_diff2(i)) && ~isnan(power_attenuation2(i)) && ...
               ~isnan(detection_rate(i)) && ~isnan(multipath_count(i))
                
                all_pseudo_range_diff = [all_pseudo_range_diff; pseudo_range_diff2(i)];
                % 将功率衰减转换为正值：-20dB对应衰减20dB
                all_power_attenuation = [all_power_attenuation; abs(power_attenuation2(i))];
                all_detection_rate = [all_detection_rate; detection_rate(i)];               
                all_weights = [all_weights; multipath_count(i)];
                file_info{end+1} = excel_files(file_idx).name;
                file_data_points = file_data_points + 1;
            end
        end
        
        fprintf('    提取了 %d 个有效数据点\n', file_data_points);
        
    catch ME
        fprintf('  警告: 文件 %s 读取失败: %s\n', excel_files(file_idx).name, ME.message);
        fprintf('  尝试使用替代方法读取...\n');
        
        % 尝试使用xlsread作为备选方案
        try
            [num, txt, raw] = xlsread(filename);
            fprintf('    使用xlsread读取成功，但需要手动处理数据格式\n');
            % 这里需要根据实际表格结构手动处理，暂时跳过
        catch
            fprintf('    所有读取方法都失败，跳过此文件\n');
        end
    end
end

fprintf('\n数据读取完成！\n');
fprintf('总数据点数: %d\n', length(all_pseudo_range_diff));

if isempty(all_pseudo_range_diff)
    error('没有读取到任何有效数据！请检查文件格式。');
end

%% 6. 筛选数据（功率衰减在0到20之间，伪距差大于0）
% 注意：功率衰减已转换为正值，0表示无衰减，20表示衰减20dB
valid_indices = all_power_attenuation >= 0 & all_power_attenuation <= 20 & all_pseudo_range_diff > 0;
pseudo_range_diff = all_pseudo_range_diff(valid_indices);
power_attenuation = all_power_attenuation(valid_indices);
detection_rate_filtered = all_detection_rate(valid_indices);
valid_false_indices = ~isnan(all_false_rate);
false_rate_filtered = all_false_rate(valid_false_indices); % 新增：筛选后的误检率
weights = all_weights(valid_indices);
false_weights = all_false_weights(valid_false_indices);
% 更新文件信息
file_info = file_info(valid_indices);

fprintf('筛选后有效数据点数: %d (保留率: %.1f%%)\n', ...
    length(pseudo_range_diff), length(pseudo_range_diff)/length(all_pseudo_range_diff)*100);

%% 7. 设置伪距差范围（500米，250个格子）
% 设置伪距差最大范围为500米
max_range = 500; % 固定500米
min_range = 1; % 伪距差>0，所以从1开始

% 计算需要多少个2米格子才能覆盖500米
% 500米 ÷ 2米/格子 = 250个格子
num_range_bins = 500; % 250个2米宽的格子

% 重新计算网格边缘（确保250个格子正好覆盖500米）
range_edges = linspace(min_range, max_range, num_range_bins + 1);
% 确保第一个边缘是1，最后一个边缘是500
range_edges(1) = min_range;
range_edges(end) = max_range;

% 计算网格中心点
range_centers = (range_edges(1:end-1) + range_edges(2:end)) / 2;

% 功率衰减范围：0-20dB，1dB间隔（21个边缘点，20个格子）
min_power = 0;
max_power = 20;
power_edges = min_power:power_resolution:max_power; % 1dB间隔
power_centers = (power_edges(1:end-1) + power_edges(2:end)) / 2; % 1dB间隔

num_power_bins = length(power_edges) - 1;

fprintf('网格设置: %d x %d = %d 个网格\n', num_range_bins, num_power_bins, num_range_bins * num_power_bins);
fprintf('伪距差范围: %d米 (从%d到%d米)\n', max_range, min_range, max_range);
fprintf('伪距差网格: %d个格子，每个格子%.1f米宽\n', num_range_bins, range_resolution);
fprintf('功率衰减网格: %d个格子，每个格子%.1fdB高\n', num_power_bins, power_resolution);

%% 8. 将数据分配到网格中
% 获取每个数据点所属的网格索引
range_bins = discretize(pseudo_range_diff, range_edges);
power_bins = discretize(power_attenuation, power_edges);

% 初始化加权检测率矩阵和权重矩阵
weighted_detection_sum = zeros(num_power_bins, num_range_bins);
weighted_false_rate_sum = zeros(num_power_bins, num_range_bins); % 新增：加权误检率总和
total_weight = zeros(num_power_bins, num_range_bins);
total_false_weight = zeros(num_power_bins, num_range_bins); % 新增：误检率总权重（LOS信号数量）
data_count = zeros(num_power_bins, num_range_bins); % 每个网格的数据点数量
false_data_count = zeros(num_power_bins, num_range_bins); % 每个网格的误检率数据点数量
%% 9. 计算每个网格的加权平均检测率
fprintf('正在计算网格加权平均检测率...\n');

for i = 1:length(pseudo_range_diff)
    if ~isnan(range_bins(i)) && ~isnan(power_bins(i))
        row_idx = power_bins(i);
        col_idx = range_bins(i);
        
        % 累加加权检测率（检测率 * 多径个数）
        weighted_detection_sum(row_idx, col_idx) = weighted_detection_sum(row_idx, col_idx) + ...
            detection_rate_filtered(i) * weights(i);
        
        % 累加权重（多径个数）
        total_weight(row_idx, col_idx) = total_weight(row_idx, col_idx) + weights(i);
        
        % 统计数据点数量
        data_count(row_idx, col_idx) = data_count(row_idx, col_idx) + 1;
                % 累加加权误检率（误检率 * LOS信号数量）- 仅当误检率和LOS权重不是NaN时
    end
end

% 计算加权平均检测率
weighted_avg_detection = weighted_detection_sum ./ total_weight./100;


% 将没有数据的网格设为NaN
weighted_avg_detection(total_weight == 0) = NaN;

%% 10. 绘制热图（使用自定义颜色映射）
figure('Position', [50, 50, 1400, 800]);

% 创建子图1：热图（主图）
subplot(2, 3, [1, 2, 4, 5]);

% 使用pcolor绘制，可以更清晰地看到网格边界
[X, Y] = meshgrid(range_edges, power_edges);
h = pcolor(X, Y, [weighted_avg_detection, nan(num_power_bins, 1); nan(1, num_range_bins+1)]);
set(h, 'EdgeColor', 'k', 'LineWidth', 0.5,'LineStyle','none');

% 使用自定义颜色映射
colormap(gca, custom_map); % 使用平滑版本的颜色映射
colorbar;
numColors=10;
z_min = 0;
z_max = 1;
levels = linspace(0, z_max, numColors+1);
cbar = colorbar('eastoutside', 'Ticks', 0:0.1:1, ...
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

min_power=5;
max_power=18;
% 设置坐标轴范围
xlim([min_range+1, max_range+1]);
ylim([min_power+1, max_power+1]);

% 设置刻度
xtick_interval = max(10, ceil((max_range - min_range) / 20)); % 最多显示20个刻度
xticks(min_range:xtick_interval:max_range);
yticks(min_power+1.5:2:max_power+0.5); % 每2dB显示一个刻度
set(gca,'FontName','Helvetica','FontSize', 25,'XTick',[1.5,10.5,20.5,30.5,40.5,50.5],'XTickLabel',{'1','10','20','30','40','50'},'YTickLabel',...
    {'8','10','12','14','16','18','20'}); % 修改坐标轴字体大小

xlabel('Code delay (m)','FontSize',25,'FontName','Helvetica');
ylabel('Energy attenuation (dB)','FontSize',25,'FontName','Helvetica');

% 设置颜色条标签
% caxis([0 100]); % 检测率范围0-100%
% ylabel(colorbar, '检测率 (%)', 'FontSize', 12);

% % 为颜色条添加刻度，显示16级颜色的对应关系
% colorbar_ticks = linspace(0, 100, size(custom_map, 1)+1);
% colorbar_ticklabels = arrayfun(@(x) sprintf('%.0f%%', x), colorbar_ticks, 'UniformOutput', false);
% colorbar('Ticks', colorbar_ticks, 'TickLabels', colorbar_ticklabels);
% 
% % 设置坐标轴
% xlabel('伪距差 (米)', 'FontSize', 14, 'FontWeight', 'bold');
% ylabel('功率衰减 (dB)', 'FontSize', 14, 'FontWeight', 'bold');
% title(sprintf('多文件汇总检测率热图 (%d个文件, %d个数据点)\n网格分辨率: 伪距差=%dm, 功率衰减=%ddB', ...
%     num_files, length(pseudo_range_diff), range_resolution, power_resolution), ...
%     'FontSize', 16, 'FontWeight', 'bold');
% 
% % 设置坐标轴范围
% xlim([min_range, max_range]);
% ylim([min_power, max_power]);
% 
% % 设置刻度
% xtick_interval = max(10, ceil((max_range - min_range) / 20)); % 最多显示20个刻度
% xticks(min_range:xtick_interval:max_range);
% yticks(min_power:2:max_power); % 每2dB显示一个刻度
% 
% % 添加网格线
% grid on;
% set(gca, 'GridAlpha', 0.3, 'FontSize', 12, 'Box', 'on');

% 添加颜色映射说明文本
text(max_range*0.02, max_power*0.95, ...
    sprintf('颜色映射:\n深蓝→蓝→白→橙→红\n对应检测率: 0%%→100%%'), ...
    'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black', ...
    'Margin', 2, 'VerticalAlignment', 'top');

%% 11. 绘制数据点数量热图
subplot(2, 3, 3);
data_count_plot = data_count;
data_count_plot(data_count == 0) = NaN; % 将0值设为NaN以便显示空白

% 使用pcolor绘制
[X2, Y2] = meshgrid(range_edges, power_edges);
h2 = pcolor(X2, Y2, [data_count_plot, nan(num_power_bins, 1); nan(1, num_range_bins+1)]);
set(h2, 'EdgeColor', 'k', 'LineWidth', 0.5);

colormap(gca, parula);
colorbar;
ylabel(colorbar, '数据点数量', 'FontSize', 10);

xlabel('伪距差 (米)', 'FontSize', 12);
ylabel('功率衰减 (dB)', 'FontSize', 12);
title('每个网格的数据点数量', 'FontSize', 14);

grid on;
set(gca, 'FontSize', 10);

%% 12. 绘制权重总和热图
subplot(2, 3, 6);
total_weight_plot = total_weight;
total_weight_plot(total_weight == 0) = NaN;

% 使用pcolor绘制
[X3, Y3] = meshgrid(range_edges, power_edges);
h3 = pcolor(X3, Y3, [total_weight_plot, nan(num_power_bins, 1); nan(1, num_range_bins+1)]);
set(h3, 'EdgeColor', 'k', 'LineWidth', 0.5);

colormap(gca, hot);
colorbar;
ylabel(colorbar, '总权重(多径个数)', 'FontSize', 10);

xlabel('伪距差 (米)', 'FontSize', 12);
ylabel('功率衰减 (dB)', 'FontSize', 12);
title('每个网格的总权重', 'FontSize', 14);

grid on;
set(gca, 'FontSize', 10);

%% 13. 创建单独的汇总统计图
figure('Position', [50, 900, 1400, 500]);

% 子图1：伪距差分布直方图（2米分箱）
subplot(1, 3, 1);
histogram(pseudo_range_diff, 'BinEdges', range_edges, 'FaceColor', 'blue', 'EdgeColor', 'black');
xlabel('伪距差 (米)', 'FontSize', 12);
ylabel('频数', 'FontSize', 12);
title(sprintf('伪距差分布 (分箱: %d米)', range_resolution), 'FontSize', 14);
grid on;

% 子图2：功率衰减分布直方图（1dB分箱）
subplot(1, 3, 2);
histogram(power_attenuation, 'BinEdges', power_edges, 'FaceColor', 'red', 'EdgeColor', 'black');
xlabel('功率衰减 (dB)', 'FontSize', 12);
ylabel('频数', 'FontSize', 12);
title('功率衰减分布 (分箱: 1dB)', 'FontSize', 14);
grid on;

% 子图3：检测率分布直方图
subplot(1, 3, 3);
histogram(detection_rate_filtered, 'BinWidth', 10, 'FaceColor', 'green', 'EdgeColor', 'black');
xlabel('检测率 (%)', 'FontSize', 12);
ylabel('频数', 'FontSize', 12);
title('检测率分布', 'FontSize', 14);
grid on;

%% 14. 绘制检测率统计图
figure('Position', [50, 1450, 1400, 500]);

% 子图1：检测率随伪距差变化
subplot(1, 2, 1);

% 计算每个伪距差网格的平均检测率
range_bin_detection = zeros(num_range_bins, 1);
range_bin_count = zeros(num_range_bins, 1);

for i = 1:num_range_bins
    idx = range_bins == i;
    
    if any(idx)
        % 加权平均
        range_bin_detection(i) = sum(detection_rate_filtered(idx) .* weights(idx)) / sum(weights(idx));
        range_bin_count(i) = sum(idx);
    else
        range_bin_detection(i) = NaN;
        range_bin_count(i) = 0;
    end
end

% 绘制检测率随伪距差变化曲线
plot(range_centers, range_bin_detection, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4, 'MarkerFaceColor', 'blue');
xlabel('伪距差 (米)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('加权平均检测率 (%)', 'FontSize', 14, 'FontWeight', 'bold');
title(sprintf('检测率随伪距差变化 (网格分辨率: %dm)', range_resolution), 'FontSize', 16, 'FontWeight', 'bold');
grid on;

% 设置坐标轴范围
xlim([min(range_centers)-1, max(range_centers)+1]);
ylim([0, 100]);

% 子图2：检测率随功率衰减变化
subplot(1, 2, 2);

% 计算每个功率衰减网格的平均检测率
power_bin_detection = zeros(num_power_bins, 1);
power_bin_count = zeros(num_power_bins, 1);

for i = 1:num_power_bins
    idx = power_bins == i;
    
    if any(idx)
        % 加权平均
        power_bin_detection(i) = sum(detection_rate_filtered(idx) .* weights(idx)) / sum(weights(idx));
        power_bin_count(i) = sum(idx);
    else
        power_bin_detection(i) = NaN;
        power_bin_count(i) = 0;
    end
end

% 绘制检测率随功率衰减变化曲线
plot(power_centers, power_bin_detection, 'r-s', 'LineWidth', 1.5, 'MarkerSize', 4, 'MarkerFaceColor', 'red');
xlabel('功率衰减 (dB)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('加权平均检测率 (%)', 'FontSize', 14, 'FontWeight', 'bold');
title('检测率随功率衰减变化', 'FontSize', 16, 'FontWeight', 'bold');
grid on;

% 设置坐标轴范围
xlim([min(power_centers)-0.5, max(power_centers)+0.5]);
ylim([0, 100]);

%% 15. 数据统计分析
% 计算总体加权平均检测率
overall_weighted_avg = sum(detection_rate_filtered .* weights) / sum(weights);

% 计算总体加权平均误检率（权重为LOS信号数量，忽略NaN值）
valid_false_rate_indices = ~isnan(false_rate_filtered) & ~isnan(false_weights) & false_weights > 0;
if any(valid_false_rate_indices)
    overall_weighted_false_rate_avg = sum(false_rate_filtered(valid_false_rate_indices) .* false_weights(valid_false_rate_indices)) / ...
        sum(false_weights(valid_false_rate_indices));
else
    overall_weighted_false_rate_avg = NaN;
end

% 统计有数据的网格
valid_cells = ~isnan(weighted_avg_detection(:));
num_valid_cells = sum(valid_cells);

% 统计信息输出
fprintf('\n======= 汇总统计信息 =======\n');
fprintf('处理的文件数量: %d\n', num_files);
fprintf('原始数据总点数: %d\n', length(all_pseudo_range_diff));
fprintf('筛选后有效数据点数: %d\n', length(pseudo_range_diff));
fprintf('伪距差范围: %.1f ~ %.1f 米\n', min(pseudo_range_diff), max(pseudo_range_diff));
fprintf('功率衰减范围: %.1f ~ %.1f dB (已转换为正值)\n', min(power_attenuation), max(power_attenuation));
fprintf('总体加权平均检测率: %.2f%%\n', overall_weighted_avg);
fprintf('网格分辨率: 伪距差=%d米, 功率衰减=%d dB\n', range_resolution, power_resolution);
fprintf('网格总数: %d x %d = %d\n', num_range_bins, num_power_bins, num_range_bins * num_power_bins);
fprintf('有数据的网格数量: %d (%.1f%%)\n', num_valid_cells, num_valid_cells/(num_range_bins*num_power_bins)*100);

% 统计检测率分布
detection_ranges = [0, 20, 40, 60, 80, 100];
detection_counts = zeros(length(detection_ranges)-1, 1);

for i = 1:length(detection_ranges)-1
    lower_bound = detection_ranges(i);
    upper_bound = detection_ranges(i+1);
    detection_counts(i) = sum(weighted_avg_detection(:) >= lower_bound & ...
        weighted_avg_detection(:) < upper_bound & ~isnan(weighted_avg_detection(:)));
end

fprintf('\n检测率分布:\n');
for i = 1:length(detection_counts)
    fprintf('  %d%%~%d%%: %d个网格 (%.1f%%)\n', ...
        detection_ranges(i), detection_ranges(i+1), detection_counts(i), ...
        detection_counts(i)/num_valid_cells*100);
end

% 统计每个文件的数据贡献
if ~isempty(file_info)
    unique_files = unique(file_info);
    file_contributions = zeros(length(unique_files), 1);
    for i = 1:length(unique_files)
        file_contributions(i) = sum(strcmp(file_info, unique_files{i}));
    end

    fprintf('\n各文件数据贡献:\n');
    for i = 1:length(unique_files)
        fprintf('  %s: %d个数据点 (%.1f%%)\n', ...
            unique_files{i}, file_contributions(i), file_contributions(i)/length(pseudo_range_diff)*100);
    end
end


for i =1:1:13
    A=weighted_avg_detection(i+6,:);
    A(isnan(A))=[];
    CCC{i}=A;
end

overall_false_rate=sum(all_false_weights)*overall_weighted_false_rate_avg./100./(sum(all_weights)*overall_weighted_avg./100+sum(all_false_weights)*overall_weighted_false_rate_avg./100);
% %% 16. 保存结果
% % 创建结果文件夹
% results_folder = sprintf('多径分析结果_%dm分辨率', range_resolution);
% if ~exist(results_folder, 'dir')
%     mkdir(results_folder);
% end
% 
% % 保存加权平均矩阵和网格信息
% save_filename = fullfile(results_folder, sprintf('多文件汇总分析结果_%dm分辨率.mat', range_resolution));
% save(save_filename, 'weighted_avg_detection', 'data_count', 'total_weight', ...
%     'range_centers', 'power_centers', 'range_edges', 'power_edges', ...
%     'range_resolution', 'power_resolution', 'overall_weighted_avg', ...
%     'num_files', 'custom_map');
% 
% % 保存详细结果到CSV文件
% csv_data = table();
% for i = 1:num_power_bins
%     for j = 1:num_range_bins
%         if ~isnan(weighted_avg_detection(i, j))
%             new_row = table(range_centers(j), power_centers(i), ...
%                 weighted_avg_detection(i, j), data_count(i, j), total_weight(i, j), ...
%                 'VariableNames', {'PseudoRangeDiff_m', 'PowerAttenuation_dB', ...
%                 'WeightedAvgDetection_percent', 'DataPointCount', 'TotalWeight'});
%             csv_data = [csv_data; new_row];
%         end
%     end
% end
% 
% if ~isempty(csv_data)
%     csv_filename = fullfile(results_folder, sprintf('网格分析结果_%dm分辨率.csv', range_resolution));
%     writetable(csv_data, csv_filename);
% end
% 
% % 保存统计信息到文本文件
% stats_filename = fullfile(results_folder, sprintf('统计信息_%dm分辨率.txt', range_resolution));
% fid = fopen(stats_filename, 'w');
% fprintf(fid, '多文件多径分析统计信息 (网格分辨率: 伪距差=%d米, 功率衰减=%ddB)\n', range_resolution, power_resolution);
% fprintf(fid, '============================================\n\n');
% fprintf(fid, '处理时间: %s\n', datestr(now));
% fprintf(fid, '处理的文件数量: %d\n', num_files);
% fprintf(fid, '原始数据总点数: %d\n', length(all_pseudo_range_diff));
% fprintf(fid, '筛选后有效数据点数: %d\n', length(pseudo_range_diff));
% fprintf(fid, '伪距差范围: %.1f ~ %.1f 米\n', min(pseudo_range_diff), max(pseudo_range_diff));
% fprintf(fid, '功率衰减范围: %.1f ~ %.1f dB (已转换为正值)\n', min(power_attenuation), max(power_attenuation));
% fprintf(fid, '总体加权平均检测率: %.2f%%\n', overall_weighted_avg);
% fprintf(fid, '网格分辨率: 伪距差=%d米, 功率衰减=%d dB\n', range_resolution, power_resolution);
% fprintf(fid, '网格总数: %d x %d = %d\n', num_range_bins, num_power_bins, num_range_bins * num_power_bins);
% fprintf(fid, '有数据的网格数量: %d (%.1f%%)\n', num_valid_cells, num_valid_cells/(num_range_bins*num_power_bins)*100);
% fprintf(fid, '颜色映射: 16级蓝-白-红渐变，对应检测率0%%-100%%\n');
% fclose(fid);
% 
% % 保存图形
% if exist('gcf', 'var')
%     saveas(gcf-2, fullfile(results_folder, sprintf('汇总热图_%dm分辨率.png', range_resolution)));
%     saveas(gcf-1, fullfile(results_folder, sprintf('数据分布图_%dm分辨率.png', range_resolution)));
%     saveas(gcf, fullfile(results_folder, sprintf('检测率趋势图_%dm分辨率.png', range_resolution)));
% end
% 
% % 保存颜色映射图像（单独显示）
% figure('Position', [100, 100, 800, 200]);
% imagesc(linspace(0, 100, 256));
% colormap(custom_map);
% colorbar;
% xlabel('检测率 (%)', 'FontSize', 12);
% title('16级蓝-白-红颜色映射 (检测率0-100%)', 'FontSize', 14);
% set(gca, 'YTick', []);
% saveas(gcf, fullfile(results_folder, '颜色映射图.png'));
% 
% fprintf('\n结果已保存到文件夹: %s\n', results_folder);
% fprintf('   - 多文件汇总分析结果_%dm分辨率.mat\n', range_resolution);
% fprintf('   - 网格分析结果_%dm分辨率.csv\n', range_resolution);
% fprintf('   - 统计信息_%dm分辨率.txt\n', range_resolution);
% fprintf('   - 汇总热图_%dm分辨率.png\n', range_resolution);
% fprintf('   - 数据分布图_%dm分辨率.png\n', range_resolution);
% fprintf('   - 检测率趋势图_%dm分辨率.png\n', range_resolution);
% fprintf('   - 颜色映射图.png\n');
% fprintf('\n处理完成！\n');