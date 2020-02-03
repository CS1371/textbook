function main
    % First sub_plot: a spiral
    subplot(1, 2, 1)
    % theta is the independent variable
    theta = 0:0.1:10.*pi;
    plot3(sin(theta),cos(theta),theta)
    title('parametric curve based on angle');
    grid on
    % second sub_plot: Brownian Motion
    subplot(1, 2, 2)
    % number of points on the trace
    N = 20;
    % velocity changes are random impulses
    dvx = rand(1, N) - 0.5	% random v changes
    dvy = rand(1, N) - 0.5
    dvz = rand(1, N) - 0.5
    % double integration to change accelerations into positions 
    x = cumsum(cumsum(dvx)); 
    y = cumsum(cumsum(dvy));
    z = cumsum(cumsum(dvz));
    plot3(x,y,z)
    grid on
    title('all 3 axes varying with parameter t')
    % text labels for the start and end of the trace
    text(0,0,0, 'start');
    text(x(N),y(N),z(N), 'end');
end
