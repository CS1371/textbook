% Higher-order fits
function main
    pause(1)
    figure
    x = 0:5;
    fine_x = 0:.1:5;
    y = [0 20 60 68 77 110];
    for order = 2:5
        y2=polyval(polyfit(x,y,order), fine_x);
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
