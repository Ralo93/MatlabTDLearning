clear ; close all; clc;

reference = [0, 0, 1]';
eps = [];

u = [0, 0, 1]';

epsilon        = 0.8;
total_episodes = 100;
max_steps      = 100;
% alpha          = 0.85;
% gamma          = 0.95;
%threshold      = 0.5;

% rewards = zeros(total_episodes, 1);

% with observation space and action space
% action space is 1 until 8

% observation space is max 90° error in 2 directions with a discretization
% of 0.5°: 180*180 = 32400
Q = rand(32400, 8);

%dynamics gibt mir den neuen state
% vnorm1 = 1;
% action1 = chooseAction(Q, vnorm1);

statevector = [];
refvector   = [];
ct          = 0;

vnorm1(1)  =  -0.4082;                    
vnorm1(2)  =   0.4082; % entspricht normiertem -2,2,4 vektor (gültig)
vnorm1(3)  =   0.8165; %winkel zu xy-plane(vnorm=[0;0;1]) ist 54.736°
vnorm1 = vnorm1';

%fprintf('Initializing...');
%Q = initQ(Q);
%fprintf('Initalization done.');

for i = 1:total_episodes
  fprintf('episode %d \n',i);
  
  t = 0;
  
  reference = reference/norm(reference); %normierung
  %error      = vnorm1-reference;
  %state1 = floor((error+91)*900/181); %discerror nur in x und y richtung?
                                          %project vnorm1 onto
  tmpVec1 = vnorm1; %setze x auf 0
  tmpVec1(1) = 0;
  tmpVec2 = vnorm1; %setze y auf 0
  tmpVec2(2) = 0;
  
  tmpRef1 = reference;
  tmpRef1(1) = 0; %setze x der reference auf 0
  tmpRef2 = reference;
  tmpRef2(2) = 0; %setze y der reference auf 0
  
  xAngle = acosd(sum(tmpRef1.*tmpVec1));
  yAngle = acosd(sum(tmpRef2.*tmpVec2));
  
  %error = [xAngle;yAngle]; %not used
  %floor(in) + ceil( (in-floor(in))/0.5) * 0.5
  x = floor(xAngle) + ceil( (xAngle-floor(xAngle))/0.5) * 0.5; %rounding to 0.5 (up)
  y = floor(yAngle) + ceil( (yAngle-floor(yAngle))/0.5) * 0.5;
  state1 = (360*x+1) + (y*2);
  fprintf('errorX %d \n',x);
  fprintf('errorY %d \n',y);
  
  % e.g. [52.0;30.5]  = state 9422
  % state1 = [0;0], [0;0.5], [0;1], ... , [0,90], [0.5;0], [0,5;0.5],...
  % state with x = 89.5 and y = 89.5 is state 32400
  
  action1 = chooseAction3d(Q, state1, epsilon); 
  
  while (t < max_steps)
  
    %ändern auf vnorm AND ceiled/floored to 0.5 steps -> random reference (gültig!)
    %reference = sin(ct*0.01)*10;
    %TODO: reinitialize reference
    
    vnorm2 = dynamics3d(vnorm1, action1, 0.7);
    %vnorm2 = vnorm2/norm(vnorm2); %NORMIERUNG
    
    angle45 = asind(abs(sum(u.*vnorm2))); %winkel zwischen normiertem vector und xy plane
    if (angle45 < 45.0 || vnorm2(3) < 0 || xAngle >= 90 || yAngle >= 90)
    
      
      break;
    
    end
    
    %ändern !winkelabweichung als reward nehmen
    rewardValue = reward3d(reference, vnorm2);

    %ÄNDERN!
    %error      = vnorm2-reference;
    %discerror2 = floor((error+91)*900/181);
    
    %Could be function
    tmpVec1 = vnorm2; %setze x auf 0
    tmpVec1(1) = 0;
    tmpVec2 = vnorm2; %setze y auf 0
    tmpVec2(2) = 0;
  
    tmpRef1 = reference;
    tmpRef1(1) = 0; %setze x der reference auf 0
    tmpRef2 = reference;
    tmpRef2(2) = 0; %setze y der reference auf 0
  
    xAngle = acosd(sum(tmpRef1.*tmpVec1));
    yAngle = acosd(sum(tmpRef2.*tmpVec2));
  
    %error = [xAngle;yAngle]; 
    %floor(in) + ceil( (in-floor(in))/0.5) * 0.5
    x = floor(xAngle) + ceil( (xAngle-floor(xAngle))/0.5) * 0.5; %rounding to 0.5 (up)
    y = floor(yAngle) + ceil( (yAngle-floor(yAngle))/0.5) * 0.5;
    
    state2 = (360*x+1) + (y*2);
    action2    = chooseAction3d(Q, state2, epsilon);
   
    qValue = update(Q, state1, state2, rewardValue, action1, action2);
    Q(state1, action1) = qValue;
     
    state1 = state2;
    action1    = action2;
    vnorm1     = vnorm2;
    
    t  = t+1;
    ct = ct+1;
    
    statevector = [statevector; vnorm1];
    refvector   = [refvector; reference];

    if length(statevector)>3000
        statevector = [];
        refvector   = [];
    end
  end
  
  epsilon = epsilon + 0.2/total_episodes; %epsilon wird größer => exploration sinkt
  eps = [eps; epsilon];
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
hold;
grid on;
plot(eps)


