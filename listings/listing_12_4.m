
% Rotating a solid cube
function main
    % Build coordinates of the cube centered at the origin.
    xx = [ 0 0 0 0 0;
        -1 -1 1 1 -1;
        -1 -1 1 1 -1;
        0 0 0 0 0]
    yy = [ 0 0 0 0 0;
        -1 1 1 -1 -1;
        -1 1 1 -1 -1;
        0 0 0 0 0]
    zz = [ 1 1 1 1 1;
        1 1 1 1 1;
        -1 -1 -1 -1 -1;
        -1 -1 -1 -1 -1]
    
    % Determine the length of the linearized row vector for the
    % reshape(...) function
    [r c] = size(xx);
    ln = r*c; % length of reshaped vector
    
    % Set up the three rotation angle parameters - the initial values and
    % the increments
    th = 0; ph = 0; ps = 0;
    dth = 0.05; dph = 0.03; dps = 0.01;
    
    % Repeat the drawing loop until the variable go is reset.
    go = true
    while go
        % Draw one cube not rotated four units down the x axis
        surf(xx+4, yy, zz)
        shading interp; colormap autumn
        hold on; alpha(0.5)
        
        % Set up the rotation matrices
        Rz = [cos(th) -sin(th)  0
            sin(th) cos(th) 0
            0	0	1];
        Ry = [cos(ph)	0	-sin(ph)
            0	1	0
            sin(ph)	0 cos(ph)];
        Rx = [ 1	0	0
            0	cos(ps) -sin(ps)
            0	sin(ps) cos(ps)];
        
        % Reshape the x, y, and z arrays into linear forms
        P(1,:) = reshape(xx, 1, ln);
        P(2,:) = reshape(yy, 1, ln);
        P(3,:) = reshape(zz, 1, ln);
        
        % Performs the rotation
        Q = Rx*Ry*Rz*P;
        
        % Recover the original array shapes
        qx = reshape(Q(1,:), r, c);
        qy = reshape(Q(2,:), r, c);
        qz = reshape(Q(3,:), r, c);
        
        % Draw the rotated cube
        surf(qx, qy, qz)
        shading interp
        axis equal; axis off; hold off
        axis([-2 6 -2 2 -2 2])
        lightangle(40, 65); alpha(0.5)
        
        % Updates the rotation angles
        th = th+dth; ph = ph+dph; ps = ps+dps;
        
        % Shows the terminating condition
        go = ps < pi/4
        
        % Pauses to give the figure time to draw
        pause(0.03)
    end
end