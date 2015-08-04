%%
close all; clear all; clc;
load('trainDataTubingen.mat');
greenInd = find(Y == 1);
blueInd = find(Y == -1);
lengthTrain = 278;
%%
green = X(greenInd, :, :);
blue = X(blueInd, :, :);

%%
for i = 1:length(greenInd)
    greenMean(i, :) = squeeze(mean(green(i,:,:)));
    blueMean(i, :) = squeeze(mean(blue(i,:,:)));
end

greenMean = mean(greenMean);
blueMean = mean(blueMean);
figure;
plot(greenMean);
title('green reg')
figure;
plot(blueMean);
title('blue reg')
fs = 1000;
figure;hold on;
BPgreen = filter_IF(greenMean, 13, 30, fs);
plot(BPgreen , 'g');
BPblue = filter_IF(blueMean, 13, 30, fs);
plot(BPblue);
title('BP')
%%
temp = squeeze(filter_IF(X(8,2,:), 10, 13, fs));
data = BPgreen;
meanD = mean(data);
stdD = std(data);
threshold = 0;%meanD + stdD*3;
dataThres = data;
dataThres(dataThres < threshold) = 0;

spikes = [];
[peakValues, peakIndices] = findpeaks(dataThres);
temp(temp < 0 ) = 0;
figure;plot(temp)
%%
figure;
hold on
[freqG, powerG] = spec_analysis(greenMean, fs, 1);
[freqB, powerB] = spec_analysis(blueMean, fs, 1);
plot(freqG, powerG, 'g')
plot(freqB, powerB, 'b')
title('Bode')
hold off

gPow = bandpower(greenMean, 1000, [350 499])
bPow = bandpower(blueMean, 1000, [350 499])
%% to get useful data out of samples, bandpass them
flow = 100;
fhigh = 499;
fs = 1000;
for i = 1:278
    for j = 1:64
        XlowBP(i, j, :) = filter_IF(X(i, j, :), 8, 30, fs);
        %XhighBP(i, j, :) = filter_IF(X(i, j, :), flow, fhigh, fs);
    end
end

%%

figure;hold on
for i = greenInd
   plot(squeeze(XlowBP(1, 2, :)), 'g')
end

%%

%% 
X = XlowBP;
chk = 1:64;
%for jk = 1:64
%   for test = 1:64
%      if(test ~= jk)
%          chk(test) = test;
%      end
%   end
%   chk = chk(chk ~= 0);
%chk = [1 2];
for i = 1:lengthTrain
    meanSignal(i, :) = squeeze(mean(X(i,chk,:)));
    %testSig(i, :) = squeeze(mean(Xlow(i,1:64,:)));
end
%trainSamples = squeeze(X(:, :, :));
%%  signal = squeeze(X(20, 32, :));
for i = 1:lengthTrain
fs = 1000;
L = 50; 
d = 5;
recordTime = length(meanSignal(i,:))/fs;
time1 = 0:1/fs:(recordTime - 1/fs);
[eFeat, numIgnored] = rfeature(meanSignal(i,:),@(x) sum(x.^2),L,d);
temp = [NaN(1,numIgnored+L-1) zohinterp(eFeat,d)];
en = temp(1:length(meanSignal(i,:)));
normalEn = (en/max(en))*2*max(meanSignal(i,:));

[eMean, numIgnored] = rfeature(normalEn,@mean,L,d);
temp = [NaN(1,numIgnored+L-1) zohinterp(eMean,d)];
energyMean = temp(1:length(normalEn));

[eVar, numIgnored] = rfeature(normalEn,@var,L,d);
temp = [NaN(1,numIgnored+L-1) zohinterp(eVar,d)];
energyVar = temp(1:length(normalEn));

meanVar = energyMean./energyVar;
threshold = 20;
thresholdPlot(i) = max((threshold/max(meanVar)) * 2 * max(meanSignal(i,:)) * ones(1, 3000));
normalMeanVar(i) = max((meanVar/max(meanVar)) * 2 * max(meanSignal(i,:)));

% figure()
% hold on
% plot(time1, meanSignal(i,:))
% plot(time1, normalMeanVar, 'g')
% legend('data', 'normalMeanVar')
% title('EE486E, HW2, Q3.1')
% ylabel('Amplitude [uV]');
% xlabel('Time [s]');
% hold off
end
% figure;
% hold on
% plot(normalMeanVar(greenInd,:), 'g')
% plot(normalMeanVar(blueInd,:), 'b')
% hold off
%%
trainSamples = meanSignal;
trainFeats = [];
for i = 1:lengthTrain
    %line length
   trainFeats(i, 1) = sum(abs(diff(trainSamples(:,i))));
   %rectified area
   trainFeats(i, 2) = sum(abs(trainSamples(:,i)));
   %max voltage
   trainFeats(i, 3) = max(trainSamples(:,i));
   %min voltage
   trainFeats(i, 4) = min(trainSamples(:,i));
   %energy
   trainFeats(i, 5) = sum(abs(trainSamples(:,i)).^2);
   %average
   trainFeats(i, 6) = bandpower(trainSamples(:,i), 1000, [7.5 13]);
   trainFeats(i, 7) = bandpower(trainSamples(:,i), 1000, [15 30]);
   trainFeats(i, 8) = bandpower(trainSamples(:,i), 1000, [4 8]);
   trainFeats(i, 9) = bandpower(trainSamples(:,i), 1000, [1 3]);
   trainFeats(i, 10) = bandpower(trainSamples(:,i), 1000, [350 499]);
   trainFeats(i, 11) = bandpower(trainSamples(:,i), 1000, [70 150]);
   trainFeats(i, 12) = normalMeanVar(i);
end
% for i = 1:10
% figure;
% hold on
% scatter(1:length(greenInd), trainFeats(greenInd, i), 'o', 'g')
% scatter(1:length(blueInd), trainFeats(blueInd, i), 'o', 'b')
% end
%normalize
meanFeats = mean(trainFeats);
stdFeats = std(trainFeats);
normFeats = [];
for i = 1:length(trainFeats(1,:))
    normFeats(:,i) = (trainFeats(:,i) - meanFeats(i))./stdFeats(i);
end

greenInd = find(Y == 1);
blueInd = find(Y == -1);
% for i = 1:8
% figure;
% hold on
% scatter(1:length(greenInd), normFeats(greenInd, i), 'o', 'g')
% scatter(1:length(blueInd), normFeats(blueInd, i), 'o', 'b')
% hold off
% end

% figure;
% plot(normFeats(greenInd, 1), 'o')%, 'g')
% figure;
% plot(normFeats(greenInd, 2), 'o')
% figure;
% plot(normFeats(greenInd, 3), 'o')
% figure;
% plot(normFeats(greenInd, 4), 'o')
% figure;
% plot(normFeats(greenInd, 5), 'o')
% figure;
% plot(normFeats(greenInd, 6), 'o')

trainLabels = Y;
trainLabels(trainLabels == -1) = 2;

%%

% cTrain = knnclassify(normFeats(:, [5 8]),normFeats(:, [5 8]), trainLabels);
% %cTest = knnclassify(normTestFeats, normTrainFeats, trainLabels);
% 
% counterTrain = 0;
% for i = 1:100
%    if(cTrain(i) == trainLabels(i))
%        counterTrain = counterTrain + 1;
%    end
% 
% end
% trainER = 1 - (counterTrain/100); 
% 
% yhigh = 2.5; ylow = -2; xhigh = 4; xlow = -2;
% %[X, Y] = meshgrid(xlow:0.01:xhigh, ylow:0.1:yhigh);
% [Xp, Yp] = meshgrid(linspace(xlow,xhigh), linspace(ylow,yhigh));
% Xp = Xp(:); Yp = Yp(:);
% cTest = knnclassify([Xp, Yp], normFeats(:, 5:6), trainLabels);
% 
% figure();
% hold on
% gscatter(Xp,Yp,cTest,'gb','.');
% scatter(normFeats(greenInd, 5), normFeats(greenInd, 8), 'o', 'g')
% scatter(normFeats(blueInd, 5), normFeats(blueInd, 8), 'o', 'b')
% title('EE486E, HW5, Q2.7.a. k-NN')
% legend('Artifact', 'Valid HFO')
% hold off

%% 
x = normFeats(:,[ 10 12]);
mnr = mnrfit(x, trainLabels);
phat = mnrval(mnr, x);
[~,yHat] = max(phat,[],2);

counterTrain = 0;
for i = 1:lengthTrain
   if(yHat(i) == trainLabels(i))
       counterTrain = counterTrain + 1;
   end

end
trainER = 1 - (counterTrain/lengthTrain); 

%% SVM 3
x = normFeats(:,[1 2 3 4 5 6 7 8 9 10 11 12]);
trainSet = x(1:175, :);
trainLabels = Y(1:length(trainSet));
testSet = x((length(trainSet)+1):278, :);
testLabels = Y((length(trainSet)+1):278);
SVMSTRUCT = svmtrain(trainSet, trainLabels, 'kernel_function','rbf');
cTrain = svmclassify(SVMSTRUCT, trainSet);
cTest = svmclassify(SVMSTRUCT, testSet);
counterTrain = 0;
for i = 1:length(trainLabels)
   if(cTrain(i) == trainLabels(i))
       counterTrain = counterTrain + 1;
   end
end
trainER = 1 - (counterTrain/length(trainSet));

counterTest = 0;
for i = 1:length(testLabels)
   if(cTest(i) == testLabels(i))
       counterTest = counterTest + 1;
   end
end
testER = 1 - (counterTest/length(testSet));
%lookat(jk) = trainER;
%end
%%
[labelsEuclid, C, sumD] = kmeans(normFeats, 2,'Replicates', 10);
[labelsCity, ctrs] = kmeans(normFeats, 2, 'Distance','city','Replicates',10);

counterTrain = 0;
for i = 1:lengthTrain
   if(labelsCity(i) == trainLabels(i))
       counterTrain = counterTrain + 1;
   end

end
trainER = 1 - (counterTrain/lengthTrain); 

%%
[directions, projections, variances] = pca(meanSignal);

varbynumcomp = variances;
totalVar = sum(variances);
cumVar = 0;
for i = 1:277
    cumVar = cumVar + variances(i);
    varbynumcomp(i) = cumVar/totalVar;
end
figure;
plot(varbynumcomp)

newProjections = projections(:,1:50);
meanEuclid = [];
for i = 1:10
[idx, C, sumD] = kmeans(newProjections, i);
meanEuclid(i) = sum(sumD);
end
figure;
plot(meanEuclid)

indexes = kmeans(newProjections, 2);
blueInd = find(indexes == 1);
greenInd = find(indexes == 2);

counterTrain = 0;
for i = 1:lengthTrain
   if(indexes(i) == trainLabels(i))
       counterTrain = counterTrain + 1;
   end

end
trainER = 1 - (counterTrain/lengthTrain); 