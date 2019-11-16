% Map data analysis
function main
    pause(1)
    figure
    % draw the streets
    raw = dlmread('../atlanta.txt');
    streets = raw(:,3:7);
    [rows,cols] = size(streets)
    colors = 'rgbkcmo';
    for in = 1:rows
        x = streets(in,[1 3])/1000000;
        y = streets(in,[2 4])/1000000;
        col = streets(in,5);
        col(col < 1) = 7;
        col(col > 6) = 7;
        plot(x,y,colors(col));
        hold on
    end
    % plot the travel times
    tt = dlmread('../ttimes.txt');
    [rows,cols] = size(tt)
    for in = 1:rows
        r = tt(in, 1); c = tt(in, 2);
        xc(r,c) = tt(in, 4)/1000000;
        yc(r,c) = tt(in, 5)/1000000;
        zc(r,c) = tt(in, 6);
    end
    surf(xc, yc, zc)
    shading interp
    alpha(.5)
    grid on
    axis tight
    xlabel('Longitude')
    ylabel('Latitude')
    zlabel('Travel Time (min)')
    view(-30, 45)
end
