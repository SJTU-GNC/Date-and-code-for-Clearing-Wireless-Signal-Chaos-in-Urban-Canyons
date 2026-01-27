clear; 
close all; 
clc;

load performance_simulation.mat

custom_map = [0.0314 0.0706 0.2275; 0.1020 0.2118 0.3686;   
              0.2588 0.5098 0.6627; 0.3922 0.6784 0.7804;   
              0.8510 0.9216 0.9373; 0.8 0.8 0.8;   
              0.9922 0.8039 0.6588; 0.9804 0.6588 0.4510;   
              0.8824 0.3098 0.1098; 0.6510 0.0471 0.0157];

[X, Y] = meshgrid(0:1:500, 0:1:20);

plot_func = @(Z, name) plot_data(Z, X, Y, custom_map, name);

plot_func(performance_GPS_simulation_tau_alp{1}, 'GPS');
plot_func(performance_BDS_simulation_tau_alp{1}, 'BDS');
plot_func(performance_Gal_simulation_tau_alp{1}, 'Galileo');
plot_func(performance_GLO_simulation_tau_alp{1}, 'GLONASS');

function plot_data(Z, X, Y, cmap, name)
    figure;
    h = pcolor(X, Y, Z);
    set(h, 'EdgeColor', 'k', 'LineWidth', 0.5, 'LineStyle', 'none');

    
    colormap(gca, cmap);
    caxis([0 1]);
    
    cbar = colorbar('eastoutside', 'Ticks', 0.1:0.1:1, ...
                    'TickDirection', 'out', 'Box', 'off', 'LineWidth', 1);
    cbar.Label.String = 'Detection Rate';
    cbar.Label.FontSize = 25;
    cbar.Label.FontName = 'Helvetica';
    
    cbar.TickLabels = {'0.1', '0.2', '0.3', '0.4', '0.5','0.6','0.7','0.8','0.9','1'};
    levels = linspace(0, 1, 11);
    tick_positions = (levels(1:end-1) + levels(2:end)) / 2;
    set(cbar, 'Ticks', tick_positions);
    xlim([0, 50]);
    ylim([9, 19]);
    
    set(gca, 'FontName', 'Helvetica', 'FontSize', 25, ...
        'XTick', [0.5, 9.5, 19.5, 29.5, 39.5, 49.5], ...
        'XTickLabel', {'1', '10', '20', '30', '40', '50'}, ...
        'YTick', [9, 11, 13, 15, 17, 19], ...
        'YTickLabel', {'10', '12', '14', '16', '18', '20'});
    
    xlabel('Code delay (m)', 'FontSize', 25, 'FontName', 'Helvetica');
    ylabel('Energy attenuation (dB)', 'FontSize', 25, 'FontName', 'Helvetica');
    title(name, 'FontSize', 20, 'FontWeight', 'normal');
end
