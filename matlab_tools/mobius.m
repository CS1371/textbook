
clear
clc
clf
close all

u = (0:0.1:112)/2;
v = (0:0.05:60)/200-0.3;
w =3;
[uu vv] = meshgrid(u,v);
xx = cos(uu).*(w + vv.*cos(uu/2));
yy = sin(uu).*(w + vv.*cos(uu/2));
zz = vv.*sin(uu/2);

[rows cols] = size(xx);
clr = zeros(rows, cols, 3) + 0.8;
clr(:,:,3) = 0.5;
surf(xx, yy, zz, clr)
view(23, 17)

axis equal
axis off
xlabel('X')
ylabel('Y')
zlabel('Z')
shading interp
light
lighting phong
material dull

set(gcf, 'color', 'w')

% Altan Bassa (2020). 
%Mobius Band (https://www.mathworks.com/matlabcentral/fileexchange/643-mobius-band)