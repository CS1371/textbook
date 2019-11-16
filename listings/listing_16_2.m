% Bubble sort
function main
    global b
    b = round((rand(1,7)-0.5) .* 100);
    bubblesort();
end
function bubblesort()
    % This function sorts the column array b in place,
    % using the bubble sort algorithm
    global b
    N = length(b);
    right = N-1;
    for in = 1:(N-1)
        for jn = 1:right
            if b(jn) > b(jn+1)
                tmp = b(jn); % swap b(jn) with b(jn+1)
                b(jn) = b(jn+1);
                b(jn+1) = tmp;
            end
        end
        right = right - 1;
    end
end
