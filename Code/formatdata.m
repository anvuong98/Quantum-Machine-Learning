function [saveFilename] = formatdata(loadFilename, saveVariables, ...
    trainRatio, valRatio, testRatio)
%% Load Data
load(loadFilename, ...
     'names', 'nImages', 'intervals', ...
     'LDOST', 'y', 'h', 'w', 'nImages', ...
     'shapeFactor','shapeIndex','shapeName')
shape = categorical(shapeIndex,shapeFactor,shapeName)';
 
[trainInd,valInd,testInd] = divideblock(nImages, ...
    trainRatio, valRatio, testRatio);

y = y(:, saveVariables);

xTrain      = LDOST(:,:,:,trainInd);
yTrain      = y(trainInd,:);
yClassTrain = shape(trainInd);

xVal        = LDOST(:,:,:,valInd);
yVal        = y(valInd,:);
yClassVal   = shape(valInd);

xTest       = LDOST(:,:,:,testInd);
yTest       = y(testInd,:);
yClassTest  = shape(testInd); 

outDim = sum(saveVariables);
shapeIndex = shapeIndex(testInd)';

%% Name File
shortNames = ['A', 'B', 'E', 'S', 'N', 'L', 'D'];

if testRatio > trainRatio + valRatio
    suffix = 'T';
else
    suffix = 'L';
end

saveFilename = generatefilename(...
    strcat('FormattedData/', ...
           shortNames(diff(intervals, 1, 2) ~= 0), ...
           '_', ...
           shortNames(saveVariables), ...
           '_', ...
           num2str(floor(nImages/1000)), ...
           '_', ...
           suffix), '.mat');


%% Save Data
save(saveFilename, ...
     'saveVariables', 'names', ...
     'intervals', 'outDim', ...
     'xTrain', 'yTrain', 'yClassTrain',...
     'xVal', 'yVal', 'yClassVal',...
     'xTest', 'yTest', 'yClassTest',...
     'shape','shapeIndex',...
     'h', 'w', ...
     'nImages')
