% listing_05_5
% Example of a for statement
clear; clc
    % Create a vector A with six elements.
    A = [6 12 6 91 13 6] % initial vector
    % The tidiest way to find limits of a collection of numbers
    % is to seed the result with the first number.
    theMax = A(1);	% set initial max value
    % Iterate across the values of A.
    for x = A	% iterate through A
        %% The code block extends from the for statement to the
        % associated end statement.  The code will be executed
        % the same number of times as the length of A even if
        % you change the value of x within the code block.
        % At each iteration, the value of x will be set to
        % the next element from the array A.
        if x > theMax	% test each element
            theMax = x;
        end  % end of the if
    end  % end of the for
    % show the result. The fprintf(...)function is a flexible
    % means of formatting output to the Command window.
    % See the discussion in Chapter 8, or enter the following
    % in the Command window:
    % > help fprintf
    fprintf('max(A) is %d\n', theMax);
