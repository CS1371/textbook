% Rotating v = u^2 about the x axes
function main
    pause(1)
    figure
    facets = 100;
    u = linspace(0, 5, facets);
    usq = u .^ 2;
    % rotate about the x-axis
    [zz yy xx] = cylinder(usq);
    surf(xx, yy, zz, xx);
    shading interp, axis tight
    xlabel('x'), ylabel('y'), zlabel('z')
    title('u^2 rotated about the x-axis')
end
