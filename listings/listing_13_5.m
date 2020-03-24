% Edge detection
function main
    % Read the original image, display it, and determine its size.
    pic = imread('../Text/C-130.jpg');
    imshow(pic)
    figure
    [rows, cols, cl] = size(pic);
    
    % Construct an array of size rows x cols containing the total color
    % intensity of each pixel. The class uint16, using two bytes instead of
    % one, is big enough for the sum of three uint8s.
    amps = uint16(pic(:,:,1))...
        + uint16(pic(:,:,2))...
        + uint16(pic(:,:,3));
    
    % Rather than guess an amplitude threshold, we compute a threshold
    % halfway between the maximum and minimum intensities across the
    % picture.
    up = max(max(amps))
    dn = min(min(amps))
    fact = .5
    thresh = uint16(dn + fact * (up - dn))
    
    % Set up the four overlapping arrays offset by a pixel each.
    pix = amps(2:end, 2:end);
    ptl = amps(1:end-1, 1:end-1);
    pt = amps(1:end-1, 2:end);
    pl = amps(2:end, 1:end-1);
    
    % The logical array alloff will be true wherever all four adjacent
    % pixels have an intensity above the threshold - these are on the sky.
    alloff= and(and((pix > thresh), ( pt  > thresh)), ...
        and(( pl > thresh), (ptl > thresh)));
    
    % The logical array allon will be true wherever all four adjacent
    % pixels have an intensity below the threshold - these are on the
    % aircraft.
    allon = and(and((pix <= thresh), ( pt <= thresh)), ...
        and(( pl <= thresh), (ptl <= thresh)));
    
    % The pixels we are looking for are those where the pixel is neither
    % completely sky not completely aircraft.
    edges = and(not(allon), not(alloff));
    
    % Makes a white image the same size as the logical arrays.
    layer = uint8(ones(rows-1, cols-1) *255);
    
    % Sets the edges to black.
    layer(edges) = 0;
    
    % Put that layer into the RGB layers, show the image, and write it to
    % the disk.
    outline(:,:,1) = layer;
    outline(:,:,2) = layer;
    outline(:,:,3) = layer;
    image(outline)
    imwrite(outline, 'c-130 edges.jpg', 'jpg')
end
