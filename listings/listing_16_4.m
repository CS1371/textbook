% Merge sort
function main
    vec = round((rand(1,9)-0.5) .* 100);
    vs = mergesort(vec);
end

function b = mergesort(a)
    % This function sorts a column array,
    % using the merge sort algorithm
    
    % Initializes the parameters
    b = a; sz = length(a);
    % The terminating condition is an array of length 1, which
    % does not need sorting.
    if sz > 1
        % Divides the array in half
        szb2 = floor(sz / 2);
        % Sorts the halves of the array
        first = mergesort(a(1 : szb2));
        second = mergesort(a(szb2+1 : sz));
        % Merges the two sorted halves
        b = merge(first, second);
    end
end

% Show the helper function to merge sorted arrays.
function b = merge(first, second)
    %	Merges two sorted arrays
    i1 = 1; i2 = 1; out = 1;
    
    % This loop repeats until one of the two arrays is used
    % up choosing and removing the smaller element out of the two
    % arrays. As long as neither i1 nor i2 past the end,
    % move the smaller element into a
    while (i1 <= length(first)) & (i2 <= length(second))
        if lt(first(i1), second(i2))
            b(out,1) = first(i1); i1 = i1 + 1;
        else
            b(out,1) = second(i2); i2 = i2 + 1;
        end
        out = out + 1;
    end
    % copy any remaining entries of the first array
    while i1 <= length(first)
        b(out,1) = first(i1); i1 = i1 + 1; out = out + 1;
    end
    % copy any remaining entries of the second array
    while i2 <= length(second)
        b(out,1) = second(i2); i2 = i2 + 1; out = out + 1;
    end
end