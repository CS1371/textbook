% Constructing a cylinder
function main
clear
clc
close all
    facets = 120; 
    len = 2; 
    radius = 0.5;
    % Notice that we re-ordered the output parameters</font><br>
    %   in order to orient the x axis horizontally</font><br>
    [zz yy xx] = cylinder(radius, facets);
    xx = xx .* len;
    surf(xx, yy, zz);
    shading interp
    colormap copper
    axis equal
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    lightangle(60, 45)
    % this line sets the transparency of the surface (0->1)
    alpha(0.8)
    view(-20, 35)
end
