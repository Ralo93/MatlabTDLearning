function qValue = update3d(Q, sx1, sy1, a, alpha, gamma, qmax, reward);
  
  
  predict = Q(sx1, sy1, a);
  target = reward + gamma*qmax;
  
  qValue = Q(sx1, sy1, a) + alpha * (target - predict);
  
  return;
  
  
  
end
