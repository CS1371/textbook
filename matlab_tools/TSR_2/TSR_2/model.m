function model
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
    clear
    clc
    close all
    
    load TSR_2.mat
    showData
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
    az = 0;
    while true
        az = az + 1;
        el = 10 - 30*cosd(az/2);
        view(az, el)
        pause(0.001)
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

function right = flipY(left)
    right = left;
    right.yy = -right.yy;
end

