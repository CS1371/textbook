% listing_05_1
% if statement example
clear; clc; close all
    day(1)
    day(5)
    day(6)
    day(7)

function day(day)
    % The first logical expression determines whether day is 7.
    if day == 7	% Saturday
        % The corresponding code block sets the value of the variable
        % state to the string 'weekend'. In general, there can be as
        % many statements within a code block as necessary.
        state = 'weekend'
        % The second logical expression determines whether day is 1.
    elseif day == 1	% Sunday
        % The corresponding code block also sets the value of the variable % state to the string 'weekend'.
        state = 'weekend'
        % The key word else introduces the default code block executed when % none of the previous tests pass.
    else
        % The default code block sets the value of the variable state to % the string 'weekday'.
        state = 'weekday'
    end
end
