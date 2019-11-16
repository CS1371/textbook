function F22
    clear
    clc
    close all
    
    global xdiv
    global ydiv
    global halfTop
    global halfFront
    global origpts
    global ht
    global wdth
    global x
    global y
    global z
    global npts
    global pt
    global vecNdx
    global plane
    global resolution
    global fuseTop
    global fuseBot
    global wingLeft
    global wingRight
    global finLeft
    global finRight
    global elevLeft
    global elevRight
    global canopy
    global pilot
    global black
    global exhaust
    global debug
    
    resolution = 256;
    recompute = true;
    newData = true;
    wingLeft = [];
    wingRight = [];
    fuseTop = [];
    finLeft = [];
    finRight = [];
    elevLeft = [];
    elevRight = [];
    canopy = [];
    black = [];
    exhaust = [];
    vecNdx = [];
    debug = fopen('debug.log','w');
    img = imread('F-22.jpg');
    imshow(img)
    figure
    img = imread('F-22_rear.jpg');
    imshow(img)
    figure
    if recompute, rs = '';, else,rs = 'don''t';, end 
    if newData, ds = '';, else,ds = 'don''t';, end 
    fprintf('%s recompute; %s input new data; resolution %d\n', ...
        rs, ds, resolution);
    ydiv = 810;
    halfTop = floor(ydiv/2);
    xdiv = 1134;
    plane = imread('F22_plans.jpg');
    [ht wdth junk] = size(plane);
    halfFront = xdiv + floor((wdth - xdiv)/2);
    x = 0;
    y = 0;
    z = 0;
    recoverData()
    if recompute
        wingLeft = [];
        fuseTop = [];
        finLeft = [];
        elevLeft = [];
        canopy = [];
        black = [];
        exhaust = [];
    end
    if newData
        origpts = npts;
        quit = false;
        redraw()
        while ~quit && newData
            [vec lab OK] = getCoord();
            if OK
                npts = npts + 1;
                pt = [pt; vec];
                addToNdx(lab, npts)
                redraw();
            else
                quit = true;
            end
        end
    end
    storeData()
    save('F_22.mat')
    if isempty(wingLeft)
        [wingLeft, wingRight] = wing('t','l','f', 'p');
    end
    if isempty(canopy)
        [pilot, canopy] = doCanopy('e','u','v','w','x');
    end
    if isempty(fuseTop)
        [fuseTop, fuseBot] = fuselage('b', 'c', 'C', 'd', 'i', 'I', 'P', 'q', ...
            'r', 'S', 'Y', 'z', '1', '2');
    end
    if isempty(finLeft)
        [finLeft, finRight] = fin('j','p');
    end
    if isempty(elevLeft)
        [elevLeft, elevRight] = elevon('k','m','p');
    end
    if isempty(black)
        black = doIntake('I');
    end
    if isempty(exhaust)
        exhaust = doExhaust('X');
    end
    showData()
end


%%%%%%%%%%%%%%%%
%
%   SHOW DATA
%
function showData() 
    global wingLeft
    global wingRight
    global finLeft
    global finRight
    global elevLeft
    global elevRight
    global exhaust
    global canopy
    global pilot
    global black
    figure('units','normalized','outerposition',[0 0 1 1])
%    showFuselage()
    showSurf(wingLeft);
    showSurf(wingRight);
    showSurf(finLeft);
    showSurf(finRight);
    showSurf(elevLeft);
    showSurf(elevRight);
    showSurf(exhaust);
    showSurf(pilot);
    showSurf(black);
    s1 = showSurf(canopy);
    set(s1, 'FaceAlpha', 0.5)
    material dull
    set(gcf, 'color', [0.7,0.7,1])
    shading interp
    axis equal
    axis tight
    axis off
    grid on
    xlabel('X - forward')
    ylabel('Y - left')
    zlabel('Z - up')
    showFuselage()
    az = 20;
    el = 25;
    lightangle(5,40)
    view(az, el)
    saveas(gcf,'../F_22.png')
%     global stop
%     stop = true; %false;
%     set(gcf,'keypressfcn',@kpfcn)
%     az = 180;
%     while ~stop
%         az = az - 0.3;
%         el = 10 - 30*cosd(az/2);
%         view(az, el)
%         pause(0.03)
%     end
end

%%%%%%%%%%%%%%%%
%
%   SHOW FUSELAGE
%
function showFuselage() 
    global fuseTop
    global fuseBot
    global rim
    global intake
    
%     mesh(fuseTop.xx, fuseTop.yy, fuseTop.zz)
%     hold on
%     mesh(fuseBot.xx, fuseBot.yy, fuseBot.zz)
    showSurf(fuseTop)
    hold on
    showSurf(fuseBot)
%     plot3(rim.x, rim.y, rim.z, 'r')
%     plot3(intake.x, intake.y, intake.z, 'c')
%     plot3(intake.x, -intake.y, intake.z, 'c')
end

%%%%%%%%%%%%%%%%
%
%   CANOPY
%
function [pilot canopy] = doCanopy(top, riml, midProf, frntProf, sideProf)
    global resolution
    global canTop

    [ctx cty ctz] = transPts(top);
    % compute top profile
    % linear from P1 to P4
    % S4 = P1 - P4
    % linear from P8 to Pend
    % S8 = P8 - Pend
    % cubic curve through P4, P8 with slopes S4, S8
    %    ax^3 + bx^2 + cx + d = y [at P4 and P8]
    %    3ax^2 + 2bx + c = S  [P4 S4 and P8 S8]
    S4 = (ctz(1) - ctz(4))/(ctx(1) - ctx(4));
    S8 = (ctz(8) - ctz(end))/(ctx(8) - ctx(end));
    x4 = ctx(4);
    x8 = ctx(8);
    y4 = ctz(4);
    y8 = ctz(8);
    A = [x4.^3   x4.^2 x4  1
         x8.^3   x8.^2 x8  1
         3*x4.^2 2*x4   1  0
         3*x8.^2 2*x8   1  0];
    B = [y4 y8 S4 S8]';
    cf = A\B;
    xv = linspace(x4, x8, 10);
    yv = polyval(cf, xv);
    ctx = [ ctx(1) xv ctx(end) ];
    ctz = [ ctz(1) yv ctz(end) ];
    cty = zeros(1, length(ctx));
    canTop = struct('x', ctx, 'y', cty, 'z', ctz)
    rim = getPoints(riml);
    midP = getPoints(midProf);
    omidP = midP(end:-1:1,:);
    omidP(:,2) = -omidP(:,2);
    frntP = getPoints(frntProf);
    ofrntP = frntP(end:-1:1,:);
    ofrntP(:,2) = -ofrntP(:,2);
%    sideP = getPoints(sideProf);
    midP = [omidP; midP]; 
    frntP = [ofrntP; frntP]; 
    rimYCoeff = polyfit(rim(:,1), rim(:,2), 2);
%    sideZCoeff = polyfit(sideP(:,1), sideP(:,3), 3); 
    xfrom = ctx(end);
    xto = ctx(1);
    x = linspace(xfrom, xto, resolution);
    zv = interp1(ctx, ctz, x);
    [ht where] = max(zv);
    xx = zeros(resolution, resolution);
    yy = xx;
    zz = xx;
    clr(:,:,1) = ones(resolution,resolution) * 0.5;
    clr(:,:,2) = ones(resolution,resolution) * 0.5;
    clr(:,:,3) = zeros(resolution,resolution);
    for ndx = 1:resolution
        xv = x(ndx);
        rY = polyval(rimYCoeff, xv);
        rZ = spline(rim(:,1), rim(:,3), xv);
        cZ = zv(ndx);
        y = linspace(rY, -rY, resolution);
        xx(ndx, :) = xv * ones(1, resolution);
        yy(ndx, :) = linspace(rY, -rY, resolution);
        zz(ndx, :) = (rZ - cZ) .* (y / rY) .^ 2 + cZ;
    end
    canopy.xx = xx;
    canopy.yy = yy;
    canopy.zz = zz;
    canopy.clr = clr;
%     surf(canopy.xx,canopy.yy,canopy.zz, canopy.clr ) 
%     shading interp
    [xx yy zz] = sphere(resolution/2);
    [r c] = size(xx);
    headSize = 15;
    pilot.xx = xx*headSize + x(where) + 20;
    pilot.yy = yy*headSize;
    pilot.zz = zz*headSize + ht - 12 - headSize;
    pilot.clr = ones(r, c, 3);
end

%%%%%%%%%%%%%%%%
%
%   ELEVON
%
function [left right] = elevon(trl, ld, p)
    global resolution
    
    res = resolution/4
    [prfZ x] = getZProfile(p);
    prf = prfZ(1:4:end)';
    tr = getPoints(trl);
    le = getPoints(ld);
    trly = tr(:, 2);
    trlx = tr(:, 1);
    ley =  le(:, 2);
    lex =  le(:, 1);
    zval = mean([tr(:,3)' le(:,3)']);
    y = linspace(ley(1),ley(2), res);
    xx = zeros(res, res);
    yy = xx;
    uzz = xx;
    lzz = xx;
    for yn = 1:res
        yv = y(yn);
        tr = interp1(trly, trlx, yv);
        le = interp1(ley, lex, yv);
        yy(yn, :) = ones(1,res) * yv;
        xx(yn, :) = linspace(tr, le, res);
        scale = (le - tr) / (x(end) - x(1));
        uzz(yn, :) = zval + prf * scale;
        lzz(yn, :) = zval - prf * scale;
    end
    left.xx = [ xx, xx(end:-1:1,:)];
    left.yy = [ yy, yy(end:-1:1,:)];
    left.zz = [uzz,lzz(end:-1:1,:)];
    left.clr = ones(res, res*2, 3) * 0.7;
    right = left;
    right.yy = -left.yy;
end

%%%%%%%%%%%%%%%%
%
%   EXHAUST
%
function ex = doExhaust(Xch)
    global resolution
    global topexprf
    global botexprf
    global backspots
    
    res = resolution/4;
    % top data
    frxx = topexprf.xx;
    tfrxx = [frxx(1) frxx ];
    frxy = topexprf.yy;
    tfrxy = [0 frxy];
    frxz = topexprf.zz;
    frxz(frxy < 10) = frxz(frxy < 10) - 3;
    tfrxz = [frxz(1) frxz ];
    [bkxx bkxy bkxz] = transPts(Xch);
    tbkxx = [bkxx(1) bkxx];
    tbkxy = [0 bkxy];
    tbkxz = [bkxz(1) bkxz];
    
    % bottom data
    frxx = botexprf.xx;
    bfrxx = [frxx(1) frxx ];
    frxy = botexprf.yy;
    bfrxy = [0 frxy];
    frxz = botexprf.zz;
    bfrxz = [frxz(1) frxz ];
    yv = linspace(tfrxy(1), tfrxy(end), res);
    extxx = zeros(2, res);
    extxy = extxx;
    extxz = extxx;
    exbxx = extxx;
    exbxy = extxx;
    exbxz = extxx;
    for ndx = 1:length(yv)
        y = yv(ndx);
        % top mesh
        yp = y;
        if yp > tfrxy(end), yp = tfrxy(end); end
        extxx(1,ndx) = interp1(tfrxy, tfrxx, yp);
        extxx(2,ndx) = interp1(tbkxy, tbkxx, yp);
        extxy(1:2,ndx) = y;
        extxz(1,ndx) = interp1(tfrxy, tfrxz, yp);
        zv(1) = extxz(1,ndx);
        zv(2) = backspots.zz(2);
        xv(1) = extxx(1,ndx);
        xv(2) = backspots.xx(2);
        extxz(2,ndx) = interp1(xv, zv, extxx(2,ndx));
        % bottom mesh
        yp = y;
        if yp > bfrxy(end), yp = bfrxy(end); end
        exbxx(1,ndx) = interp1(bfrxy, bfrxx, yp);
        exbxx(2,ndx) = interp1(tbkxy, tbkxx, yp);
        exbxy(1:2,ndx) = y;
        exbxz(1,ndx) = interp1(bfrxy, bfrxz, yp);
        zv(1) = exbxz(1,ndx);
        zv(2) = backspots.zz(2);
        xv(1) = exbxx(1,ndx);
        xv(2) = backspots.xx(2);
        exbxz(2,ndx) = interp1(xv, zv, exbxx(2,ndx));
    end
    alltopxx = [extxx(:,end:-1:1) extxx];
    alltopyy = [-extxy(:,end:-1:1) extxy];
    alltopzz = [extxz(:,end:-1:1) extxz];
    allbotxx = [exbxx(:,end:-1:1) exbxx];
    allbotyy = [-exbxy(:,end:-1:1) exbxy];
    allbotzz = [exbxz(:,end:-1:1) exbxz];
    ex.xx = [alltopxx([2 1], :); allbotxx];
    ex.yy = [alltopyy([2 1], :); allbotyy];
    ex.zz = [alltopzz([2 1], :); allbotzz];
    ex.clr = uint8(zeros(4,2*res));
%     %%
%     % diagnostic plot
%     figure
%     plot3(tfrxx, tfrxy, tfrxz, 'r');
%     hold on
%     plot3(bfrxx, bfrxy, bfrxz, 'g');
%     plot3(tbkxx, tbkxy, tbkxz, 'r');
%     plot3(backspots.xx, backspots.yy, backspots.zz, 'k+')
%     mesh(ex.xx, ex.yy, ex.zz)
% %    mesh(allbotxx, allbotyy, allbotzz)
%     axis equal
%     grid on
%     hidden off
%     xlabel('X - FORWARD')
%     ylabel('Y - TO PORT')
%     zlabel('Z - UP')
end

%%%%%%%%%%%%%%%%
%
%   FIN
%
function [left right] = fin(jch, p)
    global resolution
    
    [prfZ x] = getZProfile(p);
    c = getPoints(jch);
    dy = (c(4,2) - c(3,2) + c(2,2) - c(1,2))/2;
    dz = (c(4,3) - c(3,3) + c(2,3) - c(1,3))/2;
    zoff = (c(1,3)+c(3,3))/2 - 5;
    yoff = c(1,2);
    c(:,2) = c(:,2) - yoff;
    c(:,3) = c(:,3) - zoff;
    c([1 3],[2 3]) = 0;
    rad = atan2(-dz, dy);
    A = [1    0        0
         0 cos(rad) -sin(rad)
         0 sin(rad) cos(rad)];
    nc = (A * c')';
    trly = [nc(1,2) nc(2,2)];
    trlx = [nc(1,1) nc(2,1)];
    ley =  [nc(4,2) nc(3,2)];
    lex =  [nc(4,1) nc(3,1)];
    y = linspace(nc(1,2),nc(2,2), resolution);
    xx = zeros(resolution, resolution);
    yy = xx;
    uzz = xx;
    lzz = xx;
    for yn = 1:resolution
        yv = y(yn);
        tr = interp1(trly, trlx, yv);
        le = interp1(ley, lex, yv);
        yy(yn, :) = ones(1,resolution) * yv;
        xx(yn, :) = linspace(tr, le, resolution);
        scale = (le - tr) / (x(end) - x(1));
        uzz(yn, :) = prfZ' * scale;
        lzz(yn, :) = -prfZ' * scale;
    end
    A(2,3) = sin(rad);
    A(3,2) = -sin(rad);
    ln = 2*resolution*resolution;
    ar(1,:) = reshape([ xx, xx(end:-1:1,:)], 1, ln);
    ar(2,:) = reshape([ yy, yy(end:-1:1,:)], 1, ln);
    ar(3,:) = reshape([uzz,lzz(end:-1:1,:)], 1, ln);
    arr = A * ar;
    left.xx = reshape(arr(1,:), resolution, 2*resolution);
    left.yy = yoff + reshape(arr(2,:), resolution, 2*resolution);
    left.zz = zoff + reshape(arr(3,:), resolution, 2*resolution);
    left.clr = ones(resolution, resolution*2, 3) * 0.7;
    right = left;
    right.yy = -left.yy;
end

%%%%%%%%%%%%%%%%
%
%   FUSELAGE
%
function [top, bot] = fuselage(bch, cch, Cch, dch, ich, Ich, Pch, qch, ...
                               rch, Sch, Ych, zch, ch1, ch2)
    global resolution  
    global rim
    global canopy
    global txx
    global tyy
    global tzz
    global widerWidth
    global intake
    global blkx
    global debug
    global topexprf
    global botexprf
    global backspots
    
    res = resolution
    addWidth = 50;
    blkx = 500;
    [chx chy chz] = transPts(cch);
    [prx pry prz] = transPts(rch);
    [p1x p1y p1z] = transPts(ch1);
    [p2x p2y p2z] = transPts(ch2);
    [spx spy spz] = transPts(zch);
    [bsx bsy bsz] = transPts(bch);
    [rimx rimy rimz] = transPts(Cch);
    [dbx dby dbz] = transPts(dch);
    [ibx iby ibz] = transPts(ich);
    [Ibx Iby Ibz] = transPts(Ich);
    [qby qbz qbx] = transPts(qch);
    [Pbx Pby Pbz] = transPts(Pch);
    [xbx, xby, xbz] = transPts(Sch);
    [foldx, foldy, foldz] = transPts(Ych);
    backspots.xx = xbx;
    backspots.yy = xby;
    backspots.zz = xbz;
    intake.x = [Ibx Ibx(1)];
    intake.y = [Iby Iby(1)];
    intake.z = [Ibz Ibz(1)];
    p3x = [prx(1) prx];
    p3y = [114 pry];
    p3z = [58 prz];
    %%%%%%%%%%%%%%%%%%%%%
    %
    %   where are the profiles used?
    %
    %   profile:  length res/2 used on top forward of x = 803
    %   profile3: length res/2 + 26 used on top between x = 629 and x = 803
    %   profile4: length res/2 + 26 used on top aft of x = 441
    %   profile1: length res/2 used on bot forward of x = 840
    %   profile2: length res/2 used on bot between aft of x = 840
    %   blending on top between x = 640 and x = 850
    %   blending on top between x = 441 and x = 629
    %
    %   aft of x = 850, need to add addWidth to each side of the profile on top
    %   store the xx, yy, zz values of bottom between 848 and 798
    %   one to one link on blending top from 850 t0 640, picking center
    %   points to map.
    %
    %   profile0
    y = [-pry pry(end-1:-1:1)];
    z = [prz prz(end-1:-1:1)];
    ys = linspace(y(1), y(end), res/2);
    cf = polyfit(y, z, 5);
    zs = polyval(cf, ys);
    zs = zs - min(zs);
%     figure
%     plot(ys, zs);
%     axis equal
%     hold on
    profile = struct('x', zeros(1,res/2) + prx(1), 'y', ys, 'z', zs);
    %
    %   profile3
    y = [-p3y p3y(end-1:-1:1)];
    z = [p3z p3z(end-1:-1:1)];
    widerWidth = res/2+2*addWidth;
    ys = linspace(y(1), y(end), widerWidth);
    cf = polyfit(y, z, 5);
    zs = polyval(cf, ys);
    zs(zs < 58) = 58;
    zs = zs - min(zs);
    profile3 = struct('x', zeros(1, widerWidth) + p3x(1), 'y', ys, 'z', zs);
    range = [min(qby) max(qby)];
    yu = ys(ys > range(1) & ys < range(2));
    st = getXndx(ys, range(1));
    fyu = find(yu) + st - 1;
    q1z = -qbz*0.06 - 0.2;
    zs(fyu) = interp1(qby, q1z, yu);
    zs(end - fyu + 1) = zs(fyu);
%     plot(ys, zs, 'k');
    %
    %   profile4
    p4y = [Pby -Pby(end:-1:1)]*119/136;
    p4z = [Pbz Pbz(end:-1:1)];
%    plot(p4y, p4z - min(p4z), 'c*');
    p4z = p4z - min(p4z);
    cfp4 = polyfit(p4y, p4z, 10);
    zs = polyval(cfp4, ys);
    [mnzs at] = min(zs);
    zs = zs - mnzs;
%     plot(ys, zs, 'c');
    profile4 = struct('x', zeros(1, widerWidth) + p3x(1), 'y', ys, 'z', zs);
    %
    %   profile1
    y = [-p1y(end:-1:1) p1y(2:end)];
    z = [p1z(end:-1:1) p1z(2:end)];
    ys = linspace(y(1), y(end), res/2);
    zs = interp1(y, z, ys);
    zs = zs - max(zs);
    profile1 = struct('x', zeros(1,res/2) + p1x(1), 'y', ys, 'z', zs);
%     plot(ys, zs, 'g');
    %
    %   profile2
    y = [p2y -p2y(end-1:-1:1)];
    z = [p2z p2z(end-1:-1:1)];
    ys = linspace(y(1), y(end), res/2);
    zs = interp1(y, z, ys);
    zs = zs - max(zs);
    profile2 = struct('x', zeros(1,res/2) + p2x(1), 'y', ys, 'z', zs);
%     plot(ys, zs, 'm');
%     legend({'0 - top, fwd','3 - top, mid','4 - top, raw', ...
%             '4 - top, rear', '1 - bottom, fwd','2 - bottom, aft'})
%     grid on
    spine = struct('x', spx, 'y', spy, 'z', spz);
    bspine = struct('x', bsx, 'y', bsy, 'z', bsz);
    intkfrnx = 12;
    intkbknx = 13;
    nx = max(chx);
    tx = min(chx);
    fx = linspace(tx, nx, res);
    cf = polyfit(chx(1:intkfrnx), chy(1:intkfrnx), 4);
    oops = polyval(cf, chx(1));
    xs = linspace(chx(1), chx(intkfrnx), 50);
    ys = polyval(cf, xs) - oops;
    ys(ys > 54) = 54;
    zs = interp1([chx(intkfrnx) fx(end)], [chz(intkfrnx) chz(1)], xs);
    txx = zeros(res, widerWidth);
    tyy = txx;
    tzz = txx;
    bxx = zeros(1, res/2);
    byy = bxx;
    bzz = bxx;
    topprof = profile4;
    botprof = profile2;
    px = 0;
    for ndx = 1:res
        x = fx(ndx);
        % polyfit the nose y, interp1 the nose z
        if x > chx(intkfrnx)
            str = struct('x',x, ...
                         'y',polyval(cf, x), ...
                         'z',interp1([chx(1) chx(intkfrnx)], [chz(1) chz(intkfrnx)], x));
        elseif x >= chx(intkbknx)
        % between intake front and rear, use 
            nchy = chy;
            nchy(intkbknx) = 62.71;
            str = struct('x',x, ...
                         'y',interp1(chx, nchy, x), ...
                         'z',interp1(chx, chz, x));
%         elseif x >= wmxx
%         % interp y between intake rear and wing root
%             str = struct('x',x, ...
%                          'y',interp1([wmxx chx(intkbknx)], [wingRootTop.y(end) chy(intkbknx)], x), ...
%                          'z',interp1([wmxx chx(intkbknx)], [wingRootTop.z(end) chz(intkbknx)], x));
%         elseif x >= wmnx 
%         % use the wing root where you can
%             str = struct('x',x, ...
%                          'y',interp1(wingRootTop.x, wingRootTop.y, x), ...
%                          'z',interp1(wingRootTop.x, wingRootTop.z, x));
        else
%             % stretch the wing trailing edge to the back
%             xv = [chx(end) wingRootTop.x(1)];
%             yv = [chy(end) wingRootTop.y(1)];
%             zv = [chz(end) wingRootTop.z(1)];
%             ysm = interp1(xv, yv, x);
%             zsm = interp1(xv, zv, x);
            % interpolate on chx-z
            ysm = interp1(chx, chy, x);
            zsm = interp1(chx, chz, x);
            str = struct('x',x, 'y', ysm, 'z', zsm);
        end
        if x > 440 && px < 440
            topprof = profile3;
            blendEngTo = ndx-2;
        end
        if x > 629 && px < 629
            blendEngFr = ndx;
        end
        if x > 640 && px < 640
            blendTo = ndx;
        end
        if x > 840 && px < 840
            botprof = profile1;
        end
        if x > 848 && px < 848
            fstretchf = ndx;
        end
        if x > 802 && px < 802
            topprof = profile;
            fstretchr = ndx;  % stretch them to this x index
        end
       % set up forward stretch of intake edge
        if x > 680 && px < 680
            bcsndx = ndx;  % rearmost x index to start stretch
        end
        if x > 755 && px < 755
            bpcndx = ndx;  % frontmost extreme of stretch
        end
        if x > 795 && px < 795
            ibrndx = ndx;  % stretch them to this x index
        end
        if x > 850 && px < 850
            blendFrom = ndx;  % stretch them to this x index
        end
        px = x;
        y = str.y;
        if y < 0, y = 0; end
        z = str.z;
        txx(ndx,:) = x;
        [tyy(ndx,:), tzz(ndx,:)] = putProfile(topprof, spine, x, y, z, true);
        bxx(ndx,:) = x;
        try
        [byy(ndx,:), bzz(ndx,:)] = putProfile(botprof, bspine, x, y, z, false);
        catch
           disp('gotcha') 
        end
    end
%     figure
%     mesh(txx(bcsndx-5:blendFrom+5, :), tyy(bcsndx-5:blendFrom+5, :), tzz(bcsndx-5:blendFrom+5, :))
%     hold on
%     mesh(bxx(bcsndx-5:blendFrom+5, :), byy(bcsndx-5:blendFrom+5, :), bzz(bcsndx-5:blendFrom+5, :))
%     plot3(chx(11:end-1), chy(11:end-1), chz(11:end-1), 'r*')
%     axis equal
%     xlabel('X')
%     ylabel('Y')
%     zlabel('Z')
%     view(0, 0)
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % blend the top profile at blendFrom back to blendTo keeping y constant
    %
    prfFrmy = tyy(blendFrom,:);
    prfFrmz = tzz(blendFrom,:);
    lprf = length(prfFrmy);
    prfToz = tzz(blendTo,:);
    nx = blendFrom - blendTo - 1;
    for yndx = 1:lprf
        y = prfFrmy(yndx);
        z1 = prfFrmz(yndx);
        z2 = prfToz(yndx);
        dz = (z2-z1) / (nx+1);
        z = z1;
        for xndx = blendFrom-1:-1:blendTo+1
            z = z + dz;
            tzz(xndx,yndx) = z;
        end
    end
    for xndx = blendFrom-1:-1:blendTo+1
        ht = max(tzz(xndx,:));
        spine_ht = interp1(spine.x, spine.z, fx(xndx));
        tzz(xndx,:) = tzz(xndx,:) * spine_ht / ht;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % blend the top profile at blendEngFr back to blendEngTo keeping y constant
    %
    prfFrmy = tyy(blendEngFr,:);
    prfFrmz = tzz(blendEngFr,:);
    lprf = length(prfFrmy);
    prfToz = tzz(blendEngTo,:);
    nx = blendEngFr - blendEngTo - 1;
    vec = blendEngFr-1:-1:blendEngTo+1;
    for yndx = 1:lprf
        y = prfFrmy(yndx);
        z1 = prfFrmz(yndx);
        z2 = prfToz(yndx);
        dz = (z2-z1) / (nx+1);
        z = z1;
        for xndx = vec
            z = z + dz;
            tzz(xndx,yndx) = z;
        end
        yv = zeros(length(vec)) + y;
    end
    for xndx = vec
        ht = max(tzz(xndx,:));
        spine_ht = interp1(spine.x, spine.z, fx(xndx));
        tzz(xndx,:) = tzz(xndx,:) * spine_ht / ht;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % stretch the intake inner edge
    %
    dix = bxx(fstretchr,60) - bxx(fstretchf,60);
    diy = byy(fstretchr,60) - byy(fstretchf,60);
    diz = bzz(fstretchr,60) - bzz(fstretchf,60);
    bzz(fstretchr+1:fstretchf-1,[2:60 end-59:end]) = NaN;
    for isl = 1:60
        dsx = dix*(isl-1)/60;
        dsy = diy*(isl-1)/60;
        dsz = diz*(isl-1)/60;
%         fprintf(debug,'[%0.1f, %0.1f,%0.1f]\n', dsx, dsy, dsz);
        bxx(fstretchf,isl) = bxx(fstretchf,isl) + dsx - 40;
        byy(fstretchf,isl) = byy(fstretchf,isl) + dsy;
        bzz(fstretchf,isl) = bzz(fstretchf,isl) + dsz;
        bxx(fstretchf,129-isl) = bxx(fstretchf,129-isl) + dsx - 40;
        byy(fstretchf,129-isl) = byy(fstretchf,129-isl) - dsy;
        bzz(fstretchf,129-isl) = bzz(fstretchf,129-isl) + dsz;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % stretch the intake outer edge
    %
    dix = bxx(ibrndx,1) - bxx(bpcndx,1);
    diy = byy(ibrndx,1) - byy(bpcndx,1);
    diz = bzz(ibrndx,1) - bzz(bpcndx,1);
    bzz(bpcndx+1:ibrndx+3,[2:29 99:126]) = NaN;
    for isl = 1:29
        dsx = dix*(30-isl)/29;
        dsy = diy*(30-isl)/29;
        dsz = diz*(30-isl)/29;
        bxx(bpcndx,isl) = bxx(bpcndx,isl) + dsx;
        byy(bpcndx,isl) = byy(bpcndx,isl) + dsy;
        bzz(bpcndx,isl) = bzz(bpcndx,isl) + dsz;
        bxx(bpcndx,129-isl) = bxx(bpcndx,129-isl) + dsx;
        byy(bpcndx,129-isl) = byy(bpcndx,129-isl) - dsy;
        bzz(bpcndx,129-isl) = bzz(bpcndx,129-isl) + dsz;
    end
    %%%%%%%%%%%%%
    %   stretch the bottom edge
    %   find the index for x = 757.6
    xnx = getXndx(fx, 757);
    bzz(166:176, 29:59) = NaN;
    xv = linspace( ibx(1), ibx(2), 33);
    zv = linspace( ibz(1), ibz(2), 33);
    bxx(165, 30:62) = xv;
    bzz(165, 30:62) = zv;
    % 
    %  build the engine interior box
    %   Ibx,y,z are the interior box,   inner top
    %                                   outer top
    %                                   outer bottom
    %                                   inner bottom
    nxt = bpcndx + 1;
    % 1. wrap horizontally around behind black plate
    bxx(nxt,1:14) = Ibx(2);
    byy(nxt,1:14) = -Iby(2);
    bzz(nxt,1:14) = Ibz(2);
    bxx(nxt,15:29) = Ibx(3);
    byy(nxt,15:29) = -Iby(3);
    bzz(nxt,15:29) = Ibz(3);
    bxx(nxt,15:29) = Ibx(3);
    byy(nxt,15:29) = -Iby(3);
    bzz(nxt,15:29) = Ibz(3);
    bxx(nxt+1,14:15) = blkx-1;  % Outer Wall
    byy(nxt+1,14:15) = byy(nxt,14:15);
    bzz(nxt+1,14:15) = bzz(nxt,14:15);
    bxx(nxt+2,14:15) = blkx-1;  % back wall
    byy(nxt+2,14:15) = [-Iby(1) -Iby(4)];
    bzz(nxt+2,14:15) = [Ibz(1) Ibz(4)];
    bxx(nxt+3,14:15) = [Ibx(1) Ibx(4)];  % inner wall
    byy(nxt+3,14:15) = [-Iby(1) -Iby(4)];
    bzz(nxt+3,14:15) = [Ibz(1) Ibz(4)];
    bxx(nxt+4,14:15) = [Ibx(1) Ibx(4)];  % front face of lip
    byy(nxt+4,14:15) = [-Iby(1) -Iby(4)] - 2;
    bzz(nxt+4,14:15) = [Ibz(1) Ibz(4)];
    bxx(nxt+5,14:15) = [Ibx(1) Ibx(4)] - 20; % inner lining of gap
    byy(nxt+5,14:15) = [-Iby(1) -Iby(4)] - 2;
    bzz(nxt+5,14:15) = [Ibz(1) Ibz(4)];
    bxx(fstretchf-1,1:30) = bxx(nxt+5,14);  % bridge the gap top
    byy(fstretchf-1,1:30) = byy(nxt+5,14);
    bzz(fstretchf-1,1:30) = bzz(nxt+5,14);
    bxx(fstretchf-1,31:60) = bxx(nxt+5,15);
    byy(fstretchf-1,31:60) = byy(nxt+5,15);
    bzz(fstretchf-1,31:60) = bzz(nxt+5,15);
    % 2. wrap vertically to make top and bottom of the box
    bxx(nxt+1:nxt+2, 12) = [ibx(4),  ibx(3)]';
    byy(nxt+1:nxt+2, 12) = [-iby(4), -iby(3)]';
    bzz(nxt+1:nxt+2, 12) = [ibz(4), ibz(3)]';
    bxx(nxt+1:nxt+2, 13) = [Ibx(2),  Ibx(1)]';
    byy(nxt+1:nxt+2, 13) = [-Iby(2), -Iby(1)]';
    bzz(nxt+1:nxt+2, 13) = [Ibz(2), Ibz(1)]';
    bxx(nxt+1:nxt+2, 16) = [Ibx(3),  Ibx(4)]';
    byy(nxt+1:nxt+2, 16) = [-Iby(3), -Iby(4)]';
    bzz(nxt+1:nxt+2, 16) = [Ibz(3), Ibz(4)]';
    bxx(nxt+1:nxt+2, 17) = [ibx(1) ibx(2)]';
    byy(nxt+1:nxt+2, 17) = [-iby(1), -iby(2)]';
    bzz(nxt+1:nxt+2, 17) = [ibz(1), ibz(2)]';
    
    % fix the nose
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % cut cockpit hole
    %
    % get half the canopy
    canxx = canopy.xx(:, 1:ceil(end/2));
    canyy = canopy.yy(:, 1:ceil(end/2));
    canzz = canopy.zz(:, 1:ceil(end/2));
    [crows, ccols] = size(canxx);
    fxs = canxx(:,1);
    frimz = interp1(rimx, rimz, fxs);
    good = ~isnan(frimz)';
    frimx = fxs(good)';
    lrm = length(frimx); 
    frimy = zeros(1, lrm);
    frimz = interp1(rimx, rimz, frimx);
    for ndx = 1:lrm
        x = frimx(ndx);
        z = frimz(ndx);
        frimy(ndx) = myInterp2(canxx, canzz, canyy, x, z);
    end
    rimx = [frimx(1) frimx frimx(end)  frimx(end-1:-1:1) frimx(1)];
    rimy = [0 -frimy 0 frimy(end-1:-1:1) 0];
    rimz = [frimz(1) frimz frimz(end) frimz(end-1:-1:1) frimz(1)];
    rim = struct('x', rimx, 'y', rimy, 'z', rimz);
    %  find range of x, y values for the hole
    %%%%%%%%%%%%%%%%%
    %
    %  canopy fairing
    %
    % find x,y indices of 4 fold points
    
    [tnx tny] = size(txx);
    for ndx = 1:4
        fxndx(ndx) = getXndx(fx, foldx(ndx));
        fyndx(ndx) = getXndx(tyy(fxndx(ndx),:), foldy(ndx));
    end
    fyndx(3) = fyndx(2);
    foldx(2) = txx(fxndx(2), fyndx(2));
    foldy(2) = tyy(fxndx(2), fyndx(2));
    foldz(2) = tzz(fxndx(2), fyndx(2));
    loxnx = min(fxndx);
    hixnx = max(fxndx);
    hiynx = max(fyndx);
    loynx = tny/2+1;
    cx = (max(rimx) + min(rimx))/2;
    %  now, frame that outer edge with the fold points
    np = 0;
    %    - back edge:
    xp = [foldx(1) foldx(2)];
    yp = [foldy(1) foldy(2)];
    xnx = loxnx;
    xat = foldx(1);
    for ynx = loynx:hiynx
        xi = getXndx(fx, xat);
        yv = tyy(xi,ynx);
        xv = interp1(yp, xp, yv, 'linear', 'extrap');
        zv = tzz(xi, ynx);
        xat = xv;
        np = np + 1;
        txx(xnx, ynx) = xv;
        tyy(xnx, ynx) = yv;
        tzz(xnx, ynx) = zv;
        brim(np) = struct('x',txx(xnx,ynx), ...
            'y',tyy(xnx,ynx), ...
            'z',tzz(xnx,ynx), ...
            'np',np, ...
            'ix',xnx, ...
            'iy',ynx, ...
            'dir','rear');
        fprintf(debug,'np = %d; rear point[%d,%d] is {%0.1f,%0.1f,%0.1f}\n', ...
            np, xnx, ynx, txx(xnx, ynx), tyy(xnx, ynx), tzz(xnx, ynx));
    end
    last_rear = np;
    %    - side edge:
    xp = [foldx(2) foldx(3)];
    yp = [foldy(2) foldy(3)];
    zp = [foldz(2) foldz(3)];
    nxv = hixnx - loxnx + 1;
    xvals = linspace(xv, foldx(3), nxv);
    ynx = hiynx;
    for ndx = 1:nxv
        xnx = loxnx+ndx-1;
        xv = xvals(ndx);
        xi = getXndx(fx, xv);
        yv = interp1(xp, yp, xv, 'linear', 'extrap');
        zv = tzz(xi, ynx);
        np = np + 1;
        txx(xnx, ynx) = xv;
        tyy(xnx, ynx) = yv;
        tzz(xnx, ynx) = zv;
        brim(np) = struct('x',txx(xnx,ynx), ...
            'y',tyy(xnx,ynx), ...
            'z',tzz(xnx,ynx), ...
            'np',np, ...
            'ix',xnx, ...
            'iy',ynx, ...
            'dir','side');
        fprintf(debug,'np = %d; side point[%d,%d] is {%0.1f,%0.1f,%0.1f}\n', ...
            np, xnx, ynx, txx(xnx, ynx), tyy(xnx, ynx), tzz(xnx, ynx));
    end
    last_side = np;
    %    - front edge:
    xp = [foldx(3) foldx(4)];
    yp = [foldy(3) foldy(4)];
    xnx = hixnx;
    xat = xv;
    for ynx = hiynx:-1:loynx
        xi = getXndx(fx, xat);
        yv = tyy(xi,ynx);
        xv = interp1(yp, xp, yv, 'linear', 'extrap');
        zv = tzz(xi, ynx);
        xat = xv;
        np = np + 1;
        txx(xnx, ynx) = xv;
        tyy(xnx, ynx) = yv;
        tzz(xnx, ynx) = zv;
        brim(np) = struct('x',txx(xnx,ynx), ...
            'y',tyy(xnx,ynx), ...
            'z',tzz(xnx,ynx), ...
            'np',np, ...
            'ix',xnx, ...
            'iy',ynx, ...
            'dir','front');
        fprintf(debug,'np = %d; front point[%d,%d] is {%0.1f,%0.1f,%0.1f}\n', ...
            np, xnx, ynx, txx(xnx, ynx), tyy(xnx, ynx), tzz(xnx, ynx));
    end
    figure
%     % clip the vectors from brim to the center at the curve rimx-z
    cy = 0;
    for ndx = 1:np
        omit = ndx == last_rear || ndx == last_rear+1 ...
            || ndx == last_side || ndx == last_side+1;
        if ~omit
            rimndx = 1;
            br = brim(ndx);
            baseport = getPort(br, rim, rimndx, cx, cy);
            aport = baseport;
            while rimndx < length(rim.x) && aport == baseport 
                rimndx = rimndx+1;
                aport = getPort(br, rim, rimndx, cx, cy);
            end
            storeFold(br, rimndx);
        end
   end
    axis equal
    %
    %  really cut the hole
    tzz(loxnx+3:hixnx-3, loynx:hiynx-3) = NaN;
    %%%%%%%%%%%%%%%%%
    %  diagnostic display
    bknx = getXndx(fx, 600);
    frntnx = getXndx(fx, 1040);
    figure
%     s1 = showSurf(canopy);
%     set(s1, 'FaceAlpha', 0.5)
    plot3(rimx, rimy, rimz, 'r')
    hold on
    plot3(foldx, foldy, foldz, 'k*--')
%     plot3(cpx, cpy, cpz, 'k+')
    ckptxx = txx(bknx:frntnx,:);
    ckptyy = tyy(bknx:frntnx,:);
    ckptzz = tzz(bknx:frntnx,:);
    mesh(ckptxx, ckptyy, ckptzz)
    % connect all brim points to center
    hidden off
    axis equal
    shading interp
    view(-120, 30)
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   engine intake fillets
    %
    nx1 = getXndx(fx, 646);
    nx2 = getXndx(fx, 798);
    nx3 = getXndx(fx, 844);
    aw = addWidth;
    for ndx = nx1:nx2
        y2 = tyy(ndx, aw+1);
        y1 = byy(ndx, 1);
        z2 = tzz(ndx, aw+1);
        z1 = bzz(ndx, 1);
        ys = linspace(y1, y2, aw);
        zs = linspace(z1, z2, aw);
        tyy(ndx, 1:aw) = ys;
        tzz(ndx, 1:aw) = zs;
        tyy(ndx, end-aw+1:end) = -ys(end:-1:1);
        tzz(ndx, end-aw+1:end) = zs(end:-1:1);
    end
    xi = [ibx(4) ibx(3)];
    yi = [iby(4) iby(3)];
    zi = [ibz(4) ibz(3)];
    lasty = y1;
    lastz = z1;
    for ndx = nx2+1:nx3
        x = fx(ndx);
        y2 = tyy(ndx, aw+1);
        z2 = tzz(ndx, aw+1);
        ys = linspace(lasty, y2, aw);
        zs = linspace(lastz, z2, aw);
        lninty = interp1(xi, yi, x);
        lnintz = interp1(xi, zi, x);
        yn = aw - getXndx(-ys(end:-1:1), lninty);
        ys(yn) = -lninty;
        zs(yn) = lnintz;
        tyy(ndx, yn:aw) = ys(yn:aw);
        tzz(ndx, yn:aw) = zs(yn:aw);
        tyy(ndx, end-aw+yn:end) = -ys(aw:-1:yn);
        tzz(ndx, end-aw+yn:end) = zs(aw:-1:yn);
    end
    
    %%%%%%%%%%%%%%%%%%
    %   trim back end
    %
    nx1 = getXndx(fx, 210);
    hinx = nx1-4;
    lonx = hinx - 3;
    xx = [xbx xbx(end:-1:1)];
    xy = [xby -xby(end:-1:1)];
    xz = [xbz xbz(end:-1:1)];
    tex = xbx([1 2 end-1 end]);
    tey = xby([1 2 end-1 end]);
    tez = xbz([1 2 end-1 end]);
    tzz(1:nx1-4,:) = NaN;
    lastLong = true;
    %%%%%%%%%%
    %   trim the top surface
    for ynx = 1:widerWidth
        y = tyy(nx1,ynx);
        xp = interp1(xy, xx, y);
        isLong = xp < bsx(end-2);
        if isLong
            dx = bsx(end-4:end);
            fewx = dx(2:end);
            fewx(end) = 74;
            xv = interp1(xy, xx, y);
            dx = [txx(nx1, ynx), 74];
            dtz = [tzz(nx1, ynx), chz(end)];
            hiz = interp1(dx, dtz, txx(nx1,ynx));
            tff = chz(end) - dtz;
            dfz = tff * (chz(end) - tzz(nx1,ynx))/(chz(end) - hiz);
            dz = chz(end) - dfz;
            A = (192-xv)/135;
            B = xv - 74*A;
            ffx = A*fewx+B;
            zv = interp1(dx, dz, fewx);
            txx(hinx:-1:lonx, ynx) = ffx;
            tzz(hinx:-1:lonx, ynx) = zv;
        else
            txx(nx1-3,ynx) = xp;
        end
        if ynx < 114 && ~isLong && lastLong
            outerNdx = widerWidth + 1 -(ynx-1);
            fprintf('outer ndx = %d; x = %0.1f; y = %0.1f\n', ...
                        outerNdx, lastXp, byy(nx1,ynx-1));
        elseif ynx < 114 && isLong && ~lastLong
            innerNdx = widerWidth + 1 - ynx;
            fprintf('inner ndx = %d; xp = %0.1f; y = %0.1f\n', ...
                        innerNdx, xp, y);
        end
        lastLong = isLong;
        lastXp = xp;
    end
    %%%%%%%%%%
    %   trim the bottom surface
    bzz(1:nx1-4, :) = NaN;
    lastLong = true;
    for ynx = 1:res/2
        y = byy(nx1,ynx);
        xp = interp1(xy, xx, y);
        isLong = xp < bsx(end-2); 
        if isLong
            xv = interp1(xy, xx, y);
            dx = bsx(end-4:end);
            dbz = bsz(end-4:end);
            loz = interp1(dx, dbz, bxx(nx1,ynx));
            dff = chz(end) - dbz;
            dfz = dff * (chz(end) - bzz(nx1,ynx))/(chz(end) - loz);
            dz = chz(end) - dfz;
            dx(end) = 74;
            fewx = dx(2:end);
            A = (192-xv)/135;
            B = xv - 74*A;
            ffx = A*fewx+B;
            zv = interp1(dx, dz, fewx);
            bxx(hinx:-1:lonx, ynx) = ffx;
            bzz(hinx:-1:lonx, ynx) = zv;
        else
            bxx(nx1-3,ynx) = xp;
        end
        if ynx < 65 && ~isLong && lastLong
            outerx = bxx(nx1:-1:lonx, ynx-1);
            outerz = bzz(nx1:-1:lonx, ynx-1);
            fprintf('outer ndx = %d; x = %0.1f; y = %0.1f\n', ...
                        outerNdx, lastXp, byy(nx1,ynx-1));
        elseif ynx < 65 && isLong && ~lastLong
            innerx = [ffx dx(1)];
            innerz = interp1(dx, dz, innerx);
            fprintf('inner ndx = %d; xp = %0.1f; y = %0.1f\n', ...
                        innerNdx, xp, y);
        end
        lastLong = isLong;
        lastXp = xp;
        bxx(lonx,ynx) = interp1(tey, tex, y);
        bzz(lonx,ynx) = interp1(tey, tez, y);
    end
    %%%%%%%%%%%%%%%%%%%%%%%
    %   add inner faces
    %   1. add extra layer to bottom mesh
    %       y values are top inner and outer byy's
    %       x and z values are same as adjacent ones 
    bouter = 115;
    binner = 72;
    bzz(nx1-4, 1:binner) = bzz(nx1-3, 1:binner) + 0.6;
    bxx(nx1-4, bouter) = bxx(nx1-4, bouter+1);
    byy(hinx:-1:lonx, bouter) = tyy(1,outerNdx);
    bzz(nx1-4, bouter) = bzz(nx1-4, bouter+1);
    bxx(hinx-1:-1:lonx, bouter) = bxx(hinx-1:-1:lonx, bouter+1);
    bzz(hinx-1:-1:lonx, bouter) = bzz(hinx-1:-1:lonx, bouter+1);
    % inner edge
    bxx(nx1-4, binner) = bxx(nx1-4, binner-1);
    byy(hinx:-1:lonx, binner) = tyy(1,innerNdx);
    bzz(nx1-4, binner) = bzz(nx1-4, binner-1);
    bxx(hinx-1:-1:lonx, binner) = bxx(hinx-1:-1:lonx, binner-1);
    bzz(hinx-1:-1:lonx, binner) = bzz(hinx-1:-1:lonx, binner-1);

    % inside face - outer
    txx(hinx:-1:lonx, outerNdx-1) = txx(hinx:-1:lonx, outerNdx);
    tyy(hinx:-1:lonx, outerNdx-1) = tyy(hinx:-1:lonx, outerNdx);
    tzz(hinx:-1:lonx, outerNdx-1) = bzz(hinx:-1:lonx, bouter);
    % inside face - inner
    txx(hinx:-1:lonx, innerNdx+1) = txx(hinx:-1:lonx, innerNdx);
    tyy(hinx:-1:lonx, innerNdx+1) = tyy(hinx:-1:lonx, innerNdx);
    tzz(hinx:-1:lonx, innerNdx+1) = bzz(hinx:-1:lonx, binner);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   capture exhaust profiles
    %
    topexprf.xx = txx(nx1-2, innerNdx:outerNdx);
    topexprf.yy = tyy(nx1-2, innerNdx:outerNdx);
    topexprf.zz = tzz(nx1-2, innerNdx:outerNdx) - 0.1;
    botexprf.xx = bxx(nx1-2, binner:bouter);
    botexprf.yy = byy(nx1-2, binner:bouter);
    botexprf.zz = bzz(nx1-2, binner:bouter) + 0.1;
    %%%%%%%%%%%%%%%%%%%
    %   diagnostic plot of tail end
    %
%     figure
%     plot3(xbx, xby, xbz, 'r+')
%     hold on
%     [br bc] = size(bxx);
%     plot3(bsx(end-4:end), bsy(end-4:end), bsz(end-4:end), 'k^')
%     plot3(bxx(nx1+1,end:-5:bc/2), byy(nx1+1,end:-5:bc/2), bzz(nx1+1,end:-5:bc/2),'k*' ) 
%     mesh(bxx(1:40,(bc/2-2):end), byy(1:40,(bc/2-2):end), bzz(1:40,(bc/2-2):end) ) 
%     mesh(txx(1:40,(bc/2-2):end), tyy(1:40,(bc/2-2):end), tzz(1:40,(bc/2-2):end) ) 
%     plot3(txx(1:40,innerNdx), tyy(1:40,innerNdx), tzz(1:40,innerNdx), 'r')
%     plot3(txx(1:40,outerNdx), tyy(1:40,outerNdx), tzz(1:40,outerNdx), 'k')
%     plot3(topexprf.xx, topexprf.yy, topexprf.zz, 'g')
%     plot3(botexprf.xx, botexprf.yy, botexprf.zz, 'k')
% %     hidden off
%     xlabel('X - FORWARD')
%     ylabel('Y - TO PORT')
%     zlabel('Z - UP')
%     axis equal
%     view(-120, 18)
%     legend({'rear','bottom','bot markers','bot mesh','top mesh', ...
%         'inner','outer','topexhaust','botexhaust'})
    
    %%%%%%%%%%%%%%%%%%%%
    %   mirroring
    bxx(:, end/2:-1:1) = bxx(:,end/2+1:end);
    byy(:, end/2:-1:1) = -byy(:,end/2+1:end);
    bzz(:, end/2:-1:1) = bzz(:,end/2+1:end);
    txx(:, end/2:-1:1) = txx(:,end/2+1:end);
    tyy(:, end/2:-1:1) = -tyy(:,end/2+1:end);
    tzz(:, end/2:-1:1) = tzz(:,end/2+1:end);
    
    %%%%%%%%%%%%%%%%%
    %   mesh plot
    %
    figure
    mesh(txx, tyy, tzz)
    hold on
    mesh(bxx, byy, bzz)
    hidden off
    plot3(chx, chy, chz, 'r+')
    plot3(spx, spy, spz, 'k+-')
    plot3(bsx, bsy, bsz, 'k+-')
    plot3([ibx ibx(1)], [iby iby(1)], [ibz ibz(1)], 'g')
    plot3([ibx ibx(1)], [-iby -iby(1)], [ibz ibz(1)], 'g')
    plot3([Ibx Ibx(1)], [Iby Iby(1)], [Ibz Ibz(1)], 'c')
    plot3([Ibx Ibx(1)], [-Iby -Iby(1)], [Ibz Ibz(1)], 'c')
    plot3(xx, xy, xz, 'k*')
    axis equal
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    view(77,-19)
    top.xx = txx;
    top.yy = tyy;
    top.zz = tzz;
    [r c] = size(tzz);
    top.clr = ones(r, c, 3) * 0.7;
    bot.xx = bxx;
    bot.yy = byy;
    bot.zz = bzz;
    [r c] = size(bzz);
    bot.clr = ones(r, c, 3) * 0.7;
end

%%%%%%%%%%%%%%%%
%
%   INTAKE
%
function [black] = doIntake(Ich)
    global resolution
    global blkx

    [Ibx, Iby, Ibz] = transPts(Ich);
    r = 2;
    c = 3;
    xx = zeros(r, c) + blkx;
    yy = [-Iby(1) -Iby(2) -Iby(3)
           Iby(1) Iby(2) Iby(3)];
    zz = [ Ibz(1) Ibz(2) Ibz(3)
            Ibz(1) Ibz(2) Ibz(3)];
    clr = zeros(r, c, 3);
    black.xx = xx;
    black.yy = yy;
    black.zz = zz;
    black.clr = clr;
end

%%%%%%%%%%%%%%%%
%
%   WING
%
function [left, right] = wing(t, l, f, p)
% parameters are symbol for trailing edge coords, leading edge coords and 
%  the profile (at a specific wing station)
% get the coordinates of the trailing and leading edges and profile
    global resolution
    
    trail = getPoints(t);
    lead = getPoints(l);
    fill = getPoints(f);
    [prfZ x] = getZProfile(p);
    % range of trailing edge x values is trail(:,1), y is trail(:,2)
    yv = linspace(trail(1,2), trail(end,2), resolution);
    if lead(end,2) < yv(end), lead(end,2) = yv(end);, end
    if trail(end,2) < yv(end), trail(end,2) = yv(end);, end
    for yn = 1:length(yv)
        lx = interp1(trail(:,2), trail(:,1), yv(yn));
        ux = interp1(lead(:,2), lead(:,1), yv(yn));
        zt = interp1(trail(:,2), trail(:,3), yv(yn));
        zl = interp1(lead(:,2), lead(:,3), yv(yn));
        xx(:,yn) = linspace(lx, ux, resolution);
        yy(:,yn) = ones(resolution,1) * yv(yn);
        zz(:,yn) = linspace(zt, zl, resolution);
        scale = (ux - lx) / (x(end) - x(1));
        uzz(:, yn) = zz(:, yn) + prfZ' * scale;
        lzz(:, yn) = zz(:, yn) - prfZ' * scale / 2;
    end
    %
    %    extend leading edge where fillet needed
    lnx = [fill(1,1) fill(2,1)];
    lny = [fill(1,2) fill(2,2)];
    xf = interp1(lny, lnx, yv);
    range = find(~isnan(xf));
    xx(end,range) = xf(range);
    left.xx = [xx xx(end:-1:1,:)];
    left.yy = [yy yy(end:-1:1,:)];
    left.zz = [uzz lzz(end:-1:1,:)] - 12;
    left.clr = ones(resolution, resolution*2, 3) * 0.7;
%     figure
%     mesh(left.xx, left.yy, left.zz)
%     hold on
%     plotPts(fill, 'k*')
%     axis equal
%     grid on
    right = left;
    right.yy = -left.yy;
end



function storeFold(br, rimndx)
    global txx
    global tyy
    global tzz
    global rim
    global debug
        switch br.dir
            case 'rear' % use txx at xnx+1
                dx = 1;
                dy = 0;
            case 'side' % use txx at ynx-1
                dx = 0;
                dy = -1;
            case 'front' % use txx at xnx-1
                dx = -1;
                dy = 0;
        end
        kx = br.ix + dx;
        ky = br.iy + dy;
        txx(kx, ky) = rim.x(rimndx);
        tyy(kx, ky) = rim.y(rimndx);
        tzz(kx, ky) = rim.z(rimndx);
        fprintf(debug,'np = %3d; put [%0.1f,%0.1f,%0.1f] at [%d, %d]; other end was [%0.1f,%0.1f,%0.1f] at [%d, %d];\n', ...
            br.np, rim.x(rimndx),rim.y(rimndx),rim.z(rimndx), ...
            kx, ky, ...
            txx(br.ix, br.iy), tyy(br.ix, br.iy), tzz(br.ix, br.iy), ...
            br.ix, br.iy);
        txx(kx+dx, ky+dy) = rim.x(rimndx);
        tyy(kx+dx, ky+dy) = rim.y(rimndx);
        tzz(kx+dx, ky+dy) = rim.z(rimndx);
        fprintf(debug,'          put [%0.1f,%0.1f,%0.1f] at [%d, %d]\n', ...
            rim.x(rimndx),rim.y(rimndx),rim.z(rimndx), ...
            kx+dx, ky+dy);
        plot3(txx(kx,ky),tyy(kx,ky),tzz(kx,ky), 'r*')
        hold on
        plot3(txx(br.ix, br.iy),tyy(br.ix, br.iy),tzz(br.ix, br.iy), 'c*')
        plot3([txx(br.ix, br.iy) txx(kx,ky)], ...
              [tyy(br.ix, br.iy) tyy(kx,ky)], ...
              [tzz(br.ix, br.iy) tzz(kx,ky)], 'g')
end


function yes = getPort(A, rim, px, Bx, By)
    % A is a struct x, y, z
    % B is [Bx, By]
    % P is found as rim.x(px)
    % cross product = (Bx-Ax)*(Py-Ay) - (By-Ay)*(Px-Ax)
    BAx = Bx - A.x;
    BAy = By - A.y;
    PAx = rim.x(px) - A.x;
    PAy = rim.y(px) - A.y;
    norm = BAx*PAy - BAy*PAx;
    yes = norm < 0;
end


function plotPts(it, clr)
    x = it(:,1)';
    y = it(:,2)';
    z = it(:,3)';
    plot3(x, y, z, clr)
end


    
function [prfZ x] = getZProfile(p)
    global resolution

    prof = getPoints(p);
    x = linspace(prof(1,1),prof(end/2,1), resolution/2);
    prfZ = spline(prof(:,1), prof(:,3), x);
    prfZ = [prfZ prfZ(end:-1:1)];
    % adjust the profile so it is zero at each end
    prfZ = prfZ - prfZ(1);
    x = linspace(prof(1,1),prof(end,1), resolution);
end


function n = getXndx(fx, v)
    q = find(v < fx);
    n = q(1);

end
function fixRim(x1, x2, y1, y2, vz)
    global tzz
    global debug
%     fprintf(debug, 'fixRim(%d,%d,%d,%d,vz[%d])\n', x1, x2, y1, y2, length(vz))
    tzz(x1:x2, y1:y2) = vz;
end


function y = myInterp2(xx, zz, yy, x, z)
    [rows cols] = size(xx);
    % find x value xl
    found = false;
    for xn = 1:rows
        xv = xx(xn,1);
        if xv > x
            if xn == 1
                xi = xn
            else
                xi = xn-1;
            end
            xl = xx(xi,1);
            xh = xx(xi+1,1);
            found = true;
            break;
        end
    end
    if found
        fx = (x - xl)/(xh - xl);
        found = false;
        for zn = 1:cols
            zv = zz(xi, zn);
            if zv > z
                if zn == 1
                    zi = zn;
                else
                    zi = zn - 1;
                end
                zl = zz(xi, zi);
                zh = zz(xi, zi+1);
                found = true;
                break;
            end
        end
        if found
            fz = (z - zl)/(zh - zl);
            yl = yy(xi, zi) + fx * (yy(xi+1, zi) - yy(xi,zi));
            yh = yy(xi, zi+1) + fx * (yy(xi+1, zi+1) - yy(xi,zi+1));
            y = yl + fz * (yh - yl);
        else
            y = NaN;
        end
    else
        y = NaN;
    end
end


function [yy, zz] = putProfile(pr, sp, x, y, z, xtend)
    global widerWidth
    
    spine_ht = interp1(sp.x, sp.z, x);
    prf_gap = spine_ht - z;
    prf_ht = max(pr.z) - min(pr.z);
    prf_v_scale = abs(prf_gap/prf_ht);
    prf_wd = max(pr.y);
    prf_h_scale = y/prf_wd;
    if xtend
        pw = length(pr.x);
        add = zeros(1, (widerWidth - pw)/2)*NaN;
        yy = [add, pr.y * prf_h_scale, add];
        zz = [add, pr.z * prf_v_scale + z, add];
    else
        yy = pr.y * prf_h_scale;
        zz = pr.z * prf_v_scale + z;
    end
end

function [x, y, z] = transPts(c)
    p = getPoints(c);
    x = p(:,1)';
    y = p(:,2)';
    z = p(:,3)';
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


function s = showSurf(it)
    s = surf(it.xx, it.yy, it.zz, it.clr);
    hold on
    shading interp
end

function kpfcn(obj,event)
    global stop
    ck=get(obj,'currentkey');
    stop = true;
end


% 
% 
% function outputColor(fid, clr)
%     [rows cols junk] = size(clr);
%     fprintf(fid,'%d %d %d\n', rows, cols, junk);
%     for cl = 1:3
%         for r = 1:rows
%             for c = 1:cols
%                 fprintf(fid, '%4.3f ', clr(r,c));
%             end
%             fprintf(fid, '\n');
%         end
%     end
% end


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
    % plot front coordinate
    py = halfFront + vec(2);
    myPlot(pz, py, 'b+');
end

