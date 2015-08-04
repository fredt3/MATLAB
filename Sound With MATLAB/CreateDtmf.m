function  y = CreateDtmf (x, t, f)

t = 0:1/f:t;

if(x == '0')
    y = cos(941.*t) + cos(1336.*t);
elseif(x == '1')
    y = cos(697.*t) + cos(1209.*t);
elseif(x == '2')
    y = cos(697.*t) + cos(1336.*t);
elseif(x == '3')
    y = cos(697.*t) + cos(1477.*t);
elseif(x == '4')
    y = cos(770.*t) + cos(1209.*t);
elseif(x == '5')
    y = cos(770.*t) + cos(1336.*t);
elseif(x == '6')
    y = cos(770.*t) + cos(1477.*t);
elseif(x == '7')
    y = cos(852.*t) + cos(1209.*t);
elseif(x == '8')
    y = cos(852.*t) + cos(1336.*t);
elseif(x == '9')
    y = cos(852.*t) + cos(1477.*t);
elseif(x == '*')
    y = cos(941.*t) + cos(1209.*t);
elseif(x == '#')
    y = cos(941.*t) + cos(1477.*t);
elseif(x == 'A')
    y = cos(697.*t) + cos(1633.*t);
elseif(x == 'B')
    y = cos(770.*t) + cos(1633.*t);
elseif(x == 'C')
    y = cos(852.*t) + cos(1633.*t);
elseif(x == 'D')
    y = cos(941.*t) + cos(1633.*t);
else
    y = [];
end
