function [angle] = dynamics2d(angle,a,u)
    % for version without impulse intensity control, set u to 0.7
    
    maxAngle  = 45;
    maxChange = 5;
    
    % clockwise rotation
    if a==1
        da    = u*exp(angle*log(maxChange)/maxAngle);
        angle = angle + da;
    end
    
    % counter clockwise rotation
    if a==2
        da    = -u*exp(-angle*log(maxChange)/maxAngle);
        angle = angle + da;
        
    end
end