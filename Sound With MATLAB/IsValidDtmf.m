%Testing if an input character is a valid DTMF identifier

function y = IsValidDtmf(x)

if(x == '0' || x == '1' || x == '2' || x == '3' || x == '4' || x == '5' || x == '6' || x == '7' || x == '8' || x == '9' || x == '*' || x == '#' || x == 'A' || x == 'B' || x == 'C' || x == 'D')
    y = 1;
else
    y = 0;
end


