% Script to rotate a line
function main
    % Considering the form of the rotation equations, we need to define the
    % points where the x values are in the first row and the y values are
    % in the second row;
    pts = [3, 10
           1, 3];
       
    % Plots the line in its original location from (3,1) to (10,3)
    plot(pts(1,:), pts(2,:))
    
    % Fixes the axes at a suitable size
    axis ([0 10 0 10]), axis equal
    
    hold on
    % Iterates across a selection of angles (in radians)
    for angle = 0.05:0.05:1
        % Computes the rotation matrix
        A = [ cos(angle), -sin(angle); sin(angle), cos(angle) ];
        
        % Rotates the original line by the current angle
        pr = A * pts;
        
        % Plots the rotated line
        plot(pr(1,:), pr(2,:))
    end
end
