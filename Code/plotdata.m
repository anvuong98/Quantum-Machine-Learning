function plotdata(loadFilename)
%% Load Data
load(loadFilename, ...
    'trainedCNN0', 'trainedCNN1',...
    'predY', 'yTest',...
    'saveVariables', 'intervals', 'names')
 
%% Plot data
min_y = intervals(saveVariables, 1);
max_y = intervals(saveVariables, 2);
interval_y = max_y - min_y;
includedNames = names(saveVariables);

for iName = 1:length(includedNames)
    figure
    plot(yTest(:, iName) * interval_y(iName) + min_y(iName), ...
         predY(:, iName) * interval_y(iName) + min_y(iName), ...
         'LineStyle','none', ...
         'Marker', '.', ...
         'MarkerSize', 4, ...
         'Color', [0.8500 0.3250 0.0980])
    hold
    plot([min_y(iName) - interval_y(iName)/10,...
          max_y(iName) + interval_y(iName)/10], ...
         [min_y(iName) - interval_y(iName)/10,...
          max_y(iName) + interval_y(iName)/10], ...
         'LineWidth',1,'Color','black')
    xlabel(includedNames(iName))
    ylabel(strcat('Pred-', includedNames(iName)))
    axis([min_y(iName) - interval_y(iName)/10,...
          max_y(iName) + interval_y(iName)/10, ...
          min_y(iName) - interval_y(iName)/10,...
          max_y(iName) + interval_y(iName)/10])
    legend({'Predictions','Expected'}, ...
            'Location', 'northwest')
    set(gca, 'fontsize', 10)
    title(sprintf('CNN %s Predictions', includedNames{iName}))
    dim = [0.45 0.15 0.3 0.1];
    str = sprintf('std(test_y - pred_y) = %0.3f', ...
                  std(yTest(:, iName) - predY(:, iName)));
    annotation('textbox', dim, ...
        'String', str, ...
        'FitBoxToText','on');
    hold off
end