function qValue = update3d(Q, state1, state2, reward, action, action2)
  
  gamma = 0.95;
  alpha = 0.85;
  
  predict = Q(state1, action);
  target = reward + gamma*Q(state2, action2);
  
  Q(state, action) = Q(state, action) + alpha * (target - predict);
  
  qValue = Q(state1, action);
  
  
  
end
