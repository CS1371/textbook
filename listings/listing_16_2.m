% Bubble sort
function main
    global b
    b = round((rand(1,7)-0.5) .* 100);
    bubblesort();
end

function bubblesort()
    % This function sorts the column array b in place,
    % using the bubble sort algorithm
    
    % In order to be able to access the array in place, we pass it as a
    % global variable instead of as a parameter.
    global b
    % Since each pass puts the largest element in place, we can
    % reduce the item count by 1 each time. This initializes the size of the
    % first pass.
    N = length(b);
    right = N-1;
    % Show the loop for the N - 1 major passes.
    for in = 1:(N-1)
        % Show the loop for each major pass.
        for jn = 1:right
            if b(jn) > b(jn+1)
                % Swap the current item with its neighbor. By doing this
                % in place, the largest item is always considered the current 
                % item until it reaches the end.
                tmp = b(jn); % swap b(jn) with b(jn+1)
                b(jn) = b(jn+1);
                b(jn+1) = tmp;
            end
        end
        % Shortens the row after each major pass because the largest
        % item in the last pass is placed at the right-hand end.
        right = right - 1;
    end
end
