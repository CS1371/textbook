clear
clc
close all

top = imread('F22aTopView.jpg');
side = imread('F22aSideView.jpg');
front = imread('F22aFrontView.jpg');
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
composite = [uint8(ones(fcols, fcols,3)*255), top; ...
             front, side];
imshow(composite)
imwrite(composite(:,end:-1:1,:), 'F22.jpg', 'jpg')



