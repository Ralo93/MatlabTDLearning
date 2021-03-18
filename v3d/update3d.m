function qValue = update3d(Q, state1, state2, reward, action1, action2, alpha, gamma)
  
  
  predict = Q(state1, action1);
  target = reward + gamma*Q(state2, action2);
  
  Q(state1, action1) = Q(state1, action1) + alpha * (target - predict);
  
  qValue = Q(state1, action1);
  
  
  
end
