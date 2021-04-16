
%Q-Learning Off-Policy

#controlling parameters

%Clean initialization
clear ; close all; clc;
reference = [0, 0, 1]';

plott = 20000;
statehist    = [];
refhist      = [];
rewardhist   = [];
statevector  = zeros(3,plott); #[statevector; state1];
refvector    = zeros(3,plott); #[refvector; reference];

loopref = 0;
rewards = [];

eps = [];
ct = 0;
t = 0;

plane = [0, 0, 1]';

%Loop parameters
total_episodes = 50;
max_steps      = 1000;
k = 0.0001; # parameter for reference giving

#Learning and activation parameters
alpha = 0.85;
gamma = 0.75;
u = 1;%0.7;

%e-greedy parameter for exploration
epsilon = 1; #redundant
start = 1;
ende = 1;

% ***Q table***
mat = load("ll.mat");
tt = struct2cell(mat);
Q = cell2mat(tt);

#reference = [1,1,0]; # klären
reference = [0,0,1];
reference = reference/norm(reference);
reference = reference';

for i = 1:total_episodes
  fprintf('episode %d \n',i);
  
##  stateX = ceil(rand(1)*10);#roundIt(rand(1)*90); #randomize, im Q table
##  stateY = ceil(rand(1)*10);#8; #is 4 in degrees goes from 1 to 180
##  
##  #übersetzung von Q(90 -> +-45 fehlt
##  
##  #drehe reference um 20 grad in positive x-richtung
##  #drehe reference um 20 grad in positive y-richtung
##  #output: vNormState
##  
##  tx = rotx(stateX);
##  ty = roty(stateY);
##  
##  vStep1 = tx*reference;
##  vStep2 = ty*vStep1;
##  vnorm  = vStep2;
  
  % choose random initial state btw. -10-10 degrees
  stateX = 2*(rand(1)-0.5)*10*pi/180; #between +-1/sqrt(2)
  stateY = 2*(rand(1)-0.5)*10*pi/180;
  
  tx = rotx(stateX); #rotation matrix with a given angle
  ty = roty(stateY);
  vnorm = ty*tx*[0;0;1]; #actual state as a vector, but reference changed!
  
  while ct < max_steps
    
    reference = giveNewReference3d(k, t); #schon normiert
    
    #***OR until GAME_OVER***
    % 45° Winkel zwischen vnorm und xy Ebene ist dann, wenn z<1/sqrt(2)
    
    if (vnorm(3)<1/sqrt(2)) # || vnorm2(3) < 0 || xAngle >= 90 || yAngle >= 90)
      fprintf('45 \n');
      loopref = reference;
      break;
    elseif ( vnorm(3) < 0)
      fprintf('3<0 \n');
      loopref = reference;
      break;
    elseif ( stateX >= 1/sqrt(2) || stateX < -1/sqrt(2))  # müsste größer oder kleiner als +-0.707 sein
      fprintf('xAngle!! and stuff \n');
      loopref = reference;
      break;
    elseif ( stateY >= 1/sqrt(2) || stateY < -1/sqrt(2)) # siehe oben
      fprintf('yAngle!! and stuff \n');
      loopref = reference;
      break;
    else
      #fprintf('no Interruption!! \n');
    endif
    
    
    % choose action (and reward) depending on errorX/Y (not on stateX/Y) and 
    % shift error from -45-45 to 1-90
    [xError, yError] = getAngles(vnorm, reference); #+-45
   # printf("x: %d \n", xError);
    #printf("y: %d \n", yError);
    xErrorShift = max([min([xError+45,90]),1]); #cool
    yErrorShift = max([min([yError+45,90]),1]);
    a = chooseAction3d(Q, xErrorShift, yErrorShift, epsilon, 8);
    rewardValue = reward(xError, yError);
    
    newState = dynamics3d(vnorm, a, u); # nicht normiert!
    newState = newState/norm(newState); # vector
    
    #calc diff between newState and reference to actually get a q-state
    [xError, yError] = getAngles(newState, reference);
    xErrorShift2 = max([min([xError+45,90]),1]);
    yErrorShift2 = max([min([yError+45,90]),1]);
    qmaxValue = qmax(Q, xErrorShift2, yErrorShift2);
    
     
    updatedValue = update3d(Q, xErrorShift, yErrorShift, a, alpha, gamma, qmaxValue, rewardValue);
    Q(xErrorShift, yErrorShift, a) = updatedValue;
    
    #TODO:
    #Q = insertSymmetry(Q, xErrorShift, yErrorShift, a, updatedValue);
    
    rewards(mod(t,plott)+1) = rewardValue;    
    vnorm = newState;
    statevector(:,mod(t,plott)+1) = vnorm(:);
    refvector(:,mod(t,plott)+1)   = reference(:); #[refvector; reference];;

    % reset history when t/plott gives zero remainder
    if mod(t+1,plott)==0
      statehist    = statevector;
      refhist      = refvector;
      rewardhist   = rewards;
      statevector  = zeros(3,plott);
      refvector    = zeros(3,plott); #[refvector; reference];
      rewards      = zeros(1,plott);
    end
    
    t  = t + 1;
    ct = ct+1;
    %fprintf('episode %d, iteration %d \n',i,ct);
    
  endwhile
  
  ct = 0;
  
end

lhist = mod(t+1,plott);
statevector = [statehist, statevector(:,1:lhist)];
refvector   = [refhist, refvector(:,1:lhist)];
rewards     = [rewardhist, rewards(1:lhist)];

save('final.mat', 'Q');

figure()
hold on;
plot(statevector(1,:))
plot(refvector(1,:))
xlabel('time step');
ylabel('x reference');
       
figure()
hold on;
plot(statevector(2,:));
plot(refvector(2,:));
xlabel('time step');
ylabel('y reference');

figure()
hold on;      
plot(statevector(3,:));
plot(refvector(3,:));
xlabel('time step');
ylabel('z reference');

figure()
plot(rewards);
xlabel('time step');
ylabel('rewards');
