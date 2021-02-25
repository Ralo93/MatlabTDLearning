clear ; close all; clc;

start = 0.8;
eps = [];
eps2 = [];
target = 1;
epsilon = 0.8;
ep2 = 0.8
value = 0.8

episodes = 200;

ct = 0:1:1000;

k = 0.01;
x = sin(k*ct)/2.3;
y = sin(2*k*ct)/2.3;
z = sqrt(1-x.^2-y.^2);
reference = [x;y;z];

figure();
plot(x,y)

for i = 1:episodes
  
  #ep2 = exp(1/episodes-i);
  
  %start = 0.8
  %end = 1
  
  ep2 = ep2 + 0.2*((exp(-(episodes-i))))
  
  if ep2 > 1
    ep2 = 1;
  endif
  
  epsilon = epsilon + 0.2/episodes; %epsilon wird größer => exploration sinkt
  eps = [eps; epsilon];
  eps2 = [eps2; ep2];
  
 
end


figure()
plot(eps)

figure()
plot(eps2)


