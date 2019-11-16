function whittling
    clear
    clc
    close all
    
    global xdiv
    global ydiv
    global halfTop
    global halfNose
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
    global elevLeft 
    global elevRight
    global spinner
    global prop
    global c_back
    global c_front
    global pilot
    global antenna
    global bod_clr
    global profile
    global wallpaper
    global exhaust_at
    global exhaust_dv
    
    ThicknessToChord = 0.08;
    resolution = 200;
    bod_clr = [194 179 156] ./ 255;
    recompute = true;
    newData = false;
    wingLeft = [];
    wingRight = [];
    body = [];
    fin = [];
    elevLeft = [];
    elevRight = [];
    c_back = [];
    spinner = [];
    antenna = [];
    vecNdx = [];
    wallpaper = imread('wallpaper8.png');
    wallpaper = double(wallpaper)/255;
    if recompute, rs = '';, else,rs = 'don''t';, end 
    if newData, ds = '';, else,ds = 'don''t';, end 
    fprintf('%s recompute; %s input new data; resolution %d\n', ...
        rs, ds, resolution);
    ydiv = 412;
    halfTop = floor(ydiv/2);
    xdiv = 339;
    plane = imread('spitfire.jpg');
    [ht wdth ~] = size(plane);
    halfNose = xdiv + floor((wdth - xdiv)/2);
    x = 0;
    y = 0;
    z = 0;
    recoverData()
    profile = getPoints('p');
    profile = profile*ThicknessToChord*length(profile) / max(max(profile));
    if recompute
        wingLeft = [];
        body = [];
        fin = [];
        elevLeft = [];
        c_back = [];
        antenna = [];
        spinner = [];
    end
    quit = false;
    origpts = npts;
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
    storeData()
    if isempty(spinner)
        [spinner prop] = doProp('s');
    end
%    figure
    if isempty(body)
        body = doBody('a','b','c','d', 'f', 'g');
    end
    if isempty(fin)
        fin = doFin('h','i');
    end
    if isempty(elevLeft)
        [elevLeft elevRight] = doWing('j','k', false);
    end
    if isempty(wingLeft)
        [wingLeft wingRight] = doWing('l','m', true);
    end
    if isempty(c_back)
        [pilot c_back c_front screen] = doCanopy('y','n','u','q', 'v');
    end
    if isempty(antenna)
        [antenna guns] = doAntenna('z');
    end
    save('Spitfire.mat');
    showData(wingLeft, wingRight, body, fin, prop, antenna, guns, ... 
        elevLeft, elevRight, spinner, c_back, c_front, screen, pilot )
    az = 20;
    el = 25;
    view(az, el)
    saveas(gcf,'../spitfire.png')
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




function [antenna, guns] = doAntenna(ltr)
global bod_clr;
    data = getPoints(ltr);
    % first 2 points are the base of the anntenna
    % third point is the tip
    % 4th point is the attachment on the wing leading edge
    rad = (data(1,1) - data(2,1)) / 2;
    ht = data(3,3) - data(1,3);
    th = linspace(0, 2*pi, 40);
    u = [0 ht];
    v = [rad 0];
    [uu tth] = meshgrid(u, th);
    vv = meshgrid(v, th);
    xx = uu;
    rr = vv;
    yy = rr .* cos(tth);
    zz = rr .* sin(tth);
    antenna.xx = yy + data(1,1);
    antenna.yy = zz + data(1,2);
    antenna.zz = xx + data(1,3);
    [rows cols] = size(xx);
    antenna.clr = zeros(rows, cols, 3);
    antenna.clr(:,:,1) = bod_clr(1);
    antenna.clr(:,:,2) = bod_clr(2);
    antenna.clr(:,:,3) = bod_clr(3);
    guns.xx = xx + data(4, 1);
    guns.yy = yy + data(4, 2);
    guns.zz = zz + data(4, 3);
    guns.clr = antenna.clr;
    guns = [guns guns];
    guns(2).yy = -guns(1).yy;
end

function [pilot back front screen split] = doCanopy(ly, riml, scrn, sideProf, splt)
    global resolution
    global bod_clr
    global back_edge_xv
    global back_edge_y
    global back_edge_z
    global back_edge_from
    global back_edge_to

    % fixed part
    % ufwd gives the back edge x
    yv = getPoints(ly);
    % yv(2,:) gives the front edge
    % all we do is spread the back edge profile along from ufwd to yv
    nyz = length(back_edge_y);
    nx = nyz;
    xv = linspace(back_edge_xv, yv(2,1), nx);
    xx = zeros(nx, nyz);
    yy = xx;
    zz = xx;
    for ndx = 1:nx
        xx(ndx,:) = xv(ndx);
        yy(ndx,:) = back_edge_y;
        zz(ndx,:) = back_edge_z;
    end
    back.xx = xx;
    back.yy = yy;
    back.zz = zz;
    clr = ones(nx, nyz, 3) * 0.5;
    fwd = ceil(resolution/15);
    side = floor(fwd/2);
    for c = 1:3
        clr([1:fwd end-fwd:end],:,c) = bod_clr(c);
        clr( :, [1:side, end/2-side:end/2+side end-side:end], c) = bod_clr(c);
    end
    back.clr = clr;
    fprintf('back color is [%d x %d]\n', nx, nyz)
    backP(:,2) = back_edge_y';
    backP(:,3) = back_edge_z';
    backP(:,1) = xv(nx);
    rim = getPoints(riml);
    arimv = rim(1,:);
    arimv(1,1) = backP(1,1);
    brimv = arimv;
    brimv(2) = -brimv(2);
    backP = [arimv; backP; brimv];
    rim(1,1) = backP(1,1);
    frntP = getPoints(scrn);
    frntXfwd = frntP(1,1);
    frntXbk = frntP(end,1);
    frntZbot = frntP(1,3);
    frntZtop = frntP(end,3);
    ofrntP = frntP(end:-1:1,:);
    ofrntP(:,2) = -ofrntP(:,2);
    frntP = [frntP; ofrntP(2:end,:)];
    sideP = getPoints(sideProf);
    split = getPoints(splt);
    sideP(1,:) = backP(end/2,:);
    xfrom = min(rim(:,1));
    xto = frntXbk;
    xv = linspace(xfrom, xto, resolution);
%     figure
%     plot3(backP(:,1), backP(:,2),backP(:,3),'r');
%     hold on
%     plot3(rim(:,1), rim(:,2),rim(:,3),'k+');
    rx = linspace(min(rim(:,1)), max(rim(:,1)), resolution);
    ry = spline(rim(:,1), rim(:,2), rx);
    rz = spline(rim(:,1), rim(:,3), rx);
%     plot3(rx, ry, rz, 'r--')
%     plot3(sideP(:,1), sideP(:,2),sideP(:,3), 'g+');
%     plot3(frntP(:,1), frntP(:,2),frntP(:,3), 'c+');
%     grid on
    sideXZCoeff = polyfit(sideP(:,1), sideP(:,3), 2); 
    frntYZCoeff = polyfit(frntP(:,2), frntP(:,3), 2); 
    sy = zeros(1, resolution);
    sz =  polyval(sideXZCoeff, xv);
%     plot3(xv, sy, sz, 'g');
    fy = linspace(frntP(1,2), frntP(end,2), resolution);
    fz = polyval(frntYZCoeff, fy);
    % move its z values linearly to the right place from frntZtop to
    % fntZbot    
    t = max(fz);
    b = min(fz);
    t1 = frntZtop;
    b1 = frntZbot;
    A = (t1-b1)/(t-b);
    B = (t*b1-b*t1)/(t-b);
    fz = fz * A + B;
    fx = zeros(1, resolution) + frntXfwd ...
        + (frntXbk - frntXfwd) * (fz - frntZbot) / (frntZtop - frntZbot);
%     plot3(fx, fy, fz, 'c');
%     axis equal
    % now shade the canopy.
    xx = zeros(resolution, resolution);
    yy = xx;
    zz = xx;
    sideD = sz - lineFrom(sideP(1,3), max(fz));
    % iterate across y direction
    dfy = fy(end) - fy(1);
    dby = backP(end,2)- backP(1,2);
    dry = ry - lineFrom(ry(1), ry(end));
    ymx = max(fy);
    for yn = 1:resolution
        bky = fy(yn) * dby / dfy;
        bkz = interp1(backP(:,2), backP(:,3), bky);
        fr = [fx(yn) fy(yn) fz(yn)];
        xx(yn, :) = lineFrom(backP(2,1), fr(1));
        yy(yn, :) = lineFrom(bky, fr(2)) - dry .* fy(yn) ./ ymx;
        zz(yn, :) = lineFrom(bkz, fr(3)) + sideD;
 %       plot3(xx(yn,:), yy(yn,:), zz(yn,:), 'y')
    end
    front.xx = xx;
    front.yy = yy;
    front.zz = zz;
    front.clr = zeros(resolution, resolution, 3) + 0.2;
    fprintf('front color is [%d x %d]\n', resolution, resolution)
    [~, where] = max(fz);
    nwx(1,:) = fx(1:where-1)';
    nwx(2,:) = nwx(1,:);
    nwy(1,:) = fy(1:where-1)';
    nwy(2,:) = -nwy(1,:);
    nwz(1,:) = fz(1:where-1)';
    nwz(2,:) = nwz(1,:);
    screen.xx = nwx;
    screen.yy = nwy;
    screen.zz = nwz;
    screen.clr = zeros(2, where-1, 3) + 0.05; 
    fprintf('screen color is [%d x %d]\n', 2, where-1)
    [xx yy zz] = sphere(resolution/2);
    [r c] = size(xx);
    headSize = 7;
    pilot.xx = xx*headSize + mean(rim(:,1))-6;
    pilot.yy = yy*headSize;
    pilot.zz = zz*headSize + min(rim(:,2)) + 72;
    pilot.clr = ones(r, c, 3)*0.5;
    fprintf('pilot color is [%d x %d]\n', r, c)
    pilot.clr(:,:,3) = 0.1;
end
    
function ln = lineFrom(b, f)
    global resolution
    ln = (b + (f-b)*(0:resolution-1)/(resolution-1));
end

function [left right] = doWing(lr, lf, isWing)
    global resolution
    global bod_clr
    global profile
    global wallpaper
    
    rear = getPoints(lr);
    front = getPoints(lf);
    nc = length(profile);
    nr = resolution/2;
    % fit the front and rear edges
    rx = rear(:,1)';
    ry = rear(:,2)';
    rz = rear(:,3)';
    yv = linspace(min(ry), max(ry), nr);
    rxv = interp1(ry, rx, yv);
    rzv = interp1(ry, rz, yv);
    fx = front(:,1)';
    fy = front(:,2)';
    fz = front(:,3)';
    fxv = interp1(fy, fx, yv);
    fzv = interp1(fy, fz, yv);
    xx = zeros(nr, nc);
    yy = xx;
    zzt = xx;
    zzb = xx;
    for ndx = 1:nr
        bkx = rxv(ndx);
        frx = fxv(ndx);
        bkz = rzv(ndx);
        frz = fzv(ndx);
        dx = (frx - bkx)/nc;
        dz = (frz - bkz)/nc;
        scale = dx;
        xx(ndx,:) = bkx + (0:(nc-1))*dx;
        yy(ndx,:) = yv(ndx);
        zz(ndx,:) = bkz + (0:(nc-1))*dz;
        prfz = scale * profile(:,2)';
        zzt(ndx,:) = zz(ndx,:) + prfz;
        zzb(ndx,:) = zz(ndx,:) - prfz;
    end
    xx = [xx xx(:, end:-1:1)];
    yy = [yy yy];
    zz = [zzt zzb(:, end:-1:1)];
    right.xx = xx;
    right.yy = yy;
    right.zz = zz;
    [rows cols] = size(xx);
    if isWing
        cstr = 2001;
        cstp = 3000;
        rstr = 1;
        rstp = 2000;
    else 
        cstr = 3001;
        cstp = 4000;
        rstr = 1;
        rstp = 1000;
    end
    rndx = ceil(linspace(rstr, rstp, rows));
    cndx = ceil(linspace(cstr, cstp, cols));
    right.clr = wallpaper(rndx, cndx,:);
    % note: flipping rows here kept the first roundel on the top but
    % moved it to the root.
    %  flipping columns 
    left.clr = right.clr(:, end:-1:1, :);
    fprintf('right and left wing color is [%d x %d]\n', rows, cols)
    left.xx = right.xx;
    left.yy = -right.yy;
    left.zz = right.zz;    
end


function fin = doFin(lr, lf)
    global resolution
    global bod_clr
    global profile
    global wallpaper
    
    rear = getPoints(lr);
    front = getPoints(lf);
    nc = length(profile);
    nr = resolution/2;
    % curve fit the front and rear edges
    rx = rear(:,1)';
    rz = rear(:,3)';
    zv = linspace(min(rz), max(rz), nr);
    rv = interp1(rz, rx, zv);
    fx = front(:,1)';
    fz = front(:,3)';
    fv = spline(fz, fx, zv);
    xx = zeros(nr, nc);
    yy = xx;
    zz = xx;
    width = zeros(1, nr);
    back = width;
    for ndx = 1:nr
        bk = rv(ndx);
        fr = fv(ndx);
        dc = (fr - bk)/nc;
        width(ndx) = fr - bk;
        back(ndx) = bk;
        scale = dc;
        zz(ndx,:) = zv(ndx);
        yy(ndx,:) = scale * profile(:,2)';
        xx(ndx,:) = bk + (0:(nc-1))*dc;
    end
    xx = [xx xx(:, end:-1:1)];
    yy = [yy -yy(:, end:-1:1)];
    zz = [zz zz];
    fin.xx = xx;
    fin.yy = yy;
    fin.zz = zz;
    [rows cols] = size(xx);
    cstr = 3001;
    cstp = 4000;
    rstr = 1001;
    rstp = 2000;
    rndx = ceil(linspace(rstr, rstp, rows));
    cndx = ceil(linspace(cstr, cstp, cols));
    fin.clr = wallpaper(rndx, cndx,:);
    mxx = max(max(xx));
    mnx = min(min(xx));
    mxz = max(max(zz));
    mnz = min(min(zz));
    dx = mxx - mnx;
    dz = mxz - mnz;
    clmnx = mnx + dx/3.5;
    clmnz = mnz + dz/8;
    clmxz = clmnz + dz/2;
    r = fin.clr(:,:,1);
    g = fin.clr(:,:,2);
    b = fin.clr(:,:,3);
    for cl = 1:3
        clmxx = clmnx + dx/6;
        color = xx > clmnx & xx < clmxx & zz > clmnz & zz < clmxz;
        switch cl
            case 1  % blue
                r(color) = 0;
                g(color) = 0;
                b(color) = .6;
            case 2  % white
                r(color) = .7;
                g(color) = .7;
                b(color) = .7;
            case 3  % red
                r(color) = .6;
                g(color) = 0;
                b(color) = 0;
        end
        clmnx = clmxx;
    end
    fin.clr(:,:,1) = r;
    fin.clr(:,:,2) = g;
    fin.clr(:,:,3) = b;
end


function str = doBody(top, bot, first, scnd, thrd, frth)
    global resolution
    global back
    global bod_clr
    global exhaust_at
    global exhaust_dv
    global back_edge_xv
    global back_edge_y
    global back_edge_z
    global back_edge_from
    global back_edge_to
    global wallpaper
    
    flat_top = round(resolution/30);
    mxy = 16;
    fx = back.xx;
    fy = back.yy;
    fz = back.zz;
    topSide = getPoints(top);
    botSide = getPoints(bot);
    prof{1} = getPoints(first);
    prof{2} = getPoints(scnd);
    prof{3} = getPoints(thrd);
    prof{4} = getPoints(frth);
    % some real whittling
    xtra = getPoints('x');
    % first two values are the upper line of the rear fuselage
    ufwd = xtra(1,:);
    urear = xtra(2,:);
    xfwd = ufwd(1);
    xrear = urear(1);
    zfwd = ufwd(3);
    zrear = urear(3);
    % the remainder define the box containing the exhaust manifolds
    exhaust_at = xtra(end,:);
    exhaust_dv = [14 -1.5 0];
    
    xv = linspace(prof{4}(1,1), fx(1), resolution);
    top = polyval(polyfit(topSide(:,1), topSide(:,3), 4), xv);
    top = top + fz(end/2) - top(end);
    bot = polyval(polyfit(botSide(:,1), botSide(:,3), 4), xv);
    bot = bot + fz(1) - bot(end);
%     plot3(topSide(:,1), topSide(:,2), topSide(:,3), 'k--')
%     hold on
%     plot3(botSide(:,1), botSide(:,2), botSide(:,3),'g')
%     plot3(xv, zeros(1,resolution), top, 'b')
%     plot3(xv, zeros(1,resolution), bot, 'y')
%     plot3(fx, fy, fz, 'r')
    pprof(:,1) = fx';
    pprof(:,2) = fy';
    pprof(:,3) = fz';
    rx = prof{1}(:,1);
    ry = prof{1}(:,2);
    rz = prof{1}(:,3);
%     plot3(rx, ry, rz)
%     plot3(prof{2}(:,1), prof{2}(:,2), prof{2}(:,3), 'c*-')
    th = linspace(-pi, pi, resolution);
    pa = getRadii(pprof, th);
    clr = 'cmgr';
    for ndx = 1:4
        pr = getRadii(prof_mirror(prof{ndx}), th);
        sx = prof{ndx}(:,1);
        prf(ndx,:) = pr;
        cz = pr{1};
        irad = pr{2};
%         plot3(zeros(1,resolution)+sx(1), irad.*sin(th), irad.*cos(th)+cz, clr(ndx));
    end
    
    % now, we need to use the vertical range to scale the profile
    % and linearly mod the profile from back to first
    % we will use resolution vertically and resolution/4 horizontally
    % because this is a pretty narrow section
    xx = zeros(resolution, resolution);
    yy = xx;
    zz = xx;
    % get starting frame by interpolating on xv for the position of the
    % first frame
    from = ceil(interp1(xv,1:resolution, rx(1)));
    to = resolution;
    rirad = prf{1,2};
    firad = pa{2};
    dist = 1000;
    alfa = 45*pi/180;
    for ndx = 1:4
        for frame = from:to
            rad = rirad + (firad-rirad)*(frame-from)/(to-from);
            diff = top(frame) - bot(frame);
            rsz = rad(1) + rad(end/2);
            scale = diff / rsz;
            cz = (top(frame) + bot(frame))/2;
            xx(:, frame) = xv(frame);
            yv = rad .* sin(th)*scale;
            zv = rad .* cos(th)*scale + cz;
            yv(yv > mxy) = mxy;
            yv(yv < -mxy) = -mxy;
            if xv(frame) < xfwd
                xval = xv(frame);
                rqdz = zrear + (zfwd-zrear)*(xval-xrear)/(xfwd-xrear);
                [mxz at] = max(zv);
                dz = rqdz - mxz;
                if(dz > 0)
%                     lz = at-flat_top;
%                     rz = at+flat_top+1;
%                     zv(lz:rz) = rqdz;
%                     y = yv - yv(lz-1);
%                     z = rqdz-1-zv;
                    r = dz*0.7;
                    if r < 5, r = 5; end
                    yp = 0;
                    zp = rqdz - r + r*(sin(alfa) + cos(alfa));
                    y = yv - yp;
                    z = zv - zp;
                    fi = atan2(y, z);
                    fi(fi > 0) = fi(fi > 0) - 2*pi;
                    [mnf fat] = max(fi);
                    zst = zv(fat);
                    dlz = (zp-zst)/(at-fat);
                    for it = fat:at                        
                        doz = zst + dlz * (it-fat);
                        zp = doz - rqdz + r;
                        yp = -yv(it);
                        alf = atan2(zp, yp);
                        if alf > alfa
                            doz = rqdz - r + sqrt(r*r - yp*yp);
                        end
                        zv(it) = doz;
                        other = at + at - it + 1;
                        zv(other) = zv(it);
                    end
%                    zv([lz-1,rz+1]) = (rqdz+doz)/2;
                    distf = xfwd - xv(frame);
                    if distf < dist
                        dist = distf;
                        back_edge_from = fat;
                        back_edge_to = at + at + 1 - fat;
                        back_edge_xv = xv(frame);
                        back_edge_y = yv(back_edge_from : back_edge_to);
                        back_edge_z = zv(back_edge_from : back_edge_to);
                    end
                end
            end
            yy(:, frame) = yv;
            zz(:, frame) = zv;
%            plot3(xx(:, frame)', yy(:, frame)', zz(:, frame)');
        end
        firad = rirad;
        if ndx < 4
            rirad = prf{ndx+1,2};
            rx = prof{ndx+1}(:,1);
            to = from;
            from = ceil(interp1(xv,1:resolution, rx(1)));
        end
    end
    % columns of xx, yy, zz are frames of the aircraft
    % rows of xx, yy, zz
    % real whittling
    yy(:,1) = 0;
    yy(:,2) = yy(:,2) / 2;
    yy(:,3) = yy(:,3) * 0.75;
    yy(:,4) = yy(:,4) * 0.866;
    str.xx = xx;
    str.yy = yy;
    str.zz = zz;
    [rows cols] = size(str.xx);
    rndx = ceil(linspace(1,2000,rows));
    cndx = ceil(linspace(1,2000,cols));
    str.clr = wallpaper(rndx, cndx, :);
    fprintf('body color is [%d x %d]\n', rows, cols)
end


function dprof = prof_mirror(prof)
    dprof = [prof; prof];  % mirror the xvalues
    dprof(:,2) = [-prof(end:-1:1, 2); prof(:,2)];
    dprof(:,3) = [ prof(end:-1:1, 3); prof(:,3)];
end


function ca = getRadii(prof, th)
    fy = prof(:,2);
    fz = prof(:,3);
    cz = (max(fz)+min(fz))/2;
    rad = sqrt((fz-cz).^2 + fy .^2);
    fth = atan2(fy, fz-cz);
    irad = polyval(polyfit(fth, rad, 4), th);
    ca{1} = cz;
    ca{2} = irad;
end


function [sp prop] = doProp(ltr)
    global back
    global resolution
    
    shape = getPoints(ltr);
    x = shape(:,1)';
    x = [x x(end:-1:1)];
    z = shape(:,3)';
    zc = z(end);  % Center of spinner 
    z = z - zc;
    z = [z -z(end:-1:1)];
    cf = polyfit(z, x, 2);
    nn = 12;
    v = linspace(z(1), z(end/2), nn);
    u = polyval(cf, v);
%     figure
%     plot(u, v);
%     hold on
%     plot(x, y, 'r+')
    % rotate u v about x axis
    th = linspace(-pi, pi, resolution);
    [xx tth] = meshgrid(u, th);
    rr = meshgrid(v, th);
    [rows cols] = size(xx);
    sp.clr = ones(rows, cols, 3);
    sp.xx = xx;
    sp.yy = rr .* sin(tth);
    sp.zz = rr .* cos(tth) + zc;
    back.xx = sp.xx(:,1);
    back.yy = sp.yy(:,1);
    back.zz = sp.zz(:,1);
    th = linspace(-pi, pi, resolution);
    u = [u(2) u(1) u(3) u(3)]
    v = [v(2), v(2)+15, v(2)+50, v(3)]
    [xx tth] = meshgrid(u, th);
    rr = meshgrid(v, th);
    [rows cols] = size(xx);
    prop.clr = ones(rows, cols, 3)/1.5;
    wd = resolution/15;
    for st = ceil(linspace(1, resolution*3/4, 4))
       prop.clr(st:st+wd,:,:) = 0; 
    end
    prop.clr(1:wd,:,:) = 0
    prop.xx = xx
    prop.yy = rr .* sin(tth)
    prop.zz = rr .* cos(tth) + zc
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


function showData(wl, wr, body, fin, prop, ant, guns, ...
                 ell, elr, sp, back, front, screen, plt) 
    global exhaust_at
    global exhaust_dv
    
    figure('units','normalized','outerposition',[0 0 1 1])
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
    ps = getPoints('v');
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
    plot([1 wdth], [ydiv ydiv], 'k')
    plot([xdiv xdiv],[1 ht], 'k')
    plot([xdiv wdth], [ydiv 1], 'k')
    for ndx = (origpts+1):npts
        plotPt(pt(ndx,:))
    end
end

function [vec lab OK] = getCoord()
    global xdiv
    global ydiv
    global halfTop
    global halfNose
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
                    plot([px px],[1 ht],'r--')
                    plot([1 wdth-py], [py py], 'r--')
                    plot([wdth-py, wdth-py], [py ht], 'r--')
                else
                    % in side view
                    x = px;
                    z = ht - py;
                    plot([px px], [1 ht], 'r--')
                    plot([1 wdth], [py py], 'r--')
                end
            else
                if py > ydiv
                    % on nose view
                    y = px - halfNose;
                    z = ht - py;
                    plot([1 wdth], [py py], 'r--')
                    plot([px px], [wdth-px ht], 'r--')
                    plot([1, px], [halfTop-y, halfTop-y], 'r--')
                end
            end
        end
        if(btn ~= 1 && btn ~= 27) 
            vec = floor(x);
            vec = [vec floor(y)];
            vec = [vec floor(z)];
            lab = char(btn);
            showPoint(vec);
        end
    end
    OK = btn ~= 27;
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


function showPoint(vec)
    fprintf('[%5d, %5d, %5d]\n', vec(1), vec(2), vec(3));
end

function plotPt(vec)
    global xdiv
    global ydiv
    global halfTop
    global halfNose
    global ht
    global wdth
    global x
    global y
    global z
    % plot top  coordinate
    px = vec(1);
    py = halfTop - vec(2);
    plot(px, py, 'r+');
    % plot side coordinate
    py = ht - vec(3);
    plot(px, py, 'r+');
    % plot node coordinate
    px = halfNose + vec(2);
    plot(px, py, 'r+');
end