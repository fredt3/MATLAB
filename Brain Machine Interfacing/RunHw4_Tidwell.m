close all; clear all; clc;
load('mouseV1.mat');

%% 1.1. 12
orderedStim = unique(stimuli(:,2));
noStimuli = length(orderedStim);

%% 1.2. Yes. 30 degree increments

%% 1.3. 10 trials for each grating angle.

trials = hist(stimuli, orderedStim);
trials = trials(:,2);

%% 1.4. 3.5557 seconds
times = stimuli(:,1);
timeTrial = diff(times);
trialAvg = mean(timeTrial) / 1000;

%% 1.5. 
times = transpose([transpose(times) (max(times) + trialAvg*1000)]);

array = [];
for i = 1:length(neurons)
    for j = 1:noStimuli
        hGram = histc(neurons{i}, times);
        sum1 = sum(hGram(stimuli(:,2) == orderedStim(j)));
        totalDur = (trialAvg * length(stimuli(stimuli(:,2) == orderedStim(j))));
        array(i, j) = sum1 / totalDur;
    end
end

%plot(orderedStim, array(1,:))
figure()
subplot(4, 1, 1)
    plot(orderedStim, array(1,:))
    title([{'EE486E, HW4, Q1.5'}, {'Neuron 1'}])
    ylabel('Spike Rate [s^-1]')
    xlabel('Stimulus Angle [degrees]')
subplot(4, 1, 2)
    plot(orderedStim, array(2,:))
    title('Neuron 2')
    ylabel('Spike Rate [s^-1]')
    xlabel('Stimulus Angle [degrees]')
subplot(4, 1, 3)
    plot(orderedStim, array(3,:))
    title('Neuron 3')
    ylabel('Spike Rate [s^-1]')
    xlabel('Stimulus Angle [degrees]')
subplot(4, 1, 4)
    plot(orderedStim, array(4,:))
    title('Neuron 4')
    ylabel('Spike Rate [s^-1]')
    xlabel('Stimulus Angle [degrees]')   
    
%% 1.6. The values are not exactly the same but the plots do suggest that 
%       there is a pattern every 180 degrees.

%% 1.7

secondArr = [];
for i = 1: length(neurons)
    for j = 1:(noStimuli/2)
        secondArr(i,j) = mean([array(i, j) array(i, j+6)]); 
    end
end
figure()
subplot(4, 1, 1)
    plot(orderedStim(1:6), secondArr(1,:))
    title([{'EE486E, HW4, Q1.7'}, {'Neuron 1'}])
    ylabel('Spike Rate [s^-1]')
    xlabel('Stimulus Angle [degrees]')
subplot(4, 1, 2)
    plot(orderedStim(1:6), secondArr(2,:))
    title('Neuron 2')
    ylabel('Spike Rate [s^-1]')
    xlabel('Stimulus Angle [degrees]')
subplot(4, 1, 3)
    plot(orderedStim(1:6), secondArr(3,:))
    title('Neuron 3')
    ylabel('Spike Rate [s^-1]')
    xlabel('Stimulus Angle [degrees]')
subplot(4, 1, 4)
    plot(orderedStim(1:6), secondArr(4,:))
    title('Neuron 4')
    ylabel('Spike Rate [s^-1]')
    xlabel('Stimulus Angle [degrees]') 
    
    
%% 2.1. 1.9486 spikes per second.
startTimes = stimuli(:,1);
gAngs = stimuli(:,2);
for i = 1:120
   if(gAngs(i) >= 180)
       gAngs(i) = gAngs(i) - 180;
   end
end
times = stimuli(:,1);
traintimes = times(1:71);
gAngs = gAngs(1:70);
ord_gAngs = unique(gAngs);
%times = transpose([transpose(times) (max(times) + trialAvg*1000)]);

array2 = [];
for i = 1:length(neurons)
    for j = 1:(noStimuli/2)
        hGram = histc(neurons{i}, traintimes);
        sum1 = sum(hGram(gAngs == ord_gAngs(j)));
        totalDur = (trialAvg * length(traintimes(gAngs == ord_gAngs(j))));
        array2(i, j) = sum1 / totalDur;
    end
end

%% 2.2.a.

times = stimuli(:,1);
times = transpose([transpose(times) (max(times) + trialAvg*1000)]);
testtimes = times(71:120);
gAngs = stimuli(71:120,2);

for i = 1:50
   if(gAngs(i) >= 180)
       gAngs(i) = gAngs(i) - 180;
   end
end

for i = 1:50
   for j = 1:length(neurons) 
        hGram = histc(neurons{j}, testtimes);
        num = hGram(i);
        den = trialAvg;
        S(i, j) = num/den;
   end
end

logLTest = S * log(array2);

figure()
subplot(4, 1, 1)
    plot(orderedStim(1:6), logLTest(1,:))
    title([{'EE486E, HW4, Q2.2.a.'}, {'Trial 71'}])
    legend('0')
    ylabel('Spike Rate [s^-1]')
    xlabel('Stimulus Angle [degrees]')
subplot(4, 1, 2)
    plot(orderedStim(1:6), logLTest(2,:))
    title('Trial 72')
    legend('180')
    ylabel('Spike Rate [s^-1]')
    xlabel('Stimulus Angle [degrees]')
subplot(4, 1, 3)
    plot(orderedStim(1:6), logLTest(3,:))
    title('Trial 73')
    legend('60')
    ylabel('Spike Rate [s^-1]')
    xlabel('Stimulus Angle [degrees]')
subplot(4, 1, 4)
    plot(orderedStim(1:6), logLTest(4,:))
    title('Trial 74')
    legend('0')
    ylabel('Spike Rate [s^-1]')
    xlabel('Stimulus Angle [degrees]') 
    
%% 2.2.b. The four likelihood functions seem to reflect the true stimulus 
%           decently well. Trial 74 was incorrect which could have been due
%           to noise.

%% 2.2.c. 40%
[Y, I] = max(transpose(logLTest));

pAng = (I-1)*30;
pAng = transpose(pAng);
counter = 0;
for i = 1:50
   if(pAng(i) == gAngs(i))
       counter = counter + 1;
   end
end

percent = counter / 50;

%% 2.2.d. MSE = 3816 degrees^2.


MSE = (1/length(pAng))*sum((gAngs-pAng).^2);

%% 2.3. I was able to decode the stimuli 40% of the time. With this being 
% biological system, I think this is a decent accuracy. Some ways I think
% would improve the algorithm's performance would be to take out the gray
% screen and see if there are other correlations besides the 180 degree 
% difference.