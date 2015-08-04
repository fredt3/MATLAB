function y = PhoneNumber()

pNo = input('Phone Number: ','s');  %1-555-555-5555
signalstring = '1234567890';
j = 1;

if(length(pNo) == 14 && pNo(1)=='1' && pNo(2)=='-' && pNo(6)=='-' && pNo (10)=='-')
    for i = 1:14
        if(pNo(i) ~= '-')
            if(pNo(i)<= '9' && pNo(i) >= '0')
                signalstring(j) = pNo(i);
                j = j + 1;
            else
                y = [];
                return;
            end
        end
    end
      
    d1 = CreateDtmf(signalstring(1),200e-3,12000);
    d2 = CreateDtmf(signalstring(2),200e-3,12000);
    d3 = CreateDtmf(signalstring(3),200e-3,12000);
    d4 = CreateDtmf(signalstring(4),200e-3,12000);
    d5 = CreateDtmf(signalstring(5),200e-3,12000);
    d6 = CreateDtmf(signalstring(6),200e-3,12000);
    d7 = CreateDtmf(signalstring(7),200e-3,12000);
    d8 = CreateDtmf(signalstring(8),200e-3,12000);
    d9 = CreateDtmf(signalstring(9),200e-3,12000);
    d10 = CreateDtmf(signalstring(10),200e-3,12000);
    s = CreateSilence(100e-3,12000);
    
    y = [d1 s d2 s d3 s d4 s d5 s d6 s d7 s d8 s d9 s d10];     
    
    soundsc(y);
    
    
    
else
    y = [];
end