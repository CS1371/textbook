clear
clc
close all

% We have 3 angles to compute:
%  - alfa at A about the Z axis from the Y axis
%  - beta at A about the X axis from the horizontal
%  - gamma at B about the X axis
ln = 30;
facets = 10;
[xx yy zz] = cylinder([1 1], facets);
zz(2,:) = ln;
[r, c] = size(xx);
img = zeros(r, c, 3);
img = img + 0.8;
ri = 1;
ro = 3;
t = 1;
v = [ri ro ro ri ri];
u = [t t -t -t t];
[cxx tth] = meshgrid(u, linspace(0,2*pi, facets));
rr = meshgrid(v, 1:facets);
cyy = rr.*cos(tth);
czz = rr.*sin(tth);
[cr, cc] = size(cxx);
cimg = zeros(cr, cc, 3);
cimg = cimg + 0.8;
% rotate beam 60 about Y axis
th = -30;
N = r * c;
A = [cosd(th) -sind(th)
     sind(th) cosd(th)];
P1(1,:) = reshape(yy, 1, N);
P1(2,:) = reshape(zz, 1, N);
P2 = A * P1;
rxx = xx;
ryy = reshape(P2(1,:), r, c);
rzz = reshape(P2(2,:), r, c);
zoff = ln*cosd(30)+2;
dy = ln+4;
fryy = ln - ryy;
Pa = [10 0 32];
Pb = [-3, 60, 0];
Pr = [0 -2 0];
plot3([Pa(1) Pb(1)],[Pa(2) Pb(2)],[Pa(3) Pb(3)], 'r--') 
hold on
t = 0;
% for t = 0:0.01:1
    P = Pa + (Pb - Pa).*t;
    % find alfa
    alfa = atan2(P(1) - Pr(1), P(2) - Pr(2));
    alfa = alfa * 180 / pi
    surf_rotated(cxx, cyy, czz, cimg, alfa, 0, [0 0 0]);        % plug A
    axis equal
%    axis off
    xlabel('X axis')
    ylabel('Y axis')
    zlabel('Z axis')
    shading interp
    material metal
    nd = surf_rotated(xx, yy, zz+2, img, alfa, 0, [0 0 0])             % line E-A
    surf_rotated(cxx, cyy, czz, cimg, alfa, 0, [0 0 0])         % plug E
    zz = zz + dy;
    ryy = ryy + dy;
    fryy = fryy + dy;
    cyy = cyy + dy;
    surf_rotated(xx, zz-ln/2-2, yy+ln-2, img, alfa, 0, [0 0 0])           % line E-F
    surf_rotated(cxx, cyy+ln/2, czz+zoff, cimg, alfa, 0, [0 0 0])         % plug F
    N = 100;
    % fixed infrastructure
    % cylinder base
    [xx yy zz] = cylinder([1 1], N);
    xx = [zeros(1,N+1); xx; zeros(1,N+1)];
    yy = [zeros(1,N+1); yy; zeros(1,N+1)];
    zz = [zeros(1,N+1); zz; ones(1,N+1)];
    [r c] = size(xx);
    img = zeros(r, c, 3);
    img(:,:,1) = 0.7;
    img(:,:,2) = 0.7;
    img(:,:,3) = 0.2;
    surf(xx*3, yy*3, zz*5-5, img)
    % cube
    cxx = [ 0  0  0  0  0
          -1 -1  1  1 -1
          -1 -1  1  1 -1
           0  0  0  0  0] * 5;      
    cyy = [ 0  0  0  0  0
           1 -1 -1  1  1
           1 -1 -1  1  1
           0  0  0  0  0] * 5;      
    czz = [ 1  1  1  1  1
           1  1  1  1  1
          -1 -1 -1 -1 -1
          -1 -1 -1 -1 -1] * 5;      
    [r c] = size(cxx);
    cimg = zeros(r, c, 3);
    cimg(:,:,1) = 0.5;
    cimg(:,:,2) = 0.5;
    cimg(:,:,3) = 0.2;
    surf(cxx, cyy, czz-10, cimg)
    shading interp
    lightangle(-45, 45)
    lightangle(45, 45)
    view(78, 15)
    hold off
%end

function nd = surf_rotated(xx, yy, zz, img, alpha, beta, offset)
   % alpha is about z axis
   A = [cosd(alpha) -sind(alpha)
        sind(alpha)  cosd(alpha)];
   [r c] = size(xx);
   N = r*c;
   P1(1,:) = reshape(xx-offset(1), 1, N); 
   P1(2,:) = reshape(yy-offset(2), 1, N);
   P2 = A * P1;
   xx = reshape(P2(1,:), r, c) + offset(1);
   yy = reshape(P2(2,:), r, c) + offset(2);
   surf(xx, yy, zz, img);
   nd = [mean(xx(2,:)), mean(yy(2,:)), mean(zz(2,:))];
end




