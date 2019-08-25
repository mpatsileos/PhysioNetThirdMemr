function [score, label] = get_sepsis_score(data, model)
    
meansA = cell2mat(model(1));
stdsA = cell2mat(model(2));
multsA = cell2mat(model(3));
biasesA = cell2mat(model(4));
boundaryA = cell2mat(model(5));
multADeriv = cell2mat(model(6));
multADerivDerivA = cell2mat(model(7));
biasesDerivA = cell2mat(model(8));
boundaryDerivA = cell2mat(model(9));
contrDerivA = cell2mat(model(10));

 multMemrFeedA = cell2mat(model(11));
 biasesMemrFeedA = cell2mat(model(12));
feedMemrFeedA = cell2mat(model(13)); 
boundaryMemrFeedA = cell2mat(model(14));
contrMemrFeedA = cell2mat(model(15)); 

memristorModel = cell2mat(model(16));


dataOnly = data(:,1:39);


%Normalization of Data SetA
normDataA = dataOnly - meansA;
normDataA = normDataA./stdsA;


%model individual Scaling and biasing

%setA
resA = resistanceModelIndScIndBias(normDataA, multsA, biasesA, memristorModel);
prA = probabilityEstimation(resA, boundaryA);

resDerivA = resistanceModelIndScDerivBias(normDataA, multADeriv, multADerivDerivA, biasesDerivA, memristorModel);
prDerivA = probabilityEstimation(resDerivA, boundaryDerivA);

score12 = ((0.5 / (0.5 + contrDerivA)) * prA) + ((contrDerivA/(0.5 + contrDerivA)) * prDerivA);


resMemrFeedA = resistanceModelMemrFeed(normDataA, multMemrFeedA, feedMemrFeedA, biasesMemrFeedA, memristorModel);
prMemrFeedA = probabilityEstimation(resMemrFeedA, boundaryMemrFeedA);

score = ((1.0 / (1.0 + contrMemrFeedA)) * score12) + ((contMemrFeedA/(1.0 + contrMemrFeedA)) * prMemrFeedA);


if(score > 0.5)
    label = 1;
else
    label = 0;
end

end
