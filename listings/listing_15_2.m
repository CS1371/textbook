% Spline interpolation
function main
    pause(1)
    figure
    
    % Show original x and y values
    x = 0:5;
    y = [0, 20, 60, 68, 77, 110];
    
    % Shows dense x values to define the curve
    new_x = 0:0.2:5;
    
    % Computes the spline function
    new_y = spline(x, y, new_x);
    
    % Plot the original data and smooth curve
    plot(x, y, 'o', new_x, new_y, '-')
    grid on, axis([-1,6,-20,120])
    title('Cubic-Spline Data Plot')
    xlabel( 'x values'); ylabel('y values')
end
