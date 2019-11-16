% listing_09_1
% Function to compute N factorial
clear; clc
    res = fact(12)

function result = fact(N)
    % recursive computation of N!
    % fprintf('fact( %d )\n', N); % testing only
    if N == 0
        result = 1;
    else
        result = N * fact(N - 1);
    end
end
