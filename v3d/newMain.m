%Q-Learning Off-Policy

%Clean initialization
clear ; close all; clc;
reference = [0, 0, 1]';
statevectorX = [];
statevectorY = [];
statevectorZ = [];
loopref = 0;

refvectorX   = [];
refvectorY   = [];
refvectorZ   = [];

rewards = [];
eps = [];
ct = 0;

idk = [0, 0, 1]';

%Loop parameters
total_episodes = 30;
max_steps      = 1000;
k = 0.01; # parameter for reference giving

#Learning and activation parameters
alpha = 0.85;
gamma = 0.75;
u = 0.7;

%e-greedy parameter for exploration
epsilon = 0.8;
start = 0.8;
ende = 1;

%threshold      = 0.5;
% action space is 1 until 8

% ***Q table***
% observation space is max 90° error in 2 directions with a discretization
% of 0.5°: 180*180 = 32400
Q = rand(32400, 8);

% vnorm1 = 1;
% action1 = chooseAction(Q, vnorm1);

#testvector
vnorm1(1)  =  -0.4082;                    
vnorm1(2)  =   0.4082; % entspricht normiertem -2,2,4 vektor (gültig)
vnorm1(3)  =   0.8165; %winkel zu xy-plane(vnorm=[0;0;1]) ist 54.736°
vnorm1 = vnorm1'

for i = 1:total_episodes
  fprintf('episode %d \n',i);
  t = 0;
  
  if (i == 1)
    reference = reference/norm(reference); %normierung, already normed (0,0,1)
  else
    reference = loopref;
  end
  
  #get diff angles of state and references lik xAngle = acosd(sum(tmpRef1.*tmpVec1));
  [xAngle, yAngle] = getAngles(vnorm1, reference);
  
  #rounding to nearest 0.5 step
  x = roundIt(xAngle);
  y = roundIt(yAngle);

  #gives state regarding to rounded x and y {1;32400}  
  % e.g. [52.0;30.5] (which is rounded x and y above)  = state 9422
  % state1 = [0;0], [0;0.5], [0;1], ... , [0,90], [0.5;0], [0,5;0.5],...
  % state with x = 89.5 and y = 89.5 is state 32400
  state1 = giveState3d(x,y);
  fprintf('state1 %d \n',state1);

  action1 = chooseAction3d(Q, state1, epsilon); 
  
  while (t < max_steps)
  
    %ändern auf vnorm AND ceiled/floored to 0.5 steps -> random reference (gültig!)
    %reference = sin(ct*0.01)*10;
    %TODO: reinitialize reference
    
    reference = giveNewReference3d(k, t);
    referenceN = reference/norm(reference); #normierung 
    #fprintf('normierte reference %d \n',reference);
    
    vnorm2 = dynamics3d(vnorm1, action1, u);
    %vnorm2 = vnorm2/norm(vnorm2); %NORMIERUNG
    
    angle45 = asind(abs(sum(idk.*vnorm2))); %winkel zwischen normiertem vector und xy plane
    if (angle45 < 45.0 || vnorm2(3) < 0 || xAngle >= 90 || yAngle >= 90)
    
      loopref = reference;
      break;
    
    end
    
    %ändern !winkelabweichung als reward nehmen
    rewardValue = reward3d(referenceN, vnorm2);

    %ÄNDERN!
    %error      = vnorm2-reference;
    %discerror2 = floor((error+91)*900/181);
  
    #getting respective angle differences
    [xAngle, yAngle] = getAngles(vnorm2, referenceN);
  
    #round to nearest 0.5 step
    x = roundIt(xAngle); 
    y = roundIt(yAngle); 
  
    #new state  
    state2 = giveState3d(x,y);
    
    #new action
    action2    = chooseAction3d(Q, state2, epsilon);
   
    qValue = update3d(Q, state1, state2, rewardValue, action1, action2, alpha, gamma);
    Q(state1, action1) = qValue;
     
    state1 = state2;
    action1    = action2;
    vnorm1     = vnorm2;
    
    t  = t+1;
    ct = ct+1;
    
    statevectorX = [statevectorX; vnorm1(1)];
    statevectorY = [statevectorY; vnorm1(2)];
    statevectorZ = [statevectorZ; vnorm1(3)];
    
    refvectorX   = [refvectorX; reference(1)];
    refvectorY   = [refvectorY; reference(2)];
    refvectorZ   = [refvectorZ; reference(3)];

    if length(statevectorX)> 50000
      
        statevectorX = [];
        statevectorY = [];
        statevectorZ = [];
        
        refvectorX   = [];
        refvectorY   = [];
        refvectorZ   = [];

    end
  
  if ( t == 999)
    
    loopref = reference;
    
  endif
  
  end
  
  epsilon = start+(ende-start)*(exp(i-total_episodes)^(1/(total_episodes/10)));
  #epsilon = epsilon + 0.2/total_episodes; %epsilon wird größer => exploration sinkt
  eps = [eps; epsilon];
end

for ii=1:length(statevectorX)
    anglevectorX(ii) = statevectorX(ii);
    anglevectorY(ii) = statevectorY(ii);
    anglevectorZ(ii) = statevectorZ(ii);
end

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


figure();
grid on;
plot(eps)


