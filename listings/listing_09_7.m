clear
clc
close all

global start
global P
global ln
global Pa
global Pb
global cxx
global cyy
global czz
global cimg
global nxx
global nyy
global nzz
global nimg
global ORxmag
global fh
    
% We have 3 angles to compute:
% - alfa at A about the Z axis from the Y axis
% - beta at A about the X axis from the horizontal
% - gamma at B about the X axis
fh = fopen('debug.log','w');
fprintf(fh, '%10s%10s%10s%10s\n\n', 'step','alpha','beta','gamma');
start = 90; % inital guess at solution
ln = 30;
nw = 3;
nr = 2;
facets = 10;
[cxx cyy czz] = cylinder([1 1], facets); % arms
czz(2,:) = ln;
[r, c] = size(cxx);
cimg = zeros(r, c, 3);
cimg = cimg + 0.8;
[xx yy zz] = cylinder([nr nr], facets); % nodes
nxx = zz;
nyy = yy;
nzz = xx;
nxx = nxx*nw - nw/2;
nzr = zeros(1,facets+1);
nxx = [nzr-nw/2; nxx; nzr+nw/2];
nyy = [nzr; nyy; nzr];
nzz = [nzr; nzz; nzr];
[nr, nc] = size(nxx);
nimg = zeros(nr, nc, 3);
nimg = nimg + 0.8;
Pa = [10 -20 32];
Pb = [-3, 40, 0];
t = 0;
results = [];
ok = true;
while ok && t <= 1
    P = Pa + (Pb - Pa).*t;
    % find alfa
    try
        [alfa, beta, gamma] = get_angles();
    catch
        ok = false;
    end
    res.alf = alfa;
    res.bet = beta;
    res.gam = gamma;
    res.P = P;
    results = [results res];
    fprintf(fh, '%10.4f%10.2f%10.2f%10.2f\n', t, alfa, beta, gamma);
    t = t + 0.01;
end
fclose(fh);
draw_stuff(results)
    
    
function draw_stuff(res)
    global Pa
    global Pb
    global cxx
    global cyy
    global czz
    global cimg
    global nxx
    global nyy
    global nzz
    global nimg
    figure
    set(gca,'nextplot','replacechildren');
    % Create a video writer object for the output video file and open the object for writing.
    
    v = VideoWriter('robot_arm.mp4');
    open(v);
    % Generate a set of frames, get the frame from the figure, and then write each frame to the file.
    
    for rndx = 1:length(res)
        alfa = res(rndx).alf;
        beta = res(rndx).bet;
        gamma = res(rndx).gam;
        P = res(rndx).P;
        plot3([Pa(1) Pb(1)],[Pa(2) Pb(2)],[Pa(3) Pb(3)], 'rs--')
        hold on
        plot3(P(1), P(2), P(3), 'g*')
        
        % fixed infrastructure
        % cylinder base
        N = 100;
        [bxx byy bzz] = cylinder([1 1], N);
        bxx = [zeros(1,N+1); bxx; zeros(1,N+1)];
        byy = [zeros(1,N+1); byy; zeros(1,N+1)];
        bzz = [zeros(1,N+1); bzz; ones(1,N+1)];
        [r c] = size(bxx);
        bimg = zeros(r, c, 3);
        bimg(:,:,1) = 0.7;
        bimg(:,:,2) = 0.7;
        bimg(:,:,3) = 0.2;
        surf(bxx*3, byy*3, bzz*5-5, bimg)
        % cube
        bxx = [ 0 0 0 0 0
        -1 -1 1 1 -1
        -1 -1 1 1 -1
        0 0 0 0 0] * 5;
        byy = [ 0 0 0 0 0
        1 -1 -1 1 1
        1 -1 -1 1 1
        0 0 0 0 0] * 5;
        bzz = [ 1 1 1 1 1
        1 1 1 1 1
        -1 -1 -1 -1 -1
        -1 -1 -1 -1 -1] * 5;
        [r c] = size(bxx);
        bimg = zeros(r, c, 3);
        bimg(:,:,1) = 0.5;
        bimg(:,:,2) = 0.5;
        bimg(:,:,3) = 0.2;
        surf(bxx, byy, bzz-10, bimg)
        shading interp
        surf_rotated(nxx, nyy, nzz, nimg, 180 - alfa, 0, [0 0 0]); % plug A
        nd1 = surf_rotated(cxx, cyy, czz, cimg, 180 - alfa, 90-beta, [0 0 0]); % line E-A
        surf_rotated(nxx+nd1(1), nyy+nd1(2), nzz+nd1(3), ...
        nimg, 180 - alfa, 0, nd1); % plug E
        nd2 = surf_rotated(cxx+nd1(1), cyy+nd1(2), czz+nd1(3), ...
        cimg, 180 - alfa, 90 - gamma, nd1); % line E-F % line E-F
        surf_rotated(nxx+nd2(1), nyy+nd2(2), nzz+nd2(3), nimg, 180 - alfa, 0, nd2); % plug F
        axis equal
        % axis off
        xlabel('X axis')
        ylabel('Y axis')
        zlabel('Z axis')
        shading interp
        material metal
        grid on
        lightangle(-45, 45)
        lightangle(45, 45)
        view(-120,40)
        hold off
        frame = getframe(gcf);
        writeVideo(v,frame);
        pause(0.03)
    end
    close(v);
end


function [alf bet gam] = get_angles()
    global start
    global P
    global ORxmag
    global ln
    global fh
    
    % alpha is rotation to put P into the plane of the arm motion
    alf = atan2(P(1), P(2)) * 180/pi;
    % create the solution for the equation
    %
    % 1. horizontal: ln cos b + ln cos g = ORxmag
    % ORxmagf = ln.*(cosd(bet)+cosd(gam))
    % 2. vertical: ln sin b + ln sin g = P(3)
    % P3f = ln .* (sind(bet) + sind(gam))
    % 3. algebra: cos g^2 + sin g^2 = 1
    % from 1: cos g = ORxmag/ln - cos b
    % from 2: sin g = P(3)/ln - sin b
    % so in3: (ORxmag/ln - cos b)^2 + (P(3)/ln - sin b)^2 - 1 = 0;
    % mult by ln^2:
    % (ORxmag - ln cos b)^2 + (P(3) - ln sin b)^2 - ln^2 = 0;
    % simplify:
    % ORxmag^2 - 2 ln ORxmag cos b + ln^2 cos b^2
    % + P(3)^2 - 2 ln P(3) sin b + ln^2 sin b^2 - ln^2 = 0;
    % using 3 again:
    % ORxmag^2 + P(3)^2 - 2 ln(ORxmag cos b + P(3) sin b) = 0
    ORxmag = sqrt(P(1)^2 + P(2)^2);
    b = linspace(0, 360, 100);
    y = equation(b);
    plot(b, y)
    grid on
    title('intersection equation')
    xlabel('beta')
    ylabel('y');
    axis([-100 400 -2000 5000])
    pause(0.01)
    at = find(b > start);
    at = at(1);
    v = y(at);
    % starting at at, find the index of b closest to
    % at that has Y value opposite in sign to v = y(at)
    % bto is all the b indices whose values are opposite
    % sign from v
    bto = find(y.* v < 0);
    if isempty(bto)
        error('no solution');
    end
    % dist is the index distance from 'at'
    dist = abs(bto - at);
    % ndx is the place on dist where the min occurs
    [~, ndx] = min(dist);
    % bto(ndx) is the index on B closest to the start
    to = bto(ndx);
    try
        bet = get_zero(b(at), b(to));
    catch
        error('early shower')
    end
    gam = atan2(P(3)./ln - sind(bet), ORxmag./ln - cosd(bet))*180/pi;
    start = bet;
end



function res = get_zero(b1, b2)
    if abs(b1-b2) < 0.01
        res = b1;
    else
        bm = (b1 + b2) ./ 2;
        e1 = equation(b1);
        e2 = equation(b2);
        em = equation(bm);
        if e1 .* em >= 0
            res = get_zero(bm, b2);
        else
            res = get_zero(b1, bm);
        end
    end
end


function fn = equation(bet)
    global P
    global ln
    global ORxmag
    cb = cosd(bet);
    sb = sind(bet);
    fn = ORxmag.^2 + P(3).^2 - 2.*ln.*(ORxmag.*cb + P(3).*sb);
end


function nd = surf_rotated(xx, yy, zz, img, alpha, beta, offset)
    % beta is about x axis
    A = [cosd(beta) -sind(beta)
    sind(beta) cosd(beta)];
    [r c] = size(xx);
    N = r*c;
    P1(1,:) = reshape(yy-offset(2), 1, N);
    P1(2,:) = reshape(zz-offset(3), 1, N);
    P2 = A * P1;
    yy = reshape(P2(1,:), r, c) + offset(2);
    zz = reshape(P2(2,:), r, c) + offset(3);
    % alpha is about z axis
    A = [cosd(alpha) -sind(alpha)
    sind(alpha) cosd(alpha)];
    P1(1,:) = reshape(xx-offset(1), 1, N);
    P1(2,:) = reshape(yy-offset(2), 1, N);
    P2 = A * P1;
    xx = reshape(P2(1,:), r, c) + offset(1);
    yy = reshape(P2(2,:), r, c) + offset(2);
    surf(xx, yy, zz, img);
    nd = [mean(xx(2,:)), mean(yy(2,:)), mean(zz(2,:))];
end
