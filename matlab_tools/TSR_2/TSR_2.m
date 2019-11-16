function TSR_2
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
    global wingRight
    global body
    global fin
    global coneLeft
    global coneRight
    global engLeft
    global engRight
    global intake
    global exhst
    global cowl
    global pipe
    global elevLeft
    global elevRight
    global canopy
    global window
    global bod_clr
    global thicknessToChord
    global field
    global surfImg
    global back
    global order
    
    %   a - canopy edge
    %   b - canopy top
    %   c - nose cone dimensions
    %   e - elevon
    %   E - engine
    %   f - fin
    %   i - engine top
    %   I - engine bottom
    %   j - engine side
    %   l - fuselage lower line
    %   L - engine lower
    %   p - inlet plate
    %   r - inlet lip dx
    %   s - fuselage side line
    %   S - engine side line
    %   t - wing tip
    %   u - fuselage upper line
    %   U - engine upper line
    %   w - wing
    %   1 - flat side upper
    %   2 - flat side lower
    %   3 - engine flat side upper
    %   4 - engine flat side lower
    
    field = {'xx','yy','zz'};   
    thicknessToChord = 0.08;
    resolution = 128;
    bod_clr = [240 240 240] ./ 255;
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
    elevLeft = [];
    elevRight = [];
    engLeft = [];
    engRight = [];
    canopy = [];
    vecNdx = [];
    if recompute, rs = '';, else,rs = 'don''t';, end 
    if newData, ds = '';, else,ds = 'don''t';, end 
    fprintf('%s recompute; %s input new data; resolution %d\n', ...
        rs, ds, resolution);
    ydiv = 357;
    halfTop = 179;
    xdiv = 749;
%     plane = imread('TSR_2.bmp');
%     [ht wdth ~] = size(plane)
    halfFront = 927;
    x = 0;
    y = 0;
    z = 0;
    recoverData()
    if recompute
        wingLeft = [];
        body = [];
        fin = [];
        elevLeft = [];
        engLeft = [];
        canopy = [];
    end
    quit = false;
    origpts = npts;
%     redraw()
%     while ~quit && newData
%         [vec, lab, OK] = getCoord();
%         if OK
%             npts = npts + 1;
%             pt = [pt; vec];
%             addToNdx(lab, npts)
%             redraw();
%         else
%             quit = true;
%         end
%     end
%     storeData()
%    figure
    if isempty(body)
        body  = doBody('c','u','l','s','1','2');
    end
    if isempty(fin)
        fin = doFin('f');
    end
    if isempty(elevLeft)
        [elevLeft, elevRight] = doElev('e');
    end
    if isempty(engLeft)
        [coneLeft, coneRight, intake, exhst, pipe, cowl, engLeft, engRight] = ...
            doEngine('E','i','I','j','p','U','L','S','3','4');
        
    end
    if isempty(wingLeft)
        [wingLeft, wingRight] = doWing('w','t');
    end
    if isempty(canopy)
        [canopy window] = doCanopy('a','b','W');
    end
    figure('units','normalized','outerposition',[0 0 1 1])
    save('TSR_2.mat')
    showData()
end

function showData() 
    global wingRight
    global wingLeft
    global elevLeft
    global elevRight
    global coneLeft
    global coneRight
    global engLeft
    global engRight
    global fin
    global body
    global canopy
    global window
    global intake
    global cowl
    global exhst
    global pipe
    
    set(gcf, 'color', [0.7,0.7,1])
    showSurf(wingRight)
    showSurf(wingLeft)
    showSurf(elevRight)
    showSurf(elevLeft)
    showSurf(coneRight)
    showSurf(coneLeft)
    showSurf(engRight)
    showSurf(engLeft)
    showSurf(fin)
    showSurf(body)
    showCanopy(canopy, window)
    showInlet(intake, cowl)
    showSurf(exhst)
    showBlack(pipe)
    showBlack(flipY(pipe))
    shading interp
    axis equal
    axis tight
    axis off
    xlabel('Forward')
    ylabel('Starboard')
    zlabel('Up')
    grid on
    lightangle(25,45)
    az = 20;
    el = 25;
    view(az, el)
    saveas(gcf,'../TSR_2.png')
%     az = 0;
%     global stop
%     stop = false;
%     set(gcf,'keypressfcn',@kpfcn)
%     while ~stop
%         az = az + 0.3;
%         el = 10 - 30*cosd(az/2);
%         view(az, el)
%         pause(0.03)
%     end
end

function kpfcn(obj,event)
    global stop
    ck=get(obj,'currentkey');
    stop = true;
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

function [can win] = doCanopy(ed, tp, W)
    global resolution
    
    res = resolution;
    edge = getPoints(ed);
    top = getPoints(tp);
    edge = edge(end:-1:1,:);
    top = top(end:-1:1,:);
    xs = linspace(top(1,1), top(end,1), res);
    ts = doFit(top, 3, xs);
    eys = doFit(edge, 2, xs);
    ezs = doFit(edge, 3, xs);
%     figure
%     plot3(edge(:,1), edge(:,2), edge(:,3), 'r+')
%     hold on
%     plot3(xs, eys, ezs, 'r')
%     plot3( top(:,1),  top(:,2),  top(:,3), 'g+')
%     yzs = zeros(1,res);
%     plot3( xs, yzs, ts, 'g')
    th = linspace(0, pi/2, res);
    xz = zeros(1,res);
    xx = zeros(res, res);
    yy = xx;
    zz = xx;
    for ndx = 1:length(xs)
        a = ts(ndx) - ezs(ndx);
        b = eys(ndx);
        x = xz + xs(ndx);
        y = b*cos(th);
        z = a*sin(th) + ezs(ndx);
%         plot3(x, y, z, 'k')
        xx(:, ndx) = x;
        yy(:, ndx) = y;
        zz(:, ndx) = z;
    end
    can.xx = [xx;xx];
    can.yy = [yy;-yy(end:-1:1,:)];
    can.zz = [zz;zz(end:-1:1,:)];
    win = getPoints(W);
%     surf(can.xx, can.yy, can.zz)
%     axis equal
%     grid on
%     view(90,0)
%     xlabel('X - Forward')
%     ylabel('Y - Left (Port)')
%     zlabel('Z - Up')
    
end


function [left, right, inlet, exhst, pipe, cowl, str, other] = doEngine(E, top, bot, side, ...
                                 pl, up, lo, sde, one, two)
    global resolution
    global back
    global order
    
    vec = getPoints(E);
    P1 = vec(1,:);
    P2 = vec(2,:);
    tip = vec(3,:);
    C = (P1 + P2)/2;
    r = (P1(3) - P2(3))/2;
    th = linspace(0, pi, resolution/2);
    x = [P1(1)-10 tip(1)];
    [right.xx tth] = meshgrid(x, th);
    right.yy = -r*sin(tth) + C(2);
    right.yy(:,2) = C(2);
    right.zz = r*cos(tth) + C(3);
    right.zz(:,2) = C(3);
    inTop = vec(4,:);
    inBot = vec(5,:);
    r = (inTop(3) - inBot(3))/2;
    front.yy = C(2) - r*sin(th);
    front.zz = C(3) + r*cos(th);
    dx = inTop(1) - inBot(1);
    dz = inTop(3) - inBot(3);
    front.xx = inBot(1) + dx * (front.zz - inBot(3)) / dz;
    % make exterior ring
    % rotate the outer profile curve about the x axis at C
    xv = [422 425 428 431 432];
    rv = [39.2 39 38 37 35] - 35 + r;
    [tth, cowl.xx] = meshgrid(th, xv);
    [~, rr] = meshgrid(th, rv);
    cowl.xx(1, :) = front.xx'-3;
    for ndx = 2:4
        cowl.xx(ndx,:) = cowl.xx(ndx-1,:)+3;
    end
    cowl.xx(5, :) = cowl.xx(4, :)+1;
    cowl.yy = -C(2) + rr.*sin(tth);
    cowl.zz = rr.*cos(tth) + C(3);
    inlet.c = C;
    inlet.r = r;
    inlet.dx_dz = dx/dz;
%    exhst = 0;
    left = flipY(right);
    plp = getPoints(pl);
    x = plp([1:end,1],1);
    z = plp([1:end,1],3);
    [plate.xx, plate.zz] = meshgrid(x, z);
    plate.yy = zeros(5,5) - plp(1,2);
 
% build the engine proper - based on fuselage model
    up = getPoints(up);
    dn = getPoints(lo);
    sd = getPoints(sde);
    sd(:,2) = -sd(:,2);
    tF = getPoints(one);
%     % prepend to tF first 6 pts of up, subtract 5 from their z
%     tF = [up(1:6,:); tF];
%     tF(1:6,3) = tF(1:6,3) - 5;
    bF = getPoints(two);
%     % prepend to bF first 6 pts of dn, add 5 to their z
%     bF = [dn(1:6,:); bF];
%     bF(1:6,3) = bF(1:6,3) + 5;
%     figure
    xs = linspace(dn(1,1),dn(end,1), resolution);
%     plot3(up(:,1), up(:,2), up(:,3),'b+')
    cf = polyfit(up(:,1), up(:,3), order);
    zus = polyval(cf, xs);
    yus = zeros(1,resolution);
%     hold on
%     plot3(xs, yus, zus, 'b')
%     plot3(dn(:,1), dn(:,2), dn(:,3),'r+')
    cf = polyfit(dn(:,1), dn(:,3), order);
    zds = polyval(cf, xs);
%     plot3(xs, yus, zds, 'm')
    level = mean(sd(:,3));
%     grid on
%     plot3(sd(:,1), sd(:,2), sd(:,3), 'g+')
    cf = polyfit(sd(:,1), sd(:,2), order);
    yss = polyval(cf, xs);
%     plot3(xs, yss, yus+level, 'g')
    sd(1,1) = min([sd(1,1) tF(1,1) bF(1,1)]);
    sd(end,1) = max([sd(end,1) tF(end,1) bF(end,1)]);
    tF(:,2) = interp1(sd(:,1), sd(:,2), tF(:,1));
    bF(:,2) = interp1(sd(:,1), sd(:,2), bF(:,1));
%     plot3(tF(:,1),tF(:,2),tF(:,3), 'c*')
    cf = polyfit(tF(:,1), tF(:,3), order);
    ztFs = polyval(cf, xs);
%     plot3(xs, yss, ztFs, 'c')
%     plot3(bF(:,1),bF(:,2),bF(:,3), 'c*')
    cf = polyfit(bF(:,1), bF(:,3), order);
    zbFs = polyval(cf, xs);
%     plot3(xs, yss, zbFs, 'c')
    tC = interp1(tF(:,1), tF(:,3), xs);
    good = ~isnan(tC);
    tCx = xs(good);
    tCin = [tCx(1) tCx(end)]
    bC = interp1(bF(:,1), bF(:,3), xs);
    good = ~isnan(bC);
    bCx = xs(good);
    bCin = [bCx(1) bCx(end)]
    % now, draw a sequence of rectangles, each vertical at xs
    %  top is the top level
    %  bot is bot level
    % left and right are the sides
    %
    res = resolution/2;
    th = linspace(0, pi/2, res/2);
    cth = cos(th);
    sth = sin(th);
    lxb = zeros(1,res);
    nx = length(find(xs < C(1,1)));
    str.xx = zeros(nx, res);
    str.yy = zeros(nx, res);
    str.zz = zeros(nx, res);
    
    max_off = C(2);
    init_off = 0;
    for ndx = 1:nx
        xf = xs(ndx);
        if xf < C(1) % don't redraw the cowl
            zt = zus(ndx);
            zb = zds(ndx);
            ys = yss(ndx);
            zfu = ztFs(ndx);
            zfl = zbFs(ndx);
            bt = zt - zfu;
            off = init_off + (max_off - init_off) * ndx / nx;
            a = ys+off;
            ztl = zfu + bt*cth;
            yl = -off + a*sth;
            bb = zfl - zb;
            zbl = zfl - bb*cth;
            lx = lxb + xf;
            ly = [yl yl(end:-1:1)];
            lz = [ztl zbl(end:-1:1)];
            if ndx == nx
                str.xx(ndx,:) = cowl.xx(1,:);
                str.yy(ndx,:) = cowl.yy(1,:);
                str.zz(ndx,:) = cowl.zz(1,:);
            else
                str.xx(ndx,:) = lx;
                str.yy(ndx,:) = ly;
                str.zz(ndx,:) = lz;
            end
%             plot3(str.xx(ndx,:), str.yy(ndx,:), str.zz(ndx,:), 'k')
        end
    end
%     surf(cowl.xx,cowl.yy,cowl.zz)
%     axis equal
%     grid on
%     xlabel('X - Forward')
%     ylabel('Y - Left (Port)')
%     zlabel('Z - Up')
    other = flipY(str);
    
    xx = [str.xx(1,:)   str.xx(1,end:-1:1)];
    yy = [str.yy(1,:) other.yy(1,end:-1:1)];
    zz = [str.zz(1,:)   str.zz(1,end:-1:1)];
    up = max(max(zz));
    dn = min(min(zz));
    m = (up + dn) / 2;
    lft = max(max(yy))/2;
    exhst.xx = [xx;(xx+5);(xx+5)];
    exhst.yy = [yy;yy;xx-xx];
    exhst.zz = [zz;zz;xx-xx + m];
    pipe = exhst;
    rad = (up - dn)/2.42;
    mxyy = max(max(yy));
    pipe.yy = lft + pipe.yy * rad / mxyy;
    pipe.zz = m + (pipe.zz - m) /1.2;
    pipe.xx(1,:) = pipe.xx(1,:) - 10;
end

function [left right] = doWing(w, t)
    global resolution
    
    vec = getPoints(w);
    left = getTrapz(vec, resolution);
    tip = getPoints(t);
    leftTip = getTrapz([tip; vec(2,:); vec(1,:)], resolution);
    left = vConcat(leftTip, left);
    left.zz(1,:) = left.zz(1,1);
    right = flipY(left);
end

function prof = makeProf(vec, b, f, res)
    global thicknessToChord
    global field
    
    P1 = vec(b,:);
    P2 = vec(f,:);
    if P1(2) ~= P2(2)
        error('out of plane')
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
    root = makeProf(vec, 1, 2, res/2);
    tip = makeProf(vec, 4, 3, res/2);
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
    vec = getPoints(f);
    sidewys = getTrapz(vec(:,[1 3 2]), resolution/2);
    fin.xx = sidewys.xx;
    fin.yy = sidewys.zz;
    fin.zz = sidewys.yy;
end

function [left right] = doElev(e)
    global resolution
    vec = getPoints(e);
    left = getTrapz(vec, resolution/2);
    right = flipY(left);
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

function str = doBody(conech, up, lo, side, one, two)
    global resolution
    global order
    
    vec = getPoints(conech);
    %  circle vertical at vec(1) x
    %  radius (vec(2)z - vec(1)z) / 2
    r = (vec(1,3) - vec(2,3)) / 2;
    %  center x = vec(1)x
    C(1) = vec(1,1);
    %  center y = 0
    C(2) = 0;
    %  center z (vec(2)z + vec(1)z) / 2
    C(3) = (vec(1,3) + vec(2,3))/2;
    % cone tip at vec(3)
    % cone axis slopes down from center to tip
    th = linspace(0,2*pi, resolution);
    [tth cone.xx] = meshgrid(th, [vec(1,1), vec(3,1)]);
    cone.yy = r.*sin(tth);
    right = max(max(cone.yy));
    cone.yy(2,:) = 0;
    cone.zz = C(3) + r.*cos(tth);
    cone.zz(2,:) = vec(3,3);
    
    up = getPoints(up);
    dn = getPoints(lo);
    sd = getPoints(side);
    sd(:,2) = -sd(:,2);
    tF = getPoints(one);
    % prepend to tF first 6 pts of up, subtract 5 from their z
    tF = [up(1:6,:); tF];
    tF(1:6,3) = tF(1:6,3) - 5;
    bF = getPoints(two);
    % prepend to bF first 6 pts of dn, add 5 to their z
    bF = [dn(1:6,:); bF];
    bF(1:6,3) = bF(1:6,3) + 5;
%     figure
    xs = linspace(dn(1,1),dn(end,1), resolution);
%     plot3(up(:,1), up(:,2), up(:,3),'b+')
    cf = polyfit(up(:,1), up(:,3), order);
    zus = polyval(cf, xs);
    yus = zeros(1,resolution);
%     hold on
%     plot3(xs, yus, zus, 'b')
%     plot3(dn(:,1), dn(:,2), dn(:,3),'r+')
    cf = polyfit(dn(:,1), dn(:,3), order);
    zds = polyval(cf, xs);
%     plot3(xs, yus, zds, 'm')
    level = mean(sd(:,3));
    A1 = [C(1), right, level];
    A2 = vec(3,:);
    sd = [sd; A1; A2]; 
%     plot3(sd(:,1), sd(:,2), sd(:,3), 'g+')
%     plot3([A1(1) A2(1)], [A1(2) A2(2)], [A1(3) A2(3)], 'rs')
    cf = polyfit(sd(:,1), sd(:,2), order);
    yss = polyval(cf, xs);
%     plot3(xs, yss, yus+level, 'g')
    tF(:,2) = interp1(sd(:,1), sd(:,2), tF(:,1));
    bF(:,2) = interp1(sd(:,1), sd(:,2), bF(:,1));
%     plot3(tF(:,1),tF(:,2),tF(:,3), 'c*')
    cf = polyfit(tF(:,1), tF(:,3), order*2);
    ztFs = polyval(cf, xs);
%     plot3(xs, yss, ztFs, 'c')
%     plot3(bF(:,1),bF(:,2),bF(:,3), 'c*')
    cf = polyfit(bF(:,1), bF(:,3), order*2);
    zbFs = polyval(cf, xs);
%     plot3(xs, yss, zbFs, 'c')
    tC = interp1(tF(:,1), tF(:,3), xs);
    good = ~isnan(tC);
    tCx = xs(good);
    tCin = [tCx(1) tCx(end)];
    bC = interp1(bF(:,1), bF(:,3), xs);
    good = ~isnan(bC);
    bCx = xs(good);
    bCin = [bCx(1) bCx(end)];
    % now, draw a sequence of rectangles, each vertical at xs
    %  top is the top level
    %  bot is bot level
    % left and right are the sides
    %
    res = resolution/2;
    th = linspace(0, pi/2, res/2);
    cth = cos(th);
    sth = sin(th);
    lxb = zeros(1,res);
    nx = length(find(xs < C(1,1)));
    str.xx = zeros(nx, res);
    str.yy = zeros(nx, res);
    str.zz = zeros(nx, res);
    
    for ndx = 1:nx
        xf = xs(ndx);
        if xf < C(1) % don't redraw the nose cone
            zt = zus(ndx);
            zb = zds(ndx);
            ys = yss(ndx);
            zfu = ztFs(ndx);
            zfl = zbFs(ndx);
            bt = zt - zfu;
            a = ys;
            ztl = zfu + bt*cth;
            yl = a*sth;
            bb = zfl - zb;
            zbl = zfl - bb*cth;
            lx = lxb + xf;
            ly = [yl yl(end:-1:1)];
            lz = [ztl zbl(end:-1:1)];
%             plot3(lx, ly, lz, 'k')
            str.xx(ndx,:) = lx;
            str.yy(ndx,:) = ly;
            str.zz(ndx,:) = lz;
        end
    end
    other = flipY(str);
    str = strHCat(str,other);
    size(str.xx)
    % flip the cone in x
    cone = flipX(cone);
    % make the cone back be at xs(nx), and make its yy and zz
    % match the last values of yy and zz for the plane
    cone.xx(2,:) = xs(nx);
    cone.yy(2,:) = str.yy(end,:);
    cone.zz(2,:) = str.zz(end,:);
    % append the cone to the back of str
    str = strVCat(str, cone);
%     showSurf(str)
%     axis equal
%     grid on
%     xlabel('X - Forward')
%     ylabel('Y - Left (Stbd)')
%     zlabel('Z - Up')
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