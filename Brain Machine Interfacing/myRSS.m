function y = myRSS(xTrain, yTrain, xTest, yTest)
    B = regress(yTrain, xTrain);
    ptest = xTest*B;
    y = sum((yTest-ptest).^2);
end