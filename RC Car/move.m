function y = move(in, no)


 
fs = 44.1e3; % Establish our Sampling Frequency 
T_s = 1/fs; % Time increment between samples 
Tb = 500e-6;
Rb = 1/Tb;
sam_per_sym = floor(fs/Rb); % fs/Rb = 44.1e3/(1/Tb) 
Rb = fs./sam_per_sym; % Resulting Bit Rate 
fif = 10e3; % 10.0 kHz (IF) Frequency 
x = [1 0];
fc = 40.68e6;
 
% Setup The Bit Sequence 
sync = [1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0]; 
fwd = repmat(x, 1, 10); 
rev = repmat(x, 1, 40); 
right_fwd = repmat(x, 1, 34); 
left_fwd = repmat(x, 1, 28); 
left = repmat(x, 1, 59);
right = repmat(x, 1, 65);
rev_left = repmat(x, 1, 52);
rev_right = repmat(x, 1, 46);
 
% Generate the Baseband Line Code & Upsample 
% See Digital Line Code Lab for Information 
% Resulting Output Variable will be up_data 
t_fwd = 0:1/fs:((((length(fwd)+length(sync))*sam_per_sym)/fs)-1/fs);
t_rev = 0:1/fs:((((length(rev)+length(sync))*sam_per_sym)/fs)-1/fs);
t_fr = 0:1/fs:((((length(right_fwd)+length(sync))*sam_per_sym)/fs)-1/fs);
t_fl = 0:1/fs:((((length(left_fwd)+length(sync))*sam_per_sym)/fs)-1/fs);
t_right = 0:1/fs:((((length(right)+length(sync))*sam_per_sym)/fs)-1/fs);
t_left = 0:1/fs:((((length(left)+length(sync))*sam_per_sym)/fs)-1/fs);
t_rl = 0:1/fs:((((length(rev_left)+length(sync))*sam_per_sym)/fs)-1/fs);
t_rr = 0:1/fs:((((length(rev_right)+length(sync))*sam_per_sym)/fs)-1/fs);


fwd = rectpulse([sync fwd], sam_per_sym);
rev = rectpulse([sync rev], sam_per_sym);
right_fwd = rectpulse([sync right_fwd], sam_per_sym);
left_fwd = rectpulse([sync left_fwd], sam_per_sym);
left = rectpulse([sync left], sam_per_sym);
right = rectpulse([sync right], sam_per_sym);
rev_left = rectpulse([sync rev_left], sam_per_sym);
rev_right = rectpulse([sync rev_right], sam_per_sym);

if(in == 1)
up_data = fwd;
end
if(in == 2)
up_data = rev;
end
if(in == 3)
up_data = right_fwd;
end
if(in == 4)
up_data = left_fwd;
end
if(in == 5)
up_data = left;
end
if(in == 6)
up_data = right;
end
if(in == 7)
up_data = rev_left;
end
if(in == 8)
up_data = rev_right;
end

up_data = repmat(up_data, 1, no);

% Generate the "baseband" (IF) waveform 
time_stop = length(up_data); 
time = linspace(0,(1/fs).*time_stop, length(up_data)); 
flo = 10e3;
s_lo = cos(2*pi*flo*time); 
s_if = s_lo.*up_data; 

y = s_if;
%40.688MHz
% sound(s_if, fs);

end