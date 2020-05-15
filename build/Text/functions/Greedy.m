% Listing_17_17  Code for Greedy algorithm
function D = Greedy(A, home, target, coord)
    % initial path
    current = home;
    visited = home;
    while current(end) ~= target
        thisNode = current(end);
        % get possible paths from here
        children = find(A(thisNode,:) ~= 0);
        best = inf;
        node = -1; % no node seleected yet
        for thisChild = children
            if ~any(thisChild == visited)
                edgeCost = A(thisNode, thisChild);
                estimate = dist(thisChild, target, coord);
                cost = edgeCost + estimate;
                if cost < best
                    best = cost;
                    node = thisChild;
                end
            end % if ~any(thisChild == current)
        end % for thisChild = children
        if node == -1
            % dead end -> back up one
            current = current(1:end-1);
            if length(current == 0)
                error('path failed')
            end
        else
            current = [current node];
            visited = [visited node]; %
        end
    end
    D = sparse([0]);
    for it = 1:length(current)-1
        D(current(it), current(it+1)) = 1;
    end
end
function res = dist(a, b, coord)
    from = coord(a,:);
    to = coord(b,:);
    res = sqrt((from(1)-to(1)).^2 + (from(2)-to(2)).^2);
end
