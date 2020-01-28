% Rotating an irregular shape
clear, clc, close all
    figure
    u = [0 3  3 3.2 4 3 2.8 0];
    v = [0 0 0.05 0.3 0.3 0.28 0.1 0.1 ];
%     subplot(1, 2, 1)
%     plot(u, v, 'k')
%     axis ([-5 5 -1 1]), axis equal, axis off
%     title('2-D profile')
    facets = 200;
%     subplot(1, 2, 2)
    [xx yy zz] = cylinder(u,300);
    for ndx = 1:length(u)
        zz(ndx,:) = v(ndx);
    end
    [px, py] = size(xx);
    img = ones(px, py, 3);
    img(:,:,[1 3]) = 0.9;
%     img(:,:,3) = 0.4;
    for ndx = 1:12
        surf(xx, yy, zz, img);
        zz = zz + 0.5;
        hold on
    end
    shading interp
    axis equal , axis off
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    lightangle(60, 45)
%    title('rotated object')
    view(-30, 15)


