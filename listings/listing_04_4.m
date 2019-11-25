% listing_04_5
% moving earth
clear; clc; close all
    % lay out scenery for road cut
    
    global x
    global y
    global z
    global A
    global yr
    global clr
    global sxp
    global syp
    global szp
    global road_z
    global dbg
    global l_edge_ndx
    global r_edge_ndx
    global top
    global bot
     
    dbg = fopen('debug.log', 'w');
    road_z = 0;
    grey = [0.8 0.8 0.8];
    load('../xyz.mat')
    tth = x;
    pphi = y;
    zz = z;
    % road lines are phi = 2.4 - 2.6
    %                th = min - maxA =
    %                zz = 0
    xr = [th(1) th(1) th(end) th(end)];
    yr = [2.4 2.6 2.6 2.4];
    [xxr yyr] = meshgrid(xr, yr);
    zzr = xxr .* 0;
    [rr, rc] = size(xxr);
    img = uint8(zeros(rr, rc, 3) + 100);
    surf(xxr, yyr, zzr, img)   % road
    hold on
    % surfaces 45 deg from road edges are
    %   z = 2.4 - y
    %   z = y - 2.4
    %   z = 2.6 + y
    %   z = -y - 2.6
    zv = 2;
    xp = xr;
    yp = [yr(1), yr(1)-zv, yr(1)-zv, yr(1)];
    [xxp yyp] = meshgrid(xp, yp);
    zp = yr(1) - yyp;
    sxp{1} = xp;
    sxp{2} = xp;
    syp{1} = yp;
    syp{2} = yp;
    szp{1} = zp;
    szp{2} = -zp;
    yp = [yr(2), yr(2)+zv, yr(2)+zv, yr(2)];
    [xxp yyp] = meshgrid(xp, yp);
    zp = yr(2) - yyp;
    sxp{3} = xp;
    sxp{4} = xp;
    syp{3} = yp;
    syp{4} = yp;
    szp{3} = zp;
    szp{4} = -zp;
    % now, find the contours
    % restate the planes as ax + by + cz + d = 0
    %
    %   p1 : z = 2.4 - y    0   -1   -1   2.4
    %   p2 : z = y - 2.4    0    1   -1  -2.4
    %   p3 : z = y - 2.6    0    1   -1  -2.6
    %   p4 : z = -y + 2.6   0   -1   -1   2.6
    %    save x, y, z;
    A = [0   -1   -1   2.4
        0    1   -1  -2.4
        0    1   -1  -2.6
        0   -1   -1   2.6];
    clr = {'red','green','blue','cyan'};
    for n = 1:4
        draw_contours(n)
    end
    % find y values right before road and right after
    yps = y(:,1);
    % yps covering road
    at = yps > yr(1) & yps < yr(2);
    fat = find(at);
    l_edge_ndx = fat(1)-1;
    r_edge_ndx = fat(end)+1;
    % populate bot and top surfaces with NaN
    [rows cols] = size(x);
    bot = zeros(rows, cols) + NaN;
    top = bot;
    removeCutSurface()
    % force road level to be below road
    y_road = find(y(:,1) > yr(1) & y(:,1) < yr(2));
    y_road = [y_road(1)-1; y_road; y_road(end)+1];
    road_strip = z(y_road,:);
    too_high = road_strip >= road_z;
    road_strip(too_high) = road_z - 0.05;
    z(y_road,:) = road_strip;
    [rws cls] = size(x);
    img = uint8(zeros(rws, cls, 3));
    img(:,:,[1 2]) = 140;
    surf(x, y, z, img);  % hillside
    %shading interp
    xlabel('x (th)')
    ylabel('y (phi)')
    axis equal
    axis off
    view(78,16)
    saveas(gcf,'cutting.jpg')
    
    hold on
    dy = 0.5;
    dz = 0.7;
    where = ~isnan(bot);
    top(where) = zz(where);
    sz = size(x);
    img = uint8(zeros(sz(1), sz(2), 3));
    img(:,:,2) = 255;
    surf(x, y+dy, bot+dz, img); % embankment added
    xlabel('x (th)')
    ylabel('y (phi)')
    axis equal
    axis off
    hold on
    [rws cls] = size(x);
    img = uint8(zeros(rws, cols, 3));
    img(:,:,1) = 255;
    surf(x, y+dy, top+dz, img);  % embankment removed
    view(78,16)
    saveas(gcf,'cutting_removed.jpg')

function removeCutSurface
    global x
    global y
    global z
    
    [rows, cols] = size(x);
    for c = 1:cols
        try
            xp = x(1,c);
            yps = y(:, c);
            % interpolate for the red and blue z values
            make_a_cut(xp, yps, 1, 3, c)
            % interpolate for the green and cyan z values
            make_a_cut(xp, yps, 2, 4, c)
        catch
        end
    end
end

function make_a_cut(xp, yps, a, b, c)
    global x
    global y
    global z
    global yr
    global lip_x
    global lip_y
    global lip_z
    global dbg
    global l_edge_ndx
    global r_edge_ndx
    global road_z
    global top
    global bot
    
    za = interp1(lip_x{a}, lip_z{a}, xp);
    zb = interp1(lip_x{b}, lip_z{b}, xp);
    if ~isnan(za) & ~isnan(zb)
        ya = interp1(lip_x{a}, lip_y{a}, xp);
        yb = interp1(lip_x{b}, lip_y{b}, xp);
        cut = yps > ya & yps < yb;
        bot(cut,c) = road_z;
        z(cut,c) = NaN;
        fprintf(dbg,'a = [%0.2f,%0.2f]; b = [%0.2f,%0.2f]\n', ...
            ya, za, yb, zb);
        ny = find(cut);
        fprintf(dbg, 'ny = [ ');
        for it = ny
            fprintf(dbg, '%d ', it);
        end
        fprintf(dbg, ']\n');
        if z(ny(1)-1,c) > road_z
            z(ny(1)-1:l_edge_ndx,c) = yr(1) - y(ny(1)-1:l_edge_ndx,c);
            z(l_edge_ndx+1,c) = road_z;
            z(r_edge_ndx-1,c) = road_z;
            z(r_edge_ndx:ny(end)+1,c) = y(r_edge_ndx:ny(end)+1,c) - yr(3);
        else
            z(ny(1)-1:l_edge_ndx,c) = -yr(1) + y(ny(1)-1:l_edge_ndx,c);
            z(l_edge_ndx+1,c) = road_z;
            z(r_edge_ndx-1,c) = road_z;
            z(r_edge_ndx:ny(end)+1,c) = -y(r_edge_ndx:ny(end)+1,c) + yr(3);
        end
        bot(ny(1)-1:l_edge_ndx+1,c) = z(ny(1)-1:l_edge_ndx+1,c);
        bot(r_edge_ndx-1:ny(end)+1,c) = z(r_edge_ndx-1:ny(end)+1,c);
    end
end

function draw_contours(ndx)
    global x
    global y
    global z
    global A
    global clr
    global sxp
    global syp
    global szp
    global road_z
    global lip_x
    global lip_y
    global lip_z
    
    pln = A(ndx,:);
    cl = clr{ndx};
    d = x.*pln(1) + y.*pln(2) + z.*pln(3) + pln(4);
    [~,hcontour] = contour(x, y, d, 'LevelList', 0);
    c = hcontour.ContourMatrix;
    delete(hcontour);
    
    % Loop through the ContourMatrix
    i = 1;
    while i<size(c,2)
        % Get the X & Y for the next curve
        n = c(2,i);
        x2 = c(1,i+(1:n));
        y2 = c(2,i+(1:n));
        % Use interp2 to compute the matching Z values
        z2 = interp2(x,y,z, x2,y2);
        switch ndx
            case {1 3}
                z2(z2 < road_z) = NaN;
            case {2 4}
                z2(z2 > road_z) = NaN;
        end
        % Draw that line
        %      line(x2,y2,z2,'Color',cl,'LineWidth',2);
        z2 = condition(z2, ndx);
        lip_x{ndx} = x2;
        lip_y{ndx} = y2;
        lip_z{ndx} = z2;
        % Advance to next curve
        i = i+n+1;
    end
    %     xp = sxp{ndx};
    %     yp = syp{ndx};
    %     zp = szp{ndx};
    %     surf(xp, yp, zp)
end

function z = condition(z, ndx)
    try
        nn = find(isnan(z));
        d = diff(nn);
        at = find(d > 1);
        nat = length(at);
        % ndx 1 and 3 (red and blue)
        %            should have exactly one group of NaNs
        %            with real numbers before and after
        %  ideally:
        %  d = [n1 1 1 1 1 ... 1 1 1]
        %  worst case:
        %  d = [1 1 n1 1 1 ... 1 1 1 n2 1]
        %  put 0 in first 2 and last z values
        % ndx 2 and 4 (green and cyan)
        %            should have exactly 2 groups of NaNs
        %            with numbers only between them
        % ideally:
        %  d = [1 1 ... 1 1 n2 1 1 ... 1 1]
        %  worst case
        %  d = [1 1 n1 1 1 ... 1 1 n2 1 1 ... 1 1 n3 1 1 1]
        %  put NaN in z(3:(3 + n1 - 1))
        %         and z(end-3:-1:end-3-n3+1)
        %
        switch ndx
            case {1 3}
                if nat > 2
                    error('really bad')
                else
                    if d(1) == 1
                        z(1:at(1)-1) = 0;
                    end
                end
            case {2 4}
                if nat > 1
                    ouch = true;
                    if nat == 3
                        % fix the front
                        %  put NaN in z(3:(3 + n1 - 1))
                        n1 = d(at(1));
                        z(at(1):(at(1) + n1 - 1)) = NaN;
                        % fix the back
                        %         and z(end-3:-1:end-3-n3+1)
                        n3 = d(at(3));
                        z(end-at(3):-1:end - at(3) - n3 + 1) = NaN;
                    elseif nat == 2
                        % find which to fix
                        if at(1) < 10
                            % fix the front
                            %  put NaN in z(3:(3 + n1 - 1))
                            n1 = d(at(1));
                            z(at(1):(at(1) + n1 - 1)) = NaN;
                        else
                            % fix the back
                            %         or z(end-3:-1:end-3-n3+1)
                            n2 = d(at(2));
                            z(end-at(2):-1:end - at(2) - n2 + 1) = NaN;
                        end
                    else
                        error('really bad')
                    end
                end
        end
    catch
    end
end
