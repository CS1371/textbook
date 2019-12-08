clear
clc
close all

str1 = 'The quality of mercy is not strain''d\n';
str2 = 'It droppeth as the gentle rain from heav''n\n';
str3 = 'Upon the earth beneath\n';
str = sprintf('%s', [str1 str2 str3]);
% Draw the paper tape

w = 3.75;
nw = 375;
pix_per_inch = nw/w;
l = 60;
nl = 6000;
leader = 40;
box = nw * 0.4 / w;
lead_r = 0.1;
data_r = 0.125;
gap = 0.15;
start_gap = gap + data_r;
delta_gap = gap + 2*data_r;
hole_edge = delta_gap*pix_per_inch;
small_r = lead_r * pix_per_inch;
small_hole = make_hole(hole_edge, small_r);
big_r = data_r * pix_per_inch;
big_hole = make_hole(hole_edge, big_r);
x = linspace(0,l,nl);
y = linspace(0,w,nw);
[xx yy] = meshgrid(x, y);
zz = sin(xx) + sin(xx/3);
img = zeros(nw, nl, 3);
img(:,:,1) = 0.2;
img(:,:,2) = 0.2;
img(:,:,3) = 0.5;
% put in the leader
xat = l.*pix_per_inch - box/2;
yat = ceil((start_gap + 5*delta_gap).*pix_per_inch);
for it = 1:leader
    xp = xat - hole_edge ./ 2;
    xpt = (xp+hole_edge-1);
    yp = yat - hole_edge ./ 2;   
    ypt = (yp+hole_edge-1);
    patch = img(yp:ypt, xp:xpt, :);
    patch = patch .* small_hole;
    img(yp:ypt, xp:xpt, :) = patch;
    xat = xat - hole_edge
end
% put data rows
try
    for is = 1:length(str)
%        xat = l.*pix_per_inch - box/2;
        yat = start_gap * pix_per_inch;
        ch = set_odd_parity(str(is));
        mask = uint8(1);
        for it = 1:9
            xp = ceil(xat - hole_edge ./ 2);
            xpt = (xp+hole_edge-1);
            yp = ceil(yat - hole_edge ./ 2);   
            ypt = (yp+hole_edge-1);
            patch = img(yp:ypt, xp:xpt, :);
            if it == 6
                patch = patch .* small_hole;
            else
                ck = bitand(mask, ch);
                mask = bitshift(mask,1);
                if ck
                    patch = patch .* big_hole;
                end
            end
            img(yp:ypt, xp:xpt, :) = patch;
            yat = yat + hole_edge;
        end
        xat = xat - hole_edge;
    end
catch
    gotcha = true;
end
surf(xx, yy, zz, 1 - img)
axis equal 
axis off
shading interp
xlabel('X')
ylabel('Y')
zlabel('Z')


function ch = set_odd_parity(ch)
    
    bits = 0;
    mask = uint8(1);
    uch = uint8(ch);
    for bit = 1:7
       if bitand(mask, uch)
           bits = bits + 1;
       end
       mask = bitshift(mask,1);
    end
    res = bitand(1, bits);
    if res == 0
         ch = ch + 128;
    end
    ch = uint8(ch);
end


function hole = make_hole(side, rad)
    hole = ones(side, side, 3);
    c = ceil(side/2);
    rsq = rad.^2;
    for ix = 1:side
       for iy = 1:side 
           prsq = (ix - c).^2 + (iy - c).^2;
           if prsq <= rsq
                hole(ix, iy, :) = 0;
           end
       end
    end
end



