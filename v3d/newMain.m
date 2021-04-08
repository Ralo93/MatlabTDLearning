%Q-Learning Off-Policy

#controlling parameters

%Clean initialization
clear ; close all; clc;
reference = [0, 0, 1]';
statevectorX = [];
statevectorY = [];
statevectorZ = [];

accStateX = [];
accStateY = [];
accStateZ = [];

loopref = 0;

refvectorX   = [];
refvectorY   = [];
refvectorZ   = [];

accRefX = [];
accRefY = [];
accRefZ = [];

rewards = [];
accRewards = [];
accReward = 0;
eps = [];
ct = 0;
t = 0;

plane = [0, 0, 1]';

%Loop parameters
plott = 25000
total_episodes = 100;
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

%threshold      = 0.5;
% action space is 1 until 8

% ***Q table***
% observation space is max 90° error in 2 directions with a discretization
% of 0.5°: 180*180 = 32400 * 8
Q = rand(180, 180, 3); #259.200

% vnorm1 = 1;
% action1 = chooseAction(Q, vnorm1);

#testvector
discreteAcc = 1/sqrt(2);
vnorm1(1)  =  -0.4082;                    
vnorm1(2)  =   0.4082;

# + und - wurzel 2

 %entspricht normiertem -2,2,4 vektor (gültig)
vnorm1(3)  =   0.84; %winkel zu xy-plane(vnorm=[0;0;1]) ist 54.736°

#RANDOMIZE starting state!
startingState = 100;
#randi([1, 32581]);

#TODO
#add vectorFromState(state, reference), well there are several...
%better: get x, y fehler from state

vnorm1 = vnorm1';


for i = 1:total_episodes
  fprintf('episode %d \n',i);
    
  #reference = giveNewReference3d(k, i t);
  
  #TODO
  #***initialize terminal states with zeros and reset**
  #state
  xAngle = 35;
  yAngle = 33;
  #ref
  xRef = 30;
  yRef = 40;
  
  xError = abs(xAngle - xRef);
  yError = abs(yAngle - yRef);
  
  #get diff angles of state and references lik xAngle = acosd(sum(tmpRef1.*tmpVec1));
  
  #[xAngle, yAngle] = getAngles(vnorm1, reference);
  # fprintf('xAngle %d \n',xAngle);
   #fprintf('yAngle %d \n',yAngle);
   
   #xError1      = vnorm1(1)-reference(1);
   #yError1      = vnorm1(2)-reference(2);
 
  state1 = giveState3d(xError, yError);
  %state with x = 90 and y = 90 is state 32581
  #state1 = giveState3d(xAngle,yAngle);
  #fprintf('state1 %d \n',state1);

  action1 = chooseAction3d(Q, state1, epsilon); 
  fprintf('ACTION1 %d \n',action1);
  
  while (t < max_steps)
  
    %ändern auf vnorm AND ceiled/floored to 0.5 steps -> random reference (gültig!)
    %reference = sin(ct*0.01)*10;
    %TODO: reinitialize reference
    
    reference = giveNewReference3d(k, t);
    #0.0210
    #0.0434
    #0.9980
    
    vnorm2 = dynamics3d(vnorm1, action1, u);   
    vnorm2 = vnorm2/norm(vnorm2); %NORMIERUNG
    
    angle45 = asind(abs(sum(plane.*vnorm2))); %winkel zwischen normiertem vector und xy plane
    if (angle45 < 45.0) # || vnorm2(3) < 0 || xAngle >= 90 || yAngle >= 90)
      fprintf('45');
      loopref = reference;
      break;
    elseif ( vnorm2(3) < 0)
      fprintf('3<0');
      loopref = reference;
      break;
    elseif ( xAngle >= 90)
      fprintf('xAngle!!');
      loopref = reference;
      break;
    elseif ( yAngle >= 90)
      fprintf('yAngle!!');
      loopref = reference;
      break;
    else
      #fprintf('no Interruption!!');
    endif
    
   xError      = vnorm2(1)-reference(1);
   yError      = vnorm2(2)-reference(2);
   #fprintf('xErrror %d \n',xError);
  # fprintf('yError %d \n',yError);
    
    
    %ändern !winkelabweichung als reward nehmen
    rewardValue = reward3d(reference, vnorm2);
    rewards = [rewards; rewardValue];
    
    if (rewardValue == 0)
      
     fprintf('zeroReward! %d \n');
      
    endif
    
    #***add accumulated rewards***
    #accRewards = [accRewards; accRewards(
    accReward = accReward + rewardValue;
    accRewards = [accRewards; accReward];
    
    %ÄNDERN!
    
    %discerror2 = floor((error+91)*900/181);
    
    #getting respective angle differences
    [xAngle2, yAngle2] = getAngles(vnorm2, reference);
   
    #new state  
    state2 = giveState3d(xAngle2,yAngle2);
    #fprintf('new state2: %d \n \n', state2);
    
    #new action
    action2    = chooseAction3d(Q, state2, epsilon);
   
    qValue = update3d(Q, state1, state2, rewardValue, action1, action2, alpha, gamma);
    Q(state1, action1) = qValue;
     
    state1 = state2;
    
    #action1    = action2;
    vnorm1     = vnorm2;
    
    t  = t+1;
    ct = ct+1;
    
    #TODO Norm hier?
    statevectorX = [statevectorX; vnorm1(1)];
    statevectorY = [statevectorY; vnorm1(2)];
    statevectorZ = [statevectorZ; vnorm1(3)];
    
    refvectorX   = [refvectorX; reference(1)];
    refvectorY   = [refvectorY; reference(2)];
    refvectorZ   = [refvectorZ; reference(3)];
    
    accStateX = [accStateX; statevectorX];
    accStateY = [accStateY; statevectorY];
    accStateZ = [accStateZ; statevectorZ];
    
    accRefX = [accRefX; refvectorX];
    accRefY = [accRefY; refvectorY];
    accRefZ = [accRefZ; refvectorZ];
   
    

    if length(accRefX)> 25000
      
      # figure()
      # hold on;
      # grid on;
      # plot(accStateX)
      # plot(accRefX)
       
      # plot(accStateY);
      # plot(accRefY);
       
      # plot(accStateZ);
      # plot(accStateZ);
      
        accStateX = [];
        accStateY = [];
        accStateZ = [];
        
        accRefX   = [];
        accRefY   = [];
        accRefZ   = [];
        
        

    end
  
  if (t == 999)
    
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
#goPlot(accStateX, accRefX, accStateY, accRefY, accStateZ, accRefZ, accRewards);

figure()
hold on;
plot(accStateX)
plot(accRefX)
       
 
figure()
hold on;
plot(accStateY);
plot(accRefY);

figure()
hold on;      
plot(accStateZ);
plot(accStateZ);     
       
      
#reference3d;

# Saving table to mat file for symmetry and value check
save('learned.mat', 'Q');


#figure();
#grid on;
#plot(eps)


