% Listing_17_13  Breadth-first graph search
function D = grBFS(A, home, target)
    s = push([], home);
    while ~isempty(s)
        [s current] = pop(s);
        if current(end) == target % success exit
            D = sparse([0]);
            for ans = 1:length(current)-1
                D(current(ans), current(ans+1)) = 1;
            end
            return; % exit the function
        end % if current == target
        thisNode = current(end);
        children = find(A(thisNode,:) ~= 0);
        for thisChild = children
            if ~any(thisChild == current)
                s = push(s, [current thisChild]);
            end % if ~any(thisChild == current)
        end % for thisChild = children
    end % while s not empty
    % if we reach here we never found a path
    D = [];
end
