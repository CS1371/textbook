% Breadth-first graph traversal
function main
	pause(1)
	figure
    A = makeGraph
    % Constructs an adjacency matrix
    start = 5;
    % start is a node number (in this case, 'E')
    % Create a queue and
    % enqueue a path containing home
    q = qEnq([], start);
    % initialize the visited list
    visited = start;
    % initialize the result
    fprintf('trace: ')
    % While the queue is not empty
    while ~isempty(q)
        % Dequeue a path
        [q thisNode] = qDeq(q);
        % Traverse the children of this node
        fprintf('%s - ', char('A'+thisNode-1) );
        children = find(thisNode ~= 0);
        for aChild = children
            % If the child is not on the path
            if ~any(aChild == visited)
                % Enqueue the new path
                q = qEnq(q, aChild);
                % add to the visited list
                visited = [visited aChild];
            end % if ~any(eachchild == current)
        end % for eachchild = children
    end % while q not empty
    fprintf('\n');
end
function A = makeGraph
    % edge weights
    cost = [2 2 2 2 2 3 3 3 3 1 2 1 3];
    % edge directions
    dir = [2 2 2 2 2 2 2 2 2 2 2 2 2];
    % connectivity
    node = [ 1 2 3 4 5; ...	% edges from A
        1 6 7 0 0; ...	% edges from B
        2 7 8 0 0; ...	% edges from C
        3 8 9 0 0; ...	% edges from D
        4 11 13 9 0; ... % edges from E
        5 6 10 0 0; ... % edges from F
        10 11 12 0 0; ... % edges from G
        12 13 0 0 0];	% edges from H
    % coordinates
    coord = [ 5 6; ... % A
        3 9; ... % B
        1 6; ... % C
        3 1; ... % D
        6 2; ... % E
        6 8; ... % F
        9 7; ... % G
        10 2];	% H
    A = grAdjacency( node, cost, dir )
end
function A = grAdjacency( node, cost, dir )
    % compute an adjacency matrix.
    % it should contain the weight from one
    % node to another (0 if the nodes
    %	are not connected)
    [m cols] = size(node);
    n = length(cost);
    k = 0;
    % iterate across the edges
    %	finding the nodes at each end of the edge
    for is = 1:n
        iv = 0;
        for ir = 1:m
            for ic = 1:cols
                if node(ir, ic) == is
                    iv = iv + 1;
                    if iv > 2
                        error('bad intersection matrix');
                    end
                    ij(iv) = ir;
                end
            end
        end
        if iv ~= 2
            error(sprintf('didn''t find both ends of edge %d', is));
        end
        t = cost(is);
        if dir(is) ~= -1
            k = k + 1;
            ip(k) = ij(1); jp(k) = ij(2); tp(k) = t;
        end
        if dir(is) ~= 1
            k = k + 1;
            ip(k) = ij(2); jp(k) = ij(1); tp(k) = t;
        end
    end
    A = sparse( ip, jp, tp );
end
function q = qEnq(q, data)
    % enqueue onto a queue
    q = [q {data}];
end
function [q ans] = qDeq(q)
    % dequeue
    ans = q{1};
    q = q(2:end);
end
