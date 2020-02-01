function main()
clear
clc
close all
    N = 200;
    z_slice = 3.8;
    a_h = 1;
    % range of u
    u = linspace(0, 4, N);
    % plot left and right curves
    z = f(u);
    x = zeros(1,N);
    plot3(x, u, z, 'b')
    hold on
    plot3(x, -u, z, 'b')
    % draw circle in x-y plane at z = z_slice
    th = linspace(0, 2*pi, N);
    z = ones(1,N) * f(z_slice);
    rad = 3.8;
    x = rad .* cos(th);
    y = rad .* sin(th);
    plot3(x, y, z, 'r--');
    % draw axis of rotation
    x = [0 0];
    y = [0 0];
    z = [0 16];
    plot3(x, y, z, 'k-.')
    % r arrow
    x = [0 0];
    y = [2.5 2.5];
    z = [0 f(2.5)];
    plot3(x, y, z, 'k')
    % arrow head
    x = [0, a_h/16, 0, -a_h/16, 0]*1.5;
    y = [0 0 0 0 0];
    z = [0, -a_h, -3*a_h/4, -a_h, 0];
    fill3(x, y+2.5, z + f(2.5), 'k')
    % rotated arrow head
    x = [0, -1, -.75, -1, 0]/2;
    z = [0, 0, -.75, -2, 0]/4;
    fill3(x+3.75, y+1.1, z+15, 'k')
    % arrow 2
    x = [0 3.8];
    y = [ 0, 1.2];
    z = [ f(z_slice), 14.94];
    plot3(x, y, z, 'k')
    
    text(0.2, 2.4, 3, 'z = f(u)')
    text(3.7, 0, 15, 'theta')
    text(2.5, 0, 16, 'r')
    x = [0 3.7];
    y = [0 0];
    z = [14.4 14.4];
    plot3(x, y, z, 'k')
    x = [3 3.7];
    y = [0 0];
    z = [14.4 15.8];
    plot3(x, y, z, 'k')
    % dummy axes
    x = [0 0];
    y = [0 4];
    z = [0 0];
    plot3(x, y, z, 'k')
    text(0.2, 4, 0, 'Y')
    x = [0 4];
    y = [0 0];
    z = [0 0];
    plot3(x, y, z, 'k')
    text(3.5, 0.5, 0, 'X')
    text(0.2, 0, 16, 'Z')
    grid on
    axis([-4 4 -4 4 0 17])
%     axis equal
     axis off
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    view(30, 20)
end

function v = f(u)
    v = u.^2;
end

