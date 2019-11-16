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
    
    vecNdx = [];
    resolution = 20;
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
    quit = false;
    redraw()
    while ~quit
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
    [wingLeft wingRight] = wing('t','l','p');
    storeData()
    showData(wingLeft, wingRight)
end

function [left right] = wing(t, l, p)
% parameters are symbol for trailing edge coords, ledading edge coords and 
%  the profile (at a specific wing station
% get the coordinates of the trailing and leading edges and profile
    global resolution
    
    trail = getPoints(t);
    lead = getPoints(l);
    prof = getPoints(p);
    x = linspace(prof(1,1),prof(end,1), resolution);
    prfZ = spline(prof(:,1), prof(:,3), x);
    % adjust the profile so it is zero at each end
    prfZ = prfZ - prfZ(1);
    dp = prfZ(end);
    off = linspace(0, dp, resolution);
    prfZ = prfZ - off;
    prfZ = prfZ(end:-1:1);
    % calculate the underlying z plane
    
    % u is in the x direction (fwd)
    % v is in the spanwise direction
    % range of trailing edge x values is trail(:,1), y is trail(:,2)
    yv = linspace(trail(1,2), trail(end,2), resolution);
    for yn = 1:length(yv)
        lx = interp1(trail(:,2), trail(:,1), yv(yn));
        ux = interp1(lead(:,2), lead(:,1), yv(yn));
        zt = interp1(trail(:,2), trail(:,3), yv(yn));
        zl = interp1(lead(:,2), lead(:,3), yv(yn));
        xx(:,yn) = linspace(lx, ux, resolution);
        yy(:,yn) = ones(resolution,1) * yv(yn);
        zz(:,yn) = linspace(zt, zl, resolution);
        if yn == 1
            scale = (interp1(lead(:,2), lead(:,1), yv(2)) ...
                - interp1(trail(:,2), trail(:,1), yv(2))) ...
                / (x(end) - x(1));;
        else
            scale = (ux - lx) / (x(end) - x(1));
        end
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


function showData(up, lo) 
    global npts
    global pt
    
    figure
    for ndx = 1:npts
        it = pt(ndx,:);
        plot3(it(1), it(2), it(3), 'r+');
        hold on
    end
    surf(up.xx, up.yy, up.zz, up.clr)
    surf(lo.xx, lo.yy, lo.zz, lo.clr)
    shading interp
    axis equal
    grid on
    xlabel('X - forward')
    ylabel('Y - left')
    zlabel('Z - up')
    lightangle(45,45)
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
                    plot([wdth-px, wdth-px], [1 px], 'r--')
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