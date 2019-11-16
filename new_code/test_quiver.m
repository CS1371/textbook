function test_quiver
    clear
    clc
    close all
    
    grey = [0.8 0.8 0.8];
    load('xyz.mat');
    dp = pi/50;
    [u,v,w] = gradient(z, dp);
    quiver(x, y, z, u, v, w, 1)
    hold on
    sh = surf(x, y, z);
    set(sh,'FaceColor',grey)
    hold on
    
    xlabel('x (th)')
    ylabel('y (phi)')
    axis equal
%     axis off
    view(100, 20)
    figure
    [u v w] = surfnorm(x, y, z);
    quiver3(x, y, z, u, v, w, 1);
    title ('surface normals')
    hold on

end

