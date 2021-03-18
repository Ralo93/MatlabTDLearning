function ref = giveNewReference3d(k, t)
  
  
    xTmp = sin(k*t)/2.3;
    yTmp = sin(2*k*t)/2.3;
    zTmp = sqrt(1-xTmp.^2-yTmp.^2);
    ref = [xTmp;yTmp;zTmp];
  
    return;
  
  end