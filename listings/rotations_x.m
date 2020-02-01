function main()
clear
clc
close all
    N = 200;
    x_slice = 3.8;
    a_h = 1;
    % range of u
    u = linspace(0, 5, N);
    % plot upper and lower curves
    r = f(u);
    y = zeros(1,N);
    plot3(u, y, r, 'b')
    hold on
    plot3(u, y, -r, 'b')
    % draw circle in y-z plane at x = x_slice
    th = linspace(0, 2*pi, N);
    x = ones(1,N) * x_slice;
    rad = f(3.8);
    y = rad .* cos(th);
    z = rad .* sin(th);
    plot3(x, y, z, 'r--');
    % draw axis of rotation
    x = [0 6];
    y = [0 0];
    z = [0 0];
    plot3(x, y, z, 'k-.')
    % r arrow
    x = [x_slice x_slice];
    y = [0 0];
    z = [0 f(x_slice)];
    plot3(x, y, z, 'k')
    % arrow head
    x = [0, a_h/16, 0, -a_h/16, 0];
    y = [0 0 0 0 0];
    z = [0, -a_h, -3*a_h/4, -a_h, 0]*2;
    fill3(x+x_slice, y, z + f(x_slice), 'k')
    % rotated arrow head
    x = [0, -1, -.75, -1, 0]/4;
    z = [0, 0, -.75, -2, 0]/2;
    fill3(x+x_slice, y+14, z - 2.3, 'k')
    % arrow 2
    x = [x_slice x_slice];
    y = [ 0, 14];
    z = [ 0, -2.3];
    plot3(x, y, z, 'k')
    
    text(3.9, 0, 10, 'r = f(x)')
    text(3.1, 14, -6, 'theta')
    x = [3.5 3.5];
    y = [14 14];
    z = [-3 -5];
    plot3(x, y, z, 'k')
    % dummy axes
    x = [0 0];
    y = [0 0];
    z = [0 16];
    plot3(x, y, z, 'k')
    text(0, 0, 16, 'Z')
    x = [0 0];
    y = [0 20];
    z = [0 0];
    plot3(x, y, z, 'k')
    text(0, 20, 0, 'Y')
    text(5.5, 0, 0, 'X')
    grid on
    axis([0 5 -20 20 -16 16])
    axis off
    view(30, 20)
end

function v = f(u)
    v = u.^2;
end

