%% 
clear all; close all; clc;
load('human_ieeg.mat');

%% 1.1
dt = 1/info.fs_Hz;
stoptime = (length(data)*dt)-dt;
t = 0:dt:stoptime;

meanD = mean(data);
stdD = std(data);
threshold = meanD + stdD*6;
dataThres = data;
dataThres(dataThres < threshold) = 0;

spikes = [];
[peakValues, peakIndices] = findpeaks(dataThres);

for i = 1:length(peakValues)
    startI = (peakIndices(i) - floor(info.fs_Hz/1000));
    endI = (peakIndices(i) + floor(info.fs_Hz/1000));
    spikes(i,:) = data(startI:endI);
end

figure;
plot(1000*(0:dt:0.002), spikes(68,:))
title('EE486E, HW7, Q1.1');
xlabel('Time [msec]');
ylabel('Response [uV]');

%% 1.2.
spikesMean = mean(spikes);
figure;
hold on
plot(1000*(0:dt:0.002), spikes(:,:), 'b')
plot(1000*(0:dt:0.002), spikesMean, 'k', 'LineWidth', 2.5)
title('EE486E, HW7, Q1.2');
xlabel('Time [msec]');
ylabel('Response [uV]');
hold off



%% 1.3. 123rd Spike: Max Voltage = 110.5558 uV and Min Voltage = -28.1736 uV.
maxVolts = max(spikes');
minVolts = min(spikes');
MMV = [maxVolts; minVolts];
MMV = MMV';
MMV123 = MMV(123,:);

%% 1.4. 205th Norm Max Voltage = 0.2542 and Min Voltage = -0.8338.

MMVmean = mean(MMV);
MMVstd = std(MMV);
normFeats = [];
for i = 1:length(MMV(1,:))
    normFeats(:,i) = (MMV(:,i) - MMVmean(i))./MMVstd(i);
end

normFeats(205, :);

%% 2.1.

k = 3;
c = [normFeats(25,:); normFeats(116,:); normFeats(262,:)];
labels=[];
%(p-q).^2
for j = 1:100
for i = 1:308
   ed1 = sum((c(1,:)-normFeats(i,:)).^2);
   ed2 = sum((c(2,:)-normFeats(i,:)).^2);
   ed3 = sum((c(3,:)-normFeats(i,:)).^2);
 
   if(ed1 < ed2 && ed1 < ed3)
       labels(i) = 1;
   end
   if(ed2 < ed1 && ed2 < ed3)
       labels(i) = 2;
   end
   if(ed3 < ed1 && ed3 < ed2)
       labels(i) = 3;
   end
end
   greenInd = find(labels == 1);
   blueInd = find(labels == 2);
   redInd = find(labels == 3);
   c(1,:) = mean(normFeats(greenInd, :));
   c(2,:) = mean(normFeats(blueInd, :));
   c(3,:) = mean(normFeats(redInd, :));
end

greenInd = find(labels == 1);
blueInd = find(labels == 2);
redInd = find(labels == 3);
figure;
hold on
scatter(normFeats(greenInd, 2), normFeats(greenInd, 1), 'o', 'g')
scatter(normFeats(blueInd, 2), normFeats(blueInd, 1), 'o', 'b')
scatter(normFeats(redInd, 2), normFeats(redInd, 1), 'o', 'r')
title('EE486E, HW7, Q2.1')
xlabel('Minimum Normalized Voltage')
ylabel('Maximum Normalized Voltage')
hold off

%% 2.2. No, the values do not converge. This is because of the random 
%seeding.
k = 3;
c = [normFeats(124,:); normFeats(138,:); normFeats(283,:)];
labels=[];
%(p-q).^2
for j = 1:100
for i = 1:308
   ed1 = sum((c(1,:)-normFeats(i,:)).^2);
   ed2 = sum((c(2,:)-normFeats(i,:)).^2);
   ed3 = sum((c(3,:)-normFeats(i,:)).^2);
 
   if(ed1 < ed2 && ed1 < ed3)
       labels(i) = 1;
   end
   if(ed2 < ed1 && ed2 < ed3)
       labels(i) = 2;
   end
   if(ed3 < ed1 && ed3 < ed2)
       labels(i) = 3;
   end
end
   greenInd = find(labels == 1);
   blueInd = find(labels == 2);
   redInd = find(labels == 3);
   c(1,:) = mean(normFeats(greenInd, :));
   c(2,:) = mean(normFeats(blueInd, :));
   c(3,:) = mean(normFeats(redInd, :));
end

greenInd = find(labels == 1);
blueInd = find(labels == 2);
redInd = find(labels == 3);
figure;
hold on
scatter(normFeats(greenInd, 2), normFeats(greenInd, 1), 'o', 'g')
scatter(normFeats(blueInd, 2), normFeats(blueInd, 1), 'o', 'b')
scatter(normFeats(redInd, 2), normFeats(redInd, 1), 'o', 'r')
title('EE486E, HW7, Q2.2')
xlabel('Minimum Normalized Voltage')
ylabel('Maximum Normalized Voltage')
hold off

%% 2.3. sum(sumD) = 107.

[labels, C, sumD] = kmeans(normFeats, 3,'Replicates', 10);
sum(sumD);

greenInd = find(labels == 1);
blueInd = find(labels == 2);
redInd = find(labels == 3);
figure;
hold on
scatter(normFeats(greenInd, 2), normFeats(greenInd, 1), 'o', 'g')
scatter(normFeats(blueInd, 2), normFeats(blueInd, 1), 'o', 'b')
scatter(normFeats(redInd, 2), normFeats(redInd, 1), 'o', 'r')
title('EE486E, HW7, Q2.3')
xlabel('Minimum Normalized Voltage')
ylabel('Maximum Normalized Voltage')
hold off

%% 2.4. k = 2.
meanEuclid = [];
for i = 1:10
    [labels, C, sumD] = kmeans(normFeats, i,'Replicates', 10);
    meanEuclid(i) = sum(sumD);
end
figure;
plot(meanEuclid)
title('EE486E, HW7, Q2.4')
xlabel('k')
ylabel('Mean Squared Euclidean Distance')

%% 2.5.
[labels, C, sumD] = kmeans(normFeats, 2,'Replicates', 10);
sum(sumD);

greenInd = find(labels == 1);
blueInd = find(labels == 2);
redInd = find(labels == 3);
figure;
hold on
scatter(normFeats(greenInd, 2), normFeats(greenInd, 1), 'o', 'g')
scatter(normFeats(blueInd, 2), normFeats(blueInd, 1), 'o', 'b')
scatter(normFeats(redInd, 2), normFeats(redInd, 1), 'o', 'r')
title('EE486E, HW7, Q2.5')
xlabel('Minimum Normalized Voltage')
ylabel('Maximum Normalized Voltage')
hold off

%% 2.6.
%I would assume that the city block distance would be similar to the 
%euclidean because it encompasses the length of the legs, but the points 
%in between the two regions would change due because the city block 
%distance is actually larger than the euclidean because its a summation of
%the legs.

[labelsEuclid, C, sumD] = kmeans(normFeats, 2,'Replicates', 10);
[labelsCity, ctrs] = kmeans(normFeats, 2, 'Distance','city','Replicates',10);

figure;
subplot(2,1,1)
greenInd = find(labelsEuclid == 1);
blueInd = find(labelsEuclid == 2);
hold on
scatter(normFeats(greenInd, 2), normFeats(greenInd, 1), 'o', 'g')
scatter(normFeats(blueInd, 2), normFeats(blueInd, 1), 'o', 'b')
title([{'EE486E, HW7, Q2.6', 'Squared Euclidean Distance'}])
xlabel('Minimum Normalized Voltage')
ylabel('Max Normalized Voltage')
hold off
subplot(2,1,2)
greenInd = find(labelsCity == 1);
blueInd = find(labelsCity == 2);
hold on
scatter(normFeats(greenInd, 2), normFeats(greenInd, 1), 'o', 'g')
scatter(normFeats(blueInd, 2), normFeats(blueInd, 1), 'o', 'b')
title('Manhattan Distance')
xlabel('Minimum Normalized Voltage')
ylabel('Max Normalized Voltage')
hold off

%% 3.1. 

[directions, projections, variances] = pca(spikes);

varbynumcomp = variances;
totalVar = sum(variances);
cumVar = 0;
for i = 1:65
    cumVar = cumVar + variances(i);
    varbynumcomp(i) = cumVar/totalVar;
end
figure;
plot(varbynumcomp)
title('EE486E, HW7, Q3.1')
xlabel('Number of Main Components Remaining');
ylabel('Cumulative Proportion of Variance')

%% 3.2. 6 Main Components Remaining.

%% 3.3.

newProjections = projections(:,1:6);
meanEuclid = [];
for i = 1:10
[idx, C, sumD] = kmeans(newProjections, i);
meanEuclid(i) = sum(sumD);
end
%%figure;
%%plot(meanEuclid)
%Clusters k = 2
indexes = kmeans(newProjections, 2);
blueInd = find(indexes == 1);
greenInd = find(indexes == 2);
figure;
hold on
scatter(projections(blueInd,1), projections(blueInd,2), 'b')
scatter(projections(greenInd,1), projections(greenInd,2), 'g')
title('EE486E, HW7, Q3.3')
xlabel('Minimum Normalized Voltage')
ylabel('Maximum Normalized Voltage')
hold off

%% 3.4.
meanB = mean(spikes(blueInd,:));
meanG = mean(spikes(greenInd,:));
figure;
hold on
plot(1000*(0:dt:0.002), spikes(blueInd,:), 'b')
plot(1000*(0:dt:0.002), spikes(greenInd,:), 'g')
plot(1000*(0:dt:0.002), meanB, 'k', 'LineWidth', 2.5)
plot(1000*(0:dt:0.002), meanG, 'k', 'LineWidth', 2.5)
title('EE486E, HW7, Q3.4');
xlabel('Time [msec]');
ylabel('Response [uV]');
hold off
