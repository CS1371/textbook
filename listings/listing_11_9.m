% Constructing a sphere
function main
clear
clc
close all
    facets = 120;
    [xx yy zz] = sphere(facets-1);
    surf(xx, yy, zz);
    shading interp
    colormap copper
    axis equal, axis tight
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    lightangle(60, 45)
end
