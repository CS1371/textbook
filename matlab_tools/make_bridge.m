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
for block = 1:3
    surf(xx, zz, yy, img) % line A-B / B-C / C-D
    hold on
    text(cxx(1,1), cyy(1,1)+15, czz(1,1)+3, [br '-' bl]) % txt A-B / B-C / C-D 
    if(block == 1)
        axis equal
        axis off
        xlabel('X axis')
        ylabel('Z axis')
        zlabel('Y axis')
        text(cxx(1,1), cyy(1,1)-3, czz(1,1)+7, br) % txt A
        surf(cxx, cyy-2, czz, cimg)                % plug A
    else
        surf(xx, zz-ln/2-2, yy+ln-2, img) % lines E-F / F-G
        text(cxx(1,1), cyy(1,1)+15-ln/2, czz(1,1)+ln+3, ...
                    [char(br+3) '-' char(bl+3)]) % txt E-F / F-G 
    end
    surf(cxx, cyy+32, czz, cimg)                % plug B
    surf(rxx, ryy, rzz, img)                   % line EA FB GC
    surf(rxx, fryy, rzz, img)                   % line BE CF DG
    text(cxx(1,1), cyy(1,1)+(42+ln/2)/2, czz(1,1)+5+zoff/2, ...
                                    [bl '-' t]) % txt B-E, C-F D-G
    text(cxx(1,1), cyy(1,1)+(ln/2-4)/2, czz(1,1)+5+zoff/2, ...
                                    [t '-' br]) % txt E-A, F-B G-C
    text(cxx(1,1), cyy(1,1)+32, czz(1,1)+7, bl) % txt B C D
    surf(cxx, cyy+ln/2, czz+zoff, cimg)         % plug E F G
    text(cxx(1,1), cyy(1,1)+ln/2, czz(1,1)+5+zoff, t) % txt E F G
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
dy = 3*(ln+4);
surf(cxx, cyy+dy-2, czz-10, cimg)
czz = czz/5 
surf(cxx, cyy+dy-2, czz-1, cimg)
rxx = zz;
ryy = xx;
rzz = yy;
img(:,:,:) = 0;
surf(rxx*10-5, ryy*1.5+96.5, rzz*1.5-3.5,img)
surf(rxx*10-5, ryy*1.5+100, rzz*1.5-3.5,img)
surf(rxx*10-5, ryy*1.5+103.5, rzz*1.5-3.5,img)
shading interp
lightangle(-45, 45)
lightangle(45, 45)
view(-130, 25)





