%% Fred Tidwell HW02
close all, clear all, clc
%% 1.1
%1.1. a. 100 - 1 = 99.
%1.1. b.

time = 1:100;
mag = zeros(1, 100);
mag(50:80) = 2;
lineLength = cumsum(abs(diff(mag)));
figure()
plot(lineLength);
title('EE486E, HW2, Q1.1b')
ylabel('Amplitude');
xlabel('Index');

%% 1.2
%1.2.

%a.
figure();
RA = cumsum(abs(mag));
plot(time, RA);
title('EE486E, HW2, Q1.2a')
ylabel('Amplitude');
xlabel('Time [s]');

%b
figure();
Energy = cumsum(mag.^2);
plot(time, Energy);
title('EE486E, HW2, Q1.2b')
ylabel('Amplitude');
xlabel('Time [s]');

%c 
figure();
[totalOccurances, y] = hist(mag, 5);
ProbY = totalOccurances/length(mag);
natLog = log(ProbY);
for i = 1:5
    if(isinf(natLog(i)) == 1)
        natLog(i) = 0; 
    end
end
Entropy = -cumsum(ProbY.*natLog);
plot(y, Entropy)
title('EE486E, HW2, Q1.2c')
ylabel('Amplitude');
xlabel('Center of Bin');


%% 1.3
%1.3.
fs_Hz = 100;
dt = fs_Hz^-1;
time = 0:dt:10-dt;
signal = sin(2*pi*time);
triangle = 2*triang(length(signal))';
AM = signal.*triangle;
figure()
plot(time, AM)
title('EE486E, HW2, Q1.3')
ylabel('Amplitude');
xlabel('Time [s]');

%% 1.3b
%LineLength
lineLength = cumsum(abs(diff(AM)));
figure()
plot(lineLength);
title('EE486E, HW2, Q1.3b1')
ylabel('Amplitude');
xlabel('Index');

%Rectified Area
figure();
RA = cumsum(abs(AM));
plot(time, RA);
title('EE486E, HW2, Q1.3b2')
ylabel('Amplitude');
xlabel('Time [s]');
    
%Energy
figure();
Energy = cumsum(AM.^2);
plot(time, Energy);
title('EE486E, HW2, Q1.3b3')
ylabel('Amplitude');
xlabel('Time [s]');

%Entropy
figure();
[totalOccurances, y] = hist(AM, 5);
ProbY = totalOccurances/length(AM);
natLog = log(ProbY);
for i = 1:5
    if(isinf(natLog(i)) == 1)
        natLog(i) = 0; 
    end
end
Entropy = -cumsum(ProbY.*natLog);
plot(y, Entropy)
title('EE486E, HW2, Q1.3b4')
ylabel('Amplitude');
xlabel('Center of Bin');



%% 1.3c
FM = 2*sin(2*pi*0.1*time.^2);
figure();
plot(time, FM)
title('EE486E, HW2, Q1.3c')
ylabel('Amplitude');
xlabel('Time [s]');

%% 1.3d
%LineLength
lineLength = cumsum(abs(diff(FM)));
figure()
plot(lineLength);
title('EE486E, HW2, Q1.3d1')
ylabel('Amplitude');
xlabel('Index');

%Rectified Area
figure();
RA = cumsum(abs(FM));
plot(time, RA);
title('EE486E, HW2, Q1.3d2')
ylabel('Amplitude');
xlabel('Time [s]');
    
%Energy
figure();
Energy = cumsum(FM.^2);
plot(time, Energy);
title('EE486E, HW2, Q1.3d3')
ylabel('Amplitude');
xlabel('Time [s]');

%Entropy
figure();
[totalOccurances, y] = hist(FM, 5);
ProbY = totalOccurances/length(FM);
natLog = log(ProbY);
for i = 1:5
    if(isinf(natLog(i)) == 1)
        natLog(i) = 0; 
    end
end
Entropy = -cumsum(ProbY.*natLog);
plot(y, Entropy)
title('EE486E, HW2, Q1.3d4')
ylabel('Amplitude');
xlabel('Center of Bin');

%% Part2
close all, clear all, clc

load('szChirps.mat')
fs = info.fs_Hz;
recordTime = length(data)/fs;
time = 0:1/fs:(recordTime - 1/fs);
%% 2.1 
%2.1 The remainder of the difference in the length of n and L, divided 
%by d

%ignoredFromLeft = mod(length(n)-L,d); 

%% 2.2
% 2.2. Four values will be ignored from the left.
n = data;
L = 4*fs; 
d = (1/8)*fs;
ignoredFromLeft = mod(length(n)-L,d); 

%% 2.3

[llFeat, numIgnored] = rfeature(data,@(x) sum(abs(diff(x))),L,d);
temp = [NaN(1,numIgnored+L-1) zohinterp(llFeat,d)];
ll = temp(1:length(data));
normalLL = (ll/max(ll))*2*max(data);

figure()
hold on
plot(time, data)
plot(time, normalLL, 'g')
legend('data', 'Normalized Line Length')
title('EE486E, HW2, Q2.3')
ylabel('Amplitude [uV]');
xlabel('Time [s]');
hold off

%% 2.4. A threshold of 4.8 mV

%% 2.5.
figure()
hold on
flickers = [];
fCount = 0;
minD = min(data);
maxD = max(data);
plot(time, data)
plot(time, normalLL, 'g')
legend('data', 'Normalized Line Length')
title('EE486E, HW2, Q2.5')
ylabel('Amplitude [uV]');
xlabel('Time [s]');

for i = 1:length(time)-1
    if((ll(i) < 48e3) && (ll(i+1) > 48e3))
       fCount = fCount + 1;
       flickers(fCount) = time(i);
       line([time(i) time(i)], [minD-2000 maxD+2000], 'Color', [1 0 0]);
    end
end




hold off
%% Part 3
close all, clear all, clc

load('multiSz.mat')

fs = info.fs_Hz;
L = 10*fs; 
d = 1*fs;
recordTime1 = length(data1)/fs;
time1 = 0:1/fs:(recordTime1 - 1/fs);

%% 3.1

[eFeat, numIgnored] = rfeature(data1,@(x) sum(x.^2),L,d);
temp = [NaN(1,numIgnored+L-1) zohinterp(eFeat,d)];
en = temp(1:length(data1));
normalEn = (en/max(en))*2*max(data1);

figure()
hold on
plot(time1, data1)
plot(time1, normalEn, 'g')
legend('data', 'Normalized Energy')
title('EE486E, HW2, Q3.1')
ylabel('Amplitude [uV]');
xlabel('Time [s]');
hold off

%% 3.2

L = 30*fs;
d = 2*fs;
[eMean, numIgnored] = rfeature(normalEn,@mean,L,d);
temp = [NaN(1,numIgnored+L-1) zohinterp(eMean,d)];
energyMean = temp(1:length(normalEn));

[eVar, numIgnored] = rfeature(normalEn,@var,L,d);
temp = [NaN(1,numIgnored+L-1) zohinterp(eVar,d)];
energyVar = temp(1:length(normalEn));

meanVar = energyMean./energyVar;
normalMeanVar = (meanVar/max(meanVar)) * 2 * max(data1);

figure()
hold on
plot(data1)
plot(normalMeanVar, 'g')
legend('data1', 'Normalized Mean Variance');
title('EE486E, HW2, Q3.2')
ylabel('Amplitude [uV]');
xlabel('Time [s]');
hold off

%% 3.3. I would set a threshold of 4.

%% 3.4
L = 10*fs;
d = 1*fs;
recordTime2 = length(data2)/fs;
time2 = 0:1/fs:(recordTime2 - 1/fs);

[eFeat, numIgnored] = rfeature(data2,@(x) sum(x.^2),L,d);
temp = [NaN(1,numIgnored+L-1) zohinterp(eFeat,d)];
en = temp(1:length(data2));
normalEn = (en/max(en))*2*max(data2);

L = 30*fs;
d = 2*fs;

[eMean, numIgnored] = rfeature(normalEn,@mean,L,d);
temp = [NaN(1,numIgnored+L-1) zohinterp(eMean,d)];
energyMean = temp(1:length(normalEn));

[eVar, numIgnored] = rfeature(normalEn,@var,L,d);
temp = [NaN(1,numIgnored+L-1) zohinterp(eVar,d)];
energyVar = temp(1:length(normalEn));

meanVar = energyMean./energyVar;
threshold = 4;
thresholdPlot = (threshold/max(meanVar)) * 2 * max(data2) * ones(1, length(time2));

normalMeanVar = (meanVar/max(meanVar)) * 2 * max(data2);

figure()
hold on
plot(time2, data2)
plot(time2, thresholdPlot, 'black')
plot(time2, normalMeanVar, 'g')
title('EE486E, HW2, Q3.4')
legend('data2', 'threshold', 'Norm Mean Var')
ylabel('Amplitude [uV]');
xlabel('Time [s]');
hold off

%% 3.5. Yes, the ratio looks less predictive. I was able to detect the seizure 
%without extraneous events. I believe that a fixed threshold
% would not work as well and that each individual might respond
% differently. I think the best approach would be to train the device to
% determine a proper threshold and then set it for that specific patient.
