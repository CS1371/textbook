% listing_05_8
% Loop-and-a-half example
function main
    % Initialize the radius value to allow the loop to be entered
    % the first time.
    R = 1;
    % We will remain in this loop until the user enters
    % an illegal radius.
    while R > 0
        % The input(...)function shows the user the text string,
        % parses what is typed, and stores the result in the variable
        % provided. This is described fully in Chapter 8.
        %%	R = input('Enter a radius: ');
        %%%%
        %   for auto listing gen only
        R = rand(1,1) - 0.5
        %
        %%%%
        % We want to present the area and circumference only if the radius
        % has a legal value. Since this test occurs in the middle of the
        % while loop, we call this “loop-and- a-half" processing.
        if R > 0
            % Compute and display the area and circumference of a circle.
            area = pi * R^2;
            circum = 2 * pi * R;
            fprintf('area = %f; circum = %f\n', ...
                area, circum);
        end
    end
end
