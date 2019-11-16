function make_3_view
    clc
    close all
    img = imread('SR_71_original.gif');
    img = img(:,end:-1:1);
    front = img(491:665,607:1106);
    [fr, fc, ~] = size(front);
    top = img(12:497,24:961);
    [tr, tc, ~] = size(top);
    side = img(728:902,24:956);
    [sr, sc, ~] = size(side);
    cnx = round(linspace(1,fc,tr));
    front = front(:,cnx);
    imshow(front)
    figure
    cnx = round(linspace(1,tc,sc));
    top = top(:, cnx);
    imshow(top);
    figure
    imshow(side)
    [fr, fc, ~] = size(front)
    [tr, tc, ~] = size(top)
    [sr, sc, ~] = size(side)
    img3 = uint8(zeros(671,1429) + 255);
    img3(1:fc,1:tc) = top;
    img3(497:671,1:tc) = side;
    img3(497:671,944:1429) = front;
    figure
    imshow(img3)
end

