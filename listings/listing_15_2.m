% Spline interpolation
function main
    pause(1)
    figure
    x = 0:5;
    y = [0, 20, 60, 68, 77, 110];
    new_x = 0:0.2:5;
    new_y = spline(x, y, new_x);
    plot(x, y, 'o', new_x, new_y, '-')
    grid on, axis([-1,6,-20,120])
    title('Cubic-Spline Data Plot')
    xlabel( 'x values'); ylabel('y values')
end
