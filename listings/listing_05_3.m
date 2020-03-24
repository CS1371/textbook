% listing_05_3
%  The if statement with a logical vector
function main
    % Make the variable A a logical vector.
    A = [true true false]
    % Using this as a logical expression, MATLAB internally converts
    % this expression to if all(A).
    if A
        % All the values of A are not true; therefore, any code
        % written here does not execute.
    end
    % Make all the elements of A true.
    A(3) = true;
    if A
        % this code block will now execute.
    end
end
