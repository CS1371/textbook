% Rotating a globe
function main
    % Reads the JPEG image
    WM = imread('../Text/earthmap_s.jpg'); 
    
    % Enables good closure at the image edge by copying the first column of
    % the map beyond the last column
    WM(:,end+1,:) = WM(:,1,:);
    
    % Computes the mean image intensity of the snow on the top edge of the
    % image. This will be used to fill the circles at the north and south
    % poles.
    snow = mean( mean(WM(1,:,:)));
    
    % Fetches the size of the map
    [WMr, WMc, clr] = size(WM);
    
    % To calculate the size of the circles at the poles, we assume that the
    % map takes us to +/- 85 degrees of latitude, so we need the equivalent
    % of 5 degrees at the top and bottom of the map. This line calculates
    % how many rows represent 1 degree of latitude. 
    rowsperdeglat = WMr/170
    
    % Shows the number of rows to add to the map
    add = floor(rowsperdeglat * 5)
    
    % Computes the values of a single color layer by making an array with
    % ones(...) using the number of rows to add and the number of map
    % columns, and multiplying by the snow intensity.
    addlayer = uint8(ones(add, WMc) * snow);
    
    % Build the strips to add to the globe map by copying this layer to the
    % red, green, and blue layers of a new image array.
    toAdd(:,:,1) = addlayer;
    toAdd(:,:,2) = addlayer;
    toAdd(:,:,3) = addlayer;
    
    % Prepares the complete map by concatenating this image to the top and
    % bottom of the map.
    worldMap = [toAdd; WM; toAdd];
    
    % Retrieves the size of the map
    [nlat nlong clr] = size(worldMap)
    
    % Prepare the vectors defining the plaid by spreading the map
    % dimensions across pi radians in latitude and 2*pi radians in
    % longitude.
    lat = double(0:nlat-1) * pi / nlat;
    long = double(0:nlong-1) * 2 * pi / (nlong-1);
    
    % Prepare the sphere
    [th phi] = meshgrid(long, lat);
    radius = 10;
    zz = radius * cos(phi);
    xx = radius * sin(phi) .* cos(th);
    yy = radius * sin(phi) .* sin(th);
    
    % Scale the image to double values between 0 and 1 as required by
    % surf(...)
    wM = double(worldMap) / 256;
    
    % Draw the surface as usual, using the image as the color distribution.
    surf(xx, yy, zz, wM);
    shading interp
    axis equal, axis off, axis tight
    
    % Special preparation of the surface luminosity and light
    % characteristics to prevent glare spots
    material dull
    th = 0;
    handle = light('Color',[1,1,1]); % a custom light source
    
    % The perpetual rotation with the angle th moving backward one degree
    % at a time
    for frame = 1:300
        th = th - 1;
        view([th 20]);
        % Keeps the light in the same position relative to the observer
        lightangle(handle, th+50, 20) 
        % The usual pause to allow the drawing to take place for each
        % iteration
        pause(.03)
    end
end
