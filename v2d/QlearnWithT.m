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
total_episodes = 50;
max_steps      = 1000;
alpha = 0.85;
gamma = 0.75;


%e-greedy parameter for exploration
epsilon        = 0.8;

% ***Q table***
% with observation and action space
% action space is only 1 or 2 (in 2d)
% the observation space is -90 to 90 grad encoded as error (0-900)
t = load("T.mat");
tt = struct2cell(t);
Q = cell2mat(tt);


for i = 1:total_episodes
  fprintf('episode %d \n',i);
  t = 0;
  state1     = floor(30*rand(1))-15; %floor(90*rand(1))-45;
  error      = state1-reference;
  stateError = floor((error+91)*900/181);
  
  
  while (t < max_steps)
  
    reference = sin(ct*0.01)*10;
    action1    = chooseAction(Q, stateError, epsilon);
    %this is an angle -48.5
    state2 = dynamics2d(state1, action1, 0.7);
    if (state2 > 45.0 || state2 < -45.0)
      
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

    
    #if length(statevector) > 25000
       
     #  figure()
     #  hold on;
     #  grid on;
     #  plot(statevector)
     #  plot(refvector)
       
      # statevector = [];
      # refvector   = [];
   # end
  end


  epsilon = epsilon + 0.2/total_episodes; %epsilon wird größer => exploration sinkt
  eps = [eps; epsilon];
 
end

for ii=1:length(statevector)
    anglevector(ii) = statevector(ii);
end



#GOOD
#h1 = figure();
#hold on;
#grid on;
#plot(anglevector)
#plot(refvector)
#legend('Statevector', 'Reference');
#title ("Trajectory following");

#savefig(h1, 'ref and statevector.png');

#GOOD
#figure();
#grid on;
#plot(rewards)

#savefig(h2, 'rewards.fig');

#GOOD
#figure();
#grid on;
#plot(eps)

#savefig(h3, 'epsilon.fig');


# Saving table to mat file for symmetry and positive value check
save('Tlearned.mat', 'Q');



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


