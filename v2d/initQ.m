function Q = initQ(Q)
   
  for i = 1:8
 
    for ii=1:32400
      Q(i,ii) = rand(1);
    endfor
  endfor 
end