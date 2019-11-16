clear
clc
close all
x = linspace(-50, 50, 100);
y = x;
[xx, yy] = meshgrid(x, y);
zz = 500*peaks(100);
surf(xx, yy, zz)
shading interp
figure
gridrv = [1000 0 0];
[aspect,slope,gradN,gradE] = gradientm(zz,gridrv);
axesm eqacyl
meshm(zz,gridrv)
colormap (jet(64))
colorbar('vert')
title('Peaks:  elevation')
axis square
