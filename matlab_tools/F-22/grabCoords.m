function grabCoords
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
    global pt
    global vecNdx
    global plane
    global resolution
    global fuseLeft
    global fuseRight
    global wingLeft
    global wingRight
    global noseLeft
    global noseRight
    global finLeft
    global finRight
    global elevLeft
    global elevRight
    global canopy
    global pilot
    global intake
    
    resolution = 50;
    recompute = true;
    newData = false;
    wingLeft = [];
    wingRight = [];
    fuseLeft = [];
    fuseRight = [];
    noseLeft = [];
    noseRight = [];
    finLeft = [];
    finRight = [];
    elevLeft = [];
    elevRight = [];
    canopy = [];
    intake = [];
    vecNdx = [];
    if recompute, rs = '';, else,rs = 'don''t';, end 
    if newData, ds = '';, else,ds = 'don''t';, end 
    fprintf('%s recompute; %s input new data; resolution %d\n', ...
        rs, ds, resolution);
    ydiv = 810;
    halfTop = floor(ydiv/2);
    xdiv = 1134;
    plane = imread('F22.jpg');
    [ht wdth junk] = size(plane);
    halfNose = xdiv + floor((wdth - xdiv)/2);
    x = 0;
    y = 0;
    z = 0;
    recoverData()
    if recompute
        wingLeft = [];
        fuseLeft = [];
        noseLeft = [];
        finLeft = [];
        elevLeft = [];
        canopy = [];
        intake = [];
    end
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
    if isempty(wingLeft)
        [wingLeft wingRight] = wing('t','l','p');
    end
    if isempty(fuseLeft)
        [fuseLeft fuseRight] = fuselage('b','c','C','d','e','f');
    end
    if isempty(noseLeft)
        [noseLeft noseRight] = nose('g','h','i', 'n');
    end
    if isempty(finLeft)
        [finLeft finRight] = fin('j','p');
    end
    if isempty(elevLeft)
        [elevLeft elevRight] = elevon('k','m','p');
    end
    if isempty(canopy)
        [pilot canopy] = doCanopy('u','v','w','x');
    end
    if isempty(intake)
        intake = doIntake('o');
    end
    storeData()
    showData(wingLeft, wingRight, fuseLeft, fuseRight, .... 
        noseLeft, noseRight, finLeft, finRight, ... 
        elevLeft, elevRight, canopy, pilot, intake )
end

function ntk = doIntake(ltr)
    global resolution

    edge = getPoints(ltr);
    y = edge(:,2)';
    z = edge(:,3)';
%     figure
%     xv = edge(2,1);
%     xvs = xv*ones(1,length(y));
%     plot3(xvs, y, z)
%     hold on
%     for ndx = 1:length(y)
%         str = sprintf('%d', ndx);
%         text(y(ndx), z(ndx), str)
%     end
    ze = z(2:4);
    ye = y(2:4);
    zv = linspace(y(2), y(4), resolution);
    xvs = edge(1,1)*ones(1,resolution);
    for ndx = 1:resolution
        xx(:,ndx) = xvs;
        left = interp1(ze, ye, zv(ndx));
        yy(:,ndx) = linspace(left, -left, resolution);
        zz(:,ndx) = zv(ndx)*ones(1,resolution);
    end
    clr = zeros(resolution, resolution, 3);
    surf(xx, yy, zz, clr)
    ntk.xx = xx;
    ntk.yy = yy;
    ntk.zz = zz;
    ntk.clr = clr;
end


function [pilot canopy] = doCanopy(riml, midProf, frntProf, sideProf)
    global resolution

    rim = getPoints(riml);
    midP = getPoints(midProf);
    omidP = midP(end:-1:1,:);
    omidP(:,2) = -omidP(:,2);
    frntP = getPoints(frntProf);
    ofrntP = frntP(end:-1:1,:);
    ofrntP(:,2) = -ofrntP(:,2);
    sideP = getPoints(sideProf);
    midP = [omidP; midP]; 
    frntP = [ofrntP; frntP]; 
    rimYCoeff = polyfit(rim(:,1), rim(:,2), 2);
    sideZCoeff = polyfit(sideP(:,1), sideP(:,3), 3); 
    xfrom = 791;
    xto = 978.5;
    x = linspace(xfrom, xto, resolution);
    [ht where] = max(polyval(sideZCoeff, x));
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
        cZ = polyval(sideZCoeff, xv);
        y = linspace(rY, -rY, resolution);
        xx(ndx, :) = xv * ones(1, resolution);
        yy(ndx, :) = linspace(rY, -rY, resolution);
        zz(ndx, :) = (rZ - cZ) .* (y / rY) .^ 2 + cZ;
    end
    canopy.xx = xx;
    canopy.yy = yy;
    canopy.zz = zz;
    canopy.clr = clr;
    [xx yy zz] = sphere(resolution/2);
    [r c] = size(xx);
    headSize = 18;
    pilot.xx = xx*headSize + x(where) + 20;
    pilot.yy = yy*headSize;
    pilot.zz = zz*headSize + ht - 5 - headSize;
    pilot.clr = ones(r, c, 3);
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

function [left right] = elevon(trl, ld, p)
    global resolution
    
    [prfZ x] = getZProfile(p);
    tr = getPoints(trl);
    le = getPoints(ld);
    trly = tr(:, 2);
    trlx = tr(:, 1);
    ley =  le(:, 2);
    lex =  le(:, 1);
    zval = 8 + mean([tr(:,3)' le(:,3)']);
    y = linspace(ley(1),ley(2), resolution);
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
        uzz(yn, :) = zval + prfZ' * scale;
        lzz(yn, :) = zval - prfZ' * scale;
    end
    left.xx = [ xx, xx(end:-1:1,:)];
    left.yy = [ yy, yy(end:-1:1,:)];
    left.zz = [uzz,lzz(end:-1:1,:)];
    left.clr = ones(resolution, resolution*2, 3) * 0.7;
    right = left;
    right.yy = -left.yy;
end

function [left right] = fin(data, p)
    global resolution
    
    [prfZ x] = getZProfile(p);
    c = getPoints(data);
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

function [left right] = nose(top, bot, lft, tp)
% parameters are symbols for top & bot profiles and  
%  left side of the shape
% get the coordinates of the trailing and leading edges and profile
    global resolution
    
    topSide = getPoints(top);
    botSide = getPoints(bot);
%     figure
%     plot3(topSide(:,1), topSide(:,2), topSide(:,3), 'k')
%     hold on
%     plot3(botSide(:,1), botSide(:,2), botSide(:,3))
    grid
    lprof = getPoints(lft);
    tprof = getPoints(tp);
    % non-dimensionalize z axis
    yprof = lprof(end:-1:1,2);
    zprof = lprof(end:-1:1,3);
    zprof = zprof / max(zprof);
    zprof(1) = 0;
    yv = polyval(polyfit(zprof, yprof, 4), linspace(0, 1, resolution));
    yv(1) = yprof(1);
    yv(end) = yprof(end);
    yv = yv ./ max(yv);
    zv(1) = zprof(1);
    zv(end) = zprof(end);
    mnx = min(topSide(:,1));
    mxx = max(topSide(:,1));
    xrange = linspace(mnx, mxx, resolution);
    ypr = polyval(polyfit(tprof(end:-1:1, 1), ...
                          tprof(end:-1:1, 2), 4), xrange) ;
    mzdif = 0;
    for ndx = 1:resolution
        x = xrange(ndx);
        zl = spline(botSide(:,1)', botSide(:,3)', x);
        zu = spline(topSide(:,1)', topSide(:,3)', x);
        zv = linspace(zl, zu, resolution);
        if zu - zl > mzdif, mzdif = zu - zl; end
        xx(ndx,:) = xrange;
        zz(:,ndx) = zv;
        % scale zv to 0 .. 1
        zv = (zv - zl) ./ (zu - zl);
        yy(:,ndx) = yv * ypr(ndx);
    end
    left.xx = xx;
    left.yy = yy;
    left.zz = zz;
    left.clr = ones(resolution, resolution, 3) * 0.7;
    right = left;
    right.yy = -right.yy
end

function [left right] = fuselage(t, ul, ll, upx, py, lpx)
% parameters are symbol for trailing edge coords, leading edge coords and 
%  the x and y profiles of the shape
% get the coordinates of the trailing and leading edges and profile
    global resolution
    
    trail = getPoints(t);
    trail = trail(1:end-1,:);
    %  temporarily remove repeated y values
    ty = trail(:,2)';
    for ndx = length(ty):-1:2
        if ty(ndx) == ty(ndx-1)
            trail(ndx,2) = trail(ndx-1,2) + 0.01;
        end
    end
    ulead = getPoints(ul);
    llead = getPoints(ll);
    uprofX = getPoints(upx);
    lprofX = getPoints(lpx);
    profY = getPoints(py);
    ycorner = 80;
    uxvals = [trail(:,1); ulead(:,1)]';
    uyvals = [trail(:,2); ulead(:,2)]';
    lxvals = [trail(:,1); llead(:,1)]';
    lyvals = [trail(:,2); llead(:,2)]';
    uxrange = linspace(min(uxvals), max(uxvals), resolution);
    uyrange = linspace(min(uyvals), max(uyvals), resolution);
    lxrange = linspace(min(lxvals), max(lxvals), resolution);
    lyrange1 = linspace(min(lyvals), ycorner, resolution/2);
    lyrange2 = linspace(ycorner+1, max(lyvals), resolution/2);
    lyrange = [lyrange1 lyrange2];
    [uxx uyy] = meshgrid(uxrange, uyrange);
    [lxx lyy] = meshgrid(lxrange, lyrange);
    % check for values off the edges
    for ndx = resolution:-1:1
        uxvals = uxx(ndx,:);
        uyv = uyrange(ndx);
        tx = interp1(trail(:,2)', trail(:,1)', uyv);
        uxvals(uxvals < tx) = tx;
        tx = interp1(ulead(:,2)', ulead(:,1)', uyv);
        uxvals(uxvals > tx) = tx;
        uxx(ndx,:) = uxvals;
        lxvals = lxx(ndx,:);
        lyv = lyrange(ndx);
        tx = interp1(trail(:,2)', trail(:,1)', lyv);
        lxvals(lxvals < tx) = tx;
        tx = interp1(llead(:,2)', llead(:,1)', lyv);
        lxvals(lxvals > tx) = tx;
        lxx(ndx,:) = lxvals;
    end
    outBack = trail(3,end);  % z value of the outer trailing edge
    outFront = ulead(3,end);  % .................... leading
    level = 12 + min([outBack outFront]);
    uprxy = uprofX(:,2)';
    uprxz = uprofX(:,3)';
    lprxy = lprofX(:,2)';
    lprxz = lprofX(:,3)';
    uprxz = uprxz - min(uprxz);
    lprxz = lprxz - max(lprxz);
    pryx = profY(:,1)';
    pryz = profY(:,3)';
    pryz = pryz - min(pryz);
    pryz = pryz/max(pryz);
    % compute the zz values across the fuselage
    for nx = resolution:-1:1
        for ny = resolution:-1:1
            uxv = uxx(nx, ny);
            lxv = lxx(nx, ny);
            uyv = uyy(nx, ny);
            lyv = lyy(nx, ny);
            uprf = polyval(polyfit(uprxy, uprxz, 2), uyv);
            lprf = interp1(lprxy, lprxz, lyv);
            uscale = spline(pryx, pryz, uxv);
            lscale = spline(pryx, pryz, lxv);
            uzz(nx, ny) = level + uscale * uprf;
            lzz(nx, ny) = level + lscale * lprf;
        end
    end
    left.xx = [uxx lxx(end:-1:1,:)];
    left.yy = [uyy lyy(end:-1:1,:)];
    left.zz = [uzz lzz(end:-1:1,:)];
    left.clr = ones(resolution, resolution*2, 3) * 0.7;
    right = left;
    right.yy = -left.yy;
end


function [left right] = wing(t, l, p)
% parameters are symbol for trailing edge coords, leading edge coords and 
%  the profile (at a specific wing station)
% get the coordinates of the trailing and leading edges and profile
    global resolution
    
    trail = getPoints(t);
    lead = getPoints(l);
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
    left.xx = [xx xx(end:-1:1,:)];
    left.yy = [yy yy(end:-1:1,:)];
    left.zz = [uzz lzz(end:-1:1,:)];
    left.clr = ones(resolution, resolution*2, 3) * 0.7;
    right = left;
    right.yy = -left.yy;
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


function showData(wl, wr, fl, fr, nl, nr, fnl, fnr, ...
                 ell, elr, cnpy, plt, ntk) 
    global npts
    global pt
    
    figure
    for ndx = 156:npts
        it = pt(ndx,:);
        plot3(it(1), it(2), it(3), 'r+');
        hold on
    end
    nTake = getPoints('o');
    surf(wl.xx, wl.yy, wl.zz, wl.clr)
    hold on
    surf(wr.xx, wr.yy, wr.zz, wr.clr)
    surf(fl.xx, fl.yy, fl.zz, fl.clr)
    surf(fr.xx, fr.yy, fr.zz, fr.clr)
    surf(nl.xx, nl.yy, nl.zz, nl.clr)
    surf(nr.xx, nr.yy, nr.zz, nr.clr)
    surf(fnl.xx, fnl.yy, fnl.zz, fnl.clr)
    surf(fnr.xx, fnr.yy, fnr.zz, fnr.clr)
    surf(ell.xx, ell.yy, ell.zz, ell.clr)
    surf(elr.xx, elr.yy, elr.zz, elr.clr)
    surf(plt.xx, plt.yy, plt.zz, plt.clr)
%    surf(ntk.xx, ntk.yy, ntk.zz, ntk.clr)
    s1 = surf(cnpy.xx, cnpy.yy, cnpy.zz, cnpy.clr);
    set(s1, 'FaceAlpha', 0.5)
    material metal
    set(gcf, 'color', [0.8,0.8,1])
    shading interp
    axis equal
    axis off
    grid on
    xlabel('X - forward')
    ylabel('Y - left')
    zlabel('Z - up')
    lightangle(45,45)
    view(200, 25)
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


function storeIt(fid, title, data)
    global resolution
    
    fprintf(fid,'%s %d\n', title, resolution );
    outputMesh(fid, data.xx)
    outputMesh(fid, data.yy)
    outputMesh(fid, data.zz)
    outputColor(fid, data.clr)
end


function storeData()
    global npts
    global pt
    global vecNdx
    global resolution
    global wingLeft
    global wingRight
    global fuseLeft
    global fuseRight
    global noseLeft
    global noseRight
    global finLeft
    global finRight
    global elevLeft
    global elevRight
    global canopy
    global pilot
    
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
    storeIt(fid,'wingLeft', wingLeft)
    storeIt(fid,'wingRight', wingRight)
    storeIt(fid,'fuseLeft', fuseLeft)
    storeIt(fid,'fuseRight', fuseRight)
    storeIt(fid,'noseLeft', noseLeft)
    storeIt(fid,'noseRight', noseRight)
    storeIt(fid,'finLeft', finLeft)
    storeIt(fid,'finRight', finRight)
    storeIt(fid,'elevLeft', elevLeft)
    storeIt(fid,'elevRight', elevRight)
    storeIt(fid,'canopy', canopy)
    storeIt(fid,'pilot', pilot)
end

function outputMesh(fid, ww)
    [rows cols] = size(ww);
    fprintf(fid,'%d %d\n', rows, cols);
    for r = 1:rows
        for c = 1:cols
            fprintf(fid, '%4.3f ', ww(r,c));
        end
        fprintf(fid, '\n');
    end
end

function outputColor(fid, clr)
    [rows cols junk] = size(clr);
    fprintf(fid,'%d %d %d\n', rows, cols, junk);
    for cl = 1:3
        for r = 1:rows
            for c = 1:cols
                fprintf(fid, '%4.3f ', clr(r,c));
            end
            fprintf(fid, '\n');
        end
    end
end

function recoverData() 
    global npts
    global pt
    global vecNdx
    global wingLeft
    global wingRight
    global noseLeft
    global noseRight
    global fuseLeft
    global fuseRight
    global finLeft
    global finRight
    global elevLeft
    global elevRight
    global canopy
    global pilot
    
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
        isMore = true;
        while isMore
            str = fgetl(fid);  % structure name
            isMore = ischar(str);
            if isMore
                str = strtok(str, ' ');
                switch str
                    case 'wingRight'
                        wingRight = getArrays(fid);
                    case 'wingLeft'
                        wingLeft = getArrays(fid);
                    case 'fuseRight'
                        fuseRight = getArrays(fid);
                    case 'fuseLeft'
                        fuseLeft = getArrays(fid);
                    case 'noseRight'
                        noseRight = getArrays(fid);
                    case 'noseLeft'
                        noseLeft = getArrays(fid);
                    case 'finRight'
                        finRight = getArrays(fid);
                    case 'finLeft'
                        finLeft = getArrays(fid);
                    case 'elevRight'
                        elevRight = getArrays(fid);
                    case 'elevLeft'
                        elevLeft = getArrays(fid);
                    case 'canopy'
                        canopy = getArrays(fid);
                    case 'pilot'
                        pilot = getArrays(fid);
                end
            end
        end
        !copy data_so_far.txt backup_data.txt
    end
end

function st = getArrays(fid)
    str = fgetl(fid);
    dim = str2num(str);
    rows = dim(1);
    cols = dim(2);
    st.xx = zeros(rows, cols);
    st.yy = st.xx;
    st.zz = st.xx;
    st.clr = zeros(rows, cols, 3);
    for r = 1:rows
        st.xx(r,:) = getCols(fid);
    end
    str = fgetl(fid);
    dim = str2num(str);
    for r = 1:rows
        st.yy(r,:) = getCols(fid);
    end
    str = fgetl(fid);
    dim = str2num(str);
    for r = 1:rows
        st.zz(r,:) = getCols(fid);
    end
    str = fgetl(fid);
    dim = str2num(str);
    for cl = 1:3
        for r = 1:rows
            st.clr(r,:, cl) = getCols(fid);
        end
    end
end

function vec = getCols(fid)
    str = fgetl(fid);
    vec = str2num(str);
end

function redraw() 
    global npts
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
    for ndx = 1:npts
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
                    % in top view
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