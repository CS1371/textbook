clear
clc
close all

drab = double(imread('immature_rabbit.png'));
[rows, cols, ~] = size(drab);
drab = (drab(1:rows, 1:cols,1) ...
      + drab(1:rows, 1:cols,2) ...
      + drab(1:rows, 1:cols,3)) / 3;
rab = uint8(drab);
image(rab)
nr = rows*4;
nc = cols*4;
new_rab = zeros(nr, nc) + 255;
new_rab(1:rows, 1:cols) = rab;
imshow(rab)
figure
% deltar = 25;
% deltac = 125;
% 
% white = rab(:,:,1) >= 253 & rab(:,:,2) >= 253 & rab(:,:,3) >= 253;
% white = cat(3, white, white, white);
% % new_rab(1:rows + deltar, cols:cols + deltac, 1:3) = 255;
% % new_rab(rows:rows + deltar, 1:cols + deltac, 1:3) = 255;
% dr = 0;
% dc = 0;
% for nr = 1:2
%     patch = new_rab(dr:rows+dr-1, dc:cols + dc-1, :);
%     patch(~white) = rab(~white);
%     new_rab(dr:rows+dr-1, dc:cols + dc-1, :) = patch;
%     dr = dr + deltar;
%     dc = dc + deltac;
% end
imshow(new_rab)
% imwrite(new_rab, 'rabbits.jpg');