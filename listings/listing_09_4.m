% listing_09_4
% Recursive palindrome detector
function main
    good = isPal('Can I attain a C?')
    bad = ~isPal('Can I attain an A?')
end

% Start with a wrapper function to clean up the input string:
% - Change upper case to lower case
% - remove all characters not lower case
function res = isPal(str)
    str = lower(str);     % remove all upper case
    str = str(str >= 'a' & str <= 'z'); % keep only lower case
    res = r_isPal(str); % make the recursive calls
end

function res = r_isPal(str)
    % recursive palindrome detector
    if length(str) < 2
        res = true; % success - a short string
    elseif str(1) ~= str(end)
        res = false; % failure - first and last characters don't match
    else
        % Recursive call is safe because there must be at least two
        % characters here
        res = r_isPal(str(2:end-1));
    end
end
