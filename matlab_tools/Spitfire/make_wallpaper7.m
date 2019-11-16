function fred
clear
clc
close all
global img

img = imread('wallpaper5.png');
[rows cols ~] = size(img);
letters = zeros(1000, cols, 3);
img = [img; letters];
circle(3500, 500, 400)
ht = 800
wd = 150
% H
rect(3100, 1000, ht, wd)
rect(3100, 1400, ht, wd)
rect(3500-wd/2, 1000, wd, 500)
% F
rect(3100, 2000, ht, wd)
rect(3100, 2000, wd, 500)
rect(3500-wd/2, 2000, wd, 400)
rect(3900-wd, 2000, wd, 500)
% I
rect(3100, 3000, ht, wd)
image(img)
axis equal
imwrite(img, 'wallpaper7.png','png')
end

function rect(rw, cl, ht, wd)
    global img
    img(rw:rw+ht, cl:cl+wd,:) = 255;
end

function circle(rw, cl, rad)
global img

for row = rw-rad:rw+rad
    for col = cl-rad:cl+rad
        if ((row-rw).^2 + (col-cl).^2) < (rad .^ 2)
            img(row,col,:) = 255;
        end
    end
end
end