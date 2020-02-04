% Eyeball linear estimation
function main
    pause(1)
    figure
    
    % Show the original data points
    x = 0:5;
    y = [0 20 60 68 77 110];
    
    % Eyeball estimate
    y2 = 20 * x; 
    
    % Plot original data and estimate
    plot(x, y, 'o', x, y2);
    grid on, axis([-1 7 -20 120])
    title('Linear Estimate')
    xlabel('Time (sec)')
    ylabel('Temperature (degrees F)')
    grid on
end
