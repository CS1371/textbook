% listing_09_4
% Recursive palindrome detector
function main
    good = isPal('Can I attain a C?')
    bad = ~isPal('Can I attain an A?')
end

function res = isPal(str)
    str = lower(str);     % remove all upper case
    str = str(str >= 'a' & str <= 'z'); % keep only lower case
    res = r_isPal(str);
end

function res = r_isPal(str)
    % recursive palindrome detector
    if length(str) < 2
        res = true;
    elseif str(1) ~= str(end)
        res = false;
    else
        res = r_isPal(str(2:end-1));
    end
end
