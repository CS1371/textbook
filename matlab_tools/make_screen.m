function make_screen
    clc
    close all
    
    rows = 8000;
    cols = 12000;
    screen = uint8(zeros(rows, cols, 3));
    screen(:,:,3) = 200;
    center_r = rows - rows/4;
    center_c = cols/2;
    dmx = sqrt(center_r.^2 + center_c.^2);
    % compute rg values linearly from 0 at dmx
    %                            to 128 at 0
    max_rg = 170;
    C = max_rg ./ (dmx.*dmx);
    for r = 1:rows
        for c = 1:cols
            dr = center_r - r;
            dc = center_c - c;
            d = sqrt(dr.^2 + dc.^2);
            rg = uint8(max_rg - C .* d .* d);
            screen(r,c,[1, 2]) = rg;
        end
    end
%    plot(screen(center_r,:,1))
    imshow(screen)
    save
end

