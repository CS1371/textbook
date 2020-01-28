clear
clc
close all

rab = imread('immature_rabbit.jpg');
[rows cols ~] = size(rab);
delta = 25;

white = rab(:,:,1) >= 253 & rab(:,:,2) >= 253 & rab(:,:,3) >= 253;
white = cat(3, white, white, white);
new_rab = rab;
new_rab(1:rows + delta, cols:cols + delta, 1:3) = 255;
new_rab(rows:rows + delta, 1:cols + delta, 1:3) = 255;
subplot(2,2,1)
imshow(new_rab)
title('new rab')
patch = new_rab(delta:rows+delta-1, delta:cols + delta-1, :);
subplot(2,2,2)
imshow(patch)
title('patch before masking')
patch(~white) = rab(~white);
subplot(2,2,3)
imshow(patch)
title('patch after masking')
new_rab(delta:rows+delta-1, delta:cols + delta-1, :) = patch;
subplot(2,2,4)
imshow(new_rab)
title('done')
imwrite(new_rab, 'rabbits.jpg');