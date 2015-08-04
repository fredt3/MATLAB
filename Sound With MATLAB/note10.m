%%Given function from instructor


function tone = note10(keynum,dur)
%
%  function tone = note10(keynum,dur)
%
%	This function will produce a sinusoidal waveform corresponding to a
%	given piano key number. Harmonics are added to each tone to mimic a
%	clarinet.
%
%		 tone = the output sinusoidal waveform
%		 keynum = the piano keyboard number of the desired note
%		 dur = the duration (in seconds) of the output note
%
%   Warning: if the note duration is not compatible with the sample
%   frequency, such that a fractional number of notes would occupy your
%   input time duration for the note, a warning message will display and 
%   a system pause will occur. In this case, strike any key to continue.
%
%   Author: Robert W. Ives, US Naval Academy 12/11/09

fs = 19200;     % this is the sample frequency, 19200 samples of the sinusoid per second
% Check to see if time duration of note is compatible w/sample frequency
if (fs*dur) ~= round(fs*dur)
    disp(sprintf('Warning: sample frequency of fs=19200 Hz is not compatible with note duration %f sec\n',dur))
    pause
end
T = 1/fs;		% this is the time interval between samples
N=dur*fs;       % number of samples for this note	
tt=(0:N-1)*T;   % the time vector, with time values separated by T and the whole vector being "dur" sec long

% The following vector (h) represents the harmonic levels for a clarinet. The
% first element of h is the fundamental frequency's amplitude, the 2nd
% element is the 1st harmonic's amplitude, etc. Note that depending on the
% note being played, the harmonics actually will change, so this is a
% single approximation, and may not sound too much like a clarinet for
% notes that are too high or too low.

h=[1 0.04 0.99 0.12 0.53 0.11 0.26 0.05 0.24 0.07 0.02 0.03 0.02 0.03]; % harmonic amplitudes

% The following line creates the proper frequency for the tone…if keynum is > 49, the freq is higher than 440 Hz
%	if keynum = 49, then this is the A-440 note, and if keynum is < 49, the freq is lower than 440 Hz
freq = (440 * 2 ^ ((keynum - 49)/12))*(1:length(h));   % the frequencies of the harmonics

tone=zeros(1,length(tt));

for k=1:length(h)
    scale=h(k);
    f0=freq(k);
    tone=tone+scale*cos(2*pi*f0*tt);
end

% The following line applies a window to each note that gradually increases
%   the volume of the sinusoid, then gradually lets it fade. This window  
%   makes the sinusoid more human-like.
tone = tone .* tukeywin(length(tone))'; 

if (keynum==0)
    tone=tone*0;
end

% disp(sprintf('keynum %d has freq %6.2f\n',keynum,freq));
