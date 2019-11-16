% Listing_17_9  remove from queue
	function [q ans] = qDeq(q)
% dequeue
	ans = q{1};
	q = q(2:end);
end
