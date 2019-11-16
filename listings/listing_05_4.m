% listing_05_4
% find the days in a month
clear; clc
    jan = month_days(1, NaN)
    apr = month_days(4, NaN)
    feb_l = month_days(2, true)
    feb_nl = month_days(2, false)

function days = month_days(month, leap)
    % All tests refer to the value of the variable month.
    switch month
        % This case specification is a cell array (See Chapter 7 for specifics) containing the indices of the months with 30 days.
        case {9, 4, 6, 11}
            %      Sept, Apr, June, Nov
            % The code block extends from the case statement to the next
            % control statement (case, otherwise, or end).
            days = 30;
        case 2	% Feb
            %% This code block contains an if statement to deal with the
            % February case. It presumes that a Boolean variable leapYear
            % has been created to indicate whether this month is in a leap year.
            if leap
                days = 29;
            else
                days = 28;
            end
            %% case to deal with the remaining months.
        case {1, 3, 5, 7, 8, 10, 12}
            days = 31;
            % The default case - an error
        otherwise
            % A built-in MATLAB function that announces the error and
            % terminates the script.
            error('bad month index')
    end
end
