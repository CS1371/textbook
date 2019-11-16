% Listing_17_11  remove from a stack
	function [s ans] = pop(s)
% dequeue
	ans = s{end};
	s = s(1:(end-1));
end
