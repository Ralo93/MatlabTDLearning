function [xError, yError] = getErrorsFromState(state)
  
  
  %state = (360*x+1) + (y*2);
  
  %state 1 = [0,0]
  %state 2 = [89.5, 89.5
  
  #3621
  if (state = 1)
    
    xError = 0;
    yError = 0;
    
  else
    
    
    if ( mod(state/180/2, 1) > 0.5)
        
        xError = floor(state/180/2) + 0.5;
    else
        xError = floor(state/180/2);
    
    
    tmp = mod(state, 180);
    
    
  endif
  

  
  return;  
  
  
  
  
  
  end