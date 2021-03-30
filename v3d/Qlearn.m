%Q-Learning Off-Policy

#controlling parameters

%Clean initialization
clear ; close all; clc;
reference = [0, 0, 1]';
statevector = []; #[statevector; state1];
refvectorX   = []; #[refvector; reference];
refvectorY   = [];
refvectorZ   = [];

statevectorX = [];
statevectorY = [];
statevectorZ = [];

loopref = 0;
rewards = [];

eps = [];
ct = 0;
t = 0;

plane = [0, 0, 1]';

%Loop parameters
plott = 25000
total_episodes = 10000;
max_steps      = 1000;
k = 0.1; # parameter for reference giving

#Learning and activation parameters
alpha = 0.85;
gamma = 0.75;
u = 0.7;

%e-greedy parameter for exploration
epsilon = 0.8; #redundant
start = 0.8;
ende = 1;

% ***Q table***
Q = rand(90, 90, 8); #259.200 auf 1° geändert
reference = [1,1,0]; # klären
reference = reference/norm(reference);
reference = reference';

for i = 1:total_episodes
  fprintf('episode %d \n',i);
  
  stateX = ceil(rand(1)*10);#roundIt(rand(1)*90); #randomize, im Q table
  stateY = ceil(rand(1)*10);#8; #is 4 in degrees goes from 1 to 180
  
  #übersetzung von Q(90 -> +-45 fehlt
  
  #drehe reference um 20 grad in positive x-richtung
  #drehe reference um 20 grad in positive y-richtung
  #output: vNormState
  
  tx = rotx(stateX);
  ty = roty(stateY);
  
  vStep1 = tx*reference;
  vStep2 = ty*vStep1;
  vnorm = vStep2;
  
  
  while t < max_steps
    
    reference = giveNewReference3d(k, t); #schon normiert
    
    #***OR until GAME_OVER***
    angle45 = asind(abs(sum(plane.*vnorm))); %winkel zwischen normiertem vector und xy plane
    if (angle45 < 45.0) # || vnorm2(3) < 0 || xAngle >= 90 || yAngle >= 90)
      fprintf('45');
      loopref = reference;
      break;
    elseif ( vnorm(3) < 0)
      fprintf('3<0');
      loopref = reference;
      break;
    elseif ( stateX >= 90 || stateX < -90)
      fprintf('xAngle!! and stuff');
      loopref = reference;
      break;
    elseif ( stateY >= 90 || stateY < -90)
      fprintf('yAngle!! and stuff');
      loopref = reference;
      break;
    else
      #fprintf('no Interruption!! \n');
    endif
    
    a = chooseAction3d(Q, stateX, stateY, epsilon, 8);
    rewardValue = reward(stateX, stateY);
    newState = dynamics3d(vnorm, a, u); # nicht normiert!
    newState = newState/norm(newState); #vector
    
    #calc diff between newState and reference to actually get a q-state
    [xError, yError] = getAngles(newState, reference);
    qmaxValue = qmax(Q, xError, yError);
    
    Q(stateX, stateY, a) = update3d(Q, stateX, stateY, a, alpha, gamma, qmaxValue, rewardValue);
    vnorm = newState;
    
    
    rewards = [rewards; rewardValue];
    
    statevectorX = [statevectorX; vnorm(1)];
    statevectorY = [statevectorY; vnorm(2)];
    statevectorZ = [statevectorZ; vnorm(3)];
    
    refvectorX   = [refvectorX; reference(1)]; #[refvector; reference];
    refvectorY   = [refvectorY; reference(2)];
    refvectorZ   = [refvectorZ; reference(3)];
    

    
    if length(refvectorX)> 25000
      
      statevectorX = [];
      statevectorY = [];
      statevectorZ = [];
      
      refvectorX   = []; #[refvector; reference];
      refvectorY   = [];
      refvectorZ   = [];
      
    end
    
    t = t + 1;
    
  endwhile
  
  
  
end





figure()
hold on;
plot(statevectorX)
plot(refvectorX)
       
 
figure()
hold on;
plot(statevectorY);
plot(refvectorY);

figure()
hold on;      
plot(statevectorZ);
plot(refvectorZ);

figure()
plot(rewards);
