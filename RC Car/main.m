fs = 44.1e3;
no = 28;
f = move(1, no); %fwd
r = move(2, no); %rev
rf = move(3, no); %rfwd
lf = move(4, no); %lfwd
left = move(5, no); %l
right = move(6, no); %r
rl = move(7, no); %rl
rr = move(8, no); %rr

x = [f f f rf f f];
%x = [f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f];
sound(x, fs)