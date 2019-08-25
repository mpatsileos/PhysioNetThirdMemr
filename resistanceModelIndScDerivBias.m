function resistance = resistanceModelIndScDerivBias(normData, mults, multsDeriv, biases, memristorModel)
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


for i = 2:(rows - 1)
    for j= 1:columns
        envValue1 = transformedInp(i,j);
        if(isnan(envValue1))
            
        else
            envValue2 = transformedInp(i - 1,j);
            
            if(isnan(envValue2))
                resistance = updateResistance(resistance, memristorModel, envValue1);        
            else
                voltDiff = envValue1 + (multsDeriv(j) * (envValue1 - envValue2));
                resistance = updateResistance(resistance, memristorModel, voltDiff);
            end
        end
    end
end

  i = rows;
  if(i == 1)
                mean = resistance;
  else
                  mean = 0;
                for j= 1:columns
                        envValue1 = transformedInp(i,j);
                        if(isnan(envValue1))

                        else
                            envValue2 = transformedInp(i - 1,j);

                            if(isnan(envValue2))
                                resistance = updateResistance(resistance, memristorModel, envValue1);        
                            else
                                voltDiff = envValue1 + (multsDeriv(j) * (envValue1 - envValue2));
                                resistance = updateResistance(resistance, memristorModel, voltDiff);
                            end
                        end 
                        mean = mean + resistance;
                end
                 mean = mean/columns; 
  end
  resistance = mean;
