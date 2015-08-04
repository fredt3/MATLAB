close all; clear all; clc;
load('hfos2015.mat');

%% 1.1. 50 Artifacts and 50 valid HFOs.

artIndex = find(trainLabels == 1);
hfoIndex = find(trainLabels == 2);
countArtifacts = length(artIndex);
countHFO = length(hfoIndex);

%% 1.2. 

firstArt = trainSamples(artIndex(1));
firstHFO = trainSamples(hfoIndex(1));
t_hfo_raw = firstHFO.start_msec:1000/firstHFO.fsRaw:firstHFO.stop_msec;
t_hfo_det = firstHFO.start_msec:1000/firstHFO.fsDetection:firstHFO.stop_msec;
t_art_raw = firstArt.start_msec:1000/firstArt.fsRaw:firstArt.stop_msec;
t_art_det = firstArt.start_msec:1000/firstArt.fsDetection:firstArt.stop_msec;

figure();
suptitle([{'EE486E, HW5, Q1.2'}, {' '}, {' '}])
subplot(2, 2, 1)
    plot(t_hfo_raw, firstHFO.raw_norm )
    set(gca,'YTick',[])
    title('HFO Raw')
    xlabel('Time [ms]')
subplot(2, 2, 2)
    plot(1.205176409878364e+07:1000/32556:1.205178326575746e+07, firstArt.raw_norm )
    set(gca,'YTick',[])
    title('Artifacts Raw')
    xlabel('Time [ms]')
subplot(2, 2, 3)
    plot(t_hfo_det, firstHFO.detection)
    set(gca,'YTick',[])
    title('HFO BandPassed')
    xlabel('Time [ms]')
subplot(2, 2, 4)
    plot(t_art_det, firstArt.detection)
    set(gca,'YTick',[])
    title('Artifacts BandPassed')
    xlabel('Time [ms]')
    
    
%% 1.3. The HFOs have a period of spikes where the time-epoch will have
% unusually high energy. The Artifacts still have the high energy because
% of it's dramatic change in amplitude.

%% 1.4. 

trainFeats = [];
for i = 1:length(trainLabels)
   trainFeats(i, 1) = sum(abs(diff(trainSamples(i).raw_norm)));
   trainFeats(i, 2) = sum(abs(trainSamples(i).raw_norm));
end

testFeats = [];
for i = 1:length(testLabels)
   testFeats(i, 1) = sum(abs(diff(testSamples(i).raw_norm)));
   testFeats(i, 2) = sum(abs(testSamples(i).raw_norm));
end

figure();
hold on
scatter(trainFeats(artIndex,1), trainFeats(artIndex,2), 'r')
scatter(trainFeats(hfoIndex,1), trainFeats(hfoIndex,2), 'g')
title('EE486E, HW5, Q1.4')
legend('Artifact', 'Valid HFO')
hold off


%% 1.5.a.

trainMean = mean(trainFeats);
trainStd = std(trainFeats);

normTrainFeats1 = (trainFeats(:,1) - trainMean(1))./trainStd(1);
normTrainFeats2 = (trainFeats(:,2) - trainMean(2))./trainStd(2);
normTestFeats1 = (testFeats(:,1) - trainMean(1))./trainStd(1);
normTestFeats2 = (testFeats(:,2) - trainMean(2))./trainStd(2);

normTrainFeats = cat(2, normTrainFeats1, normTrainFeats2);
normTestFeats = cat(2, normTestFeats1, normTestFeats2);

figure();
hold on
scatter(normTrainFeats(artIndex,1), normTrainFeats(artIndex,2), 'r')
scatter(normTrainFeats(hfoIndex,1), normTrainFeats(hfoIndex,2), 'g')
title('EE486E, HW5, Q1.5.a.')
legend('Artifact', 'Valid HFO')
hold off

%% 1.5.b. If we do not normalize, classifiers such as k-Nearest Neighbor
% will over-emphasize between points that are farther away. Normalizing,
% will allow the data set to be closer together for better prediction
% performance.

%% 1.5.c. Normally, training sets are set aside to calibrate the current 
% system. The test set could be runtime data that you would be applying the
% means and standard deviations to continuously. The test set should not be
% used to re-train the system.

%% 2.1 Error Rate for Test = 17.69%. Error Rate for Training = 0%. 
cTrain = knnclassify(normTrainFeats, normTrainFeats, trainLabels);
cTest = knnclassify(normTestFeats, normTrainFeats, trainLabels);


counterTrain = 0;
for i = 1:100
   if(cTrain(i) == trainLabels(i))
       counterTrain = counterTrain + 1;
   end

end
trainER = 1 - (counterTrain/100); 

counterTest = 0;
for i = 1:520
   if(cTest(i) == testLabels(i))
       counterTest = counterTest + 1;
   end

end
testER = 1 - (counterTest/520);

%% 2.2. The training error is zero because the training set was used to
% determine the classifier. So with k equal to one, the nearest neighbor 
% be the training data. So when the sample and the training sets are
% the same, the error is always zero.

%% 2.3. Train Error Rate = 13%.

mnr = mnrfit(normTrainFeats, trainLabels);
phat = mnrval(mnr, normTrainFeats);
[~,yHat] = max(phat,[],2);

counterTrain = 0;
for i = 1:100
   if(yHat(i) == trainLabels(i))
       counterTrain = counterTrain + 1;
   end

end
trainER = 1 - (counterTrain/100); 

%% 2.4. Test Error Rate = 14.23%. Train Error Rate is smaller because the 
% binary logistic regression line is fit to the training error and is
% biased towards it.

mnr = mnrfit(normTrainFeats, trainLabels);
phat = mnrval(mnr, normTestFeats);
[~,yHat] = max(phat,[],2);

counterTest = 0;
for i = 1:520
   if(yHat(i) == testLabels(i))
       counterTest = counterTest + 1;
   end

end
testER = 1 - (counterTest/520);

%% 2.5. Error Rate for Test = 13.27%. Error Rate for Training = 12.00%. 
cTrain = classify(normTrainFeats, normTrainFeats, trainLabels, 'quadratic');
cTest = classify(normTestFeats, normTrainFeats, trainLabels, 'quadratic');


counterTrain = 0;
for i = 1:100
   if(cTrain(i) == trainLabels(i))
       counterTrain = counterTrain + 1;
   end

end
trainER = 1 - (counterTrain/100); 

counterTest = 0;
for i = 1:520
   if(cTest(i) == testLabels(i))
       counterTest = counterTest + 1;
   end

end
testER = 1 - (counterTest/520);


%% 2.6. Error Rate for Test = 13.65%. Error Rate for Training = 7.00%. 

SVMSTRUCT = svmtrain(normTrainFeats, trainLabels, 'kernel_function','rbf');
cTrain = svmclassify(SVMSTRUCT, normTrainFeats);
cTest = svmclassify(SVMSTRUCT, normTestFeats);

counterTrain = 0;
for i = 1:100
   if(cTrain(i) == trainLabels(i))
       counterTrain = counterTrain + 1;
   end

end
trainER = 1 - (counterTrain/100); 

counterTest = 0;
for i = 1:520
   if(cTest(i) == testLabels(i))
       counterTest = counterTest + 1;
   end

end
testER = 1 - (counterTest/520);

%% 2.7. 

yhigh = 3; ylow = -3; xhigh = 3; xlow = -2;
%[X, Y] = meshgrid(xlow:0.01:xhigh, ylow:0.1:yhigh);
[X, Y] = meshgrid(linspace(xlow,xhigh), linspace(ylow,yhigh));
X = X(:); Y = Y(:);
cTest = knnclassify([X, Y], normTrainFeats, trainLabels);

figure();
hold on
gscatter(X,Y,cTest,'rg','.');
scatter(normTrainFeats(artIndex,1), normTrainFeats(artIndex,2), 'r')
scatter(normTrainFeats(hfoIndex,1), normTrainFeats(hfoIndex,2), 'g')
title('EE486E, HW5, Q2.7.a. k-NN')
legend('Artifact', 'Valid HFO')
hold off

mnr = mnrfit(normTrainFeats, trainLabels);
phat = mnrval(mnr, [X,Y]);
[~,yHat] = max(phat,[],2);
K = mnr(1);
L = mnr(2);
Q = mnr(3);
% Function to compute K + L*v + v'*Q*v for multiple vectors
% v=[x;y]. Accepts x and y as scalars or column vectors.
f = @(x,y) K + [x y]*L + sum(([x y]*Q) .* [x y], 2);

figure();
hold on
gscatter(X,Y,yHat,'rg','.');
%h2 = ezplot(f,[4.5 8 2 4]);
scatter(normTrainFeats(artIndex,1), normTrainFeats(artIndex,2), 'r')
scatter(normTrainFeats(hfoIndex,1), normTrainFeats(hfoIndex,2), 'g')
title('EE486E, HW5, Q2.7.a. Logistic Regression')
legend('Artifact', 'Valid HFO')
hold off

cTrain = classify([X,Y], normTrainFeats, trainLabels, 'quadratic');


figure();
hold on
gscatter(X,Y,cTrain,'rg','.');
scatter(normTrainFeats(artIndex,1), normTrainFeats(artIndex,2), 'r')
scatter(normTrainFeats(hfoIndex,1), normTrainFeats(hfoIndex,2), 'g')
title('EE486E, HW5, Q2.7.a. QDA')
legend('Artifact', 'Valid HFO')
hold off

SVMSTRUCT = svmtrain(normTrainFeats, trainLabels, 'kernel_function','rbf');
cTrain = svmclassify(SVMSTRUCT, [X,Y]);

figure();
hold on
gscatter(X,Y,cTrain,'rg','.');
scatter(normTrainFeats(artIndex,1), normTrainFeats(artIndex,2), 'r')
scatter(normTrainFeats(hfoIndex,1), normTrainFeats(hfoIndex,2), 'g')
title('EE486E, HW5, Q2.7.a. SVM')
legend('Artifact', 'Valid HFO')
hold off

%% 2.8. In the k-NN plot, Because k = 1 the decision boundary seems to be 
% overfitted in favor of the training data. This is another explaination
% why the training error rate = 0%. The Logistic Regression model seemed
% underfit and allowed for too much error to occur. The other two plots,
% the QDA and SVM, both did a good job fitting the model but I believe the
% SVM plot had a better fit especially since it's performance is higher
% than QDA.

%% 2.9. 
knnClassTrainArr = [];
knnClassTestArr = [];
knnTrainER = [];
knnTestER = [];
for i=1:25
    cTrain = knnclassify(normTrainFeats, normTrainFeats, trainLabels, i);
    cTest = knnclassify(normTestFeats, normTrainFeats, trainLabels, i);

    counterTrain = 0;
    for j = 1:100
        if(cTrain(j) == trainLabels(j))
               counterTrain = counterTrain + 1;
        end

    end
    knnTrainER(i) = 1 - (counterTrain/100); 

    counterTest = 0;
    for k = 1:520
        if(cTest(k) == testLabels(k))
               counterTest = counterTest + 1;
        end

    end
    knnTestER(i) = 1 - (counterTest/520);
end
figure();
hold on
plot(1:25, knnTrainER, ':')
plot(1:25, knnTestER, 'b')
title('EE486E, HW5, Q2.9.')
xlabel('k-Value')
ylabel('Error Rate')
legend('Training Error','Test Error');
set(gca, 'XDir', 'reverse');
hold off

%% 2.10. For the k-NN training and test curves, the test curve does as 
% expected and makes a somewhat parabolic shape with a minimum around the k
% = to 10-15 region. For the training curve, the error rate with the 
% k value up to 2 is zero percent (like predicted earlier) and seems to
% level off at an error rate at around 10%.

%% 3.1. k = 11. Error Rate = 10.00%.

indices = crossvalind('Kfold', trainLabels, 10);

for k = 1:25
    cp = classperf(trainLabels);
    for i = 1:10
    test = (indices == i); train = ~test;
    class = knnclassify(normTrainFeats(test,:), normTrainFeats(train,:), trainLabels(train,:), k);
    classperf(cp, class, test)
    end
    errRates(k) = cp.ErrorRate;
end

%% 3.2. The difference in mean between the two rates is 0.38%. The two 
% rates are very similar in percentage.

meanErr = mean(errRates);
meanKnnErr = mean(knnTestER);

%% 3.3.  The "optimal" k-NN classifier in comparision with the test error 
% rates calculated in Section 2 was very close to the predictions of the
% error rates quadratic and SVM-RBF classifiers, but higher than the
% Logistic Regression.

%% 3.4. I do not think it is a fair comparison because the test in the 
% cross validation is using 100 points where the other tests run 520
% points. To make it more fair they should have the same test set and have
% the same length.