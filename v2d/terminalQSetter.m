function Q = terminalQSetter(Q, state)
    
  for i=1:size(Q, 2)
    
    Q(state, i) = 0;
  end
  
  
  
end
