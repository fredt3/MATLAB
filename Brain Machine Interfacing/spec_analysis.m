function [freq, power] = spec_analysis(amplitude, f_sampling, ohms)
% function [freq, power] = spec_analysis(amplitude, f_sampling, ohms)
%
% Generates the power spectrum of the signal for a given load impedance.
% Input to the function are the waveform samples (Volts), 
% sampling frequency (Hz) sampling frequency, impedance (Ohms).
%
% Outputs are power (in Watts) and Frequency (in Hz).
%
% Modified from code developed by Chris Ranson
%

a=length(amplitude);
temp = fft(amplitude,a);
Y=fftshift(temp);
Pyy = Y.*conj(Y)/a;
power = abs((Pyy./(2.*f_sampling))./(2*ohms));
power= 10.*log10(power) + 30;
freq = (-(a/2 - 1):((a/2))) * ((f_sampling)/a);
