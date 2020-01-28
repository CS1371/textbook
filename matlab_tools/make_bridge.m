clear
clc
close all

ln = 30;
[xx yy zz] = cylinder([1 1], 100);
zz(2,:) = ln;
[r, c] = size(xx);
img = zeros(r, c, 3);
img = img + 0.8;
ri = 1;
ro = 3;
t = 1;
v = [ri ro ro ri ri];
u = [t t -t -t t];
facets = 500;
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
P1(1,:) = reshape(yy-2, 1, N);
P1(2,:) = reshape(zz, 1, N);
P2 = A * P1;
rxx = xx;
ryy = reshape(P2(1,:), r, c);
rzz = reshape(P2(2,:), r, c);
zoff = ln*cosd(30)+2;
br = 'A';
bl = 'B';
t = 'E';
dy = ln+4;
fryy = ln - ryy;
Pa = [10 0 32];
Pb = [-3, 60, 0];
plot3([Pa(1) Pb(1)],[Pa(2) Pb(2)],[Pa(3) Pb(3)], 'r--') 
hold on
for block = 1:3
    if(block == 1)
        surf(cxx, cyy-2, czz, cimg)                % plug A
        axis equal
%        axis off
        xlabel('X axis')
        ylabel('Y axis')
        zlabel('Z axis')
    elseif block == 2
        surf(xx, zz-ln/2-2, yy+ln-2, img) % line E-F
    end
    if block == 1
        surf(rxx, ryy, rzz, img)                   % line EA
    end
    if block ~= 3
        surf(cxx, cyy+ln/2, czz+zoff, cimg)         % plug E F
    end
    zz = zz + dy;
    ryy = ryy + dy;
    fryy = fryy + dy;
    cyy = cyy + dy;
    br = bl;
    bl = char(bl+1);
    t = char(t+1);
end
shading interp
material metal
N = 100;
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
surf(xx*3, yy*3-2, zz*5-5, img)
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
surf(cxx, cyy-2, czz-10, cimg)
shading interp
lightangle(-45, 45)
lightangle(45, 45)
view(90, 0)





