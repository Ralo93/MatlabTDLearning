function reward = reward(stateX, stateY)
  
  if (stateX == 0 && stateY == 0)
    
    reward = 0;
    return;
    
  endif
  
  reward = 1/(abs(stateX)+abs(stateY)); #can use tuning

end
