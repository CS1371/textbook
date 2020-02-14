% Quick sort
function main
    vec = round((rand(1,9)-0.5) .* 100);
    vs = quicksort(vec, 1, length(vec));
end

% Each recursive call is provided with the vector to sort and
% the range of indices to sort. These are initially from = 1 and 
% to = length(a).
function a = quicksort(a, from, to)
    % This function sorts a column array, using the quick sort algorithm
    
    % The terminating condition for the recursion is when the
    % vector to sort has size 1—that is, when from == to .
    if from < to
        % The partition function performs three roles—it places the
        % pivot in the right place, moves the smaller and larger values 
        % to the correct sides, and returns the location of the pivot to 
        % permit the recursive partitioning.
        [a p] = partition(a, from, to);
        % Show recursive calls to sort the left and right parts of the 
        % vector.
        a = quicksort(a, from, p);
        a = quicksort(a, p + 1, to);
    end
end

% Show the helper function.
function [a lower] = partition(a, from, to)
    % This function partitions a vector
    
    % Initializes the variables
    pivot = a(from); i = from - 1; j = to + 1;
    % The outer loop continues until i passes j .
    while i < j
        i = i + 1;
        % Skip i forward over all the items less than the pivot.
        while a(i) < pivot
            i = i + 1;
        end
        j = j - 1;
        % Skip j backward over all the elements greater than the pivot.
        while a(j) > pivot
            j = j - 1;
        end
        % If i < j , i is indexing an item greater than the pivot,
        % and j is indexing an item less than the pivot. By swapping the
        % contents of a(i) and a(j) , we rectify both inequities and can
        % continue the inner loop.
        if (i < j)
            temp = a(i); % this section swaps
            a(i) = a(j); % a(i) with a(j)
            a(j) = temp;
        end
    end
    % When the loop exits, both i and j are indexing the pivot.
    lower = j;
end

