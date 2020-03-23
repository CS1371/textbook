function star(pt, sc, v, th)
    % Draws one star at location [pt(1), pt(2)] with scale sc, rotation
    % speed v, and angle th
    
    % Invoke the helper function triangle(...) to draw two rotating
    % triangles rotating in opposite directions
    triangle(1, v*th, pt, sc)
    hold on
    
    % Function to draw one triangle with the following parameters: up, with
    % values 1 for upright and -1 for point down; th, the scaled rotation
    % angle; and pt and sc, which are passed directly through the star(...)
    % function
    triangle(-1, v*th, pt, sc)
end

function triangle( up, th, pt, sc )
    % Coordinates of an equilateral triangle
    pts = [-.5	.5	0	-.5;	% x values
        -.289 -.289 .577 -.289]; % y values
    
    % Computes the rotation matrix and applies the scaling factor
    A = sc * [cos(th), -sin(th); sin(th), cos(th)];
    
    % Rotates and scales the points of the triangle
    thePts = A * pts;
    
    % Call the function fill(...) to fill the triangle, offsetting the x
    % and y coordinates by the original location of the triangle, and
    % scaling y by the up multiplier to invert the triangle if necessary.
    fill( thePts(1,:) + pt(1), ...
        up*thePts(2,:) + pt(2), 1);
end