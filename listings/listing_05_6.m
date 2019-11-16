% listing_05_6
% for statement using indexing
clear; clc
    % Generalize the creation of the vector A using the rand(...)
    % function to create a vector with 10 elements each
    % between 0 and 100. The floor(...) function rounds
    % each value down to the next lower integer.
    A = floor(rand(1,10)*100)
    % Initialize variables
    theMax = A(1), theIndex = 1;
    % Create an anonymous vector of indices from 1 to the length
    % of A and uses it to define the loop-control variable, index.
    for index = 1:length(A)
        % Extract the appropriate element from A to operate with as before.
        x = A(index);
        %% The same comparison logic as shown in Listing 4.5.
        if x > theMax
            theMax = x;
            % In addition to saving the new max value, we save the index
            % where it occurs.
            theIndex = index;
        end
    end
    % This is our first occurrence where a logical line of code
    % extends beyond the physical limitations of a single line.
    % Since MATLAB normally uses the end of the line to indicate
    % the end of an operation, we use ellipses (...) to specify
    % that the logic is continued onto the next line.
    fprintf('the max value in A is %d at %d\n', ...
        theMax, theIndex);
