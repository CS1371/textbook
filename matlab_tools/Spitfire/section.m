clear
clc
close all
% make the wing section
th = linspace(0, 2*pi, 40);
r = 1.1; g = .1;
cx = sqrt(r^2-g^2) - 1; cy = g;
x = r*cos(th) + cx;
y = r*sin(th) + cy;
plot( x, y,  'r' )
axis equal
grid on
hold on
z = complex(x, y);
w = z + 1./z;
x = real(w)
y = imag(w)
n = 50
xv = linspace(x(20), x(1), n)
yu = interp1(x(1:20), y(1:20), xv);
yl = interp1(x(21:40), y(21:40), xv);
dy = yu-yl;
yfu = dy/2
plot( x, y, 'k');
plot(xv, yu, 'gx')
plot(xv, yl, 'rx')
plot(xv, yfu, 'b')
plot(xv, -yfu, 'b')
