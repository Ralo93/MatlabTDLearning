clear ; close all; clc;

start = 0.8;
eps = [];
eps2 = [];
target = 1;
epsilon = 0.8;
ep2 = 0.8
value = 0.8

episodes = 200;

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


