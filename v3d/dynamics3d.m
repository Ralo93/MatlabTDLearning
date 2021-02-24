function [vnorm] = dynamics3d(vnorm,a,u)
    % for version without impulse intensity control, set u to 0.7
    
    maxAngle  = 45;
    maxChange = 5;
    
    if a==1
        % project vnorm onto xz-plane
        xz    = vnorm([1,3]);
        alpha = -sign(xz(1))*(pi/2-atan(abs(xz(2)/xz(1))))/pi*180;
        da    = -u*exp(-alpha*log(maxChange)/maxAngle);
        da    = da*pi/180;
        R     = [cos(da), 0, sin(da); ...
                 0,       1, 0;       ...
                -sin(da), 0, cos(da)];
        vnorm = R*vnorm;
    end
    
    if a==2
        % project vnorm onto xz-plane
        xz    = vnorm([1,3]);
        alpha = -sign(xz(1))*(pi/2-atan(abs(xz(2)/xz(1))))/pi*180;
        da    = u*exp(alpha*log(maxChange)/maxAngle);
        da    = da*pi/180;
        R     = [1,  0,        0;       ...
                 0,  cos(da),  sin(da); ...
                 0, -sin(da),  cos(da)];
        vnorm = R*vnorm;
    end
    
    if a==3
        % project vnorm onto yz-plane
        xz    = vnorm([2,3]);
        alpha = -sign(xz(1))*(pi/2-atan(abs(xz(2)/xz(1))))/pi*180;
        da    = u*exp(alpha*log(maxChange)/maxAngle);
        da    = da*pi/180;
        R     = [cos(da), 0, sin(da); ...
                 0,       1, 0;       ...
                -sin(da), 0, cos(da)];
        vnorm = R*vnorm;
    end
    
    if a==4
        % project vnorm onto yz-plane
        xz    = vnorm([2,3]);
        alpha = -sign(xz(1))*(pi/2-atan(abs(xz(2)/xz(1))))/pi*180;
        da    = -u*exp(-alpha*log(maxChange)/maxAngle);
        da    = da*pi/180;
        R     = [1,  0,        0;       ...
                 0,  cos(da),  sin(da); ...
                 0, -sin(da),  cos(da)];
        vnorm = R*vnorm;
    end
    
    if a==5
        v1 = dynamics3d(vnorm,1,u);
        v2 = dynamics3d(vnorm,2,u);
        vnorm = 1*(v1+v2);
        vnorm = vnorm/norm(vnorm);
    end
    
    if a==6
        v1 = dynamics3d(vnorm,2,u);
        v2 = dynamics3d(vnorm,3,u);
        vnorm = 1*(v1+v2);
        vnorm = vnorm/norm(vnorm);
    end
    
    if a==7
        v1 = dynamics3d(vnorm,3,u);
        v2 = dynamics3d(vnorm,4,u);
        vnorm = 1*(v1+v2);
        vnorm = vnorm/norm(vnorm);
    end
    
    if a==8
        v1 = dynamics3d(vnorm,4,u);
        v2 = dynamics3d(vnorm,1,u);
        vnorm = 1*(v1+v2);
        vnorm = vnorm/norm(vnorm);
    end
end