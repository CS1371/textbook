% Higher-order fits
function main
    pause(1)
    figure
    
    % Set up the data sets
    x = 0:5;
    fine_x = 0:.1:5;
    y = [0 20 60 68 77 110];
    
    % Study second through fifth order fits
    for order = 2:5
        % Combine polyfit and polyval calls to compute new y values
        y2=polyval(polyfit(x,y,order), fine_x);
        
        % Plot the results
        subplot(2,2,order-1)
        plot(x, y, 'o', fine_x, y2)
        grid on, axis([-1 7 -20 120])
        ttl = sprintf('Degree %d Polynomial Fit', ...
            order );
        title(ttl)
        xlabel('Time (sec)')
        ylabel('Temperature (degrees F)')
    end
end
