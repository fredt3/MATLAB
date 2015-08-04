%Creates a vector of zeros with the inputs of time and sample frequency.

function y = CreateSilence(t, f)

t = (0:1/f:t);

a = length(t);

y = zeros(1,a);