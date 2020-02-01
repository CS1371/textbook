% Drawing a Donut
function main
clear
clc
close all
    % we draw a donut by first creating its cross-section,
    % a circle displaced from the origin of coordinates
    % in the x-z plane
    % we will need a plaid consisting of two angles:
    % - one for creating the circle
    % - one for rotating the section
    N = 200;
    r = 1;  % the circle radius
    R = 3; % the donut radius
    th = linspace(0, 2*pi, N);
    [tth1 tth2] = meshgrid(th, th);
    %  make the circle
    rr = R + r.*cos(tth1);
    zz = r.*sin(tth1);
    % now, rotate it
    xx = rr.*cos(tth2);
    yy = rr.*sin(tth2);
    surf(xx, yy, zz);
    shading interp
    axis equal;axis tight; axis off
    colormap copper
    lightangle(60, 45)
    lightangle(140, 45)
end
