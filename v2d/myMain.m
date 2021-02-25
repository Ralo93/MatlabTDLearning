%Clean initialization
clear ; close all; clc;
reference = 0;
statevector = [];
refvector   = [];
rewards = [];
eps = [];
ct = 0;
tmpValues = [];


%Hyper parameters
total_episodes = 200;
max_steps      = 1000;
alpha = 0.85; %Learning rate
gamma = 0.95; %Future discount rate
epsilon        = 0.8; %e-greedy parameter for exploration


% ***Q table***
% with observation and action space
% action space is only 1 or 2 (in 2d)
% the observation space is -90 to 90 grad encoded as error (0-900)

%Uses positive initialization with negative rewards -> more exploration by overestimating q-values at the beginning.
Q = rand(900, 2);

fprintf('Initialisierung...');
for i = 1:900
  for ii = 1:2
    
    Q(i,ii) = Q(i,ii) + 1;
  endfor
  
end
fprintf('Initialisierung...done');

for i = 1:total_episodes
  fprintf('episode %d \n',i);
  t = 0;
  state1     = floor(30*rand(1))-15; %floor(90*rand(1))-45;
  error      = state1-reference;
  stateError = floor((error+91)*900/181);
  action1    = chooseAction(Q, stateError, epsilon);
  
  reference = sin(ct*0.1)*10;
  fprintf('reference: %d ', reference);
  fprintf('referenceState: %d \n', giveStateFromAngle(reference));
  
  st = round(giveStateFromAngle(reference));
  tmpValues = giveQactions(Q, st);
  fprintf('tmp: %d !', tmpValues);
  
  Q = terminalQSetter(Q, st);
  fprintf('q values: %d ', Q(st, :));
  
  
  while (t < max_steps)
  
    #reference = sin(ct*0.01)*10;
    #fprintf('reference: %d', reference);
    #fprintf('referenceState: %d', giveStateFromAngle(reference));
    %Reinitialize all Q values in the terminal state to 0
    
    %In jedem step ist die reference (also terminal state wieder eine neue?)
   
    %this is an angle -48.5
    state2 = dynamics2d(state1, action1, 0.7);
    if (state2 > 45.0 || state2 < -45.0)
      
      break;
    
    end
  
    rewardValue = reward(reference, state2);
    rewards = [rewards; rewardValue];
    error      = state2-reference;
    discerror2 = floor((error+91)*900/181);
    action2    = chooseAction(Q, discerror2, epsilon);

    qValue = update(Q, stateError, discerror2, rewardValue, action1, action2, alpha, gamma);
    Q(stateError, action1) = qValue;
  
    stateError = discerror2;
    action1    = action2;
    state1     = state2;
    
    t  = t+1;
    #ct = ct+1;
    
    statevector = [statevector; state1];
    refvector   = [refvector; reference];

    
    if length(statevector) > 25000
       
       figure()
       hold on;
       grid on;
       plot(statevector)
       plot(refvector)
       
       statevector = [];
       refvector   = [];
    end
  end
  
  ct = ct + 1;


  epsilon = epsilon + 0.2/total_episodes; %epsilon wird größer => exploration sinkt
  eps = [eps; epsilon];
 
  %Reinitialize with old values from terminal setting:
  Q(st, :) = tmpValues;
 
end

for ii=1:length(statevector)
    anglevector(ii) = statevector(ii);
end

figure();
hold on;
grid on;
plot(anglevector)
plot(refvector)

figure();
grid on;
plot(rewards)

figure();
grid on;
plot(eps)


