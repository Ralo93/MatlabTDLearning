function [xError, yError] = getErrorsFromState(state)
  
  
  %state = (360*x+1) + (y*2);
  
  %INPUT: state
  %OUTPUT: xError, yError  

    xError = floor(state/180)/2;
    
    #yError = (mod(state-1,180) / 2);
    tmp = mod(state, 180);
    yError = floor(tmp/2);
  
  

  
  return;  
  
  
  
  
  
  end