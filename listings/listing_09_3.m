% listing_09_3
% Wrapper implementation for the factorial function
clear; clc
    r1 = fact(10);
    try, r2 = fact(-3);
    catch exc, er = getReport(exc),	end
    try, r2 = fact(-3);
    catch exc, er = getReport(exc),	end

function result = fact(N)
    % computation of N!
    if (N < 0) || ((N - floor(N)) > 0)
        error('bad parameter for fact');
    else
        result = r_fact(N);
    end
end
function result = r_fact(N)
    % recursive computation of N!
    fprintf('fact( %d )\n', N);
    if N == 0
        result = 1;
    else
        result = N * r_fact(N - 1);
    end
end
