function reward = reward3d(reference, vnorm)
  
  %Reward function for reference reference "reference" [-45;45]
  %and the current reference vnorm, as well as the factor b
  %which is -1.5 and is used for making rewards negative:
  %small differences between reference and vnorm get punished only a litte
  %while big differences bet punished a lot
  b = -1.5;
  vnorm = vnorm';
  reference = reference';
  
  reward = b*norm(reference - vnorm, 2);
  return;
  
  #***DEAD CODE FROM HERE ON BUT FOR REASONING STILL INCLUDED***
  
  
  %Reward = |reference| + p(vnorm)
  vnormR = vnorm(1,1:2);
  
  ref1 = reference(1,1:2);
  ref1(1) = ref1(1) +0.5;
  
  ref2 = reference(1,1:2);
  ref2(1) = ref2(1) -0.5;
  
  ref3 = reference(1,1:2);
  ref3(2) = ref3(2) +0.5;
  
  ref4 = reference(1,1:2);
  ref4(2) = ref4(2) -0.5;
  
  %Good cases: reference .+ 0.5 or reference .- 0.5 is vnorm then its fine.
  %refTmp = reference;
  %refTmp(1) = refTmp(1) + 0.5;  
  
  if (vnormR == ref1 || vnormR == ref2 || vnormR == ref3 || vnormR == ref4)
    
    reward = 0;
    return;
    
  endif
  
  tmpVec1 = vnorm; %setze x auf 0
  tmpVec1(1) = 0;
  tmpVec2 = vnorm; %setze y auf 0
  tmpVec2(2) = 0;
  
  tmpRef1 = reference;
  tmpRef1(1) = 0; %setze x der reference auf 0
  tmpRef2 = reference;
  tmpRef2(2) = 0; %setze y der reference auf 0
  
  xAngle = acosd(sum(tmpRef1.*tmpVec1));
  x = floor(xAngle) + ceil( (xAngle-floor(xAngle))/0.5) * 0.5; %rounding to 0.5 (up)
    
  %fprintf('xAngle Diff: %d \n',xAngle);
  yAngle = acosd(sum(tmpRef2.*tmpVec2));
  %fprintf('yAngle Diff: %d \n',yAngle);
  
  y = floor(yAngle) + ceil( (yAngle-floor(yAngle))/0.5) * 0.5;
  
  
  reward = (-b*x*y)/100; %werte kleiner machen
  %fprintf('Reward %d \n',reward);
  
  
end
