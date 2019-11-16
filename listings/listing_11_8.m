% Constructing a cylinder
function main
    pause(1)
    figure
    facets = 120; len = 2; radius = 1;
    [zz yy xx] = cylinder(radius,120);
    xx = xx .* len;
    surf(xx, yy, zz);
    shading interp
    colormap bone
    axis equal,axis tight,axis off
    lightangle(60, 45)
    alpha(0.8)
    view(-20, 35)
end
