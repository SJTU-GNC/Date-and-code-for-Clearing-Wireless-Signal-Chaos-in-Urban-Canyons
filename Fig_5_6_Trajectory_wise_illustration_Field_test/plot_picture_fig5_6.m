clear
close all
clc
load plotSet.mat
load sheixian_xz.mat
zoomPoint = [413, 500, 0]'; % Select x, y, z point to zoom in around (meters)
zoomSize = 1000; % Select how large volume around the zoom point that should be displayed (meters)

simulationToPlot = 1;
constellationRepetitionToPlot = 1;
sampleToPlot = 356;
sampleToPlot2= 336;
% the samplt to plot is changed but not 16 in 1hz

fig.fontSize = 15;
set(0, 'DefaultTextInterpreter', fig.font)
set(0, 'DefaultLegendInterpreter', fig.font)
set(0, 'DefaultAxesTickLabelInterpreter', fig.font)
set(0, 'defaultTextFontSize', fig.fontSize)
set(0, 'defaultAxesFontSize', fig.fontSize)
set(0, 'defaultlinelinewidth', fig.plotLineWidth);

% Attribute one color to visualuze each received satellite
possibleColors = {'r', 'g', 'b', 'm', 'c', 'k', 'y', [255,192,203]/255,...
    [0.5 0.5 0.5], [255, 165, 0]/255, [0.1 0.1 0.1], 'r', 'g', 'b',...
    'm', 'c', 'k', 'y', [255,192,203]/255, [0.5 0.5 0.5],...
    [255, 165, 0]/255, [0.1 0.1 0.1], 'r', 'g', 'b', 'm', 'c'};

% Define the colors of the objects
planeColors.car = 0.8*ones(1,3);
planeColors.ground = 0.5*ones(1,3);
planeColors.build = 0.3*ones(1,3);

close all
% figure('units', 'normalized', 'outerposition', [0 0 1 1])
figure('Position', [50, 50, 1400, 800]);
box on
hold on

data = D(simulationToPlot).data;
results = data.results(constellationRepetitionToPlot, sampleToPlot);

% Plot all planes
% plot the scene, by Lishaoqian
roof_x = []; roof_y = []; roof_z = [];
for w = 2:1:length(data.planes)
    if strcmp(data.planes(w).planeType,'roof')
        patch(roof_x, roof_y, roof_z, planeColors.(data.planes(w).objectType));
        % Plot the polynomial roof
        roof_x = []; roof_y = []; roof_z = [];
    else
        plot_points = data.planes(w).points;
        plotRectangle(plot_points(:,1), plot_points(:,2),...
            plot_points(:,3), plot_points(:,4),...
            planeColors.(data.planes(w).objectType))
        roof_x = [roof_x data.planes(w).points(1,3)];
        roof_y = [roof_y data.planes(w).points(2,3)];
        roof_z = [roof_z data.planes(w).points(3,3)];
    end
    if w == length(data.planes) - 1
        patch(roof_x, roof_y, roof_z, planeColors.(data.planes(w).objectType));
    end
end



view(210,40)

xlabel('East (m)','Rotation', -15)
ylabel('North (m)','Rotation', 45)
zlabel('Up (m)')


linearizationPoint_LLA = [31.2360 121.5017	16];

load bds_24_global_real.mat

load receiver_bds_round1.mat
antennaTrajectory.position_ENU = ...
    lla2enu([r_location(:,2) r_location(:,3) r_location(:,4)], ...
    linearizationPoint_LLA, 'flat')';

hold on

XX=x{4}(:,109:109+348);
for i = 1:1:size(XX,2)
    if XX(2,i)==1&&XX(1,i)==0
    color_select(:,i)=[0;1;0];
    elseif XX(1,i)==1&&XX(2,i)==0
        color_select(:,i)=[1; 0; 0];
    elseif XX(1,i)==0&&XX(2,i)==0&&XX(3,i)==0
        color_select(:,i)=[0;0;0];
    elseif XX(1,i)==1&&XX(2,i)==1&&XX(3,i)==1
        % color_select(:,i)=[112/255;48/255;160/255];
        color_select(:,i)=[0;0;1];
    end

end

p1 = scatter(antennaTrajectory.position_ENU(1,201:549), antennaTrajectory.position_ENU(2,201:549),150,color_select','filled',...
    'Displayname','Simulation Path');

set(gca,'FontSize',36)


xlim([-620 920])
ylim([-200 1200])
zlim([0 zoomSize/2])


