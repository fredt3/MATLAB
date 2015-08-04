close all; clear all; clc;
load('p300DataTrain.mat');

%% 1.1.
data11 = EEG(:,:,:, 11);
tcount = 0;
ntcount = 0;
targ = zeros(240, 1);
ntarg = zeros(240, 1);

for i = 1:50
    for j = 1:180
        if(StimType(i, j) == 1)
            tcount = tcount + 1;
            targ = targ + squeeze(data11(i, j, :)); 
            
        else
            ntcount = ntcount + 1;
            ntarg = ntarg + squeeze(data11(i, j, :));
        end
    end
end

tmean = targ / tcount;
ntmean = ntarg / ntcount;

t = 0:1/info.Fs_Hz: (1-(1/info.Fs_Hz));
figure;
hold on;
plot(t*1000, tmean)
plot(t*1000, ntmean, 'r')
xlabel('Time [ms]')
ylabel('Voltage [uV]')
title('EE486E, HW6, Q1.1')
hold off

%% 1.2.
data23 = EEG(:,:,:, 23);
tcount = 0;
ntcount = 0;
targ = zeros(240, 1);
ntarg = zeros(240, 1);

for i = 1:50
    for j = 1:180
        if(StimType(i, j) == 1)
            tcount = tcount + 1;
            targ = targ + squeeze(data23(i, j, :)); 
            
        else
            ntcount = ntcount + 1;
            ntarg = ntarg + squeeze(data23(i, j, :));
        end
    end
end

tmean = targ / tcount;
ntmean = ntarg / ntcount;

t = 0:1/info.Fs_Hz: (1-(1/info.Fs_Hz));
figure;
hold on;
plot(t*1000, tmean)
plot(t*1000, ntmean, 'r')
xlabel('Time [ms]')
ylabel('Voltage [uV]')
title('EE486E, HW6, Q1.2')
hold off

%% 1.3.
% I would choose a time betwenn 300 and 600 ms. During this time, the
% difference between the target and nontarget voltage is the greatest. In
% addition I would choose channel 11. This is because Channel's 11
% difference in voltage is much greater than Channel 23's difference.

%% 1.4.
for k = 1:64
    data = EEG(:,:,:, k);
    tcount = 0;
    ntcount = 0;
    targ = zeros(240, 1);
    ntarg = zeros(240, 1);
    for i = 1:50
      for j = 1:180
         if(StimType(i, j) == 1)
            tcount = tcount + 1;
            targ = targ + squeeze(data(i, j, :)); 
            
         else
            ntcount = ntcount + 1;
            ntarg = ntarg + squeeze(data(i, j, :));
         end
      end
    end
    tmean = targ / tcount;
    ntmean = ntarg / ntcount;
    meandiff300(k) = tmean(73)-ntmean(73);
end

figure;
topoplotEEG(double(transpose(meandiff300)), 'eloc64.txt', 'gridscale', 150);
colorbar;
title('EE486E, HW6, Q1.4')

%% 1.5.
% Channel 11 is the center of the brain. You can see that the difference is
% higher in this area as it is the brightest color (my plot does not have
% red) on the plot. Channels 47, 56, 55, 60 are in the dark blue and
% which represent the smallest difference at t = 300 ms.

%% 2.1. 1.4996
t = 0:1/info.Fs_Hz: (1-(1/info.Fs_Hz));
start1 = find(t == 0.250);
end1 = find(t == 0.450);
start2 = 145;
end2 = 169;
data = squeeze(EEG(10, 11, :, 11));
p300score = mean(data(start1:end1)) - mean(data(start2:end2))

%% 2.2.
% I expected this value to be rather high because the potential peaks at around 300 ms and
% starts to settle down around 600 ms.

%% 2.3.

scores = zeros(12, 1);
counts = scores;

for i = 1:180
	data = squeeze(EEG(20, i, :, 11));
    p300score = mean(data(start1:end1)) - mean(data(start2:end2));
    scores(StimCode(20,i)) = scores(StimCode(20, i)) + p300score;
    counts(StimCode(20,i)) = counts(StimCode(20, i)) + 1;
end

scores = scores ./ counts;
figure;
plot(scores)
xlabel('Index (the row or column)')
ylabel('Voltage [uV]')
title('EE486E, HW6, Q2.3')
xlim([1 12])

%% 2.4. Highest two magnitudes were row 4, column 7 which indicated D, 
% which is correct.

%% 2.5. 64% First 5 = 4 A P V 5
allscores = zeros(12, 50);

for j = 1:50
    scores = zeros(12, 1);
    counts = scores;
    for i = 1:180
        data = squeeze(EEG(j, i, :, 11));
        p300score = mean(data(start1:end1)) - mean(data(start2:end2));
        scores(StimCode(j,i)) = scores(StimCode(j, i)) + p300score;
        counts(StimCode(j,i)) = counts(StimCode(j, i)) + 1;
    end
    scores = scores ./ counts;
    allscores(:, j) = scores;
end

ArrayMat = [ 'A' 'B' 'C' 'D' 'E' 'F'
             'G' 'H' 'I' 'J' 'K' 'L' 
             'M' 'N' 'O' 'P' 'Q' 'R'
             'S' 'T' 'U' 'V' 'W' 'X'
             'Y' 'Z' '1' '2' '3' '4'
             '5' '6' '7' '8' '9' ' ' ];
         
prediction = [];
tre = 0;
count = 0;
for i = 1:50
   pRow = find(max(allscores(7:12, i)) == allscores(:, i)) - 6;
   pCol = find(max(allscores(1:6, i)) == allscores(:, i));
   prediction(i) = ArrayMat(pRow, pCol);
   if(prediction(i) == TargetChar(i))
        count = count + 1;
   end
end
tre = 1 - (count/50);

%%
clear all; clc;
load('p300DataValidate.mat')

%% 2.6. 65.71% First 5 predicted characters = R Z 3 O L
t = 0:1/info.Fs_Hz: (1-(1/info.Fs_Hz));
start1 = find(t == 0.250);
end1 = find(t == 0.450);
start2 = 145;
end2 = 169;

allscores = zeros(12, 35);

for j = 1:35
    scores = zeros(12, 1);
    counts = scores;
    for i = 1:180
        data = squeeze(EEG(j, i, :, 11));
        p300score = mean(data(start1:end1)) - mean(data(start2:end2));
        scores(StimCode(j,i)) = scores(StimCode(j, i)) + p300score;
        counts(StimCode(j,i)) = counts(StimCode(j, i)) + 1;
    end
    scores = scores ./ counts;
    allscores(:, j) = scores;
end

ArrayMat = [ 'A' 'B' 'C' 'D' 'E' 'F'
             'G' 'H' 'I' 'J' 'K' 'L' 
             'M' 'N' 'O' 'P' 'Q' 'R'
             'S' 'T' 'U' 'V' 'W' 'X'
             'Y' 'Z' '1' '2' '3' '4'
             '5' '6' '7' '8' '9' ' ' ];
         
prediction = [];
tre = 0;
count = 0;
for i = 1:35
   pRow = find(max(allscores(7:12, i)) == allscores(:, i)) - 6;
   pCol = find(max(allscores(1:6, i)) == allscores(:, i));
   prediction(i) = ArrayMat(pRow, pCol);
   if(prediction(i) == TargetChar(i))
        count = count + 1;
   end
end
tre = 1 - (count/35);

%% 3.1
% One potential advantage is the number of different classifications
% techniques that can be used on the data without needing much
% computational power. One disadvantage is having potentially useful
% features that could have given us better predictors.

%% 3.2. I would say that this is a 36-way classification task. Just because
% the computation of the single feature was not complex did not mean we did
% not classify the data into 36 different sets.

%% 3.3. A way we could improve on our prediction algorithm is by adding 
% features to our data set. We could use Entropy or Rectified Aread
% differences between the two time frames to see how they do at predicting
% the correct character epoch. We could take advantage of the data labels
% by only using the data from the targeted data and discriminating against
% the non-targeted data. This would assist in selecting more informative
% features in large sets.

%% 
clear all; clc;
load('simData');

%% 4.1. MSEtrain = 0.7871 and MSEtest = 9234.7
B = regress(yTrain, xTrain);
ptrain = xTrain*B;
pval = xVal*B;

MSEtrain = (1/length(ptrain))*sum((yTrain-ptrain).^2);
MSEtest = (1/length(pval))*sum((yVal-pval).^2);

%% 4.2. Regression was based on train data so the validation set which had 
% less data. The MSE for the training was rather small because it was
% calculated using the training data.

%% 4.3. Features 1 through 4.
sequentialfs(@myRSS,xTrain,yTrain);

%% 4.4. B =
%
%   -2.5961
%    0.5523
%    0.0778
%    8.8985
% MSEtrain = 0.8209

B = regress(yTrain, xTrain(:, 1:4));
ptrain = xTrain(:, 1:4)*B;
pval = xVal(:, 1:4)*B;

MSEtrain = (1/length(ptrain))*sum((yTrain-ptrain).^2);
MSEtest = (1/length(pval))*sum((yVal-pval).^2);

%% 4.5. SE = 
%       0.1460
%       0.1909    
%       0.0797    
%       0.0530
% Figure 2 because it has the highest SE at 0.1909. This means that the
% estimate of the B coefficient varies much more than the other 3 features.
SE = std(bootstrp(1000, @regress, yTrain, xTrain(:,1:4)));

%% 4.6. The validation set MSE was 1.4394, which is order of magnitudes 
% lower than the original MSE in 4.1. This is most likely from the other 7
% features were acting as noise for the prediction and when we scrapped
% those features are prediction became more accurate and precise.
