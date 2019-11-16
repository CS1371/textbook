clear
clc
close all

RGB = imread('cottage_smooth_sky.jpg');
imagesc(RGB)
[IND,map] = rgb2ind(RGB,256);
figure
imagesc(IND)
colormap(map)
