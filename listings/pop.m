	function [s ans] = pop(s)
% pop
	ans = s{end};
	s = s(1:(end-1));
end
