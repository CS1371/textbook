clear
clc
close all

global brkt
global fxx
global fyy
global fzz

    R = 5;
    mr = 1;
    hr = 0.5;
    n = 2000;
    mhr = R - 3*hr;
    hf = mhr/R;
    [hxx, hyy, hzz] = cylinder([0,hr,hr,0], n);
    hzz(2,:) = -0.1;
    hzz([3,4],:) = 1.1;
    dth = 360/8;
    ths = 1:8;
    th = 0;
    bth = (atan2(hr, mhr) * 180) / pi;
    brkt = [];
    for thx = 1:8
        ohxx = hxx + mhr*sind(th);
        ohyy = hyy + mhr*cosd(th);
        brkt = [brkt; [th-bth,th+bth]];
        th = th + dth;
    end
    brkt = [brkt; brkt(1,:) + 360];
    [mxx, myy, mzz] = cylinder([0,mr,mr,0], n);
    mzz(2,:) = 0;
    mzz([3,4],:) = 1;
    [xx yy zz] = cylinder([0,R,R,0], n);
    zz(2,:) = 0;
    zz([3,4],:) = 1;
    zz(5,:) = 0;
    xx(1,:) = mxx(2,:);
    yy(1,:) = myy(2,:);
    xx(4,:) = mxx(3,:);
    yy(4,:) = myy(3,:);
    xx(5,:) = xx(1,:);
    yy(5,:) = yy(1,:);
    fxx = [xx(1,:)
           xx(2,:)*hf
           xx(2,:)*hf
           xx(2:3,:)
           xx(3,:)*hf
           xx(3,:)*hf
           xx(4:5,:)];
    fyy = [yy(1,:)
           yy(2,:)*hf
           yy(2,:)*hf
           yy(2:3,:)
           yy(3,:)*hf
           yy(3,:)*hf
           yy(4:5,:)];
    fzz = [zz(1,:)
           zz(1,:)
           zz(1,:)
           zz(2:3,:)
           zz(3,:)
           zz(3,:)
           zz(4:5,:)];
    fix_hole_edges(n, hr, mhr)
    xx = fxx([3 4 5 6 3], :);
    yy = fyy([3 4 5 6 3], :);
    zz = fzz([3 4 5 6 3], :);
    [nr, nc] = size(xx);
    C = zeros(nr, nc, 3) + 0.2;
    C(:,:,2) = 0.5; 
    surf(xx, yy, zz, C);
    shading interp
    hold on
    xx = fxx([1 2 7 8 9], :);
    yy = fyy([1 2 7 8 9], :);
    zz = fzz([1 2 7 8 9], :);
    surf(xx, yy, zz, C);
    shading interp
    axis equal; axis off
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    %alpha 0.7
    lightangle(-45, -45)
    lightangle(-45, 60)
    view(-12, 40)

function fix_hole_edges(n, hr, mhr)
global brkt
global fxx
global fyy
global fzz
    [brs bc] = size(brkt);
    dth = 360/n;
    thd = 0;
    dgv = 0;
    edges = [];
    for nd = 1:(n+1)
        found = false;
        for br = 1:brs
            found = thd > brkt(br,1) && thd < brkt(br,2);
            if found
                edges = brkt(br,:);
                break;
            end
        end
        if found
            mid = (edges(2)+edges(1))/2;
            dlth = thd - mid;
            la = mhr * tand(dlth);
            lr = sqrt(hr*hr-la*la);
            dc = lr*cosd(thd);
            fxx(2,nd) = fxx(2,nd) - dc;
            fxx(3,nd) = fxx(3,nd) + dc;
            fxx(6,nd) = fxx(3,nd);
            fxx(7,nd) = fxx(2,nd);
            dr = lr*sind(thd);
            fyy(2,nd) = fyy(2,nd) - dr;
            fyy(3,nd) = fyy(3,nd) + dr;
            fyy(6,nd) = fyy(3,nd);
            fyy(7,nd) = fyy(2,nd);
        end
        thd = thd + dth;
        if rem(dgv,200) == 0
            fprintf('angle %d\n', floor(thd));
        end
        dgv = dgv + 1;
    end
    fprintf('angle %d\n', thd);
end

