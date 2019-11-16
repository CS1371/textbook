% Linear interpolation
function main
    pause(1)
    figure
    x = 0:5;
    y = [0, 20, 60, 68, 77, 110];
    plot(x, y, 'r+')
    hold on
    fprintf('value at 1.5 is %2.2f\n', interp1(x, y ,1.5));
    new_x = 0:0.241:5;
    new_y = interp1(x,y,new_x);
    plot(new_x, new_y, 'o')
    grid on, axis([-1,6,-20,120])
    title('linear Interpolation Plot')
    xlabel('x values') ; ylabel('y values')
    fprintf('value at 7 is %2.2f\n', interp1(x, y ,7));
end
