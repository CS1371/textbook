% Constructing a sphere
function main
    pause(1)
    figure
    facets = 120; radius = 1;
    [xx yy zz] = sphere(facets-1);
    surf(xx, yy, zz);
    shading interp
    colormap copper
    axis equal, axis tight, axis off
    lightangle(60, 45)
end
