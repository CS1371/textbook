% Plotting line intersections
function main
    % equations are y = m1 x + c1
    % y = m2 x + c2
    % in matrix form:
    % [ -m1 1; * [xp; = [c1
    % -m2 1 ] yp] c2]
    
    % Sets the x and y limits of the plot
    ax = [-0.5 6]; ay = [-4.5 18];
    
    % Plot the original two lines
    m1 = 3; c1 = -2;
    y1 = m1*ax + c1;
    m2 = -2; c2 = 9;
    y2 = m2*ax + c2;
    plot(ax, y1)
    hold on
    plot(ax, y2, 'b-')
    
    % Solve for the intersection point. 
    % Sets the simultaneous equation matrix
    A = [-m1 1; -m2 1];
    % Shows the right-hand side of the equation
    c = [c1; c2];
    % Solves the linear equation - P(1) is the x value; P(2) is the y value
    P = A\c;
    
    % Plots the lines identifying the intersection point
    ix = P(1); iy = P(2);
    plot([ix ix], [0 iy*1.2], 'r:')
    plot([0 ix*1.2],[iy iy], 'r:')
    
    % Plot the axes
    plot(ax, [0 0], 'k');
    axis([ax ay])
    plot([0 0], ay, 'k');
    
    % Finish the plot
    legend({'Line 1','Line 2','Intersect'}, ...
        'Location','NorthWest' )
end