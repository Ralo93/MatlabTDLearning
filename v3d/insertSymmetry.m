function Q = insertSymmetry(Q, x, y, a, value)

  minusX = -x;
  minusY = -y;
  
  trueX = max([min([x+45,90]),1]);
  trueY = max([min([y+45,90]),1]);
  
  xErrorShift = max([min([minusX+45,90]),1]); #cool
  yErrorShift = max([min([minusY+45,90]),1]);
  #fprintf('x!! %d \n', xErrorShift);
  #fprintf('y!! %d \n', yErrorShift);
  #if a = 1:
  #insrt value into Q(a=3) and vice versa 
  if (a == 1) #r
    
      Q(xErrorShift, trueY, 3) = value;
      Q(xErrorShift, yErrorShift, 3) = value;
      Q(trueX, yErrorShift, 1) = value;
      
      Q(trueY, trueX, 2) = value; #h
      Q(yErrorShift, trueX, 2) = value;
      Q(trueY, xErrorShift, 4) = value; #v
      Q(yErrorShift, xErrorShift, 4) = value;
      return;
      
    elseif ( a == 2) #h
      
      Q(xErrorShift, trueY, 4) = value;
      Q(xErrorShift, yErrorShift, 4) = value;
      Q(trueX, yErrorShift, 2) = value;
      
      Q(trueY, trueX, 1) = value; #h
      Q(yErrorShift, trueX, 1) = value;
      Q(trueY, xErrorShift, 3) = value; #v
      Q(yErrorShift, xErrorShift, 3) = value;
      return;
      
      
    elseif (a == 3) #l
      
      Q(xErrorShift, trueY, 1) = value;
      Q(xErrorShift, yErrorShift, 1) = value;
      Q(trueX, yErrorShift, 3) = value;
      
      Q(trueY, trueX, 4) = value; #??
      Q(yErrorShift, trueX, 4) = value;
      Q(trueY, xErrorShift, 2) = value;
      Q(yErrorShift, xErrorShift, 2) = value;
      return;
      
      
    elseif (a == 4) #v
      
      Q(xErrorShift, trueY, 2) = value;
      Q(xErrorShift, yErrorShift, 2) = value;
      Q(trueX, yErrorShift, 4) = value;
      
      Q(trueY, trueX, 3) = value; 
      Q(yErrorShift, trueX, 3) = value;
      Q(trueY, xErrorShift, 1) = value; #v
      Q(yErrorShift, xErrorShift, 1) = value;
      return;
      
    elseif (a == 5) #rv
      
      Q(xErrorShift, trueY, 7) = value;
      Q(xErrorShift, yErrorShift, 7) = value;
      Q(trueX, yErrorShift, 5) = value;
      
      Q(trueY, trueX, 6) = value; #h
      Q(yErrorShift, trueX, 6) = value;
      Q(trueY, xErrorShift, 8) = value; #v
      Q(yErrorShift, xErrorShift, 8) = value;
      return;
      
    elseif (a == 6) #vl
      
      Q(xErrorShift, trueY, 8) = value;
      Q(xErrorShift, yErrorShift, 8) = value;
      Q(trueX, yErrorShift, 6) = value;
      
      Q(trueY, trueX, 5) = value; #h
      Q(yErrorShift, trueX, 5) = value;
      Q(trueY, xErrorShift, 7) = value; #v
      Q(yErrorShift, xErrorShift, 7) = value;
      return;
      
    elseif (a == 7) #lh
      
      Q(xErrorShift, trueY, 5) = value;
      Q(xErrorShift, yErrorShift, 5) = value;
      Q(trueX, yErrorShift, 7) = value;
      
      Q(trueY, trueX, 8) = value; #h
      Q(yErrorShift, trueX, 8) = value;
      Q(trueY, xErrorShift, 6) = value; #v
      Q(yErrorShift, xErrorShift, 6) = value;
      return;
      
    elseif (a == 8) #rh
      
      Q(xErrorShift, trueY, 6) = value;
      Q(xErrorShift, yErrorShift, 6) = value;
      Q(trueX, yErrorShift, 8) = value;
      
      Q(trueY, trueX, 7) = value; #h
      Q(yErrorShift, trueX, 7) = value;
      Q(trueY, xErrorShift, 5) = value; #v
      Q(yErrorShift, xErrorShift, 5) = value;
      return;
      
    else
      #fprintf('no Interruption!! \n');
    endif
  #if a = 2:
  #insert value into Q(a=4) and vice versa
  
  
  
  
  
  
  
  
  
end
