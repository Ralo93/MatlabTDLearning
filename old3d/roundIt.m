function rounded = roundIt(xAngle)
  
  
  acc = 0.5; #accuracy for rounding -> rounds to nearest 0.5 step
  rounded = (round(xAngle/acc))*acc;
  return;
  
  
  end