function x = filter_IF(samples, flow, fhigh, fs)
% x = filter_IF(samples, flow, fhigh, fs)
%
% This function bandpass filters a signal.  flo is the lower -3dB cutoff 
% frequency, fhigh is the upper -3dB cutoff frequency, and fs is 
% the sampling frequency.
%
% Note that flow, fhigh must be much less than half of fs for
% this function to work properly.
%
% This function is designed to implement a much tighter filter than the
% filter_RF function.


NumTaps = 300;
%Order = 7;
Wn = [2*flow/fs 2*fhigh/fs];

B = fir1(NumTaps, Wn);  % Set up the filter coefficients
A = 1;

%[B,A] = butter(NumTaps,Wn);

tempx = filter(B,A,samples);  % Filter the signal

x = tempx-mean(tempx); % Output the result