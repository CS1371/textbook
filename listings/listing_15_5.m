% Removing the power line from the sky
function main
    % Read the original cottage picture
    p = imread('../Text/Witney.jpg');
    % Obtain its sizes
    [rows, cols, clrs] = size(p);
    % Get x values for the curve fitting
    x = 1:cols;
    % Make a copy of the original picture
    sky = p;
    % Convert the top 700 rows where the sky is
    for row = 1:700
        % Treat each color individually
        for color = 1:3
            % The polynomial approximation needs each row as a double
            % vector
            cv = double(p(row, :, color)); 
            % Compute a synthetic row
            coef = polyfit(x, cv, 2);
            ncr = polyval(coef, x);
            % Put the row in the sky
            sky(row,:,color) = uint8(ncr);
        end
    end
    % Show and save the new image
    image(sky)
    imwrite(sky, 'sky.jpg');
end
