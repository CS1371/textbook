function F_117a
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
    global resolution
    global bod_clr
    global blk_clr
    global gold_clr
    global flat
    global dflat
    global field
    global plane

    xdiv = 739;
    ydiv = 466;
    field = {'xx','yy','zz'};
    resolution = 256;
    bod_clr = [0 0 0];
    blk_clr = [0.2 0.2 0.2];
    gold_clr = [0.5 0.5 0];
    surfImg = zeros(resolution*5,resolution,3);
    for clr = 1:3
        surfImg(:,:,clr) = bod_clr(clr);
    end
    recompute = true;
    newData = true;
    vecNdx = [];
    if recompute, rs = ''; else,rs = 'don''t'; end
    if newData, ds = ''; else,ds = 'don''t'; end
    fprintf('%s recompute; %s input new data; resolution %d\n', ...
        rs, ds, resolution);
    plane = imread('f_3_v.bmp');
    [ht, wdth, ~] = size(plane)
    halfFront = 990;
    halfTop = 230;
    x = 0;
    y = 0;
    z = 0;
    recoverData()
    if recompute
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
        flat = [];
        flat = [flat makeFlat('a', 1:3,'plain')];
%        flat = [flat makeFlat('a', [1 4 3],'plain')];
        flat = [flat makeFlat('a', [1 37 38 3],'plain')];
        flat = [flat makeFlat('a', [35 38 37 36],'gold')];
        flat = [flat makeFlat('a', [4 35 36],'plain')];
%        flat = [flat makeFlat('a', [3 4 5],'plain')];
        flat = [flat makeFlat('a', [3 38 39 5],'plain')];
        flat = [flat makeFlat('a', [39 38 35 34],'gold')];
        flat = [flat makeFlat('a', [34 35 4],'plain')];
%        flat = [flat makeFlat('a', 4:8,'plain')];
        flat = [flat makeFlat('a', [5 39 40 33 34 4 8 7 6],'plain')];
        flat = [flat makeFlat('a', [5 6 9 10],'plain')];
        flat = [flat makeFlat('a', [40 39 34 33],'gold')];
        flat = [flat makeFlat('a', [6 7 11 9],'black')];
        flat = [flat makeFlat('a', [7 8 12 11],'plain')];
        flat = [flat makeFlat('a', [9 11 12 13 10],'plain')];
        flat = [flat makeFlat('a', [4 8 14 15],'plain')];
        flat = [flat makeFlat('a', [14 15 16 17],'plain')];
        flat = [flat makeFlat('a', [ 8 14 17 18 ],'plain')];
        flat = [flat makeFlat('a', [ 8 18 12 ],'plain')];
        flat = [flat makeFlat('a', [ 13 12 18 19 30 ],'plain')];
        flat = [flat makeFlat('a', [ 19 18 23 25 20 21 ],'plain')];
%        flat = [flat makeFlat('a', [ 18 22 23 ],'plain')];
        flat = [flat makeFlat('a', [ 18 17 24 25 ],'plain')];
%        flat = [flat makeFlat('a', [ 18 17 22 ],'plain')];
        flat = [flat makeFlat('a', [ 16 26 28 27 24 ],'plain')];
        flat = [flat makeFlat('a', [ 17 16 24 ],'plain')];
        flat = [flat makeFlat('a', [ 25 24 27 ],'plain')];
        flat = [flat makeFlat('a', [ 20 25 27 28 ],'plain')];
        flat = [flat makeFlat('a', [ 29 20 28 26 ],'plain')];
        flat = [flat makeFlat('a', [ 21 20 29 ],'plain')];
        flat = [flat makeFlat('a', [ 2 3 5 10 13 31 ],'plain')];
        flat = [flat makeFlat('a', [ 31 13 30 19 21 20 32 26],'plain')];
        flat = [flat makeFlat('f', [ 1 2 3 4 ],'plain')];
        flat = [flat makeFlat('f', [ 3 2 5 6 ],'plain')];
        flat = [flat makeFlat('f', [ 6 5 7 8 ],'plain')];
        flat = [flat makeFlat('f', [ 4 8 7 1 ],'plain')];
        flat = [flat makeFlat('f', [ 4 3 6 8 ],'plain')];
        flat = [flat makeFlat('w', [ 1 2 3 7 8 ],'plain')];
        flat = [flat makeFlat('w', [ 3:7 ],'plain')];
        flat = [flat makeFlat('w', [ 8 7 9 10 ],'plain')];
        flat = [flat makeFlat('w', [ 7 6 11 9 ],'plain')];
        flat = [flat makeFlat('w', [ 6 5 12 11 ],'plain')];
        flat = [flat makeFlat('w', [ 10 9 11 12 13 14 ],'plain')];
        flat = [flat makeFlat('w', [ 8 17 16 15 1 ],'plain')];
        flat = [flat makeFlat('w', [ 5 18 16 17 19 ],'plain')];
        flat = [flat makeFlat('w', [ 8 10 9 17 ],'plain')];
        flat = [flat makeFlat('w', [ 11 19 17 9 ],'plain')];
        flat = [flat makeFlat('w', [ 19 11 12 5 ],'plain')];
        dflat = [];
        try
            for ndx = 1:length(flat)
                if ndx == 6
                    gotcha = true;
                end
                dflat = [dflat doFlat(flat(ndx))];
            end
        catch
            oops = true;
        end
        figure('units','normalized','outerposition',[0 0 1 1])
        !rm f_117a.mat
        save('f_117a.mat')
        showData()
    end
end

function showData()
global flats
global dflat
global stop

    for f = dflat
        drawFlat(f);
    end
    set(gcf, 'color', [0.7,0.7,1])
    axis equal
    axis tight
    axis off
    material([0.3 0.8 0.2])
    xlabel('Forward')
    ylabel('Starboard')
    zlabel('Up')
    grid on
    az = 20;
    el = 25;
    lightangle(30,80)
    lightangle(5,40)
    view(az, el)
    saveas(gcf,'../F_117.png')
%     az = 0;
%     el = 0;
%     lightangle(30,80)
%     stop = false;
%     set(gcf,'keypressfcn',@kpfcn)
%     while ~stop
%         view(az, el)
%         az = az + 0.3;
%         el = 10 - 30*cosd(az*.419);
%         pause(0.03)
%     end
end

function f = makeFlat(ltr, rng, typ)
    f.letter = ltr;
    f.range = rng;
    f.type = typ;
end

function kpfcn(obj,event)
    global stop
    ck=get(obj,'currentkey');
    stop = true;
end

function drawFlat(f)
global bod_clr
global blk_clr
    global gold_clr
    switch f.type
        case 'plain'
           sa = fill3(f.x, f.y, f.z, bod_clr);
           set(sa,'EdgeColor','none')
           hold on
           sa = fill3(f.x, -f.y, f.z, bod_clr);
           set(sa,'EdgeColor','none')
        case 'black'
           fill3(f.x, f.y, f.z, blk_clr)
           hold on
           fill3(f.x, -f.y, f.z, blk_clr)
        case 'gold'
           sa = fill3(f.x, f.y, f.z, gold_clr);
           set(sa,'FaceAlpha',0.5)
           hold on
           sa = fill3(f.x, -f.y, f.z, gold_clr);
           set(sa,'FaceAlpha',0.5)
    end
end


function df = doFlat(f)
    v = getPoints(f.letter);
    v = v(f.range,:);
    df = f;
   df.x = v(:,1)'; 
   df.y = v(:,2)'; 
   df.z = v(:,3)'; 
end


function right = flipY(left)
    right = left;
    right.yy = -right.yy;
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
    myPlot([ydiv ydiv], [1 wdth], 'c--')
    myPlot([1 ht], [xdiv xdiv],'c--')
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