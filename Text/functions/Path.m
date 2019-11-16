% Listing_17_15  Helper function for Dijkstra's algorithm
	function ret = Path(nodes, len)
% Path constructor
	ret.nodes = nodes;
	ret.key = len;
	end
	function ret = pthGetLast(apath)
% Returns number of last node on a path
	ret = apath.nodes(end);
	end
