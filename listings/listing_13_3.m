% Making a kaleidoscope
function main
    kaleidoscope('../Text/tree.jpg')
end

function kaleidoscope(name)
    % Making a kaleidoscope
    % usage: kaleidoscope(file_name)
    pause(1)
    figure
    %read the image
    picture = imread(name);
    subplot(1,2,1); imshow(picture(ceil(1:1.5:end),:,:))
    % resize it to 128*128
    [rows cols ~] = size(picture);
    n = 128;
    rndx = ceil(linspace(1,rows, n));
    cndx = ceil(linspace(1,cols, n));
    pic = picture(rndx, cndx, :);
    % build the kaleidoscope
    img = buildIt(buildIt(pic));
    subplot(1,2,2); imshow(img)
end

function img = buildIt(img)
    % helper function to do the manipulations
    %	top left	top right
    %	bottom left	bottom right
    img = [img	             img(:,end:-1:1,:)
        img(end:-1:1,:,:) img(end:-1:1,end:-1:1,:)];
end
