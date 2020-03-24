% listing_05_7
% while statement example
function main
    %% Create a test vector and initialize the answers as before.
    A = floor(rand(1,10)*100)
    theMax = A(1); theIndex = 1;
    % Initialize the index value since this is manually updated.
    index = 1;
    % This test will fail immediately if the vector A is empty.
    while index <= length(A)
        % Extract the item x from the array
        x = A(index);
        % The same test as before to update the maximum value.
        if x > theMax
            theMax = x;
            theIndex = index;
        end
        % “Manually" update the index to move the loop closer to finishing.
        index = index + 1;
    end
    fprintf('the max value in A is %d at %d\n', ...
        theMax, theIndex);
end
