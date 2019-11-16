function getProfiles
    clear
    clc
    close all
    
    global origpts
    global npts
    global pt
    global img
    
    img = imread('profiles.gif');
    imshow(img)
    recoverData()
    origpts = npts;
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
    storeData()
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
    global img

    hold off
    imshow(img)
    hold on
    for ndx = (origpts+1):npts
        plotPt(pt(ndx,:))
    end
end

function [vec, lab, OK] = getCoord()
    global x
    global y
    global z
    global mx
    global kx
    global my
    global ky
    
    btn = 1;
    vec = [];
    lab = char(27);
    mx = 116/1606;
    kx = -1658*116/1606;
    ky = 780;
    my = 8/116;
    while btn == 1
        [px, py, btn] = ginput(1);
        if btn ~= 27
            x = px*mx + kx;
            y = py - ky + my*x;
            z = 0;
        end
        if(btn ~= 1 && btn ~= 27) 
            vec = [x, y, z];
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
    
    % plot top  coordinate
    px = vec(1);
    py = vec(2);
    plot(px, py, 'r+');
end

