function F_117a_views
clc
close all
    img = imread('F_117a_3_views.gif');
    img = img(19:end,19:end);
    [rows cols] = size(img);
    img3 = uint8(zeros(rows, cols, 3));
    img3(:,:,1) = img;
    img3(:,:,2) = img;
    img3(:,:,3) = img;
    imshow(img3)
    figure
    front = img3(1:100, 490:942,:);
    imshow(front)
    figure
    side = img3(400:488, 250:990, :);
    side = side(:, end:-1:1,:);
    side(1:41, 636:end,:) = 255;
    % shrink side cols by 6
    [srows scols ~] = size(side);
    scndx = round(linspace(1, scols, scols-6));
    side = side(:,scndx,:);
    % clip 6 off side left side
    side = side(:, 7:end, :);
    imshow(side)
    figure
    plan = img3(15:470, 20:745, :);
    plan(1:144, 522:end,:) = 255;
    plan(1:94, 461:end,:) = 255;
    plan(385:end, 348:end,:) = 255;
    plan(423:end,253:end,:) = 255;
    imshow(plan)
    [frows fcols ~] = size(front);
    [srows scols ~] = size(side);
    [prows pcols ~] = size(plan);
    gap = 20;
    figure
    dfr = -14;
    f_3_v = uint8(zeros(prows+20+frows, scols + gap + prows, 3))+255;
    f_3_v(1:prows, 1:pcols, :) = plan;
    f_3_v(prows+gap:prows+gap+srows-1, 1:scols, :) = side;
    f_3_v(prows+gap+dfr:prows+gap+frows-1+dfr, scols+gap:scols+gap+fcols-1, :) = front;
    f_3_v(f_3_v > 160) = 255;
    f_3_v(f_3_v < 100) = 0;
    r = prows+gap/2;
    c = scols+gap/2;
    f_3_v(r,1:end,[1 3]) = 0;
    f_3_v(1:end, c,[1 3]) = 0;
    while r > 0
        f_3_v(r,c,[1 3]) = 0;
        r = r - 1;
        c = c + 1;
    end
    imshow(f_3_v)
    imwrite(f_3_v, 'f_3_v.bmp')
end

