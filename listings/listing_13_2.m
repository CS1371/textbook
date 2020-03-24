% Listing 13.2
% Replacing the gray sky
function main
    % Read the two images
    v = imread('../Text/Vienna.jpg');
    w = imread('../Text/Witney.jpg');
    
    image(w) % Draws the cottage picture
    figure % Makes a new figure window
    thres = 160; %Sets the arbitrary threshold
    
    % Define a 2-D layer containing logic that separates the Vienna sky
    % from the rest of the picture
    layer = (v(:,:,1) > thres) ...
        & (v(:,:,2) > thres) ...
        & (v(:,:,3) > thres);
    
    % Build a logical mask to replace the appropriate pixels from the
    % cottage picture into the Vienna picture by populating each color
    % layer of the mask with that layer
    mask(:,:,1) = layer;
    mask(:,:,2) = layer;
    mask(:,:,3) = layer;
    
    mask(700:end,:,:) = false; % Refuses to replace any pixel below row 700
    nv = v; % Copies the original image
    nv(mask) = w(mask); % Replaces the sky
    image(nv); % Shows the image
    imwrite(nv, 'newVienna.jpg', 'jpg') % Save the JPEG result
end