% Edge detection
function main
    pause(1)
    figure
    pic = imread('../C-130.jpg');
    imshow(pic)
    figure
    [rows, cols, cl] = size(pic);
    amps = uint16(pic(:,:,1))...
        + uint16(pic(:,:,2))...
        + uint16(pic(:,:,3));
    up = max(max(amps))
    dn = min(min(amps))
    fact = .5
    thresh = uint16(dn + fact * (up - dn))
    pix = amps(2:end, 2:end);
    ptl = amps(1:end-1, 1:end-1);
    pt = amps(1:end-1, 2:end);
    pl = amps(2:end, 1:end-1);
    alloff= and(and((pix > thresh), ( pt  > thresh)), ...
        and(( pl > thresh), (ptl > thresh)));
    allon = and(and((pix <= thresh), ( pt <= thresh)), ...
        and(( pl <= thresh), (ptl <= thresh)));
    edges = and(not(allon), not(alloff));
    layer = uint8(ones(rows-1, cols-1) *255);
    layer(edges) = 0;
    outline(:,:,1) = layer;
    outline(:,:,2) = layer;
    outline(:,:,3) = layer;
    image(outline)
    imwrite(outline, 'c-130 edges.jpg', 'jpg')
end
