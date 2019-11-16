function SR_71
    clear
    clc
    close all
    
    global xdiv
    global ydiv
    global halfTop
    global halfFront
    global ht
    global wdth
    global x
    global y
    global z
    global npts
    global origpts
    global pt
    global vecNdx
    global plane
    global resolution
    global wingLeft
    global fillet
    global body
    global fin
    global engLeft
    global plug
    global canopy
    global window
    global bod_clr
    global thicknessToChord
    global field
    global surfImg
    global back
    global order
    
    %   c - cone
    %   f - fin
    %   F - fillet
    %   i - engine top
    %   I - engine bottom
    %   j - engine side
    %   p - lip
    %   r - fuselage rear profile top
    %   R - fuselage rear profile bottom
    %   s - fuselage profile top
    %   S - fuselage profile bottom
    %   w - wing
    %   x - fuselage x profile top
    %   X - fuselage x profile bottom
    %   y - fuselage y profile
    %   Y - fuselage rear y profile
    %   z - cockpit top view
    %   Z - cockpit side view
    
    field = {'xx','yy','zz'};   
    thicknessToChord = 0.04;
    resolution = 128;
    bod_clr = [220 180 220] ./ 255;
    surfImg = zeros(resolution*2,resolution,3);
    for clr = 1:3
        surfImg(:,:,clr) = bod_clr(clr);
    end
    back = 10;
    order = 4;
    recompute = true;
    newData = true;
    wingLeft = [];
    wingRight = [];
    body = [];
    fin = [];
    engLeft = [];
    engRight = [];
    canopy = [];
    vecNdx = [];
    if recompute, rs = ''; else,rs = 'don''t'; end 
    if newData, ds = ''; else,ds = 'don''t'; end 
    fprintf('%s recompute; %s input new data; resolution %d\n', ...
        rs, ds, resolution);
    ydiv = 562;
    halfTop = 279;
    xdiv = 1076;
    plane = imread('SR_71_3_view_1.gif');
    [ht, wdth, ~] = size(plane)
    halfFront = 1361;
    x = 0;
    y = 0;
    z = 0;
    recoverData()
    if recompute
        wingLeft = [];
        body = [];
        fin = [];
        engLeft = [];
        canopy = [];
    end
    quit = false;
    origpts = npts;
    redraw()
    while ~quit && newData
        [vec, lab, OK] = getCoord();
        if OK
            npts = npts + 1;
            pt = [pt; vec];
            addToNdx(lab, npts)
            redraw();
        else
            quit = true;
        end
    end
    storeData()
%    figure
%
%   Body
%
    if isempty(body)
        body  = doBody('s','S', 'x', 'X', 'y', 'r', 'R', 'Y');
    end
%
%   Fin
%
    if isempty(fin)
        fin = doFin('f');
    end
%
%   Wing  - DO BEFORE ENGINE / need back cutout dimension
%
    if isempty(wingLeft)
        [wingLeft, wingRight] = doWing('w');
    end
%
%   Engine
%
    if isempty(engLeft)
        [engLeft, plug, fillet] = doEngine('c','i','I','j','F');
        
    end
%
%   Canopy
%
    if isempty(canopy)
        [canopy] = doCanopy('z','Z');
    end
    figure
    showData()
end

function showData() 
    global wingLeft
    global engLeft
    global plug
    global fin
    global body
    global fillet
    global canopy
    global window
    global intake
    global cowl
    global exhst
    global pipe
    
    set(gcf, 'color', [0.7,0.7,1])
    showSurf(wingLeft)
    showSurf(flipY(wingLeft))
    showSurf(fillet)
    showSurf(flipY(engLeft))
    showSurf(engLeft)
    showSurf(flipY(fillet))
    showSurf(fillet)
    showSurf(fin)
    showSurf(flipY(fin))
    showSurf(body)
     showSurf(canopy)
%    showCanopy(canopy, window)
%     showInlet(intake, cowl)
%     showSurf(exhst)
    showBlack(plug)
    showBlack(flipY(plug))
%     showBlack(flipY(pipe))
    shading interp
    axis equal
    axis tight
    axis off
    xlabel('Forward')
    ylabel('Starboard')
    zlabel('Up')
    grid on
    az = 25;
    el = 35;
    lightangle(215,60)
    while true
        az = az + 1;
        view(az, el)
        break;
        el = 10 - 30*cosd(az/2);
        pause(0.001)
    end
end

function right = flipY(left)
    right = left;
    right.yy = -right.yy;
end

function C = vConcat(A, B)
    global field
    for v = 1:3
        fld = field{v};
        C.(fld) = [A.(fld); B.(fld)];
    end
end

function cs = doFit(v, n, xs)
    global order
    
    cf = polyfit(v(:,1), v(:,n), order);
    cs = polyval(cf, xs);
end

function cs = doFity(v, xs)
    global order
    
    cf = polyfit(v(:,2), v(:,3), order);
    cs = polyval(cf, xs);
end

function [can] = doCanopy(lz, lZ)
    global resolution
    global bodProf
    
    res = resolution;
    bodProf.xx(1,:) = 700;
    top = getPoints(lZ);
    side = getPoints(lz);
    tip = top(end,:);
    side = [side; tip];
    topRange = 18:47;
    lnz = length(topRange);
    can.xx(1:2,:) = bodProf.xx(:,topRange);
    can.yy(1:2,:) = bodProf.yy(:,topRange);
    can.zz(1:2,:) = bodProf.zz(:,topRange);
    ic = 3;
%     can.xx(ic,:) = 885;
%     can.yy(ic,:) = bodProf.yy(1,topRange);
%     can.zz(ic,:) = bodProf.zz(1,topRange);
%     ic = 4;
    wintopx = top(end-1,1);
    wintopz = top(end-1,3);
    xv = linspace(tip(1), wintopx, lnz/2);
    yv = linspace(side(end-1,2), 0, lnz/2);
    zv = linspace(tip(3), wintopz, lnz/2);
    xv2 = linspace(side(end-1,1), wintopx, lnz/2);
    can.xx(ic,:) = [xv2  xv2(end:-1:1)];
    can.zz(ic,:) = [zv  zv(end:-1:1)];
    can.xx(ic+1,:) = [xv  xv(end:-1:1)];
    can.zz(ic+1,:) = can.zz(3,:);
    can.yy(ic,:) = [yv -yv(end:-1:1)];
    can.yy(ic+1,:) = 0;
    figure
    plot3( top(:,1),  top(:,2), top(:,3), 'r+');
    hold on
    plot3(side(:,1), side(:,2),side(:,3), 'g+');
    showSurf(can)
    axis equal
    grid on 
    xlabel('X axis')
    ylabel('Y axis')
    zlabel('Z axis')
    view(0,0)
end


function [left, plug, fillet] = doEngine(c, top, bot, side, F)
    global resolution
    global wingLeft
    global e_data
    
    vec = getPoints(c);
    cntr = sum(vec(1:4,:))/4;
    rsum = 0;
    for ndx = 1:4
        df = vec(ndx,:) - cntr;
        itsr = sqrt(sum(df.^2));
        rsum = rsum + itsr;
    end
    r = rsum/4;
    P5 = vec(5,:);  % point of the cone
    P6 = vec(6,:);  % fwd cowl lip 
    P7 = vec(7,:);  % rear cowl lip
    P8 = vec(8,:);  % wing/engine intersect (inner from cone)
    P9 = vec(9,:);  % outer corner of exhaust cone
    P10 = vec(10,:);  % outer corner of engine parallel section
    P6(2) = cntr(2);
    P7(2) = cntr(2);
    tdx = P5(1) - cntr(1);
    tdy = P5(2) - cntr(2);
    tdz = P5(3) - cntr(3);
    thy = atan2(tdy, tdx);
    thz = atan2(tdz, tdx);
    dz7 = P7(3) - cntr(3);
    dxc = cntr(1) - P7(1) - dz7 * sin(thz);
    nc(1) = cntr(1) - dxc + 5;
    nc(2) = -(e_data.corner(2) + e_data.outer)/2;
    nc(3) = cntr(3) - dxc*sin(thz);
    nr = r * (tdx+dxc)/tdx;
    u = [P5(1), nc(1), nc(1), P6(1), P7(1)] - nc(1);
    v = [nc(3), nc(3)+nr, P6(3), P6(3), P7(3)] - nc(3);
    py(:,1) = u' + nc(1);
    py(:,2) = P5(2);
    py(:,3) = v' + nc(3);
    th = linspace(0, 2*pi, resolution);
    [xx tth] = meshgrid(u, th);
    rr = meshgrid(v, th);
    yy = rr .* cos(tth);
    zz = rr .* sin(tth);
    [r c] = size(xx);
    Az = [cos(thy) -sin(thy) 0
          sin(thy)  cos(thy) 0
             0         0     1];
    Ay = [cos(thz) 0 -sin(thz)
             0     1     0
          sin(thz) 0  cos(thy)];
    V1(1,:) = reshape(xx, 1, r*c);
    V1(2,:) = reshape(yy, 1, r*c);
    V1(3,:) = reshape(zz, 1, r*c);
    V2 = Ay * Az * V1;
    % now we need the engine front - circle center P8(1), nc(2), nc(3)
    %                                       radius (-e_data.corner(2) + e_data.outer)/2;
    %    at fixed x position
    efr = (e_data.outer - e_data.corner(2))/2;
    ex = zeros(1,resolution) - 10;
    ey = efr*cos(th);
    ez = efr*sin(th);
    nxx = reshape(V2(1,:), r, c);
    nyy = reshape(V2(2,:), r, c);
    nzz = reshape(V2(3,:), r, c);
    exb = ex + 27 - nc(1) + P10(1) + 2;
    nxx = [nxx ex' exb'];
    nyy = [nyy ey' ey'];
    nzz = [nzz ez' ez'];
    % Now,shrink it at constant radius to 16 segments
    ndx = round(linspace(1,16,resolution)) * resolution/16;
    ndx = [ndx(2:end) ndx(1)];
    nth = th(ndx);
    exb = exb - 1;
    ey = efr*cos(nth);
    ez = efr*sin(nth);
    nxx = [nxx exb'];
    nyy = [nyy ey'];
    nzz = [nzz ez'];
    % this is also where the exhaust plug goes
    plugx(:,1) = exb + nc(1);
    plugy(:,1) = ey*0.95 + nc(2);
    plugz(:,1) = ez*0.95 + nc(3);
    plugx(:,2) = plugx(:,1);
    plugy(:,2) = nc(2);
    plugz(:,2) = nc(3);
    plug.xx = plugx;
    plug.yy = plugy;
    plug.zz = plugz;
    
    % now add end of exhaust cone
    er = P9(2) + nc(2);
    exb = ex - nc(1) + P9(1);
    ey = er*cos(nth);
    ez = er*sin(nth);
    nxx = [nxx exb'];
    nyy = [nyy ey'];
    nzz = [nzz ez'];
    figure
%     doPlot([cntr; P5; P6; P7], 'r*')
%     doPlot(nc,'r+')
%     doPlot(py,'r')
    mesh(nxx+nc(1), nyy + nc(2), nzz + nc(3))
    hold on
    grid on
    view(54, 38)
    left.xx = nxx + nc(1);
    left.yy = nyy + nc(2);
    left.zz = nzz + nc(3);
    ymn = min(min(nyy));
    zatmn = nc(3);
    
    % now do the fillet
    vec = getPoints(F);
    vec(:,1) = vec(:,1) - 12;
    vec(:,2) = -vec(:,2);
    res = resolution/8;
    sx = linspace(vec(1,1),vec(end,1), res);
    doPlot(vec, 'k*')
    sy = doFit(vec, 2, sx);
    sz = zeros(1,res) + vec(1,3);
    plot3( sx, sy, sz, 'k')
    isy = zeros(1,res) + ymn + nc(2);
    isz = zeros(1,res) + zatmn;
    plot3(sx, isy, isz, 'k')
    th = linspace(0, pi/2, res);
    fillet.xx = zeros(res,res);
    fillet.yy = zeros(res,res);
    fillet.zz = zeros(res,res);
    for ndx = 1:res
        x = sx(ndx);
        y = sy(ndx);
        z = myInterp2(wingLeft.xx, wingLeft.yy, wingLeft.zz, x, -y); 
        if isnan(z) || z < sz(ndx)
            z = sz(ndx);
        end
        iy = isy(ndx);
        iz = isz(ndx);
        b = iz - z;
        if y < iy
            a = iy - y;
            lx = zeros(1,res) + x;
            ly = y + a*cos(th);
            lz = z + b - b*sin(th);
            plot3(lx, ly, lz);
        else
            lx = x;
            ly = y;
            lz = z + b;
        end
        fillet.xx(ndx,:) = lx;
        fillet.yy(ndx,:) = ly;
        fillet.zz(ndx,:) = lz;
    end
    axis equal
    xlabel('X axis')
    ylabel('Y axis')
    zlabel('Z axis')
end


function z = myInterp2(xx, yy, zz, x, y)
    z = NaN;
    iy = find(yy(:,1) > y);
    iy = iy(1);
    ux = xx(iy,end/2);
    lx = xx(iy,end);
    vx = xx(iy,end/2+1:end);
    vz = zz(iy,end/2+1:end);
    if x <= vx(1) & x >= vx(end)
        ix = 1;
        while vx(ix) > x
            ix = ix + 1;
        end
        z = vz(ix);    
    end
end


function doPlot(v, clr)
    plot3(v(:,1), v(:,2), v(:,3), clr)
    hold on
end

function [left right fillet] = doWing(w, F)
    global resolution
    global field
    global e_data
    
    res = resolution/2;
    vec = getPoints(w);
    e_data.corner = vec(3,:);
    e_data.outer = vec(4,2);
    np = vec(3,:);
    np(1) = vec(4,1);
    np(2) = np(2)+1;
    vec = [vec(1:3,:); np; vec(4:end,:)];
    figure
    it = max(vec(:,2));
    where = find(vec(:,2) == it);
    trail = 1:where(1);
    lead = where(end):length(vec);
    plot3(vec(trail,1), vec(trail, 2), vec(trail, 3),'r')
    hold on
    plot3(vec(lead,1), vec(lead, 2), vec(lead, 3),'g')
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    grid on
    yvs = linspace(0,it,res);
    left.xx = zeros(res, resolution);
    left.yy = zeros(res, resolution);
    left.zz = zeros(res, resolution);
    for ndx = 1:res
        yv = yvs(ndx);
        xt = interp1(vec(trail,2), vec(trail,1), yv);
        zt = interp1(vec(trail,2), vec(trail,3), yv);
        xl = interp1(vec(lead,2), vec(lead,1), yv);
        zl = interp1(vec(lead,2), vec(lead,3), yv);
%        plot3([xt xl],[yv yv],[zt zl],'k')
        prof = makeProf([xt, yv, zt],[xl, yv, zl], resolution/2);
        plot3(prof.xx, prof.yy, prof.zz);
        for fndx = 1:3
            fld = field{fndx};
            left.(fld)(ndx,:) = prof.(fld);
        end       
    end
    view(90,0)
    axis equal
    right = flipY(left);
end

function prof = makeProf(P1, P2, res)
    global thicknessToChord
    global field
    
    if P1(2) ~= P2(2)
        P2(2) = P1(2);
    end
    P12 = (P1 + P2) / 2;
    dir = P2 - P1;
    d = dir(1) * thicknessToChord / 2;
    w = P2(1) - P12(1);
    x = 1:res/2;
    xv = (x - 1) * w / (res/2-1);
    zv = d*xv.^2/w.^2 - d;
    yv  = zeros(1,res/2) + P1(2);
    % mirror x's
    xv = [(P12(1)-xv(end:-1:1)) (xv+P12(1))];
    yv = [yv yv];
    zv = [zv(end:-1:1) zv];
    % mirror z's
    xv = [xv xv(end:-1:1)];
    yv = [yv yv];
    zv = [zv -zv] + P1(3);
%     figure
%     plot3(xv, yv, zv, 'k')
%     grid on
    prof.xx = xv;
    prof.yy = yv;
    prof.zz = zv;
    
end


function tpz = getTrapz(vec, res)
    global field
    root = makeProf(vec(1), vec(2), res/2);
    tip = makeProf(vec(4), vec(3), res/2);
    for layer = 1:3
        fld = field{layer};
        tpz.(fld) = zeros(res, res);
        dlta = (tip.(fld) - root.(fld))/(res-1);
        for ndx = 1:res
            tpz.(fld)(ndx,:) = root.(fld);
            root.(fld) = root.(fld) + dlta;
        end
    end
end


function fin = doFin(f)
    global resolution
    global field
    
    res = resolution/4;
    vec = getPoints(f);
    vec(:,2) = vec(:,2) + 12;
    vec(:,3) = vec(:,3) - 10;
%     np = vec(3,:);
%     np(1) = vec(4,1);
%     np(2) = np(2)+1;
%     vec = [vec(1:3,:); np; vec(4:end,:)];
    figure
    it = max(vec(:,3));
    where = find(vec(:,3) == it);
    trail = 1:where(1);
    lead = where(end):length(vec);
    plot3(vec(trail,1), vec(trail, 2), vec(trail, 3),'r')
    hold on
    plot3(vec(lead,1), vec(lead, 2), vec(lead, 3),'g')
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    grid on
    axis equal
    mz = min(vec(:,3));
    zvs = linspace(mz,it,res);
    fin.xx = zeros(res, res);
    fin.yy = zeros(res, res);
    fin.zz = zeros(res, res);
    for ndx = 1:res
        zv = zvs(ndx);
        xt = interp1(vec(trail,3), vec(trail,1), zv);
        yt = interp1(vec(trail,3), vec(trail,2), zv);
        xl = interp1(vec(lead,3), vec(lead,1), zv);
        yl = interp1(vec(lead,3), vec(lead,2), zv);
        plot3([xt xl],[yt yl],[zv zv],'k')
        prof = makeProf([xt, yt, zv],[xl, yl, zv], res/2);
        plot3(prof.xx, prof.yy, prof.zz);
        for fndx = 1:3
            fld = field{fndx};
            fin.(fld)(ndx,:) = prof.(fld);
        end       
    end
    view(90,0)
    axis equal
end


function str = strHCat(A, B)
    str.xx = [A.xx B.xx(:,end:-1:1)]; 
    str.yy = [A.yy B.yy(:,end:-1:1)]; 
    str.zz = [A.zz B.zz(:,end:-1:1)]; 
end

function str = strVCat(A, B)
    str.xx = [A.xx; B.xx]; 
    str.yy = [A.yy; B.yy]; 
    str.zz = [A.zz; B.zz]; 
end

function str = flipX(str)
    str.xx = str.xx([2 1],:);
    str.yy = str.yy([2 1],:);
    str.zz = str.zz([2 1],:);
end

function str = doBody(prft, prfb, lx, lX, ly, lr, lR, lY )
    global resolution
    global bodProf
    global order
    
    res = resolution/2;
    prt = getPoints(prft);
    [r c] = size(prt);
    px = prt(1,1);
    prtop(:,1) = [prt(:,1); prt(end:-1:1,1)]; 
    prtop(:,1) = px; 
    prtop(:,2) = [prt(:,2); -prt(end:-1:1,2)] ;
    prtop(:,3) = [prt(:,3); prt(end:-1:1,3)] ;
    prb = getPoints(prfb);
    prbot(:,1) = [prb(:,1); prb(end:-1:1,1)] ;
    prbot(:,1) = px;
    prbot(:,2) = [prb(:,2); -prb(end:-1:1,2)] ;
    prbot(:,3) = [prb(:,3); prb(end:-1:1,3)] ;
    xu = getPoints(lx);
    xl = getPoints(lX);
    xy = getPoints(ly);
    xu = xu(4:end,:);
%    xl = xl(4:end,:);
%    xy = xy(5:end,:);
    p66 = xy(1,3);
    pys = linspace(prtop(1,2), prtop(end,2), res);
    pxs = zeros(1, res) + px;
    pts = doFity(prtop, pys);
    pbs = doFity(prbot, pys);
    top = max(pts);
    bot = min(pbs);
    mid = max(pbs);
    left = max(pys);
    figure
    plot3(prtop(:,1),prtop(:,2), prtop(:,3), 'g+')
    hold on
    plot3(pxs, pys, pts, 'g')
    plot3(prbot(:,1), prbot(:,2), prbot(:,3), 'r+')
    plot3(pxs, pys, pbs, 'r')
    xs = linspace(xy(1,1), xy(end,1), res);
    ys = zeros(1,res);
    ts = doFit(xu, 2, xs);
    hi = max(ts(xs >= 797));
    ts(xs < 797) = hi;
    plot3(xu(:,1), xu(:,2), xu(:,3), 'r+')
    plot3(xs, ys, ts, 'r')
    bs = doFit(xl, 3, xs);
    lo = min(bs(xs >= 832));
    bs(xs < 832) = lo;
    plot3(xl(:,1), xl(:,2), xl(:,3), 'g+')
    plot3(xs, ys, bs, 'g')
    ss = doFit(xy, 2, xs);
    zs = ys + p66;
    plot3(xs, ss, zs, 'b')
    plot3(xy(:,1), xy(:,2), xy(:,3), 'b+')
    xru = getPoints(lr);
    xrl = getPoints(lR);
    xry = getPoints(lY);
    xry(:,2) = -xry(:,2);
    plot3(xru(:,1), xru(:,2), xru(:,3), 'r+')
    plot3(xrl(:,1), xrl(:,2), xrl(:,3), 'g+')
    plot3(xry(:,1), xry(:,2), xry(:,3), 'b+')
    xrs = linspace(xry(1,1), xry(end,1), res-1);
    yrs = zeros(1,res-1);
    trs = doFit(xru, 3, xrs);
    hi = max(trs(xrs <= 181));
    trs(xrs > 181) = hi;
    plot3(xrs, yrs, trs, 'r')
    brs = doFit(xrl, 3, xrs);
    lo = min(brs(xrs < 296));
    brs(xrs > 296) = lo;
    plot3(xrs, yrs, brs, 'g')
    srs = doFit(xry, 2, xrs);
    zrs = yrs + p66;
    plot3(xrs, srs, zrs, 'b')
    zx = zeros(1, res);
    xs = [xrs 500 780 xs];
    ts = [trs trs(end) trs(end) ts];
    bs = [brs brs(end) brs(end) bs];
    ss = [srs srs(end) srs(end) ss];
    str.xx = zeros(2*res,2*res);
    str.yy = zeros(2*res,2*res);
    str.zz = zeros(2*res,2*res);
    next = false;
    for ndx = 1:length(xs)
        x = xs(ndx);
        if x > 900
            oops = true;
        end
        up = ts(ndx);
        dn = bs(ndx);
        lft = ss(ndx);
        xm = p66;
        m = dn + (up-dn)*17/57 - p66;
        up = up - m;
        dn = dn - m;
        tpscl = (up - xm) / (top - mid);
        btscl = (xm - dn) / (mid - bot);
        lfscl = lft / left;
        nts = (pts - mid) * tpscl + xm;
        nbs = (pbs - mid) * btscl + xm;
        nys = pys * lfscl;
        nxs = zx + x;
        plot3(nxs, nys, nts, 'g')
        plot3(nxs, nys, nbs, 'r')
        str.xx(ndx,:) = [nxs nxs];
        str.yy(ndx,:) = [nys nys(end:-1:1)];
        str.zz(ndx,:) = [nts nbs(end:-1:1)];
        if x == 500
            bodProf.xx(1,:) =  str.xx(ndx,:);
            bodProf.yy(1,:) =  str.yy(ndx,:);
            bodProf.zz(1,:) =  str.zz(ndx,:);
            next = true;
        elseif next
            bodProf.xx(2,:) =  str.xx(ndx,:);
            bodProf.yy(2,:) =  str.yy(ndx,:);
            bodProf.zz(2,:) =  str.zz(ndx,:);
            next = false;
        end
    end 
    axis equal
    grid on
    xlabel('X - Forward')
    ylabel('Y - Left (Stbd)')
    zlabel('Z - Up')
    view(0,0)
end



function vec = getPoints(lab)
    global vecNdx
    global pt
    
    vec = [];
    found = false;
    for it = 1:length(vecNdx)
        ntry = vecNdx(it);
        if lab == ntry.name
            for ndx = 1:length(ntry.pNdx)
                vec = [vec; pt(ntry.pNdx(ndx),:)];
            end
            found = true;
            break;
        end
    end
    if ~found
        error(['no points for label "' lab '"'])
    end
end

function showSurf(tr)
    global surfImg
    [rows cols] = size(tr.xx);
    surf(tr.xx, tr.yy, tr.zz, surfImg(1:rows,1:cols,:))
    hold on
end

function showCanopy(tr,win)
    global surfImg
    [rows cols] = size(tr.xx);
    img = surfImg(1:rows,1:cols,:);
    for ndx = 1:5
        % find closest tr.xx index (col) across first row
        [tmpc, atc(ndx)] = min(abs(tr.xx(1,:)-win(ndx,1)));
        % find closest tr.yy down that column
        [tmpr, atr(ndx)] = min(abs(tr.yy(:,atc(ndx))'+win(ndx,2)));
    end
    atr(1) = atr(1) + 4;
    atr(3) = atr(3) - 2;
    atr(5) = atr(5) - 15;
    img(20:atr(1),atc(1):atc(2),:) = 0;
    img((rows-atr(1)):(end-20),atc(1):atc(2),:) = 0;
    img(1:atr(3),atc(3):atc(4),:) = 0;
    img((rows-atr(3)):end,atc(3):atc(4),:) = 0;
    dc = cols - atc(5);
    val = 15
    for col = atc(5):cols
        dlta = val - round((col-atc(5))*val/dc);
        img(1:(atr(5)+dlta-10),col,:) = 0;
        img(rows-(atr(5)+dlta-10):end,col,:) = 0;
        img((atr(5)+dlta):rows-(atr(5)+dlta),col,:) = 0;
    end
%    img(atr(5)-30:atr(5), atc(5):end,1) = 0;
    surf(tr.xx, tr.yy, tr.zz, img)
    hold on
end

function showBlack(tr)
    [rows cols] = size(tr.xx);
    surf(tr.xx, tr.yy, tr.zz, zeros(rows,cols,3))
    hold on
end

function showInlet(in, cowl)
    global resolution;
    global back;
    global surfImg

    C = in.c;
    r = in.r;
    res = resolution/8;
    th = linspace(0,pi,res);
    rv = [0 r];
    [tth rr] = meshgrid(th, rv);
    yy = C(2)-rr.*sin(tth);
    zz = C(3)-rr.*cos(tth);
    xx = C(1)+in.dx_dz*(zz - C(3)) - back;
    xx(3,:) = xx(2,:) + back;
    yy(3,:) = yy(2,:);
    zz(3,:) = zz(2,:);
    [r c] = size(xx);
    img = zeros(r, c, 3);
    surf(xx, yy, zz, img)
    cxx = cowl.xx;
    cyy = cowl.yy;
    czz = cowl.zz;
    [r c] = size(cxx);
%    cimg = zeros(r, c, 3)+240;
    surf(cxx, cyy, czz, surfImg(1:r,1:c,:))
    surf(cxx, -cyy, czz, surfImg(1:r,1:c,:))
    surf(xx, -yy, zz, img)
end



function addToNdx(lab, ndx)
    global vecNdx
    
    found = false;
    for it = 1:length(vecNdx)
        ntry = vecNdx(it);
        if lab == ntry.name
            ntry.pNdx = [ntry.pNdx ndx];
            vecNdx(it) = ntry;
            found = true;
            break;
        end
    end
    if ~found
        ntry.name = lab;
        ntry.pNdx = ndx;
        vecNdx = [vecNdx ntry];
    end
end


function storeData()
    global npts
    global pt
    global vecNdx
    global resolution
    
    fid = fopen('data_so_far.txt', 'w');
    fprintf(fid, 'np %d\n', npts);
    for ndx = 1:npts
        fprintf(fid,'pt %d %d %d\n', pt(ndx,1), pt(ndx,2), pt(ndx,3));
    end
    fprintf(fid,'nx %d\n', length(vecNdx));
    for ndx = 1:length(vecNdx)
        str = vecNdx(ndx);
        fprintf(fid,'nd %c ', str.name);
        for jndx = 1:length(str.pNdx)
            fprintf(fid, '%d ', str.pNdx(jndx));
        end
        fprintf(fid, '\n');
    end
    fclose(fid);
end


function recoverData() 
    global npts
    global pt
    global vecNdx
    
    fid = fopen('data_so_far.txt', 'r');
    npts = 0;
    pt = [];
    vecNdx = [];
    if fid ~= -1        
        str = fgetl(fid);
        npts = str2num(str(4:end));
        for ndx = 1:npts
            str = fgetl(fid);
            pt = [pt; str2num(str(4:end))]; 
        end
        str = fgetl(fid);
        nx = str2num(str(4:end));
        for ndx = 1:nx
            str = fgetl(fid);
            ntry.name = str(4);
            ntry.pNdx = str2num(str(6:end));
            vecNdx = [vecNdx ntry];
        end
        !copy data_so_far.txt backup_data.txt
    end
end

function redraw() 
    global npts
    global origpts
    global pt
    global plane
    global ht
    global wdth
    global xdiv
    global ydiv

    hold off
    imshow(plane)
    hold on
    myPlot([ydiv ydiv], [1 wdth], 'k')
    myPlot([1 ht], [xdiv xdiv],'k')
%    myPlot([xdiv wdth], [ydiv 1], 'k')
    for ndx = (origpts+1):npts
        plotPt(pt(ndx,:))
    end
end

function [vec, lab, OK] = getCoord()
    global xdiv
    global ydiv
    global halfTop
    global halfFront
    global ht
    global wdth
    global x
    global y
    global z
    
    btn = 1;
    vec = [];
    lab = char(27);
    while btn == 1
        [px, py, btn] = ginput(1);
        if btn ~= 27
            if px < xdiv
                if py < ydiv
                    % in plan view
                    x = px;
                    y = halfTop-py;
                    % draw guide lines
                    myPlot([1 ht],[px px],'r--')
                    lxr = xdiv + ydiv - py;
                    myPlot([py py], [1 lxr], 'r--')
                    myPlot([py ht], [lxr, lxr], 'r--')
                else
                    % in side view
                    x = px;
                    z = ht - py;
                    myPlot([1 ht], [px px], 'r--')
                    myPlot([py py], [1 wdth], 'r--')
                end
            else
                if py > ydiv
                    % on nose view
                    y = px - halfFront;
                    z = ht - py;
                    myPlot([1 wdth], [py py], 'r--')
                    lyr = ydiv + xdiv - px;
                    myPlot([lyr ht], [px px], 'r--')
                    myPlot([lyr lyr], [1, px], 'r--')
                end
            end
        end
        if(btn ~= 1 && btn ~= 27) 
            vec = [floor(x) floor(y) floor(z)];
            lab = char(btn);
            showPoint(vec);
        end
    end
    OK = btn ~= 27;
end

function myPlot(x, y, z)
    plot(y,x,z)
%     if length(y) == 1
%         fprintf('plot [%d,%d] as [%d,%d]\n', x, y, y, x)
%     end
end

function showPoint(vec)
    fprintf('[%5d, %5d, %5d]\n', vec(1), vec(2), vec(3));
end

function plotPt(vec)
    global halfTop
    global halfFront
    global ht
    
    % plot top  coordinate
    px = vec(1);
    py = halfTop - vec(2);
    myPlot(py, px, 'r+');
    % plot side coordinate
    pz = ht - vec(3);
    myPlot(pz, px, 'g+');
    % plot node coordinate
    py = halfFront + vec(2);
    myPlot(pz, py, 'b+');
end