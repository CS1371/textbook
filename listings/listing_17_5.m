% Code for Dijkstra’s algorithm
function grDijkstra
    pause(1)
    figure
    [A coord] = makeGraph; % call script to make the graph:
    gplot(A, coord, 'ro-')
    hold on
    for index = 1:length(coord)
        str = char('A' + index - 1);
        text(coord(index,1) + 0.2, ...
            coord(index,2) + 0.3, str);
    end
	showCosts(coord, A);
    axis([0 11 0 10]); axis off; hold on
    start = 2
    target = 8
    pq = pqEnq([], Path(start, 0));
    while ~isempty(pq)
        [pq current] = qDeq(pq);
        if pthGetLast(current) == target
            D = sparse(0);
            answer = current.nodes;
            for ans = 1:length(answer)-1
                D(answer(ans), answer(ans+1)) = 1;
            end
            gplot(D, coord, 'gx--')
            title('Optimal Search from B to H')
            return;
        end % if last(current) == target
        endnode = pthGetLast(current);
        children = A(endnode,:);
        children = find(children ~= 0);
        for achild = children
            len = A(endnode, achild);
            if ~any(achild == current.nodes)
                clone = Path( [current.nodes achild], ...
                    current.key + len);
                pq = pqEnq(pq, clone);
            end % if ~any child == current.nodes
        end % for achild = children
    end % if pq not empty
    % If we reach here we never found a path
    D = [];
end
function showCosts(co, A)
	n = length(A);
	for r = 1:n
        for c = r+1:n
            if A(r,c) > 0
                str = num2str(A(r,c));
                c1 = co(r,:);
                c2 = co(c,:);
                at = (c1 + c2) ./ 2;
                text(at(1),at(2), str);
            end
        end
    end
end
function [A coord] = makeGraph
    % edge weights
    cost = [24 19 15 19 19 19 27 27 27 70 18 15 31 19 27 27];
    % edge directions
    dir = [2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2];
    % connectivity
    node = [ 1 2 3 0	% edges from A
        1 4 5 6			% edges from B
        4 7 8 0			% edges from C
        7 9 0 0			% edges from D
        2 9 10 0		% edges from E
        3 11 12 0		% edges from F
        11 13 14 0		% edges from G
        10 13 0 0		% edges from H
        12 14 15 0		% edges from I
        5 15 16 0		% edges from J
        6 8 16 0]		% edges from K
    % coordinates
    coord = [   5 4 	% A
                3 6 	% B
                2 4 	% C
                3 1 	% D
                6 2 	% E
                6 5.5 	% F 
                8 5 	% G
                10 2 	% H
                7 7 	% I
                4 8 	% J
                1 7];	% K
    A = grAdjacency( node, cost, dir );
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
function pq = pqEnq(pq, item)
    % enqueue in order to a queue
    in = 1;
    at = length(pq)+1;
    while in <= length(pq)
        if is_before(item, pq{in})
            at = in;
            break;
        end
        in = in + 1;
    end
    pq = [pq(1:at-1) {item} pq(at:end)];
end
function [q ans] = qDeq(q)
    % dequeue
    ans = q{1};
    q = q(2:end);
end
function ret = Path(nodes, len)
    % Path constructor
    ret.nodes = nodes;
    ret.key = len;
end
function ret = pthGetLast(apath)
    % Returns number of last node on a path
    ret = apath.nodes(end);
end
function ans = is_before(a, b)
    acl = class(a);
    ans = false;
    if isa(b, acl)
        switch acl
            case 'double'
                ans = a < b;
            case 'struct'
                if isfield(a, 'key')
                    ans = a.key < b.key;
                elseif isfield(a, 'dod')
                    ans = age(a) < age(b);
                else
                    error('comparing unknown structures')
                end
            otherwise
                error(['can''t compare ' acl 's'])
        end
    end
end
