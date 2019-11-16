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
    global windows
    global bod_clr
    global thicknessToChord
    global field
    global surfImg
    global back
    global order
    global winImg
    
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
    
    !rm debug.log
    diary
    diary debug.log
    field = {'xx','yy','zz'};   
    thicknessToChord = 0.04;
    resolution = 128;
    bod_clr = [20 20 20] ./ 255;
    surfImg = zeros(resolution*5,resolution,3);
    for clr = 1:3
        surfImg(:,:,clr) = bod_clr(clr);
    end
    winImg = imread('windowImg.jpg');
%     imwrite(winImg,'windowImg.jpg');
    winImg = double(winImg)./255;
    back = 10;
    order = 4;
    recompute = true;
    newData = true;
    wingLeft = [];
%     wingRight = [];
    body = [];
    fin = [];
    engLeft = [];
%     engRight = [];
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
        [body windows] = doBody('s','S', 'x', 'X', 'y', 'r', 'R', 'Y', 'z', 'q', 'Q');
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
        [wingLeft] = doWing('w');
    end
%
%   Engine
%
    if isempty(engLeft)
        [engLeft, plug, fillet] = doEngine('c','i','I','j','F');
        
    end
    save SR_71.mat
    figure('units','normalized','outerposition',[0 0 1 1])
    showData()
    diary off
end

function showData() 
    global wingLeft
    global engLeft
    global plug
    global fin
    global body
    global fillet
%     global canopy
    global windows
%     global intake
%     global cowl
%     global exhst
%     global pipe
    
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
    showWindow(windows)
    showWindow(flipY(windows))
    showBlack(plug)
    showBlack(flipY(plug))
    shading interp
    axis equal
    axis tight
    axis off
    xlabel('Forward')
    ylabel('Starboard')
    zlabel('Up')
    grid on
    az = 20;
    el = 25;
    lightangle(30,80)
    lightangle(5,40)
    view(az, el)
    saveas(gcf,'../SR_71.png')
%     az = 25;
%     el = 35;
%     while true
%         az = az + 0.3;
%         el = 10 - 30*cosd(az/2);
%         view(az, el)
%         pause(0.03)
%     end
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

function cs = doFit(v, n, xs, ord)  
    cf = polyfit(v(:,1), v(:,n), ord);
    cs = polyval(cf, xs);
end

function cs = doFity(v, xs, ord)
    cf = polyfit(v(:,2), v(:,3), ord);
    cs = polyval(cf, xs);
end


function [left, plug, fillet] = doEngine(c, top, bot, side, F)
    global resolution
    global wingLeft
    global e_data
    global order
    
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
    sy = doFit(vec, 2, sx, order);
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

function left = doWing(w)
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

function [str windows] = doBody(prft, prfb, lx, lX, ly, lr, lR, lY, lZ, lq, lQ )
    global resolution
    global order
    global widex
    global widey
    global topx
    global topz
    global botx
    global botz
    global upts
    global upbs
    global upxs
    global upys
    global canx
    global canz
    global csdxs
    global csdys
    global uptopslpv
    global uptopslpy
    
    res = resolution/2;
    chine_z = 66;
    prt = getPoints(prft);
    prb = getPoints(prfb);
    xru = getPoints(lr);
    xrl = getPoints(lR);
    xry = getPoints(lY);
    xry(:,2) = -xry(:,2);
    xu = getPoints(lx);
    xl = getPoints(lX);
    xy = getPoints(ly);
    canopy = getPoints(lZ);
    cside = getPoints(lq);
    ctop = getPoints(lQ);
    [r c] = size(prt);
    figure
    px = prt(1,1);
    prtop(:,1) = [prt(:,1); prt(end:-1:1,1)]; 
    prtop(:,1) = px; 
    prtop(:,2) = [prt(:,2); -prt(end:-1:1,2)] ;
    prtop(:,3) = [prt(:,3); prt(end:-1:1,3)] ;
    plot3(prtop(:,1),prtop(:,2), prtop(:,3), 'r+-')
    hold on
    prbot(:,1) = [prb(:,1); prb(end:-1:1,1)] ;
    prbot(:,1) = px;
    prbot(:,2) = [prb(:,2); -prb(end:-1:1,2)] ;
    prbot(:,3) = [prb(:,3); prb(end:-1:1,3)] ;
    plot3(prbot(:,1), prbot(:,2), prbot(:,3), 'g+')
    pys = linspace(prtop(1,2), prtop(end,2), res);
    pxs = zeros(1, res) + px;
    pts = spline(prtop(:,2)', prtop(:,3)', pys);
    pbs = doFity(prbot, pys, order);
    plot3(pxs, pys, pts, 'r')
    plot3(pxs, pys, pbs, 'g')
    grid on
    view(-90, 0)
    %
    %   shape the nose
    plot3(xu(:,1), xu(:,2), xu(:,3), 'r*')
    hold on
    plot3(xl(:,1), xl(:,2), xl(:,3), 'g*')
    plot3(xy(:,1), xy(:,2), xy(:,3), 'b*')
    xts = linspace(xu(1,1), xu(end,1), res);
    ys = zeros(1,res);
    ts = doFit(xu, 3, xts, order);
    plot3(xts, ys, ts, 'r')
    xbs = linspace(xl(1,1), xl(end,1), res);
    bs = doFit(xl, 3, xbs, order);
    plot3(xbs, ys, bs, 'g')
    xss = linspace(xy(1,1), xy(end,1), res);
    ss = doFit(xy, 2, xss, order);
    plot3(xss, ss, ys + chine_z, 'b')
%   
%   shape the rear fuselage
    plot3(xru(:,1), xru(:,2), xru(:,3), 'r+')
    plot3(xrl(:,1), xrl(:,2), xrl(:,3), 'g+')
%    plot3(xry(:,1), xry(:,2), xry(:,3), 'b+')
%    xmin = min([xru(end,1) xrl(end,1) xry(end,1)]);
    xrs = linspace(xry(1,1), xry(end,1), res-1);
    yrs = zeros(1,res-1);
    trs = doFit(xru, 3, xrs, order);
    plot3(xrs, yrs, trs, 'r')
    brs = doFit(xrl, 3, xrs, order);
    plot3(xrs, yrs, brs, 'g')
    srs = doFit(xry, 2, xrs, order);
    plot3(xrs, srs, yrs + xru(1,3), 'b')
    % build the rear fuselage
    % normalize the profile so we can scale it by multiplying by the
    % width and height, anmd add the low point
%     plot3(pxs, pys, pts, 'r')
%     plot3(pxs, pys, pbs, 'g')
    %   pxs is a constant x location size res
    %   pys is uniform across the profile in y
    %   pts is the top profile
    %   pbs is the bottom profile
    ht = max(pts) - min(pbs);
    upts = (pts - min(pbs)) / ht;
    upbs = (pbs - min(pbs)) / ht;
    upxs = zeros(1,res);
    ymax = max(pys);
    upys = pys/ymax;
    uptopslpv = diff(upts) ./ diff(upys);
    uptopslpy = (upys(1:end-1) + upys(2:end))/2;
    % xrs are the rear x stations
    % xs are the front x stations
    %
    %   draw both surfaces
    %
    canx = canopy(:,1)';
    cany = canopy(:,2)';
    canz = canopy(:,3)';
    csdx = cside(:,1)';
    csdy = cside(:,2)';
    csdxs = linspace(csdx(1), csdx(end), 50);
    cf = polyfit(csdx, csdy, 4);
    csdys = polyval(cf, csdxs);
    cf = polyfit(csdx, cside(:,3)', 4);
    csdzs = polyval(cf, csdxs);
    ctpx = ctop(:,1)';
    ctpy = ctop(:,2)';
    ctpz = ctop(:,3)';
    plot3(ctpx, ctpy, ctpz, 'k+-')
    sxrs = xrs;
    sxrs(end) = xss(1) - 20;
    xrs(end) = canx(1);
    widex = [sxrs xss];
    widey = [srs ss];
    topx = [xrs xts];
    topz = [trs ts];
    botx = [xrs xbs];
    botz = [brs bs];
    xover = linspace(widex(1), widex(end), res*4);
    txx = zeros(length(xover), res);
    tyy = txx;
    tzz = txx;
    bxx = zeros(res*4, res);
    byy = bxx;
    bzz = bxx;
    filling = false;
    from = 0;
    to = 0;
    for ndx = 1:length(xover)
        x = xover(ndx);
        [y, t, b, fillIt] = doSlice(x);
        if fillIt && ~filling
            from = ndx;
            filling = true;
        elseif ~fillIt & filling
            to = ndx;
            filling = false;
        end
        txx(ndx,:) = x;
        tyy(ndx,:) = y;
        tzz(ndx,:) = t;
        bxx(ndx,:) = x;
        byy(ndx,:) = y;
        bzz(ndx,:) = b;
    end
    fy = tyy(from,:);
    ty = tyy(to,:);
    fz = tzz(from,:);
    tz = tzz(to,:);
    fx = zeros(1, length(fy)) + txx(from,1);
    tx = zeros(1, length(fy)) + txx(to,1);
    plot3(fx, fy, fz, 'r')
    plot3(tx, ty, tz, 'r')
    axis equal
    grid on
    xlabel('X - Forward')
    ylabel('Y - Left (Stbd)')
    zlabel('Z - Up')
    view(0, 0)
    figure
    xf = from:to;
    n = to - from;
    bv = (0:n)/n;
    for ndx = 1:length(y)
        delta = tzz(to, ndx) - tzz(from, ndx);
        dz = bv * delta;
        tzz(from:to, ndx) = tzz(from, ndx) + dz;
    end
    [txx, tyy, tzz, windows] = drawWindows(xover, txx, tyy, tzz);
    str.xx = [txx; bxx(end:-1:1,:)];
    str.yy = [tyy; byy(end:-1:1,:)];
    str.zz = [tzz; bzz(end:-1:1,:)];
end

function plotPts(str, clr)
    x = [str.x];
    y = [str.y];
    z = [str.z];
    plot3(x, y, z, clr)
    hold on
end


function [txx, tyy, tzz, wins] = drawWindows(xover, txx, tyy, tzz)
    global upxs
    xf = find(xover > 862 & xover < 912);
    from = xf(1);
    to = xf(end);
    px1 = 7;
    px2 = 11;
    px4 = 2;
    px6 = 4;
    px7 = 6;
    nxy3 = 41;
    nxy5 = 37;
    nxy6 = nxy5;
    nxy7 = nxy5 - 1;
    nx1 = xf(px1);
    nx2 = xf(px2);
    nx4 = xf(px4);
    nx6 = xf(px6);
    nx5 = nx4;
    nx7 = xf(px7);
    P1 = struct('x',txx(nx1,1), 'y',0, 'z',max(tzz(nx1,:)));
    P2 = struct('x',txx(nx2,1), 'y',0, 'z',max(tzz(nx2,:)));
    P3 = struct('x',P1.x, 'y',tyy(nx1,nxy3), 'z',tzz(nx1,nxy3));
    yps = tyy(nx4,nxy3-2:nxy3+2);
    zps = tzz(nx4,nxy3-2:nxy3+2);
    P4 = struct('x',txx(nx4,1), 'y',interp1(zps, yps, P3.z), 'z',P3.z);
    P3A = Pmean(P3, P4);
    P5 = struct('x',P4.x, 'y',tyy(nx5,nxy5), 'z',tzz(nx5,nxy5));
    P7 = struct('x',txx(nx7,1) + 2, 'y',tyy(nx7,nxy7), 'z',tzz(nx7,nxy7));
    P6 = Pmean(P5, P7);
    plotPts([P1 P2 P3 P3A P4 P5 P6 P7 P1],'g*-');
%     % straighten the line from P12 to P3:
%     %  change tzz(nx1,33:40) and the mirror image, tzz(nx1,32:-1:24)
%     dy = tyy(nx1,nxy3);
%     zztop = tzz(nx1, 33);
%     dz = tzz(nx1,nxy3) - zztop;
%     for ndx = 33:40
%         yv = tyy(nx1, ndx);
%         tzz(nx1, ndx) = zztop - 0.2 + dz * yv / dy;
%         tzz(nx1, 65 - ndx) = tzz(nx1, ndx);
%     end
    % attach the top blue curve to the line P1-P7
    dx = P7.x - P1.x;
    dy = P7.y - P1.y;
    dz = P7.z - P1.z;    
    for ndx = 33:35
        ly = tyy(nx1,ndx);
        txx(nx1,ndx) = P1.x + dx * ly / dy;
        tzz(nx1,ndx) = P1.z + dz * ly / dy;
        txx(nx1,65-ndx) = txx(nx1,ndx);
        tzz(nx1,65-ndx) = tzz(nx1,ndx);
        plot3([txx(nx1,65-ndx) txx(nx1,ndx)], ...
              [tyy(nx1,65-ndx) tyy(nx1,ndx)], ...
              [tzz(nx1,65-ndx) tzz(nx1,ndx)], 'ks');
    end
    top1 = [P5 P6 P7];
    bot1 = [P4 P3];
    top2 = [P7 P1];
    bot2 = [P3 P2];
    w1 = mkWin(top1, bot1, 50, 60);
    w2 = mkWin(top2, bot2, 50, 40);
    toprow = [top1 P1];
    botrow = [bot1 P2];
    backcol = [P5 P4];
    pxf = find(xover > 885 & xover < 912);
    pfrom = pxf(1);
    pto = pxf(end);
    xndx = pfrom:pto;
    yndx = 44:-1:32;
    noseSurf.xx = txx(xndx, yndx);
    noseSurf.yy = tyy(xndx, yndx);
    noseSurf.zz = tzz(xndx, yndx);
    for row = 40:-1:1
        WinBelowSurf = true;
        for col = 1:50
            x = w2.xx(row,col);
            y = w2.yy(row,col);
            z = w2.zz(row,col);
            % find the z value of the window at each point
            zv = myinterp2(noseSurf, x, y);
%             fprintf('(nose) consider [%0.1f, %0.1f, %0.1f]; zv = %0.1f -- ', ...
%                         x, y, z, zv)
            if ~isnan(zv)
                if z >= zv && WinBelowSurf
                    % move that coordinate to intersection pt
                    WinBelowSurf = false;
                    w2.zz(row,col) = zv;
                    plot3(x, y, zv, 'ks');
%                     fprintf('move to zv');
                elseif WinBelowSurf
                    w2.zz(row,col) = NaN;
%                     fprintf('set zz to NaN');
                    plot3(x, y, z, 'k.');
                end              
%             else
%                 error('surface not big enough')
            end
%             fprintf('\n')
        end
    end
    wins = strVCat(w1, w2);
    [r,c] = size(wins.xx);
    pr = r*c;
    resetOffBack = false;
    offBack = true;
    for ndx = 1:length(xf)
        pt = xf(ndx);
        yplus = find(tyy(pt,:) > 0 );
        offTop = true;
        for ypnx = 1:length(yplus)
            yp = yplus(ypnx);
            x = txx(pt, yp);
            y = tyy(pt, yp);
            % find the z value of the window at each point
%             fprintf('consider [%0.1f, %0.1f, %0.1f] -- ', ...
%                         x, y, tzz(pt, yp))
            zv = myinterp2(wins, x, y);
            % check back edge
            if offBack && ~isnan(zv)
                resetOffBack = true;
                % move this point's x and z to window back edge
                txx(pt,yp) = interp1([backcol.y], [backcol.x], y);
                tzz(pt,yp) = interp1([backcol.y], [backcol.z], y);
                txx(pt, 65 - yp) = txx(pt, yp); 
                tzz(pt, 65 - yp) = tzz(pt, yp); 
%                 fprintf(' moved back point to [%0.1f, %0.1f, %0.1f\n', ...
%                     txx(pt,yp), y, tzz(pt, yp))
                plot3([txx(pt,yp) txx(pt,yp)], [tyy(pt, yp) tyy(pt, 65 - yp)], ...
                    [tzz(pt, yp) tzz(pt, 65 - yp)], 'c*')
            end
            % tzz(pt, yp) is the z value of the surface at that point
            if ~offBack && offTop && ~isnan(zv) && x < 884
                % just moved onto the surface
                % Move this point's y and z to the window top
                tyy(pt, yp) = interp1([toprow.x], [toprow.y], x);
                tzz(pt, yp) = interp1([toprow.x], [toprow.z], x);
                tyy(pt, 65 - yp) = -tyy(pt, yp); 
                tzz(pt, 65 - yp) = tzz(pt, yp); 
%                 fprintf(' moved point to [%0.1f, %0.1f, %0.1f\n', ...
%                     x, tyy(pt, yp), tzz(pt, yp))
                plot3([x x], [tyy(pt, yp) tyy(pt, 65 - yp)], ...
                    [tzz(pt, yp) tzz(pt, 65 - yp)], 'r*')
                offTop = false;
            elseif ~offBack && ~offTop && ~isnan(zv)
                tyy(pt, yp) = NaN;
                tzz(pt, yp) = NaN;
                tyy(pt, 65 - yp) = NaN; 
                tzz(pt, 65 - yp) = NaN; 
%                 fprintf(' made point NaN\n')
            elseif ~offBack && ~offTop && isnan(zv)  && x < 886
                % fell off the bottom
                % Move this point's y and z to the window bottom
                tyy(pt, yp) = interp1([botrow.x], [botrow.y], x);
                tzz(pt, yp) = interp1([botrow.x], [botrow.z], x);
                tyy(pt, 65 - yp) = -tyy(pt, yp); 
                tzz(pt, 65 - yp) = tzz(pt, yp); 
%                 fprintf(' moved point to [%0.1f, %0.1f, %0.1f\n', ...
%                     x, tyy(pt, yp), tzz(pt, yp))
                plot3([x x], [tyy(pt, yp) tyy(pt, 65 - yp)], ...
                    [tzz(pt, yp) tzz(pt, 65 - yp)], 'k*')
                offTop = true;
            else
%                 fprintf('\n');
            end
        end
        if resetOffBack
            offBack = false;
        end
    end

    for ndx = 1:length(xf)
        pt = xf(ndx);
        x = txx(pt,1);
        y = tyy(pt,:);
        t = tzz(pt,:);
        plot3(upxs+x, y, t);
        hold on
    end
    for ndx = 1:length(y)
        plot3(xover(from:to), tyy(from:to,ndx), tzz(from:to,ndx));
    end
    axis equal
    grid on
    xlabel('X - Forward')
    ylabel('Y - Left (Stbd)')
    zlabel('Z - Up')
    view(90, 0)
end


function A = Pmean(B, C)
    A.x = (B.x + C.x)/2;
    A.y = (B.y + C.y)/2;
    A.z = (B.z + C.z)/2;
end


function z = myinterp2(w, x, y) 
    z = NaN;
    xx = w.xx;
    yy = w.yy;
    zz = w.zz;
    [rows, cols] = size(xx);
    % find x values
    found = false;
    if x >= xx(1,1)
        for xn = 2:rows
            if x <= xx(xn,1)
                found = true;
                break;
            end
        end
        if found
            xp = xn-1;
            xf = (x - xx(xp,1)) / (xx(xn,1) - xx(xp,1));
            found = false;
            if y <= yy(xp,1)
                for yn = 2:cols
                    if y >= yy(xp,yn)
                        found = true;
                        break;
                    end
                end
                if found
                    yp = yn-1;
                    yf = (y - yy(xp,yp)) / (yy(xp,yn) - yy(xp,yp));
                    dz1 = zz(xn,yp) - zz(xp,yp);
                    dz2 = zz(xn,yn) - zz(xp,yn);
                    z1 = zz(xp,yp) + xf*dz1;
                    z2 = zz(xp,yn) + xf*dz2;
                    z = z1 + yf * (z2 - z1);              
                end
            end
        end
    end
end

function win = mkWin(stop, sbot, NV, NH) 
    topX = [stop.x];
    topY = [stop.y];
    topZ = [stop.z];
    xts = linspace(topX(1), topX(end), NH);
    yts = interp1(topX, topY, xts);
    zts = interp1(topX, topZ, xts);
    botX = [sbot.x];
    botY = [sbot.y];
    botZ = [sbot.z];
    xbs = linspace(botX(1), botX(end), NH);
    ybs = interp1(botX, botY, xbs);
    zbs = interp1(botX, botZ, xbs);
    xx = zeros(NH, NV);
    yy = xx;
    zz = yy;
    for row = 1:NH
        zv = linspace(zbs(row), zts(row), NV);
        xx(row,:) = interp1([zbs(row), zts(row)], [xbs(row), xts(row)], zv);
        yy(row,:) = interp1([zbs(row), zts(row)], [ybs(row), yts(row)], zv);
        zz(row,:) = zv;
    end
    mesh(xx, yy, zz)
    win.xx = xx;
    win.yy = yy;
    win.zz = zz;
end

function [y t b fillIt] = doSlice(x)
    global widex
    global widey
    global topx
    global topz
    global botx
    global botz
    global upts
    global upbs
    global upxs
    global upys
    global canx
    global canz
    global csdxs
    global csdys
    global uptopslpv
    global uptopslpy
    
    w = interp1(widex, widey, x);
    ztop = interp1(topx, topz, x);
    zbot = interp1(botx, botz, x);
    b = upbs*(ztop-zbot) + zbot;
    t = upts*(ztop-zbot) + zbot;
    y = upys*w;
    if x > canx(1) && x < canx(end)
        ct = interp1(canx, canz, x);
        lv = min(t);
        % get canopy side width
        ly = interp1(csdxs, csdys, x);
        % find the top's z value
        lz = interp1(y, t, ly);
        ptopslpv = uptopslpv * (ztop-zbot) / w;
        ptopslpy = uptopslpy * w;
        m = interp1(ptopslpy, ptopslpv, ly);
        % draw a line with that slope from the y intercept
        % of the side line with the z value of the existing curve
        % to its intercept with y = 0
        % radius r = (c-t) cos th / (1 - cos th)
        % c is the intercept of the line with y=0
        % t is the top of the cockit (ct)
        % tan th = slope, m
        % sin(x)^2 + cos(x)^2 = 1;
        % tan(x)^2 + 1 = 1/cos(x)^2;
        % cos(x) = sqrt(1/(1+tan(x)^2))
        lc = lz - m*ly;
        cth = sqrt(1/(1 + m^2));
        cmt = lc - ct;
        asl = atan(m); 
        if cmt > 0
            r = cmt * cth / (1 - cth);
            ccz = ct - r;
            th = linspace(0.51*pi, 0.5*pi - asl, 25);
            vx = zeros(1,200) + x;
%            plot3(vx, -r*cos(th), r*sin(th)+ccz, 'k')
            resty = y(y >= ly);
            restz = t(y >= ly);
            crvy = [ -r*cos(th), resty ];
            crvy = [ -crvy(end:-1:1), crvy];
            crvz = [ r*sin(th)+ccz, restz ];
            crvz = [ crvz(end:-1:1), crvz];
            crvx = vx(1:length(crvy));
%            plot3(crvx, crvy, crvz, 'r')
            t = interp1(crvy, crvz, y);
        end
    end
    if x >= 773 & x < 799
        clr = 'k';
        fillIt = true;
    else
        clr = 'c';
        fillIt = false;
    end
    plot3(upxs+x, y, t, clr);
    hold on
    plot3(upxs+x, y, b, 'm');
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


function showBlack(tr)
    [rows cols] = size(tr.xx);
    surf(tr.xx, tr.yy, tr.zz, zeros(rows,cols,3))
    hold on
end


function showWindow(tr)
    global winImg
    [rows cols ~] = size(tr.xx);
%     winImg = ones(rows, cols, 3) * 0.81;
%     winImg(:,:,3) = 16/256;
    s1 = surf(tr.xx, tr.yy, tr.zz, winImg)
%    set(s1, 'FaceAlpha', 0.2)
    hold on
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