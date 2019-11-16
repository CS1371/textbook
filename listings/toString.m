% Listing_17_4  Converting any object to a string
	function str = toString(item)
% turn any object into its string representation
	if isa(item, 'char')
	str = ['''' item ''''];
	elseif isa(item, 'double')
	if length(item) == 1
	str = sprintf('%g', item );
	else
	str = '[';
	for in = 1:length(item)
	str = [str ...
	sprintf(' %g', item(in) ) ];
	end
	str = [str ' ]'];
	end
	elseif isa(item, 'struct')
	if isfield(item, 'name')
	str = item.name;
	else
	nms = fieldnames(item);
	str = [];
	for in = 1:length(nms)
	nm = nms{in};
	str = [str nm ': ' ...
	toString(item.(nm)) 13];
	end
	end
	else
	str = 'unknown data';
	end
	end
