% Eyeball linear estimation
function main
    x = 0:5;
    y = [0 20 60 68 77 110];
    y2 = 20 * x;
    plot(x, y, 'o', x, y2);
    grid on, axis([-1 7 -20 120])
    title('Linear Estimate')
    xlabel('Time (sec)')
    ylabel('Temperature (degrees F)')
    grid on
end
