%% Fred Tidwell
%EE486E
%HW 01
%
%%
close all, clear all, clc
load('units.mat')

%%
%1.1. The sampling rate is 32051 Hz
fs = info.fs_Hz;


%%
%1.2. The Nyquist freq is 16025.5 Hz
nyquistFreq = fs/2;

%%
%1.3 The data would be aliased.

%%
%1.4 The recording is 10 s
recordTime = length(data)/fs;

%%
% 1.5 Plot the 7th second of the recording. label x in seconds. i.e 7s = 0s and
% 8s = 1s
time = 0:1/fs:(recordTime - 1/fs);

startIndex = find(time==6);
stopIndex = find(time==7);
plotTime = time(startIndex:stopIndex);
plotTime = plotTime - 6;
plotData = data(startIndex:stopIndex);
figure()
plot(plotTime,plotData)
title('EE486E, HW1, Q1.5')
xlabel('Time [s]')
ylabel('Amplitude [uV]')


%%
%1.6 I would make the threshold 50 microvolts

%%
%1.7 The time of the third spike is 486.1 msecs.

for i = 1:length(plotData)
   if(plotData(i) < 50)
       plotData(i) = 0;
   end
end
startcounter = 0;                       %Need a start counter to begin the zero-crossing 
stopcounter = 0;                        %Need a stop counter to terminate the zero-crossings
startduration = [];                     %Null value for startduration of zero-crossing
stopduration = [];                      %Null value for stopduration of xero-crossing
startIndex = [];                        %Null value for the start index counter
stopIndex = [];                         %Null value for the end index counter
for i = 1:length(plotData) - 1                     %
    if( (plotData(i) == 0)  &&  (plotData(i+1) > 0)   )
        startcounter = startcounter + 1;
        startduration(startcounter) = plotTime(i);
        startIndex(startcounter) = i;
    end
    if( (plotData(i) > 0)  &&  (plotData(i+1) == 0)   )
        stopcounter = stopcounter + 1;
        stopduration(stopcounter) = plotTime(i);
        stopIndex(stopcounter) = i;
    end
end

%Array of Durations
d =  stopduration - startduration;

%Find maxs for all durations    
mh = [];
spikeTimes = [];
for i = 1:length(d)
    max = 0;
    tempTime = 0;
    for j = startIndex(i) : stopIndex(i)
        if(plotData(j) > max)
           max = plotData(j);
           tempTime = plotTime(j);
        end
    end
    mh(i) = max;
    spikeTimes(i) = tempTime;
end

thirdSpikeTime = spikeTimes(3);

%%
%1.8 There are 32 spikes in the data field.

for i = 1:length(data)
   if(data(i) < 50)
       data(i) = 0;
   end
end
startcounter = 0;                       %Need a start counter to begin the zero-crossing 
stopcounter = 0;                        %Need a stop counter to terminate the zero-crossings
startduration = [];                     %Null value for startduration of zero-crossing
stopduration = [];                      %Null value for stopduration of xero-crossing
startIndex = [];                        %Null value for the start index counter
stopIndex = [];                         %Null value for the end index counter
for i = 1:length(data) - 1                     %
    if( (data(i) == 0)  &&  (data(i+1) > 0)   )
        startcounter = startcounter + 1;
        startduration(startcounter) = time(i);
        startIndex(startcounter) = i;
    end
    if( (data(i) > 0)  &&  (data(i+1) == 0)   )
        stopcounter = stopcounter + 1;
        stopduration(stopcounter) = time(i);
        stopIndex(stopcounter) = i;
    end
end

%Array of Durations
d =  stopduration - startduration;

%Find maxs for all durations    
mh = [];
spikeTimes = [];
for i = 1:length(d)
    max = 0;
    tempTime = 0;
    for j = startIndex(i) : stopIndex(i)
        if(data(j) > max)
           max = data(j);
           tempTime = time(j);
        end
    end
    mh(i) = max;
    spikeTimes(i) = tempTime;
end

numOfSpikes = length(mh);

%%
clear all, clc
load('seizure.mat')

%%
%2.1 The recording is 645 s, while the first recording lasted 10 seconds.
fs = info.fs_Hz;
recordTime = length(RT2)/fs;

%%
%2.2 This recording has amplitudes in the millivolts while the first was in
%microvolts.
maxVolt = max(RT2);

%%
%2.3 Plot from 10 to 20 seconds
time = 0:1/fs:(recordTime - 1/fs);

startIndex = find(time==10);
stopIndex = find(time==20);
plotTime = time(startIndex:stopIndex);
plotTime = plotTime - 10;
plotData = RT2(startIndex:stopIndex);
figure()
plot(plotTime,plotData)
title('EE486E, HW1, Q2.3')
xlabel('Time [s]')
ylabel('Amplitude [uV]')

%%
%2.4 Frequency in first recording is much higher.

%%
%2.5 This plot is at high frequencies like the first recording, but has the
%sinusoidal shape like the seizure recording.
clear all, clc
load('rawData.mat')
%figure()
%plot(RawData)

%%
%2.6 Instead of looking like a sinusoid, the data appears like noise with
%impulses
fs = info.fs_Hz;
nyqFreq = fs / 2;

c1 = 300 / nyqFreq;
c2 = 3000 / nyqFreq;
[b,a] = butter(3,[c1 c2]); 
filteredData = filtfilt(b,a,RawData);

recordTime = length(filteredData)/fs;
time = 0:1/fs:(recordTime - 1/fs);

figure()
plot(time, filteredData)
title('EE486E, HW1, Q2.6')
xlabel('Time [s]')
ylabel('Amplitude [uV]')

%%
%2.7 You could calculate the power and then determine which signal it is
%then apply the appropiate preprocessing technique.

%%
%3.1 I would toss out the beginning of the trial. The experiment is just
%starting up and the test is given non-constant tests.

clear all, clc
load('ep.mat')
fs = info.fs_Hz;
recordTime = length(ep)/fs;
time = 0:1/fs:(recordTime - 1/fs);


%%
%3.2 The average time is 162.2 msec. 

atIntervals = reshape(ep, [fs, 118]);
[maxPeaksat1sec, indexes] = max(atIntervals);
%indexes are the sample in the second so divide by sample per second to get
%split
timeOfMax = indexes ./ fs;

average = mean(timeOfMax);

%%
%3.3 Plot
figure()
hold on
stdDeviation = ones(1, length(ep));
%errorbar(ep, stdDeviation,'Color', [0.7 0.7 0.7]);
errorbar(time, ep, ones(size(ep)), 'Color', [0.7 0.7 0.7])
plot(time,ep, 'r') %puff at 1s intervals
title('EE486E, HW1, Q3.3')
xlabel('Time [s]')
ylabel('Amplitude [uV]')
xlim([0 118])

%%
%3.4 My method would be to assume that noise is constant among all
%frequencies and find out where the deviation from a zero-mean would be.
%Then find the power and manipulate the data to correct itself.
