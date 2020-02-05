clear
clc
close all

X = imread('immature_rabbit.jpg');
imshow(X)
figure
[rows, cols, ~] = size(X)
brows = 280;
bcols = 4*cols;
mask1 = X(:,:,1) <= 250;
mask = cat(3, mask1, mask1, mask1);
Y = uint8(zeros(brows, bcols, 3)) + 255;
Y(1:rows, 1:cols, :) = X;
imshow(Y)

%
dr = 20; 
dc = 150;
row = 0;
col = 0;
for pic = 1:4
    row = row + dr;
    col = col + dc;
    patch = Y(row:row+rows-1, col:col+cols-1, :);
    patch(mask) = X(mask);
    Y(row:row+rows-1, col:col+cols-1, :) = patch;
end

imwrite(Y,'rabbit_queue.jpg')