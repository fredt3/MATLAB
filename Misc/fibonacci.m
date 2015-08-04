%By: Fred Tidwell
%Function returns the nth number in a fibonacci sequence
%(0,1,1,2,3,5,8,13,...). If input is not valid, return an error message and
%the NULL vector [].

function y = fibonacci(n)

if(n < 0)   %negative n
    disp('Input is not a positive number!');
    y = [];
elseif(n ~= round(n)) %non-integer n
    disp('Input is not an integer!');
    y = [];
elseif(n == 0) %n is 0
    y = 0;
elseif(n==1) %n is 1
    y = 1;
else          %n>1,find position by adding the two below its position
    y = fibonacci(n-1) + fibonacci(n-2);
end