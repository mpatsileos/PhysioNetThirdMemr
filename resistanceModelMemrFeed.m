function resistance = resistanceModelMemrFeed(normData, mults, multsFeedback, biases, memristorModel)
transformedInp = normData.*mults;
transformedInp = transformedInp + biases;

dimensions = size(transformedInp);
rows = dimensions(1);
columns = dimensions(2);


resistance = 4.0;
i = 1;
for j = 1:columns
    resistance = updateResistance(resistance, memristorModel, transformedInp(i,j));
end

memristanceDifferencePerRow = resistance - 4.0;
oldResistance = resistance;

for i = 2:(rows - 1)
    for j= 1:columns
        envValue1 = transformedInp(i,j);
        if(isnan(envValue1))
            
        else
            voltDiff = envValue1 + (multsFeedback(j) * memristanceDifferencePerRow);
             resistance = updateResistance(resistance, memristorModel, voltDiff);        
        end
    end
    memristanceDifferencePerRow = resistance - oldResistance;
    oldResistance = resistance;
end


  i = rows;

  if(i>1)
                  mean = 0;
                for j= 1:columns
                       envValue1 = transformedInp(i,j);
                        if(isnan(envValue1))

                        else
                            voltDiff = envValue1 + (multsFeedback(j) * memristanceDifferencePerRow);
                            resistance = updateResistance(resistance, memristorModel, voltDiff);        
                        end
                        mean = mean + resistance;
                end
                 mean = mean/columns;
                resistance = mean;
  end