function fred
clear
clc
close all
global img
% circle is in the rectangle 3100:3900,  100:900
%      H is in the rectangle 3100:3900, 1000:1500
%      F is in the rectangle 3100:3900, 2000:2500
img = imread('wallpaper7.png');
% white stripe
img(1:2000, 300:380,:) = 255;
% fuselage Roundels
copy_rect(3100, 100, 800, 800,  400, 700, 500, 200, [255, 255, 0], false)
copy_rect(3100, 100, 800, 800,  470, 730, 360, 140, [0 ,0, 180], false)
copy_rect(3100, 100, 800, 800,  540, 760, 220,  80, [255, 255, 255], false)
copy_rect(3100, 100, 800, 800,  610, 785,  80,  30, [255, 0, 0], false)
copy_rect(3100, 100, 800, 800, 1200, 700, 500, 200, [255 255 0], false)
copy_rect(3100, 100, 800, 800, 1270, 730, 360, 140, [0 ,0, 180], false)
copy_rect(3100, 100, 800, 800, 1340, 760, 220,  80, [255, 255, 255], false)
copy_rect(3100, 100, 800, 800, 1410, 785,  80,  30, [255, 0, 0], false)
% wing roundels
% on the wing, rows are chordwise, columns are spanwise
copy_rect(3100, 100, 800, 800,  320, 2153, 600, 300, [0 ,0, 180], false)
copy_rect(3100, 100, 800, 800,  495, 2240, 250, 125, [180 ,0, 0], false)
copy_rect(3100, 100, 800, 800,  320, 3000-153-300, 600, 300, [0 ,0, 180], false)
copy_rect(3100, 100, 800, 800,  495, 3000-240-125, 250, 125, [180 ,0, 0], false)
% Fuselage letters
copy_rect(3100, 1000, 800, 600,  350, 560, 400, 120, [255, 255, 255], false)
copy_rect(3100, 3000, 800, 600,  350, 500, 400, 120, [255, 255, 255], false)
copy_rect(3100, 2000, 800, 600,  300, 920, 400, 120, [255, 255, 255], false)
copy_rect(3100, 1000, 800, 600,  2000-350-400, 560, 400, 120, [255, 255, 255], false)
copy_rect(3100, 3000, 800, 600,  2000-350-400, 500, 400, 120, [255, 255, 255], false)
copy_rect(3100, 2000, 800, 600,  2000-300-400, 920, 400, 120, [255, 255, 255], true)
% rudder bars
% rudder paint is rows 1:1000, cols 3001:4000
% row 4000 is the stbd trailing edge
% row 3001 is the port trailing edge
% row 3501 is the leading edge
% col 
% blue color
% width = [1 8 14 21 25 28 31 34 37 39 42 44 46 48 50 52 54 55 ...
%     55 56 57 57 58 58 58 58 58 58 58 58 57  57 57 56 56 55 ...
%     55 54 54 53 52 51 51 50 49 48 48 47 46 45 45 44 43 43 42 ...
%     42 41 41 40 40 40 39 39 39 38 38 37 37 36 36 36 35  35 ...
%     35 34 34 33 33 33 32 32 31 31 30 29 28 27 26 25 24 22 ...
%     21 19 18 16 14 12 8 5 1];
% 
% back = [23 19.6 16.2222   12.8333   11.5354   10.9192   10.3030    9.6869    9.0707 ...
%     8.4545    7.8384    7.2222    6.6061    5.9899    5.3737    4.7576    4.1414    3.9661 ...
%     3.9221    3.8781    3.8341    3.7900    3.7460    3.7020    3.6580    3.6140    3.5700 ...
%     3.5260    3.4820    3.4380    3.3939    3.3499    3.3059    3.2619    3.2179    3.1739 ...
%     3.1299    3.0859    3.0418    3.0022    3.0462    3.0902    3.1342    3.1782    3.2222 ...
%     3.2662    3.3102    3.3543    3.3983    3.4423    3.4863    3.5303    3.5743    3.6183 ...
%     3.6623    3.7063    3.7504    3.7944    3.8384    3.8824    3.9264    3.9704    4.0722 ...
%     4.2922    4.5123    4.7323    4.9524    5.1724    5.3925    5.6126    5.8326    6.0527 ...
%     6.2727    6.4928    6.7128    6.9329    7.1530    7.3730    7.5931    7.8131    8.0332 ...
%     8.2532    8.4733    8.6934    8.9134    9.3737    9.9899   10.6061   11.2222   11.8384 ...
%     12.4545   13.0707   13.6869   14.3030   14.9192   15.5354   16.5303   18.6869   20.8434 ...
%     23.0000];
% 
% br = [1100 3850];
% bl = [1100 3900];
% tr = [1700 3650];
% tl = [1700 3850];
% ml = [1300 3870];
% mr = [1300 3800];
% fill_poly([br bl ml tl tr mr], [0, 0, 255])
image(img)
axis equal
imwrite(img, 'wallpaper8.png','png')
end

function fill_poly(vec, clr)
    global img
%   vec defines the polygon clockwise [r1 c1 r2 c2 r3 c3 ...]
    
    
    polyY = vec(1:2:end);
    polyX = vec(2:2:end);
    % find the range of values
    [~, where] = min(polyY);
    top = polyY(where);
    [~, where] = max(polyY);
    bot = polyY(where);
    [~, where] = min(polyX);
    lft = polyX(where);
    [~, where] = max(polyX);
    rt = polyX(where);
    polyCorners = length(polyX);
    
% int  nodes, nodeX[MAX_POLY_CORNERS], pixelX, pixelY, i, j, swap ;
% 
% //  Loop through the rows of the image.
% for (pixelY=IMAGE_TOP; pixelY<IMAGE_BOT; pixelY++) {
    for pixelY = top:bot
% 
%   //  Build a list of nodes.
        nodes=1; j=polyCorners;
    %   for (i=0; i<polyCorners; i++) {
            for i = 1:polyCorners
    %     if (polyY[i]<(double) pixelY && polyY[j]>=(double) pixelY
    %     ||  polyY[j]<(double) pixelY && polyY[i]>=(double) pixelY) {
                if polyY(i) < pixelY && polyY(j) >= pixelY ...
                 || polyY(j) < pixelY && polyY(i) >= pixelY
    %       nodeX[nodes++]=(int) (polyX[i]+(pixelY-polyY[i])/(polyY[j]-polyY[i])
    %       *(polyX[j]-polyX[i])); }
                    nodeX(nodes) = ceil(polyX(i) + ...
                                   (pixelY-polyY(i))/(polyY(j) - polyY(i)) ...
                                   * (polyX(j) - polyX(i)) );
                    nodes = nodes + 1;
                end
    %     j=i; }
                j = i;
            end
    % 
    %   //  Sort the nodes, via a simple “Bubble” sort.
    cmx = nodes-2;
    for row = 1:(nodes-2)
        for col = 1:cmx
            if nodeX(col) > nodeX(col+1)
                tmp = nodeX(col); 
                nodeX(col) = nodeX(col+1); 
                nodeX(col+1) = tmp;
            end
        end
        cmx = cmx - 1;
    end
    % 
    %   //  Fill the pixels between node pairs.
    %   for (i=0; i<nodes; i+=2) {
        for i = 1:2:(nodes-1)
    %     if   (nodeX[i  ]>=IMAGE_RIGHT) break;
            if nodeX(i) > rt, break, end
    %     if   (nodeX[i+1]> IMAGE_LEFT ) {
            if nodeX(i+1) > lft
    %       if (nodeX[i  ]< IMAGE_LEFT ) nodeX[i  ]=IMAGE_LEFT ;
                if nodeX(i) < lft, nodeX(i) = lft; end
    %       if (nodeX[i+1]> IMAGE_RIGHT) nodeX[i+1]=IMAGE_RIGHT;
                if nodeX(i+1) > rt, nodeX(i+1) = rt; end
    %       for (j=nodeX[i]; j<nodeX[i+1]; j++) fillPixel(j,pixelY); }}}
                for j = nodeX(i):nodeX(i+1)
                    img(pixelY, j, 1) = clr(1);
                    img(pixelY, j, 2) = clr(2);
                    img(pixelY, j, 3) = clr(3);
                end
            end
        end
    end
end


function copy_rect(frw, fcl, fht, fwd, trw, tcl, tht, twd, cvec, flip)
    global img
    trnd = trw:(trw+tht-1);
    if flip
        tcnd = (tcl+twd-1):-1:tcl;
    else
        tcnd = tcl:(tcl+twd-1);
    end
    frnd = ceil(linspace(frw, frw+fht-1, tht));
    fcnd = ceil(linspace(fcl, fcl+fwd-1, twd));
    for r = 1:tht
        for c = 1:twd
            if img(frnd(r), fcnd(c), 1) > 100
                for cl = 1:3
                    img(trnd(r), tcnd(c), cl) = cvec(cl);
                end
            end
        end
    end
end



