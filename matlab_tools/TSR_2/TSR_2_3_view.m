function TSR_2
    clc
    close all
    
    v3 = imread('TSR_2.gif');
    [rows cols] = size(v3);
    lns = uint8(zeros(rows, cols, 3));
    for clr = 1:3
        lns(:,:,clr) = v3;
    end
    lns = lns(:, end:-1:1, :);
    imshow(lns)
    front = lns(4:171, 7:338,:);
    front(153:end, 297:end,:) = 255;
    [fr fc ~] = size(front)
    figure
    imshow(front)
    side = lns(199:374,15:791,:);
    side(1:36, 87:end, :) = 255;
    side(1:104, 632:end, :) = 255;
    side(1:148, 739:end, :) = 255;
    [sr sc ~] = size(side)
    figure
    imshow(side)
    top = lns(1:367,240:end,:);
    top(1:160, 1:80,:) = 255; 
    top(290:end, 1:479,:) = 255; 
    top(326:end, 1:530,:) = 255; 
    [tr tc ~] = size(top)
    figure
    top = top(:,end:-1:1,:);
    imshow(top)
    
    views = uint8(zeros(100,100, 3)+255);
    views(1:tr, 16:tc+15, :) = top;
    views(tr+1:tr+sr, 1:sc, :) = side;
    views(tr+1:tr+fr, tc+1:tc+fc,:) = front;
    views(1:370,749:end,:) = 255;
    views(536:end,770:end,:) = 255;
    views(1:367, 1:16, :) = 255;
    views(357,1:749,:) = 0;
    views(180,749:end,[1 3]) = 0;
    views(1:374,927,[1 3]) = 0;
    c = 749
    for r = 357:-1:20
        views(r,c,:) = 0;
        c = c + 1;
    end
    figure
    imshow(views)
    imwrite(views, 'TSR_2.bmp')
end

