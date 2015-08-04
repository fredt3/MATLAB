close all; clear all; clc;
load('motorData15.mat');

%% 1.1. 1972 by 801

cols = (1 + 20*40);
rows = 1972;

%% 1.2
oneMat = ones(1972,1);
S = [];
N = 20;
M = 1991;

offset = 0;
for i = 1:M-N+1 %rows
    %S(i, 1) = 1;
    N = 20;
    M = 1991;
    for j = 1:40 % j = # spike   
        for k = 1:N % k = # in bin
            S(i, k + N*(j-1)) = spikes(k + offset, j);  
        end
    end
    offset = offset+1;
end %2 22 42

S = cat(2, oneMat, S);

%% 1.3.a.

Bx = inv((S.')*S)*(S.')*X(20:1991);
By = inv((S.')*S)*(S.')*Y(20:1991);

reshapeBx = reshape(Bx(2:801), [20, 40]);
reshapeBx = reshapeBx.';
reshapeBy = reshape(By(2:801), [20, 40]);
reshapeBy = reshapeBy.';

figure()
subplot(2, 1, 1)
    imagesc(reshapeBx);
    xlabel('Time Bins')
    ylabel('Neurons')
    colorbar;
    title('EE486E, HW3, Q1.3.a')
subplot(2, 1, 2)
    imagesc(reshapeBy);
    xlabel('Time Bins')
    ylabel('Neurons')
    colorbar;
    
%% 
%1.3.b. Both plots have a drastic difference in value in time ban 3. In
%addition only neurons 1-20 had an impact in the temporal pattern change. 
%the beta for the X position seemed to be more positive in that area while
%in the Y position the values seemed less.

%1.4.c. The cells involved in predicting the X and Y position are the same
%and the X and Y position is correlated.

%% 1.4.a.

pX = S*Bx;
pY = S*By;

figure()
subplot(2, 1, 1)
    hold on
    plot(pX, 'r')
    plot(X((N-1):length(X)))
    title([{'EE486E, HW3, Q1.4.a'}, {'X data'}])
    legend('Predicted', 'Real')
    ylabel('Response')
    xlabel('Index')
    hold off
subplot(2, 1, 2)
    hold on
    plot(pY, 'r')
    plot(Y((N-1):length(Y)))
    title('Y data')
    legend('Predicted', 'Real')
    ylabel('Response')
    xlabel('Index')
    hold off
    
%% 1.4.b.  R^2 for X = 0.7038, R^2 for Y = 0.9132

RSSx = sum((X(N:M)-pX).^2);
TSSx = sum((X(N:M)-mean(X(N:M))).^2);

R2X = 1 - (RSSx/TSSx);

RSSy = sum((Y(N:M)-pY).^2);
TSSy = sum((Y(N:M)-mean(Y(N:M))).^2);

R2Y = 1 - (RSSy/TSSy);

%% 1.5

figure()
% for j=1:1972
%           hold on
%           scatter(j,X(N-1+j), 'b', '.');
%           scatter(j,pX(j), 'o', 'r');
%           ylim([8000 12000])
%           title([{'EE486E, HW3, Q1.5'}, {'X data'}])
%           legend('Predicted', 'Real')
%           ylabel('Response')
%           xlabel('Index')
%           movieArr(j) = getframe;
%           hold off
% end
hold on
scatter(1972,X(N-1+1972), 'b', '.');
scatter(1972,pX(1972), 'o', 'r');
ylim([8000 12000])
title([{'EE486E, HW3, Q1.5'}, {'X data'}])
legend('Predicted', 'Real')
ylabel('Response')
xlabel('Index')

figure()
% for j=1:1972
%           hold on
%           scatter(j,Y(N-1+j), 'b', '.');
%           scatter(j,pY(j), 'o', 'r');
%           ylim([12000 16000])
%           title([{'EE486E, HW3, Q1.5'}, {'Y data'}])
%           legend('Predicted', 'Real')
%           ylabel('Response')
%           xlabel('Index')
%           %movieArr(j) = getframe;
%           hold off
% end
hold on
scatter(1972,Y(N-1+1972), 'b', '.');
scatter(1972,pY(1972), 'o', 'r');
ylim([12000 16000])
title([{'EE486E, HW3, Q1.5'}, {'Y data'}])
legend('Predicted', 'Real')
ylabel('Response')
xlabel('Index')


%% 2.1    R^2 for X = 0.7525, R^2 for Y = 0.9296
sTest = S(1:400, :);
sTrain = S(401:1972, :);
Bx = inv((sTrain.')*sTrain)*(sTrain.')*X(420:1991);
By = inv((sTrain.')*sTrain)*(sTrain.')*Y(420:1991);

pX = sTrain*Bx;
pY = sTrain*By;

RSSx = sum((X(420:1991)-pX).^2);
TSSx = sum((X(420:1991)-mean(X(420:1991))).^2);
R2X = 1 - (RSSx/TSSx);
RSSy = sum((Y(420:1991)-pY).^2);
TSSy = sum((Y(420:1991)-mean(Y(420:1991))).^2);
R2Y = 1 - (RSSy/TSSy);

%% 2.2 MSEx = 1.488E5 and MSEy = 9.2967E4
pX = sTest*Bx;
pY = sTest*By;
MSEx = (1/length(pX))*sum((X(20:419)-pX).^2);
MSEy = (1/length(pY))*sum((Y(20:419)-pY).^2);


%% 2.3. 801-451 = 350 Columns Cut. 

% sTrain = [];
% MSEx = 0;
% MSEy = 0;
% Columns = 801;
% 
% while(MSEx < 60000 && MSEy < 60000)
%     sTrain = S(401:1972, 1:Columns);
%     Bx = inv((sTrain.')*sTrain)*(sTrain.')*X(420:1991);
%     By = inv((sTrain.')*sTrain)*(sTrain.')*Y(420:1991);
%     pX = sTrain*Bx;
%     pY = sTrain*By;
%     MSEx = (1/length(pX))*sum((X(420:1991)-pX).^2);
%     MSEy = (1/length(pY))*sum((Y(420:1991)-pY).^2);
%     Columns = Columns - 1;
% end

%% 2.4. 801-448 = 353 Columns Cut. 

    sTrain = S(401:1972, [1 5:451]);
    Bx = inv((sTrain.')*sTrain)*(sTrain.')*X(420:1991);
    By = inv((sTrain.')*sTrain)*(sTrain.')*Y(420:1991);
    pXtrain = sTrain*Bx;
    pYtrain = sTrain*By;
    MSEx = (1/length(pXtrain))*sum((X(420:1991)-pXtrain).^2);
    MSEy = (1/length(pYtrain))*sum((Y(420:1991)-pYtrain).^2);

%% 2.5. Training Set MSE for X = 59,978 square units and for Y = 58033 square units. 

%% 2.6. Test Set MSE for X = 102,975 square units and for Y = 107,031 square units.
    
    sTest = S(1:400, [1 5:451]);
    pXtest = sTest*Bx;
    pYtest = sTest*By;
    MSEx = (1/length(pXtest))*sum((X(20:419)-pXtest).^2);
    MSEy = (1/length(pYtest))*sum((Y(20:419)-pYtest).^2);
    
    
%% 2.7.
figure()
subplot(2, 1, 1)
    hold on
    plot(pXtest, 'r')
    plot(X(20:419))
    title([{'EE486E, HW3, Q2.7'}, {'X data'}])
    legend('Predicted', 'Real')
    ylabel('Response')
    xlabel('Index')
    hold off
subplot(2, 1, 2)
    hold on
    plot(pYtest, 'r')
    plot(Y(20:419))
    title('Y data')
    legend('Predicted', 'Real')
    ylabel('Response')
    xlabel('Index')
    hold off
    