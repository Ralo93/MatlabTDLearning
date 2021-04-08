function [x, y] = getAngles(vnorm, reference)
  
##    tmpVec1 = vnorm; %setze x auf 0
##    tmpVec1(1) = 0;
##    tmpVec2 = vnorm; %setze y auf 0
##    tmpVec2(2) = 0;
##  
##    tmpRef1 = reference;
##    tmpRef1(1) = 0; %setze x der reference auf 0
##    tmpRef2 = reference;
##    tmpRef2(2) = 0; %setze y der reference auf 0
##  
##    xAngle = acosd(sum(tmpRef1.*tmpVec1));
##    yAngle = acosd(sum(tmpRef2.*tmpVec2));
##  
##    x = ceil(xAngle); #ceiled for 90
##    y = ceil(yAngle);

    % compute reference angles
    xangleR = asin(-reference(2));
    yangleR = asin(reference(1)/cos(xangleR));
    xangleR = xangleR*180/pi;
    yangleR = yangleR*180/pi;
    
    % compute sphere angles
    xangleV = asin(-vnorm(2));
    yangleV = asin(vnorm(1)/cos(xangleV));
    xangleV = xangleV*180/pi;
    yangleV = yangleV*180/pi;
    
    x = ceil(xangleR-xangleV);
    y = ceil(yangleR-yangleV);
    return;
    
end