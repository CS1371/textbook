% Linear interpolation
function main
    % Use data illustrated in Figure 15.2
    pause(1)
    figure
    x = 0:5;
    y = [0, 20, 60, 68, 77, 110];
    plot(x, y, 'r+')
    hold on
    
    % Take single interpolated reading from data at x = 1.5
    fprintf('value at 1.5 is %2.2f\n', interp1(x, y ,1.5));
    
    % Plot points spaced 0.241 points apart on x-axis marked with circles
    % (shown in Figure 15.3). Notice that the circles fall on the straight
    % lines between the given data values.
    new_x = 0:0.241:5;
    new_y = interp1(x,y,new_x);
    
    % Document the plot
    plot(new_x, new_y, 'o')
    grid on, axis([-1,6,-20,120])
    title('Linear Interpolation Plot')
    xlabel('x values') ; ylabel('y values')
    
    % Attempt to extrapolate to the point x = 7 and see that NaN (Not a
    % Number) is returned because interp1 refuses to extrapolate outside
    % the original range of x values. 
    fprintf('value at 7 is %2.2f\n', interp1(x, y ,7));
end
