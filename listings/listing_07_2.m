% listing_07_2
% Cell array processing example
function main
    it = totalNums({1:3 {4 9} 42 {{{4}}}})
end

function ans = totalNums(ca)
    % count the numbers in a cell array
    ans = 0;
    for in = 1 :length(ca)
        item = ca{in} ;	% extract the item
        type = class(item); % determine its type
        switch type
            case 'double'  % add the number to the total
                ans = ans + sum(item);
            case 'cell' % use this function on the embedded cell array
                ans = ans + totalNums(item);
                % ignore any other types
        end
    end
end
