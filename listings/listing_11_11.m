% Rotating an irregular shape
function main
    pause(1)
    figure
    u = [0 0 3 3 1.75 1.75 2 2 1.75 1.75 3 4 ...
        5.25 5.25 5 5 5.25 5.25 3 3 6 6];
    v = [0 .5 .5 .502 .502 .55 .55 1.75 1.75 ...
        2.5 2.5 1.5 1.5 1.4 1.4 ...
        .55 .55 .502 .502 .5 .5 0];
    subplot(1, 2, 1)
    plot(u, v, 'k')
    axis ([-1 7 -1 3]), axis equal, axis off
    title('2-D profile')
    facets = 200;
    subplot(1, 2, 2)
    [zz yy xx] = cylinder(v,300);
    for ndx = 1:length(u)
        xx(ndx,:) = u(ndx);
    end
    surf(xx, yy, zz);
    shading interp
    axis square, axis tight, axis off
    colormap bone
    lightangle(60, 45)
    lightangle(140, 45)
    alpha(0.8)
    title('rotated object')
end
