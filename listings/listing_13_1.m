% Listing 13.1
% Exploring the sky situation
function main
    v = imread('../Text/Vienna.jpg'); % Reads the image
    image(v) % Displays the image
    figure % Creates a new figure window for the next plots
    row = 400; % Determines a suitable row (400 is a good choice)
    
    % Extract the three color layers for the chosen row
    red = v(row, :, 1);
    gr = v(row, :, 2);
    bl = v(row, :, 3);
    
    % Plot the three colors. Since we omitted one of the axis values, we
    % make the assumption that the x values are the integers 1:length(y),
    % which gives us the horizontal pixel number across the row.
    plot(red, 'r');
    hold on
    plot(gr,  'g');
    plot(bl, 'b');
end
