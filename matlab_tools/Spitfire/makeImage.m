clear
clc
close all

top = imread('plan_view.bmp');
side = imread('right_view.bmp');
front = imread('nose_view.bmp');
[trows tcols junk] = size(top);
[srows scols junk] = size(side);
[frows fcols junk] = size(front);
% reduce top rows trows -> fcols
% reduce top cols tcols -> scols
% reduce side rows srows -> frows
trndx = ceil(linspace(1,trows,fcols));
tcndx = ceil(linspace(1,tcols,scols));
srndx = ceil(linspace(1,srows,frows));
top = top(trndx, tcndx, :);
side = side(srndx,:,:);
imshow(front)
figure
imshow(top)
figure
imshow(side)
figure
composite_top = [top, uint8(ones(fcols, fcols)*73)];
composite_bottom = [side, front];
negative = [composite_top; composite_bottom];
hist = zeros(1,256);
count = 0;
for ndx = 1:256
    hist(ndx) = length(find(negative==ndx-1));
    count = count + hist(ndx);
end
[rows cols] = size(negative);
composite = uint8(ones(rows, cols)*255);
composite(negative > 150) = 0;
imshow(composite)
imwrite(composite, 'spitfire.jpg', 'jpg')



