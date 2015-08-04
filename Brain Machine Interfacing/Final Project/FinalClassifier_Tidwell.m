function predictedClass = FinalClassifier_Tidwell(testData)

%Call Train Features 278x14
normTrainFeats = load('trainFeats.mat');
normTrainFeats = normTrainFeats.normFeats;

%Call Train Labels 278x1
trainLabels = load('trainLabels.mat');
trainLabels = trainLabels.Y;

%Filter testData
for i = 1:length(testData(:,1,1))
    for j = 1:64
        testData(i, j, :) = filter_IF(testData(i, j, :), 7.5, 13, 1000);
    end
end

%Create Test Features
testFeats = [];
selectFeats = [2 6 10 11 12 18 19 21 22 23 24 27 28 30 32 38 39 40 46 53 54 56 59 62 64];
for i = 1:length(testData(:,1,1))
   for j = 1:length(selectFeats)
       testFeats(i, j) = sum(abs(diff(squeeze(testData(i, selectFeats(j), :)))));
   end
end

%normalize
meanFeats = mean(testFeats);
stdFeats = std(testFeats);
normTestFeats = [];
for i = 1:length(testFeats(1,:))
    normTestFeats(:,i) = (testFeats(:,i) - meanFeats(i))./stdFeats(i);
end


% Apply Classifier LDA
trainLabels(trainLabels == -1) = 2;
cTest = classify(normTestFeats, normTrainFeats, trainLabels, 'linear');
cTest(cTest == 2) = -1;

%return labels
predictedClass = cTest;

end