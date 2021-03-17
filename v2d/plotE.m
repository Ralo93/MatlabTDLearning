function a = plotE(episodes)
  
  start = 0.8;
  ende = 1;
  eps = [];
  
  for i = 1:episodes
    
    
 
    e = start+(ende-start)*(exp(i-episodes)^(1/(episodes/10)));
    eps = [eps;e];
    
    
    
  endfor
  
  #GOOD
figure();
grid on;
plot(eps)
  
  
end