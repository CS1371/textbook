function Book_Cover
    clear
    clc
    close all
    
    global clouds
    global rows
    global cols
    global ndx
    
    file = {'spitfire.png' ...
            'F_117.png' ...
            'TSR_2.png' ...
            'F_22.png' ...
            'SR_71.png'};
    for ndx = 1:length(file)
       plane(ndx) = {imread(file{ndx})};
    end
    % shrink the spitfire
    plane{1} = stretch(plane{1}, 0.7);
    % stretch the SR-71
    plane{end} = stretch(plane{end}, 1.6);
    clouds = imread('clouds.jpg');
    % make it bigger
    [rows cols ~] = size(clouds);
    cndx = round(linspace(1,cols,2*cols));
    rndx = round(linspace(1,rows,2*rows));
    clouds = clouds(rndx, cndx,:);
    [rows cols ~] = size(clouds)
    imshow(clouds)
    pln = [1 2 3 4 4 5];
    rw = [round(rows/2 + 600), ...  % spitfire
          round(rows/2 - 300), ...        % F-117
          round(rows/2 + 800), ...  % TSR-2
          round(rows/2 + 950), ... % F-22
          round(rows/2 - 1500), ... % F-22
          round(rows/2) - 1000];    % SR-71
    c1 = 700;
    cl = [round(cols - 900 - c1), ...   % spitfire
          round(cols - 2200 - c1), ...   % F-117
          round(cols - 2700 - c1), ...   % TSR-2
          round(cols - 5000 - c1), ...   % F-22
          round(cols - 3200 - c1), ...   % F-22
          round(cols - 5800 - c1)];     % SR-71
    np = length(rw)
    for ndx = 1:np
        imshow(plane{pln(ndx)});
        draw(rw(ndx), cl(ndx), plane{pln(ndx)})
        figure
    end
    imshow(clouds)
    imwrite(clouds, 'Smith_Cover.png')
    clouds = clouds(1:2:end,1:2:end,:);
    imshow(clouds)
    imwrite(clouds, 'Puzzle.png')
end 

function pln = stretch(pln, scale)
    [rows cols ~] = size(pln);
    rndx = round(linspace(1, rows, rows .* scale));
    cndx = round(linspace(1, cols, cols .* scale));
    pln = pln(rndx, cndx, :);
end

function draw(r, c, pln)
    global clouds
    global rows
    global cols
    global ndx
    
    [prows, pcols, ~] = size(pln);
    mask = pln(:,:,1) < 254 ...
         & pln(:,:,2) < 254 ...
         & pln(:,:,3) < 254;
    
    rwvec = r:r + prows - 1;
    if rwvec(end) > rows
        fprintf('raise plane %d by %d\n', ndx, rwvec(end) - rows);
        error('bad')
    end
    clvec = c:c + pcols - 1;
    if clvec(end) > cols
        fprintf('move plane %d left by %d\n', ndx, clvec(end) - cols);
        error('bad')
    end
    for clr = 1:3
        layer = clouds(rwvec, clvec, clr);
        plc = pln(:,:, clr);
        layer(mask) = plc(mask);
        clouds(rwvec, clvec, clr) = layer;
    end
end

