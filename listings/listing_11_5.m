% Linear parametric 3-D plots
function main
    pause(1)
    figure
    subplot(1, 2, 1)
    theta = 0:0.1:10.*pi;
    plot3(sin(theta),cos(theta),theta)
    title('parametric curve based on angle');
    grid on
    subplot(1, 2, 2)
    N = 20;
    dvx = rand(1, N) - 0.5	% random v changes
    dvy = rand(1, N) - 0.5
    dvz = rand(1, N) - 0.5
    x = cumsum(cumsum(dvx)); % integrate to get pos
    y = cumsum(cumsum(dvy));
    z = cumsum(cumsum(dvz));
    plot3(x,y,z)
    grid on
    title('all 3 axes varying with parameter t')
    text(0,0,0, 'start');
    text(x(N),y(N),z(N), 'end');
end
