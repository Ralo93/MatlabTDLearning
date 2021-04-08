%Q-Learning Off-Policy

%Clean initialization
clear ; close all; clc;
reference = 0;
statevector = [];
refvector   = [];
rewards = [];
eps = [];
ct = 0;

%Loop parameters
total_episodes = 30;
max_steps      = 1000;
windowReset = 50000;
loopstate = 0;

#Learning and activation parameters
alpha = 0.85;
gamma = 0.75;
u = 0.7;
%e-greedy parameter for exploration
epsilon = 1;
start = 0.8;
ende = 1;

% ***Q table***
% with observation and action space
% action space is only 1 or 2 (in 2d)
% the observation space is -90 to 90 grad encoded as error (0-900)

#***loading learned Q-table from Qlearn.m
t = load("learned.mat");
tt = struct2cell(t);
Q = cell2mat(tt);

for i = 1:total_episodes
  fprintf('episode %d \n',i);
  t = 0;
  
  #random initialization of starting state
  accc = 0.5;
  
  #random initialize starting state, otherwise take state from previous episode/iteration
  if ( i == 1)
    state1 = (round(85.5*rand(1)/0.5)*0.5) - 40;
  else
    state1 = loopstate;
  end
  #fprintf('start: %d \n', state1);
  error      = state1-reference;
  stateError = floor((error+91)*900/181);
  #fprintf('sE: %d \n', stateError);
  
  
  while (t < max_steps)
  
    reference = (1/2*cos(ct*0.001)*40); #the last digit describes the angle to follow in Qlearned, max is ~40

    if (i > total_episodes*0.6)
      
      reference = sin(ct*0.01)*30;
      
    endif
    
    
    
    #*** rounding the reference to 0.5 steps ***
    acc = 0.5;
    reference = round(reference/acc)*acc;
    q = giveStateFromAngle(reference);
    
    #***IMPORTANT***
    #the terminal state should actually be initialized with 0 at this point.
    #I am not sure, if this makes sense with this rapid change of references, 
    #because the setting to 0 should actually happen in the outer loop!   
    
    #setting terminal Q values to 0, but remember entries for resetting them
    tmp1 = Q(q, 1);
    tmp2 = Q(q, 2);
    
    Q(q, 1) = 0;
    Q(q, 2) = 0;
    
    action1    = chooseAction(Q, stateError, epsilon);
    %this is an angle -48.5
    state2 = dynamics2d(state1, action1, u);
    #fprintf('state: %d \n', state2);
    if (state2 > 45.0 || state2 < -45.0)
      
      Q(q, 1) = tmp1;
      Q(q, 2) = tmp2;
      break;
    
    end
  
    rewardValue = reward(reference, state2);
    rewards = [rewards; rewardValue];
    error      = state2-reference;
    discerror2 = floor((error+91)*900/181);
    #action2    = chooseAction(Q, discerror2, epsilon);

    qValue = updateQ(Q, stateError, discerror2, rewardValue, action1, alpha, gamma);
    Q(stateError, action1) = qValue;
  
    stateError = discerror2;
    state1     = state2;
    
    t  = t+1;
    ct = ct+1;
    
    statevector = [statevector; state1];
    refvector   = [refvector; reference];

    #***reset Q-values which were terminal before***
    Q(q, 1) = tmp1;
    Q(q, 2) = tmp2;
    
    
    if length(statevector) > windowReset
       
       figure()
       hold on;
       grid on;
       plot(statevector)
       plot(refvector)
       
       statevector = [];
       refvector   = [];
   end
   
   #take this state for the next episode/iteration
   if ( t == 999)
     
     loopstate = state1;
     
   endif
   
  end

  #***this only works for ~ 1000 episodes!
  #if ( i < 0.9*total_episodes)
  #epsilon = start+(ende-start)*(exp(i-total_episodes)^(1/(total_episodes/10)));
  #endif
  
  #epsilon = epsilon + 0.2/total_episodes; %epsilon wird größer => exploration sinkt
  eps = [eps; epsilon];
 
end

for ii=1:length(statevector)
    anglevector(ii) = statevector(ii);
end


#activate for plotting
h1 = figure();
hold on;
grid on;
plot(anglevector)
plot(refvector)
legend('Statevector', 'Reference');
title ("Trajectory following");

#savefig(h1, 'ref and statevector.png');

#activate for plotting
figure();
grid on;
plot(rewards)

#savefig(h2, 'rewards.fig');

#activate for plotting
#figure();
#grid on;
#plot(eps)

#savefig(h3, 'epsilon.fig');


# Saving table to mat file for symmetry and positive value check
save('final.mat', 'Q');


#figure();
#hold on;
#grid on;
#plot(anglevector)
#plot(refvector)

#figure();
#grid on;
#plot(rewards)

#figure();
#grid on;
#plot(eps)


