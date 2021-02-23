function angle = giveAngleFromState(state)
  
  % 900 states into discrete angles of -45,0 -44,9 -44,8
  
  
  % state 1 = -45,0 grad
  % state 2 = -44,9 grad
  % state 3 = -44,8 grads
  if (state == 450)
    
    angle = 0;
    return;
    
  end
  
  if (state < 450)
    
    %e.g. 427
    state = state/10; % is now 42,7
    
    angle = -(45-state);
    return;
    
    
  elseif (state > 450)
    
    tmp = state - 450; % eg 451 -> then its 1
    tmp = tmp/10; %now its 0,1
    
    angle = tmp;
    return;
    
  end
  
  
  % state 900 = 45,0 grad
  
  
  
  
  
  
  
  
  
end
