% Rotating v = u^2 about the z axes
clear
clc
close all
    N = 200;
    % Using the analogy of a sheet of paper wrapped into a cylinder
    % and taped, we see that we need a plaid in z and theta, the angle
    % of rotation
    u = linspace(0, 1, N);
    th = linspace(0, 2*pi, N);
    % we now compute tht plaid coordinates:
    [uu, tth] = meshgrid(u, th);
    % now, the cartesian conversion gives us the cylinder we want:
    rr = uu;
    zz = f(rr);
    xx = rr.*cos(tth);
    yy = rr.*sin(tth);
    surf(xx, yy, zz, xx);
    shading interp
    colormap copper
    xlabel('X'); ylabel('Y'); zlabel('Z')
    view(-30, 20)
    hold on
    % draw axis of rotation
    x = [0 0];
    y = [0 0];
    z = [0 1];
    plot3(x, y, z, 'k--')
    lightangle(-60, 45)

function v = f(u)
    v = u.^2;
end

