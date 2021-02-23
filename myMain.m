clear ; close all; clc;

reference = 0;



epsilon        = 0.8;
total_episodes = 500;
max_steps      = 1000;
% alpha          = 0.85;
% gamma          = 0.95;
%threshold      = 0.5;

% rewards = zeros(total_episodes, 1);

% with observation space and action space
% action space is only 1 or 2
% the observation space is -90 to 90 grad (error!), 0-900
Q = zeros(900, 2);

%dynamics gibt mir den neuen state
% state1 = 1;
% action1 = chooseAction(Q, state1);

statevector = [];
refvector   = [];
ct          = 0;

for i = 1:total_episodes
  fprintf('episode %d \n',i);
  
  t = 0;
  state1     = floor(30*rand(1))-15;%floor(90*rand(1))-45;
  error      = state1-reference;
  discerror1 = floor((error+91)*900/181);
  action1    = chooseAction(Q, discerror1, epsilon);
  
  
  while (t < max_steps)
  
    reference = sin(ct*0.01)*10;
   
    %this is an angle -48.5
    state2 = dynamics2d(state1, action1, 0.7);
    if (state2 > 45.0 || state2 < -45.0)
    
      break;
    
    end
  
    
  
    rewardValue = reward(reference, state2);

    error      = state2-reference;
    discerror2 = floor((error+91)*900/181);
    action2    = chooseAction(Q, discerror2, epsilon);

    qValue = update(Q, discerror1, discerror2, rewardValue, action1, action2);
    Q(discerror1, action1) = qValue;
  
  
    discerror1 = discerror2;
    action1    = action2;
    state1     = state2;
    
    t  = t+1;
    ct = ct+1;
    
    statevector = [statevector; state1];
    refvector   = [refvector; reference];

    if length(statevector)>3000
        statevector = [];
        refvector   = [];
    end
  end
  
  epsilon = epsilon + 0.2/total_episodes;

end

for ii=1:length(statevector)
    anglevector(ii) = statevector(ii);
end

figure();
hold on;
grid on;
plot(anglevector)
plot(refvector)



