clc;

#load('Qmat.mat');
epsilon = 1;

statevector = [];
refvector   = [];
ct          = 0;

maxiter     = 300;

#state1      = -10;
reference   = 0;

timevec     = (1:maxiter)*0.02;

for ii=1:length(timevec)
    
    reference = sin(timevec(ii)*2)*15;
    
	  error      = state1-reference;
	  discerror1 = floor((error+91)*900/181);
	  action1    = chooseAction3d(Q, discerror1, epsilon);
    
    state1     = dynamics3d(state1, action1, 0.7);
    
    ct = ct+1;
    
    statevector = [statevector; state1];
    refvector   = [refvector; reference];
    
end

figure('Color','white');
hold on;
plot(timevec,statevector,'Linewidth',1.3);
plot(timevec,refvector,'Linewidth',1.3);
xlabel('t in s','fontsize',14);
ylabel('Sphere angle','fontsize',16);
