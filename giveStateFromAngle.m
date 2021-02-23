function state = giveStateFromAngle(angle)
  
  %-45 until + 45
  
  
  if (angle == 0)
    
    state = 450;
    return;
    
  elseif (angle < 0)
    
    % state between 0 and 450
    angle = angle*10;
    
    state = 450 + angle;
    
    return;
    
  elseif (angle > 0)
    
    % state between 451 and 900
    
    angle = angle*10;
       
    state = 450+angle;
    return;
    
  end
  
  
  
  
  
  
  
  
  
  
  
  
end
