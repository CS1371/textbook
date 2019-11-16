% Listing_17_3  Converting a cell array to a string
function str = CAToString(ca)
    % Traverse a cell array to make a string
    str = '';
    for in = 1:length(ca)
        str = [str toString(ca{in}) 13];
    end
end
