function reward = reward(xError45, yError45)
  
  b = -1.5;
  
  if (xError45 == 0 && yError45 == 0)
    
    reward = 0;
    return;
    
  endif
  
  reward = b*(abs(xError45)+abs(yError45)); #can use tuning

end
