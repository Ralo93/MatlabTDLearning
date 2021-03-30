function abs = goPlot(anglevectorX, refvectorX, anglevectorY, refvectorY, anglevectorZ, refvectorZ, accRewards)
  
h1 = figure();
hold on;
grid on;
plot(anglevectorX)
plot(refvectorX)
legend('Statevector', 'Reference');
title ("X following");

h2 = figure();
hold on;
grid on;
plot(anglevectorY)
plot(refvectorY)
legend('Statevector', 'Reference');
title ("Y following");

h3 = figure();
hold on;
grid on;
plot(anglevectorZ)
plot(refvectorZ)
legend('Statevector', 'Reference');
title ("Z following");

h3 = figure();
grid on;
plot(accRewards)
legend('Accumulated Rewards');
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  end