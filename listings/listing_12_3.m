% Rotating a solid cube
function main
    pause(1)
    figure
    xx = [ 0 0 0 0 0;
        -1 -1 1 1 -1;
        -1 -1 1 1 -1;
        0 0 0 0 0]
    yy = [ 0 0 0 0 0;
        -1 1 1 -1 -1;
        -1 1 1 -1 -1;
        0 0 0 0 0]
    zz = [ 1 1 1 1 1;
        1 1 1 1 1;
        -1 -1 -1 -1 -1;
        -1 -1 -1 -1 -1]
    [r c] = size(xx);
    ln = r*c; % length of reshaped vector
    th = 0; ph = 0; ps = 0;
    dth = 0.05; dph = 0.03; dps = 0.01;
    go = true
    while go
        surf(xx+4, yy, zz)
        shading interp; colormap autumn
        hold on; alpha(0.5)
        Rz = [cos(th) -sin(th)  0
            sin(th) cos(th) 0
            0	0	1];
        Ry = [cos(ph)	0	-sin(ph)
            0	1	0
            sin(ph)	0 cos(ph)];
        Rx = [ 1	0	0
            0	cos(ps) -sin(ps)
            0	sin(ps) cos(ps)];
        P(1,:) = reshape(xx, 1, ln);
        P(2,:) = reshape(yy, 1, ln);
        P(3,:) = reshape(zz, 1, ln);
        Q = Rx*Ry*Rz*P;
        qx = reshape(Q(1,:), r, c);
        qy = reshape(Q(2,:), r, c);
        qz = reshape(Q(3,:), r, c);
        surf(qx, qy, qz)
        shading interp
        axis equal; axis off; hold off
        axis([-2 6 -2 2 -2 2])
        lightangle(40, 65); alpha(0.5)
        th = th+dth; ph = ph+dph; ps = ps+dps;
        go = ps < pi/4
        pause(0.03)
    end
end
