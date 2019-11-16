function fred
clear
clc
close all
global img

img = imread('wallpaper5.png');
res = 1000;
res2 = 2*res;
res3 = 3*res;
res4 = 4*res;
resb8 = res/8;
resb20 = res/20;
whiter = res2+100;
whitec = res2+100;
for clr = 1:3
    img(1:res2, resb8:(resb8+resb20),clr) = img(whiter, whitec, clr);
end
image(img)
imwrite(img, 'wallpaper6.png','png')
end

function circle(x, y, r, clr)

end

