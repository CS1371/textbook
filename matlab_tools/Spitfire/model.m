function model
    global exhaust_at
    global exhaust_dv
    
    load spitfire.mat
    showData(wingLeft, wingRight, body, fin, prop, antenna, guns, ... 
        elevLeft, elevRight, spinner, c_back, c_front, screen, pilot )
    az = 0;
    while true
        az = az + 1;
        el = 10 - 30*cosd(az/2);
        view(az, el)
        pause(0.001)
    end
end


function showData(wl, wr, body, fin, prop, ant, guns, ...
                 ell, elr, sp, back, front, screen, plt) 
    global exhaust_at
    global exhaust_dv
    
    figure
    surf(sp.xx, sp.yy, sp.zz, sp.clr)
    hold on
    surf(body.xx, body.yy, body.zz, body.clr)
    surf(fin.xx, fin.yy, fin.zz, fin.clr)
    surf(ell.xx, ell.yy-10, ell.zz, ell.clr)
    surf(elr.xx, elr.yy+10, elr.zz, elr.clr)
    surf(wl.xx, wl.yy, wl.zz+10, wl.clr)
    surf(wr.xx, wr.yy, wr.zz+10, wr.clr)
    s1 = surf(prop.xx, prop.yy, prop.zz, prop.clr);
    set(s1, 'FaceAlpha', 0.1)
    surf(back.xx, back.yy, back.zz, back.clr)
    s2 = surf(front.xx, front.yy, front.zz, front.clr);
    set(s2, 'FaceAlpha', 0.3)
    s3 = surf(screen.xx, screen.yy, screen.zz, screen.clr);
    set(s3, 'FaceAlpha', 0.3)
    surf(plt.xx, plt.yy, plt.zz, plt.clr);
    plot3(screen.xx(1,:), screen.yy(1,:), screen.zz(1,:), 'k', 'LineWidth', 2)
    plot3(screen.xx(1,:), -screen.yy(1,:), screen.zz(1,:), 'k', 'LineWidth', 2)
    surf(ant.xx, ant.yy, ant.zz, ant.clr);
    surf(guns(1).xx, guns(1).yy, guns(1).zz, guns(1).clr);
    surf(guns(2).xx, guns(2).yy, guns(2).zz, guns(2).clr);
    ps = [   206     0    68
            200    -8    55];
    cx = ps(end,1);
    cz = ps(end,3);
    dps = ps(1, :) - ps(end,:);
    th = atan2(dps(1), dps(3));
    yv = linspace(-16, 16, 26);
    xv = zeros(1, 26);
    [xx zz] = rotateIt(front.xx-cx, front.zz-cz, th);
    zv = griddata(xx, front.yy, zz, xv, yv);
    [xl zl] = rotateIt(xv, zv, -th);
    plot3(xl+cx, yv, zl+cz, 'k', 'LineWidth', 2)
    % do the exhaust manifolds
    [xx, yy, zz] = sphere(20);
    xx = xx .* 8 + exhaust_at(1);
    yy = yy .* 4 + exhaust_at(2);
    zz = zz .* 4 + exhaust_at(3);
    [rows cols] = size(xx);
    clr = ones(rows, cols, 3) * 0.2;
    for ndx = 1:3
        surf(xx, yy, zz, clr)
        surf(xx, -yy, zz, clr)
        xx = xx + exhaust_dv(1);
        yy = yy - exhaust_dv(2);
    end
    material metal
    set(gcf, 'color', [0.7,0.7,1])
    shading interp
    axis equal
    axis tight
    axis off
    lightangle(45,45)
    view(20, 26)
end

function [xx yy] = rotateIt(xx, yy, th)
    A = [cos(th) -sin(th); sin(th) cos(th)];
    [rows cols] = size(xx);
    rx = reshape(xx, 1, rows*cols);
    ry = reshape(yy, 1, rows*cols);
    P1 = [rx; ry];
    P2 = A * P1;
    xx = reshape(P2(1,:), rows, cols);
    yy = reshape(P2(2,:), rows, cols);
end


