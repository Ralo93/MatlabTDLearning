function reward = reward(angle, alpha)
  
  %Reward function for reference angle "angle" [-45;45]
  %and the current angle alpha, as well as the factor b
  %which is -1.5 and is used for making rewards negative:
  %small differences between angle and alpha get punished only a litte
  %while big differences bet punished a lot
  b = 1.5;
  
  %Reward = |angle| + p(alpha)
  if (angle + 0.5 == alpha || angle - 0.5 == alpha)
    
    reward = 0;
    return;
    
  end
  
  %%EDIT: Grenzwerte! Wenn angle < alpha dann sind rewards positiv!
  
  if angle > 0 && alpha > 0
    
    tmp = angle - alpha;
    reward = -b*tmp;
    
    if alpha > angle
      
      reward = -reward;
      
    end
    
    return
    
  elseif angle < 0 && alpha < 0
    
    tmp = angle - alpha;
    reward = b*tmp;
    
    if abs(alpha) > abs(angle)
      
      reward = -reward;
    end
    
    return; 
    
  elseif angle <0 && alpha >0
    
    tmp = abs(angle) + alpha;
    reward = -b*tmp;
    return; 
    
  elseif angle > 0 && alpha < 0
    
    tmp = angle + abs(alpha);
    reward = -b*tmp;
    return;
   
  elseif angle == 0
   
   reward = -b*(angle + abs(alpha));
   return;
    
    
    
  end
   
  
end
