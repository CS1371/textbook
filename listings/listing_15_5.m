% Removing the power line from the sky
function main
    p = imread('../Text/Witney.jpg');
    [rows, cols, clrs] = size(p);
    x = 1:cols;
    sky = p;
    for row = 1:700
        for color = 1:3
            cv = double(p(row, :, color));
            coef = polyfit(x, cv, 2);
            ncr = polyval(coef, x);
            sky(row,:,color) = uint8(ncr);
        end
    end
    image(sky)
    imwrite(sky, 'sky.jpg');
end
