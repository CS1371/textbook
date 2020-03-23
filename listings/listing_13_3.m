% Listing 13.3
% Making a kaleidoscope
function main
    kaleidoscope('../Text/tree.jpg')
end

function kaleidoscope(name)
    % Making a kaleidoscope
    % Usage: kaleidoscope(file_name)
    pause(1)
    figure
    
    % Read the image
    picture = imread(name); 
    
    % Draw it on the left subplot    
    subplot(1,2,1); imshow(picture(ceil(1:1.5:end),:,:))
    
    % Resize it to 128*128 (make it square)
    [rows cols ~] = size(picture);
    n = 128;
    rndx = ceil(linspace(1,rows, n));
    cndx = ceil(linspace(1,cols, n));
    pic = picture(rndx, cndx, :);
    
    % Build the kaleidoscope. Calls the helper function to build the first 
    % set of 4, and then immediately calls it again to build the 4x4 
    % compound image
    img = buildIt(buildIt(pic));
    
    % Draws it on the right panel
    subplot(1,2,2); imshow(img)
end

function img = buildIt(img)
    % Helper function to do the manipulations. Builds four mirrored images
    % from the original
    %	top left        top right
    %	bottom left     bottom right
    img = [img	             img(:,end:-1:1,:)
        img(end:-1:1,:,:) img(end:-1:1,end:-1:1,:)];
end
