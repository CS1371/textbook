% Replacing the gray sky
function main
    pause(1)
    figure
    v = imread('../Vienna.jpg');
    w = imread('../Witney.jpg');
    image(w)
    figure
    thres = 160;
    layer = (v(:,:,1) > thres) ...
        & (v(:,:,2) > thres) ...
        & (v(:,:,3) > thres);
    mask(:,:,1) = layer;
    mask(:,:,2) = layer;
    mask(:,:,3) = layer;
    mask(700:end,:,:) = false;
    nv = v;
    nv(mask) = w(mask);
    image(nv);
    imwrite(nv, 'newVienna.jpg', 'jpg')
end
