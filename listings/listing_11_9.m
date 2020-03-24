% Rotating v = u^2 about the x axes
function main
    N = 200;
    u = linspace(0, 5, N);
    v = f(u);
    % rotate about the x-axis
    [yy zz xx] = cylinder(v, N - 1);
    % change the length of the cylinder
    xx = xx .* 5;
    surf(xx, yy, zz, xx);
    shading interp
    colormap copper
    xlabel('X'); ylabel('Y'); zlabel('Z')
    view(30, 20)
    hold on
    % draw axis of rotation
    x = [0 5];
    y = [0 0];
    z = [0 0];
    plot3(x, y, z, 'k--')
    lightangle(0, 45)
end

function v = f(u)
    v = u.^2;
end

