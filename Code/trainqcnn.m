function [saveFilename] = trainqcnn(loadFilename)
%% Load Data
load(loadFilename, ...
     'saveVariables', 'names', ...
     'intervals', 'outDim', ...
     'xTrain0', 'yTrain0',...
     'xTrain1', 'yTrain1',...
     'xVal0', 'yVal0',...
     'xVal1', 'yVal1',...
     'xTest0', 'yTest0',...
     'xTest1', 'yTest1',...
     'result',...
     'h', 'w', ...
     'nImages')
 
     
%% Specify training parameters 
modu = 1;
options0 = ...
    trainingOptions('sgdm', ...
                    'Plots', 'training-progress', ...
                    'ExecutionEnvironment', 'auto', ...
                    'Verbose', 0, ...
                    'VerboseFrequency', 200, ...
                    'Shuffle', 'every-epoch', ...
                    'InitialLearnRate', 0.1, ...
                    'LearnRateSchedule', 'piecewise', ...
                    'LearnRateDropFactor', 0.9, ...
                    'LearnRateDropPeriod', 1 / modu, ...
                    'L2Regularization', 0.001, ...
                    'Momentum', 0.9, ...
                    'ValidationData', {xVal0, yVal0}, ...
                    'ValidationFrequency', 20 / modu, ...
                    'ValidationPatience', Inf, ...
                    'MaxEpochs', 40, ...
                    'MiniBatchSize', 200 * modu);
                
options1 = ...
    trainingOptions('sgdm', ...
                    'Plots', 'training-progress', ...
                    'ExecutionEnvironment', 'auto', ...
                    'Verbose', 0, ...
                    'VerboseFrequency', 200, ...
                    'Shuffle', 'every-epoch', ...
                    'InitialLearnRate', 0.1, ...
                    'LearnRateSchedule', 'piecewise', ...
                    'LearnRateDropFactor', 0.9, ...
                    'LearnRateDropPeriod', 1 / modu, ...
                    'L2Regularization', 0.001, ...
                    'Momentum', 0.9, ...
                    'ValidationData', {xVal1, yVal1}, ...
                    'ValidationFrequency', 20 / modu, ...
                    'ValidationPatience', Inf, ...
                    'MaxEpochs', 40, ...
                    'MiniBatchSize', 200 * modu);
     
%% Specify network architecture
layers = [
    imageInputLayer([h w 1], 'Normalization', 'none')
    
    convolution2dLayer(5, 128, 'Padding', 2)
    batchNormalizationLayer
    leakyReluLayer
    dropoutLayer
%   maxPooling2dLayer(3,'Stride',2)
    averagePooling2dLayer(4,'Stride',2)

    convolution2dLayer(5, 64, 'Padding', 2)
    batchNormalizationLayer  
    leakyReluLayer
    dropoutLayer
%   maxPooling2dLayer(3,'Stride',2)
    averagePooling2dLayer(4,'Stride',2)

    convolution2dLayer(5,32,'Padding',2)
    batchNormalizationLayer  
    leakyReluLayer
     dropoutLayer
%   maxPooling2dLayer(3,'Stride',2)
    averagePooling2dLayer(4,'Stride',2)
    
    
    
    fullyConnectedLayer(512)
    leakyReluLayer
    fullyConnectedLayer(32)
    leakyReluLayer
    fullyConnectedLayer(outDim)
    regressionLayer];

%% Train the network 
trainedCNN0 = trainNetwork(xTrain0, yTrain0, layers, options0); %Gaussian
trainedCNN1 = trainNetwork(xTrain1, yTrain1, layers, options1); %Lorentzian

%% predict test data
predY0 = predict(trainedCNN0, xTest0);
predY1 = predict(trainedCNN1, xTest1);
predY = vertcat(predY0, predY1);
yTest = vertcat(yTest0, yTest1);

%% Name File
shortNames = ['A', 'B', 'E', 'S', 'N', 'L', 'D'];

saveFilename = generatefilename(...
    strcat('Networks/', ...
           shortNames(diff(intervals, 1, 2) ~= 0), ...
           '_', ...
           shortNames(saveVariables), ...
           '_', ...
           num2str(floor(nImages/1000)), ...
           '_N'), '.mat');
       
%% Save data
save(saveFilename,...
    'trainedCNN0', 'trainedCNN1',...
    'predY', 'yTest',...
    'saveVariables', 'intervals', 'names', ...
     'trainedCNN0', 'trainedCNN1');



